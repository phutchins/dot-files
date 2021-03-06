#!/bin/bash
set -ueo pipefail

UPDATER_BASE_DIR=${HOME}
BINARY_PATH="/usr/local/bin"
STORJ_GIT_DIR="${UPDATER_BASE_DIR}/github"
UPDATE_STATE_DIR="${UPDATER_BASE_DIR}/.storj.updater"
CURRENT_BUILD_FILE="current.build"
PREVIOUS_BUILD_FILE="previous.build"
LATEST_VERSION=""
LATEST_BUILD=""
CURRENT_BUILD=""
BUILD_BASE_PATH='https://storj-v3-alpha-builds.storage.googleapis.com'
BUILD_PATH_EXT='go1.12.1'
# Combine the next two params
BUILD_FILE_NAME='storagenode_linux_arm.zip'
BINARY_FILE_NAME='storagenode_linux_arm'
RENAME_BINARY_TO='storagenode'
BUILD_DOWNLOAD_DIR="/tmp"
MAX_RETRIES=42

# setup
mkdir -p $STORJ_GIT_DIR
mkdir -p $UPDATE_STATE_DIR

# deps
git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?

if [ $GIT_IS_AVAILABLE -ne 0 ]; then
  echo "Git is not installed! :("
  exit 1;
fi

wget --version 2>&1 >/dev/null
WGET_IS_AVAILABLE=$?

if [ $WGET_IS_AVAILABLE -ne 0 ]; then
  echo "wget is not installed :("
  exit 1;
fi

# Add check for unzip

# functions

function clean_up() {
  cd ${BUILD_DOWNLOAD_DIR}
  if [ -f "${BUILD_DOWNLOAD_DIR}/${BINARY_FILE_NAME}" ]; then
    rm ${BINARY_FILE_NAME}
  fi
  if [ -f "${BUILD_DOWNLOAD_DIR}/${LATEST_VERSION}_${BUILD_FILE_NAME}" ]; then
    rm ${LATEST_VERSION}_${BUILD_FILE_NAME}
  fi
}

function get_sha_for_tag() {
  cd "${STORJ_GIT_DIR}/storj";
  local TAG=$1
  local LB=$(git rev-list -n 1 $TAG | head -n 1 | sed -e 's/^commit //' | head -c 7)
  echo $LB;
}

function get_latest_version() {
  cd "${STORJ_GIT_DIR}/storj";
  local LV=$(git tag | grep 'v.*' | sort -V | tail -1)
  echo "$LV"
}

function get_download_url() {
  local VERSION=$1
  local SHA=$2
  local DL_URL="${BUILD_BASE_PATH}/${SHA}-heads-${VERSION}-${BUILD_PATH_EXT}/${BUILD_FILE_NAME}"
  echo "$DL_URL"
}

function get_archive() {
  # find the latest version
  LATEST_VERSION=$(get_latest_version)
  SHORT_SHA=$(get_sha_for_tag $LATEST_VERSION)

  echo "Attempting to download version ${LATEST_VERSION}"
  BUILD_DOWNLOAD_URL=$(get_download_url $LATEST_VERSION $SHORT_SHA)

  echo "Downloading build from ${BUILD_DOWNLOAD_URL}"
  GET_BUILD_COMMAND="wget -q -O ${BUILD_DOWNLOAD_DIR}/${LATEST_VERSION}_${BUILD_FILE_NAME} ${BUILD_DOWNLOAD_URL}"

  if $($GET_BUILD_COMMAND); then
    # set LATEST_BUILD so we exit the loop and move along
    echo "Got latest build of ${LATEST_VERSION}"
    LATEST_BUILD=${LATEST_VERSION}
  else
    echo "Failed to get build"
    exit
  fi
}

function update_repo() {
  echo "Pulling ${STORJ_GIT_DIR}/storj";
  cd "${STORJ_GIT_DIR}/storj";
  echo "Current dir is: $(pwd)"
  git checkout master
  git pull;
  git fetch -a
}

# pull the latest source from github
if [ ! -d ${STORJ_GIT_DIR}/storj ]; then
  echo "Repo did not exist, checking it out..."
  git clone https://github.com/storj/storj.git ${STORJ_GIT_DIR}/storj
  LATEST_VERSION=$(get_latest_version);
  git checkout $LATEST_VERSION
  echo "Repo checked out."
  update_repo;
else
  echo "Repo exists, pulling latest..."
  update_repo;
fi

clean_up;

get_archive;

# determine what version we're running now
if [ -f "${UPDATE_STATE_DIR}/${CURRENT_BUILD_FILE}" ]; then
  CURRENT_BUILD=$(cat ${UPDATE_STATE_DIR}/${CURRENT_BUILD_FILE})
  echo "Current build is ${CURRENT_BUILD}"
else
  echo "No current build found."
fi

if [ "${CURRENT_BUILD}" == "${LATEST_VERSION}" ]; then
  echo "Latest version of ${LATEST_VERSION} is already installed"
  exit 0;
fi


# write current version number to file
if [ ! -z "${CURRENT_BUILD}" ]; then
  # if we have a current build, save it to the previous build file
  echo ${CURRENT_BUILD} > ${UPDATE_STATE_DIR}/${PREVIOUS_BUILD_FILE}
  echo "Saved the current build (${CURRENT_BUILD}) to ${UPDATE_STATE_DIR}/${PREVIOUS_BUILD_FILE}"
else
  echo "No current build to save as previous build"
fi

# extract and replace the current binary
function install_build_from_zip() {
  # check if the unzipped file exists and delete it if it does
  cd ${BUILD_DOWNLOAD_DIR}
  BUILD_ARCHIVE_PATH="${LATEST_VERSION}_${BUILD_FILE_NAME}"
  echo "Extracting build from ${BUILD_DOWNLOAD_DIR}/${BUILD_ARCHIVE_PATH}"
  /usr/bin/unzip $BUILD_DOWNLOAD_DIR/$BUILD_ARCHIVE_PATH -d $BUILD_DOWNLOAD_DIR
  UNZIP_RESULT=$?

  # Why does this return "Archive:: command not found"
  if [ "${UNZIP_RESULT}" -eq "0" ]; then
    chmod +x ${BINARY_FILE_NAME}
    mv ${BINARY_FILE_NAME} ${BINARY_PATH}/${RENAME_BINARY_TO}
  else
    echo "Failed to unzip archive..."
    exit 1;
  fi
}

install_build_from_zip;

# after we've actually replaced the previous build, update the current build
$(echo ${LATEST_BUILD} > ${UPDATE_STATE_DIR}/${CURRENT_BUILD_FILE})

# Restart the service
echo "Install finished."
echo "Restarting storagenode service..."
systemctl restart storagenode
