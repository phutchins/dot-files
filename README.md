# Dot Files

## ToDo

+ Check for JDK and JRE, prompt user to install

+ On initial launch of weechat, prompt for passwords and create encrypted secret file
'''
/secure passphrase passwordToEncryptAllSecrets
/secure set freenode_services_password myNickservPassword
/set irc.server.freenode.command "/msg nickserv identify ${sec.data.freenode_services_password}"
/save
```

Could store this file on github if needed as it's encrypted...
