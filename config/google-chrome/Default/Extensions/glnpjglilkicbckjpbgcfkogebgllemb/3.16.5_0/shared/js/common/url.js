(function(e,c){var f=["protocol","host","port","path","queryKey","anchor"];function b(h,g){return h===g}function d(h,g){return h.length>=g.length&&h.substr(0,g.length)===g}function a(g,h){return c(h).every(function(j,i){return g[i]===j})}Okta.Url=function(g){var h;if(c.isString(g)){h=Okta.parseUri(g);h.href=h.source}else{h={protocol:g.protocol.replace(":",""),host:g.hostname,port:g.port,path:g.pathname,query:g.search.replace("?",""),queryKey:Okta.parseUri(g.search)["queryKey"],anchor:g.hash.replace("#",""),href:g.href}}c.extend(this,h)};c.extend(Okta.Url.prototype,{matches:function(h,i){var g;if(i){return new RegExp(h).test(this.href)}else{g=Okta.parseUri(h);return c(f).every(function(j){switch(j){case"protocol":case"port":case"host":return b(this[j],g[j]);case"path":return d(this[j],g[j]);case"queryKey":return a(this[j],g[j]);case"anchor":return g[j]===""||b(this[j],g[j]);default:throw"Invalid url part: "+j}},this)}}})}($okta,_okta));