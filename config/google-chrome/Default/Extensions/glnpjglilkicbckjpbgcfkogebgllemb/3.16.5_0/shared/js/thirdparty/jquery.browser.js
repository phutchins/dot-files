/*
 * jQuery Browser Plugin v0.0.3
 * https://github.com/gabceb/jquery-browser-plugin
 *
 * Original jquery-browser code Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
 * http://jquery.org/license
 *
 * Modifications Copyright 2013 Gabriel Cebrian
 * https://github.com/gabceb
 *
 * Released under the MIT license
 *
 * Date: 2013-07-29T17:23:27-07:00
 */
(function(d,c,e){var a,b;d.uaMatch=function(h){h=h.toLowerCase();var g=/(opr)[\/]([\w.]+)/.exec(h)||/(chrome)[ \/]([\w.]+)/.exec(h)||/(webkit)[ \/]([\w.]+)/.exec(h)||/(opera)(?:.*version|)[ \/]([\w.]+)/.exec(h)||/(msie) ([\w.]+)/.exec(h)||h.indexOf("trident")>=0&&/(rv)(?::| )([\w.]+)/.exec(h)||h.indexOf("compatible")<0&&/(mozilla)(?:.*? rv:([\w.]+)|)/.exec(h)||[];var f=/(ipad)/.exec(h)||/(iphone)/.exec(h)||/(android)/.exec(h)||/(win)/.exec(h)||/(mac)/.exec(h)||/(linux)/.exec(h)||[];return{browser:g[1]||"",version:g[2]||"0",platform:f[0]||""}};a=d.uaMatch(c.navigator.userAgent);b={};if(a.browser){b[a.browser]=true;b.version=a.version}if(a.platform){b[a.platform]=true}if(b.chrome||b.opr){b.webkit=true}else{if(b.webkit){b.safari=true}}if(b.rv){b.msie=true}if(b.opr){b.opera=true}d.browser=b})($okta,window);