function AutofillBar(e,g,f,a){var c=e.document;var h;var d=false;this.showBarWithMFA=function(k,j){i("To access this application you must provide extra verification.","Verify","/policy/plugin/second-factor?ruleId="+k+"&appUserId="+j,490)};this.showBarWithLogin=function(j){if(!a.pluginOfflineToolbarEnabled){return}i("To access this and other applications in Okta, please click Login.","Login","/home/plugin?appUserId="+j,410)};this.showBarWithUsername=function(m,k){c=f.prepareOnce();var j=new oktaPlugin.Widget.DropDown(c);j.create(m,oktaPlugin.Widget.DropDown.appInstanceDisplayFunc,0);h=new OktaNotifyBar(e,c);var l=h.o;if(k){l.msg="Do you want Okta to autofill your current password for the form below?";l.button1.text="Autofill"}else{l.msg="Do you want Okta to sign you in to this site?";l.button1.text="Sign In"}l.events.onClose=function(){d=false};l.events.button1Click=function(){var n=j.getSelectedValue();g("getCredToFill",{id:n.id})};l.button2.text="Never";l.events.button2Click=function(){g("neverThisUrl");h.close()};h.create({cssClass:"x-fill-cred"});h.getControlDiv().prepend(j.getRootElm());h.appendToDom();d=true};this.isOpen=function(){return d};this.close=function(){if(h){if(d){h.close()}h=null}};function i(l,j,n,m){c=f.prepareOnce();h=new OktaNotifyBar(e,c);var k=h.o;k.msg=l;k.button1.text=j;k.events.onClose=function(){d=false};k.events.button1Click=function(){b(n,m)};h.create({cssClass:"x-fill-cred"});h.appendToDom();d=true}function b(q,p){var o,k,m,j,l;o=function(r){g("PopupClosed",{})};if(!$okta("#oktamessage").length){k=document.createElement("div");k.style.display="none";k.id="oktamessage";$okta(c.body).prepend(k);if(k.addEventListener){k.addEventListener("oktaClosePopup",o)}else{if(k.attachEvent){k.oktaClosePopup=0;k.attachEvent("onpropertychange",function(r){if(r.propertyName=="oktaClosePopup"){o()}})}}}m="("+function(u,x){var s,t,v,r=0;s=open(u,"oktaPopupLogin","toolbar=0,width=500,height="+x+",location=1,menubar=0,scrollbars=yes");v=document.getElementById("oktamessage");t=setInterval(function(){var w;if(r++>120){clearInterval(t)}if(s.closed){clearInterval(t);if(document.createEvent){w=document.createEvent("Event");w.initEvent("oktaClosePopup",true,true);v.dispatchEvent(w)}else{if(document.createEventObject){v.oktaClosePopup++}}}},500)}+")("+JSON.stringify(ENV._domain+q)+", "+p+")";j=c.createElement("script");j.type="text/javascript";try{j.appendChild(c.createTextNode(m))}catch(n){j.text=m}l=c.getElementsByTagName("head")[0]||c.documentElement;l.insertBefore(j,l.firstChild);l.removeChild(j)}};