var __nimservice=function(x){function m(){return{x:(window.innerWidth?window.innerWidth:document.documentElement.clientWidth?document.documentElement.clientWidth:screen.width)/2+(void 0!==window.screenLeft?window.screenLeft:window.screenX),y:(window.innerHeight?window.innerHeight:document.documentElement.clientHeight?document.documentElement.clientHeight:screen.height)/2+(void 0!==window.screenTop?window.screenTop:window.screenY)-170}}function V(a,b,c){a=JSON.parse(a);var d={};d.messageNumber=b;d.operation=a.operation;d.certIdentifier=a.certIdentifier?a.certIdentifier:"";d.callback=c;d.valid=!0;10<=E&&(E=0);w[E]=d;E+=1;g+=1}function s(a,b,c){V(a,b,c);try{var d=document.getElementById("hsmiframe");if("undefined"===typeof window.postMessage){var e=window.crosscert.util||{};b=A+"/TIC";var d=A+"/VestCert/MangoFS.jsp",f=document.getElementById("IFR_SERVER"),h=document.getElementById("FRM_SENDER"),g=document.getElementById("message"),k=document.getElementById("returnURL");null!=f&&f.parentNode.removeChild(f);null!=h&&h.parentNode.removeChild(h);-1!=navigator.userAgent.indexOf("MSIE 7.0")?(f=document.createElement('<iframe id="IFR_SERVER" name="IFR_SERVER" src="'+b+'" />'),f.style.display="none",document.body.appendChild(f),h=document.createElement('<form id="FRM_SENDER" action="'+d+'" method="post" target="IFR_SERVER" > </form>')):(f=document.createElement("iframe"),f.setAttribute("id","IFR_SERVER"),f.setAttribute("name","IFR_SERVER"),f.setAttribute("src",b),f.style.display="none",document.body.appendChild(f),h=document.createElement("form"),h.setAttribute("id","FRM_SENDER"),h.setAttribute("action",d),h.setAttribute("method","post"),h.setAttribute("target","IFR_SERVER"));h.style.display="none";document.body.appendChild(h);g=document.createElement("input");g.setAttribute("id","message");g.setAttribute("name","message");g.value=e.bytesToHex(e.encodeUtf8(a));h.appendChild(g);k=document.createElement("input");k.setAttribute("id","fsreturnURL");k.setAttribute("name","returnURL");h.appendChild(k);k.value=e.bytesToHex(e.encodeUtf8(location.href));try{J(f,"onload",function(a){a=document.getElementById("IFR_SERVER");var b,c={};try{b=a.contentWindow.name}catch(d){throw d;}try{c.data=e.decodeUtf8(e.decode64(b)),c.origin=A}catch(f){return}N(c)})}catch(m){alert(m.message)}h.submit()}else d.contentWindow.postMessage(a,A)}catch(l){null!=c&&c(-1)}}function J(a,b,c){null==a&&(a=window);null==c&&(c=N);if(0<K){var d=a,e=b,f=c;null==d&&(d=window);K--;"function"===typeof d.addEventListener?(null==e&&(e="message"),d.removeEventListener(e,f,!1)):(null==e&&(e="onmessage"),d.detachEvent(e,f))}"function"===typeof a.addEventListener?(null==b&&(b="message"),a.addEventListener(b,c,!1)):(null==b&&(b="onmessage"),a.attachEvent(b,c));K++}function v(a,b){for(var c=u.length,d=0;d<c;d++){var e=u[d];if(e.device==a&&e.drive==b)return""+e.tokenIdentifier}return""}function W(a,b,c,d,e){var f=v(p,t);null==f||0>=f.length?e(-1):(a={messageNumber:g,sessionID:""+l,operation:this.operation[4],tokenIdentifier:f,CAType:"crosscert",referenceNumber:c,authenticationCode:d,options:{center:m(),CAServiceIP:a,CAServicePort:b}},s(JSON.stringify(a),g,e))}function X(a,b,c,d,e,f){var h=v(p,t);if(null==h||0>=h.length)f(-1);else{var k="",n="";p!=y.device&&c&&(k=c.certIdentifier,n=c.keyIdentifier);c="";c=0<d.length||0<e.length?{messageNumber:g,sessionID:""+l,operation:this.operation[6],tokenIdentifier:h,CAType:"crosscert",oldcertIdentifier:k,oldKeyIdentifier:n,newpin:d,oldpin:e,options:{center:m(),CAServiceIP:a,CAServicePort:b}}:{messageNumber:g,sessionID:""+l,operation:this.operation[6],tokenIdentifier:h,CAType:"crosscert",oldcertIdentifier:k,oldKeyIdentifier:n,options:{center:m(),CAServiceIP:a,CAServicePort:b}};s(JSON.stringify(c),g,f)}}function Y(a,b){var c=v(p,t);null==c||0>=c.length?b(-1):(c={messageNumber:g,sessionID:""+l,operation:this.operation[5],tokenIdentifier:c,certIdentifier:a.certIdentifier,KeyIdentifier:a.keyIdentifier,options:{center:m()}},s(JSON.stringify(c),g,b))}function Z(a,b,c,d,e){var f=v(p,t);if(null==f||0>=f.length)e(-1);else{var h="",k="";p!=y.device&&d&&(h=d.certIdentifier,k=d.keyIdentifier);a={messageNumber:g,sessionID:""+l,operation:this.operation[7],tokenIdentifier:f,CAType:"crosscert",certIdentifier:h,keyIdentifier:k,options:{center:m(),CAServiceIP:a,CAServicePort:b,reason:c}};s(JSON.stringify(a),g,e)}}function O(a,b){u.length=0;var c={messageNumber:g,sessionID:""+l,operation:this.operation[0],options:{center:m()},reload:a};s(JSON.stringify(c),g,b)}function P(a){var b={messageNumber:g,sessionID:""+l,operation:this.operation[8],options:{center:m()}};s(JSON.stringify(b),g,a)}function Q(a){q.length=0;var b=v(p,t);if(null==b||0>=b.length)x.uiUtil().loadingBox(!1,"us-div-list-load"),a(-1);else{var c=null;null!=B?(B=B.replace(/\|/gi,";"),c={messageNumber:g,sessionID:""+l,operation:this.operation[1],tokenIdentifier:b,filter:{mode:"",OID:B},options:{center:m()}}):c={messageNumber:g,sessionID:""+l,operation:this.operation[1],tokenIdentifier:b,options:{center:m()}};B=null;s(JSON.stringify(c),g,a)}}function L(a,b){var c=v(p,t);null==c||0>=c.length||void 0==a||null==a?b(-1):(c={messageNumber:g,sessionID:""+l,operation:this.operation[2],tokenIdentifier:c,certIdentifier:a.certIdentifier,options:{center:m()}},s(JSON.stringify(c),g,b))}function $(a,b,c,d,e,f){var h=v(p,t);if(null==h||0>=h.length)f(-1);else{var k="2";!1==d&&(k="4");var n=d="";p!=y.device&&a&&(d=a.certIdentifier,n=a.keyIdentifier);a=null!=e?{messageNumber:g,sessionID:""+l,operation:this.operation[3],tokenIdentifier:h,pin:b,certIdentifier:d,keyIdentifier:n,plain:c[0],outputfile:c[2],options:{center:m(),vid:{recipientCertificate:e,type:"1"},signInputType:"2",signOutputType:c[1]+"",signtype:k,encoding:"0"}}:{messageNumber:g,sessionID:""+l,operation:this.operation[3],tokenIdentifier:h,pin:b,certIdentifier:d,keyIdentifier:n,plain:c[0],outputfile:c[2],options:{center:m(),signInputType:"2",signOutputType:c[1]+"",signtype:k,encoding:"0"}};s(JSON.stringify(a),g,f)}}function R(a,b,c,d,e,f,h){var k=v(p,t);if(null==k||0>=k.length)h(-1);else{var n="2";!1==e&&(n="4");var q=e="";p!=y.device&&a&&(e=a.certIdentifier,q=a.keyIdentifier);a=null!=f?{messageNumber:g,sessionID:""+l,operation:this.operation[3],tokenIdentifier:k,pin:b,certIdentifier:e,keyIdentifier:q,plain:d,options:{center:m(),vid:{recipientCertificate:f,type:"1"},signInputType:c+"",signtype:n,encoding:"0"}}:{messageNumber:g,sessionID:""+l,operation:this.operation[3],tokenIdentifier:k,pin:b,certIdentifier:e,keyIdentifier:q,plain:d,options:{center:m(),signInputType:c+"",signtype:n,encoding:"0"}};s(JSON.stringify(a),g,h)}}function aa(a,b,c,d,e){var f=v(p,t);if(null==f||0>=f.length)e(-1);else{var h="";p!=y.device&&a&&(h=a.keyIdentifier);a=null!=d?{messageNumber:g,sessionID:""+l,operation:this.operation[3],tokenIdentifier:f,pin:b,keyIdentifier:h,plain:c,options:{center:m(),vid:{recipientCertificate:d,type:"1"},signtype:"0",encoding:"0"}}:{messageNumber:g,sessionID:""+l,operation:this.operation[3],tokenIdentifier:f,pin:b,keyIdentifier:h,plain:c,options:{center:m(),signtype:"0",encoding:"0"}};s(JSON.stringify(a),g,e)}}function ba(a,b,c,d,e){var f=v(p,t);null==f||0>=f.length?e(-1):(a=v(a,b),null==a||0>=a.length?e(-1):(c={messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[9],tokenIdentifier:f,newTokenIdentifier:a,certIdentifier:c.certIdentifier,keyIdentifier:c.keyIdentifier,deleteCert:null==d||!1==d?"0":"1",options:{center:m()}},s(JSON.stringify(c),g,e)))}function ca(a,b){var c=v(p,t);if(null==c||0>=c.length)b(-1);else{var d="";p!=y.device&&a&&(d=a.certIdentifier);c={messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[10],tokenIdentifier:c,certIdentifier:d,mode:"",options:{center:m()}};s(JSON.stringify(c),g,b)}}function da(a,b,c){b=v(p,t);null==b||0>=b.length?c(-1):(a={messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[11],tokenIdentifier:b,certIdentifier:a.certIdentifier,keyIdentifier:a.keyIdentifier,reusePin:1,options:{center:m()}},s(JSON.stringify(a),g,c))}function ea(a){var b=v(p,t);null==b||0>=b.length?a(-1):(b={messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[12],tokenIdentifier:b,options:{center:m()}},s(JSON.stringify(b),g,a))}function fa(a,b){var c=v(p,t);null==c||0>=c.length?b(-1):(c={messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[13],tokenIdentifier:c,certIdentifier:a.certIdentifier,keyIdentifier:a.keyIdentifier,options:{center:m()}},s(JSON.stringify(c),g,b))}function ga(a,b){var c=eval(a.list);if("ok"!=a.resultMessage)return k=a.resultCode,n=a.resultMessage,b(a.resultCode,0),!1;for(var d=1,e=1,f=1,h=c.length,g=0;g<h;g++){var m=c[g],l={};l.tokenIdentifier=m.tokenIdentifier;l.name=m.name;l.type=m.type;l.device=m.type==S.name?!0==m.systemDrive?S.device:M.device:m.type==F.name?F.device:m.type==G.name?G.device:m.type==H.name?H.device:m.type==y.name?y.device:m.type==I.name?I.device:0;l.drive=0;l.device==M.device?(l.drive=f,f+=1):l.device==H.device?(l.drive=e,e+=1):l.device==G.device?(l.drive=d,d+=1,l.trusted=m.trusted):l.drive=0;u[g]=l}b(a.resultCode,h)}function ha(a,b){if("ok"!=a.resultMessage)return k=a.resultCode,n=a.resultMessage,b(k,0),!1;for(var c=eval(a.list),d=c.length,e=0;e<d;e++){var f=c[e],h={};h.subject=f.subject;h.issuer=f.issuer;h.serial=f.serial;h.validFrom=f.validFrom;h.validTo=f.validTo;h.certIdentifier=f.certIdentifier;h.keyIdentifier=f.keyIdentifier;h.kmcertIdentifier=f.kmCertIdentifier;h.kmkeyIdentifier=f.kmKeyIdentifier;var g={};g.id=f.policy.id;g.userNotice=f.policy.userNotice;h.policy=g;h.cert="";q[e]=h}b(a.resultCode,q.length)}function T(a,b,c,d){a=null==b?{messageNumber:g,sessionID:""+l,operation:this.operation[14],tokenIdentifier:"0",signature:c,options:{center:m(),signtype:"2"}}:{messageNumber:g,sessionID:""+l,operation:this.operation[14],tokenIdentifier:"0",signature:c,params:{plainType:a,plain:b},options:{center:m(),signtype:"4"}};s(JSON.stringify(a),g,d)}function ia(a,b,c,d){a={messageNumber:g,sessionID:""+l,operation:this.operation[14],tokenIdentifier:"0",signature:b,params:{plain:a,type:0,certOrKey:c},options:{center:m(),signtype:"0"}};s(JSON.stringify(a),g,d)}function ja(a,b,c,d,e,f){a=null==a?{messageNumber:g,sessionID:""+l,operation:this.operation[14],tokenIdentifier:"0",signature:c,outputfile:e,options:{center:m(),signtype:"2",signInputType:b+"",signOutputType:d+""}}:{messageNumber:g,sessionID:""+l,operation:this.operation[14],tokenIdentifier:"0",signature:c,outputfile:e,params:{plainInputType:2,plain:a},options:{center:m(),signtype:"4",signInputType:b+"",signOutputType:d+""}};s(JSON.stringify(a),g,f)}function ka(a,b,c,d){var e=v(p,t);if(null==e||0>=e.length)d(-1);else{var f="",h=f="";p!=y.device&&a&&(f=a.certIdentifier,h=a.keyIdentifier);f=null==b?{messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[15],tokenIdentifier:e,certIdentifier:f,keyIdentifier:h,options:{center:m()},idn:c}:{messageNumber:g,sessionID:""+l,manager:"Manager",operation:this.operation[15],tokenIdentifier:e,pin:b,certIdentifier:f,keyIdentifier:h,options:{center:m()},idn:c};s(JSON.stringify(f),g,d)}}function la(a,b,c,d,e){var f=v(F.device,0);null==f||0>=f.length?e(-1):(a={messageNumber:g,sessionID:""+l,operation:this.operation[16],tokenIdentifier:f,options:{center:m(),wParam:b,lParam:c,version:a,url:d}},s(JSON.stringify(a),g,e))}function ma(a,b,c,d,e,f){var h=v(y.device,0);null==h||0>=h.length?f(-1):(a={messageNumber:g,sessionID:""+l,operation:this.operation[16],tokenIdentifier:h,options:{center:m(),tokenorder:"Mobile_SmartCert",sitecode:a,modcode:b,siteURL:c,serviceIP:d,servicePort:e}},s(JSON.stringify(a),g,f))}function na(a,b){var c=v(p,t);null==c||0>=c.length?b(-1):(c={messageNumber:g,sessionID:""+l,operation:this.operation[17],tokenIdentifier:c,certIdentifier:a.certIdentifier,options:{center:m()}},s(JSON.stringify(c),g,b))}function oa(a,b,c,d){var e=0;"sha256"==c.toLowerCase()&&(e=1);a={messageNumber:g,sessionID:""+l,manager:"Cipher",operation:this.operation[18],tokenIdentifier:0,plainType:a,plain:b,mode:e,options:{center:m()}};s(JSON.stringify(a),g,d)}function pa(a,b,c,d,e,f,h){a={messageNumber:g,sessionID:""+l,manager:"Cipher",tokenIdentifier:0,operation:this.operation[19],plain:d,args:{algorithm:a,mode:0,padding:0},keys:{key:c,iv:b},options:{center:m(),fromCharset:e,toCharset:f}};s(JSON.stringify(a),g,h)}function qa(a,b,c,d,e,f,h){a={messageNumber:g,sessionID:""+l,manager:"Cipher",operation:this.operation[20],encMsg:d,args:{algorithm:a,mode:0,padding:0},keys:{key:c,iv:b},options:{center:m(),fromCharset:e,toCharset:f}};s(JSON.stringify(a),g,h)}function ra(a,b,c,d){a=v(p,t);null==a||0>=a.length?d(-1):(b={messageNumber:g,sessionID:""+l,operation:this.operation[21],tokenIdentifier:a,certIdentifier:b.kmcertIdentifier,plain:c,options:{center:m()}},s(JSON.stringify(b),g,d))}function sa(a,b,c,d,e){a=v(p,t);null==a||0>=a.length?e(-1):(b={messageNumber:g,sessionID:""+l,operation:this.operation[22],tokenIdentifier:a,pin:c,keyIdentifier:b.kmkeyIdentifier,envelopedMsg:d,options:{center:m()}},s(JSON.stringify(b),g,e))}function ta(a,b,c){a=v(I.device,0);null==a||0>=a.length?c(-1):(a={messageNumber:g,sessionID:""+l,operation:this.operation[23],tokenIdentifier:a,options:{center:m()}},s(JSON.stringify(a),g,c))}function ua(a,b){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage,b(k,n);else{q.length=0;p=I.device;t=0;for(var c=eval(a.list),d=c.length,e=0;e<d;e++){var f=c[e],h={};h.subject=f.subject;h.issuer=f.issuer;h.serial=f.serial;h.validFrom=f.validFrom;h.validTo=f.validTo;h.certIdentifier=f.certIdentifier;h.keyIdentifier=f.keyIdentifier;h.kmcertIdentifier=f.kmCertIdentifier;h.kmkeyIdentifier=f.kmKeyIdentifier;var g={};g.id=f.policy.id;g.userNotice=f.policy.userNotice;h.policy=g;h.cert="";q[e]=h}b(a.resultCode,a.resultMessage)}}function C(a){var b=0;switch(a){case 0:for(b=0;b<w.length;b++)if(w[b].operation==this.operation[0]||w[b].operation==this.operation[1]||w[b].operation==this.operation[2])w[b].valid=!1;break;case 1:for(b=0;b<w.length;b++)if(w[b].operation==this.operation[1]||w[b].operation==this.operation[2])w[b].valid=!1;break;case 2:for(b=0;b<w.length;b++)w[b].operation==this.operation[2]&&(w[b].valid=!1)}}var g=0,l=Math.random();this.operation=[];this.operation[0]="GetTokenList";this.operation[1]="GetCertificateList";this.operation[2]="GetCertificate";this.operation[3]="GenerateSignature";this.operation[4]="IssueCertificate";this.operation[5]="DeleteCertificate";this.operation[6]="UpdateCertificate";this.operation[7]="RevokeCertificate";this.operation[8]="GetVersion";this.operation[9]="ChangeStorage";this.operation[10]="ValidateCertificate";this.operation[11]="ExportCertificate";this.operation[12]="ImportCertificate";this.operation[13]="ChangePin";this.operation[14]="VerifySignature";this.operation[15]="VerifyVID";this.operation[16]="SetTokenOptions";this.operation[17]="GetCACertificate";this.operation[18]="GetHash";this.operation[19]="Encrypt";this.operation[20]="Decrypt";this.operation[21]="Envelope";this.operation[22]="Deenvelope";this.operation[23]="GetCertificateListWithP12";var z=!1,D=null,u=[],q=[],p=0,t=0,B=null,k="",n="",E=0,w=[],A="https://127.0.0.1:14461",M={device:1,name:"DISK DRIVE"},G={device:2,name:"PKCS#11 TOKEN"},H={device:3,name:"SmartCard TOKEN"},F={device:4,name:"Ubikey"},S={device:5,name:"DISK DRIVE"},y={device:6,name:"Mobile USIM"},I={device:9,name:"PKCS#12 TOKEN"},K=0,N=function(a){if(a.origin==A&&(z=!0,!(null==a.data||0>=a.data.length))){var b=0,c="",d=null;a=JSON.parse(a.data);for(b=0;b<w.length;b++)if(w[b].messageNumber==a.messageNumber){if(!1==w[b].valid){w[b].callback(-1);return}a.operation==this.operation[2]&&(c=w[b].certIdentifier);d=w[b].callback;w[b]=0;break}if(a.operation==this.operation[0])ga(a,d);else if(a.operation==this.operation[1])ha(a,d);else if(a.operation==this.operation[2])if(b=c,0!=a.resultCode&&"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage,d(k,"");else{for(var c=q.length,e=0;e<c;e++)b==q[e].certIdentifier&&(q[e].cert=a.certificate);d(a.resultCode,a.certificate)}else if(a.operation==this.operation[3]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;b="";b=a.file?a.file:a.signature;void 0!=a.encryptedVIDRandom?d(a.resultCode,a.resultMessage,b,a.encryptedVIDRandom):d(a.resultCode,a.resultMessage,b,"")}else if(a.operation==this.operation[4])0!=a.resultCode||"ok"!=a.resultMessage?(k=a.resultCode,n=a.resultMessage,d(k,n)):d(0,"success");else if(a.operation==this.operation[5]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[6]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[7]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[8])D=a.list[0].version,a=D.split("."),D=a[0]+"."+a[1]+"."+a[2]+".0",d(D);else if(a.operation==this.operation[9]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[10]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage,a.validCode,a.validMessage)}else if(a.operation==this.operation[11]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[12]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[13]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage)}else if(a.operation==this.operation[14])k=a.resultCode,n=a.resultMessage,b="",b=a.file?a.file:a.verifyResult,d(a.resultCode,b);else if(a.operation==this.operation[15])k=a.resultCode,n=a.resultMessage,d(a.resultCode,a.resultMessage);else if(a.operation==this.operation[16])k=a.resultCode,n=a.resultMessage,d(a.resultCode);else if(a.operation==this.operation[17])0!=a.resultCode||"ok"!=a.resultMessage?(k=a.resultCode,n=a.resultMessage,d(k)):d(a.resultCode,a.caCertificate,a.rootCertificate);else if(a.operation==this.operation[18]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.hash)}else if(a.operation==this.operation[19]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.encResult)}else if(a.operation==this.operation[20]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.decResult)}else if(a.operation==this.operation[21]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage,a.envelopeResult)}else if(a.operation==this.operation[22]){if(0!=a.resultCode||"ok"!=a.resultMessage)k=a.resultCode,n=a.resultMessage;d(a.resultCode,a.resultMessage,a.deenvelopeResult)}else a.operation==this.operation[23]&&ua(a,d)}},U=function(a){z=!1;var b=!0,c=function(c,d){b&&(b=!1,c&&c.parentNode&&c.parentNode.removeChild(c),d?setTimeout(function(){P(function(b){1*b.replace(/\./g,"")<1*x.nimVersion.replace(/\./g,"")?(alert(x.uiUtil().getErrorMessageLang().IDS_ERROR_NIM_NOT_LASTEST_VERSION),null!=parent?parent.document.location=x.nimCheckUrl:document.location=x.nimCheckUrl):(z=d,a(d))})},300):(z=d,a(d)))},d;-1!=navigator.userAgent.indexOf("MSIE 7.0")?d=document.createElement("<img id='hsmImg' src='"+A+"/TIC?cd="+Math.random()+"' onload='' onerror='fnResult(this, false)' />"):(d=document.createElement("img"),d.setAttribute("id","hsmImg"),d.setAttribute("src",A+"/TIC?cd="+Math.random()));d.onerror=function(){c(d,!1)};d.onload=function(){c(d,!0)};d.style.display="none";document.body.appendChild(d);if(-1!=navigator.userAgent.indexOf("MSIE 8")){var e=function(){!1==z?setTimeout(e,100):c(null,!0)};setTimeout(e,100)}};U(function(a){(z=a)?(a=document.getElementById("hsmiframe"),null!=a&&(a.onload=function(){J()})):(alert(x.uiUtil().getErrorMessageLang().IDS_ERROR_NIM_NOT_INSTALL),null!=parent?parent.document.location=x.nimCheckUrl:document.location=x.nimCheckUrl)});J();var r=function(a,b){-1!=b&&x.uiUtil().loadingBox(!0,"us-div-list-load",b);U(function(b){b?a():(document.location="mangowire:///",setTimeout(a,1500))})};return{Version:function(a){r(function(){null==D?P(a):a(D)})},GetLastErrorCode:function(){return k},GetLastErrorMessage:function(){return n},IsAvailable:function(){return z},GetAllUserCertListNum:function(a,b,c,d,e){r(function(){C(1);k=-1;n="";p=a;t=b;B=d;a==F.device?la(x.ubiKeyEnv.version,x.ubiKeyEnv.siteInfo,x.ubiKeyEnv.securityInfo,x.ubiKeyEnv.downloadURL,function(a){0==a?Q(e):e(a,0)}):Q(e)},0)},GetSignDataP7:function(a,b,c,d,e,f,h){r(function(){k=-1;n="";R(q[a-1],b,c,d,e,f,h)},1)},GetAllUserCert:function(a,b){r(function(){function c(f,h){if(0==f){if(null!=h&&0<h.length){var g={};g.index=d+1;g.cert=h;e[d]=g}}else return b(f),!1;if(a==e.length)return __callback=null,b(0,e),!0;d+=1;L(q[d],c)}C(2);var d=0,e=[];L(q[d],c)})},GetSignDataP1:function(a,b,c,d,e){r(function(){k=-1;n="";aa(q[a-1],b,c,d,e)},1)},GetCert:function(a){return q&&q[a-1]?q[a-1].cert:null},GetIframeLoaded:function(){return z},ExpireCertificate:function(){},DeleteCertificate:function(a,b,c,d){r(function(){k=-1;n="";p=a;t=b;Y(q[c-1],d)},3)},RenewCertificate:function(a,b,c,d,e,f,h,g){r(function(){k=-1;n="";p=c;t=d;X(a,b,q[e-1],f,h,g)},4)},RevokeCertificate:function(a,b,c,d,e,f,g){r(function(){k=-1;n="";p=c;t=d;Z(a,b,f,q[e-1],g)},2)},IssueCertificate:function(a,b,c,d,e,f,g,l){r(function(){k=-1;n="";p=c;t=d;W(a,b,f,g,l)})},GetDiskListNum:function(a,b){C(0);p=a;for(var c=0,d=u.length,e=0,c=0;c<d;c++)u[c].device==a&&e++;b(e)},GetDiskDriveName:function(a){for(var b=0,c=u.length,b=0;b<c;b++)if(u[b].device==M.device&&u[b].drive==a)return u[b].name;return""},ValidateCertificate:function(a,b){r(function(){k=-1;n="";ca(q[a-1],b)},12)},CopyCert:function(a,b,c,d,e,f,g){r(function(){p=a;t=b;ba(c,d,q[e-1],f,g)},5)},ImportCert:function(a,b,c){r(function(){p=a;t=b;ea(c)},6)},ExportCert:function(a,b,c,d,e){r(function(){p=a;t=b;da(q[c-1],d,e)},7)},ChangePassword:function(a,b,c,d){r(function(){p=a;t=b;fa(q[c-1],d)},8)},VerifySignedData:function(a,b,c){r(function(){T(0,a,b,c)})},VerifySignature:function(a,b,c,d){r(function(){ia(a,b,c,d)})},GetSecureTokenName:function(a){for(var b=0,c=u.length,b=0;b<c;b++)if(u[b].device==G.device&&u[b].drive==a)return u[b].name+"|"+u[b].type+"|"+u[b].trusted;return""},GetSmartCardName:function(a){for(var b=0,c=u.length,b=0;b<c;b++)if(u[b].device==H.device&&u[b].drive==a)return u[b].name;return""},GetMobileTokenName:function(a){for(var b=0,c=u.length,b=0;b<c;b++)if(u[b].device==y.device&&u[b].drive==a)return u[b].name;return""},VerifyVID:function(a,b,c,d){r(function(){ka(q[a-1],b,c,d)})},GetCACertificates:function(a,b){r(function(){na(q[a-1],b)},-1)},VerifySignedDataWithHashValue:function(a,b,c){r(function(){T(2,a,b,c)})},GetAllMediaList:function(a,b){r(function(){function c(a,c){0==a?ma(x.usimEnv.sitecode,x.usimEnv.modecode,x.usimEnv.siteURL,x.usimEnv.serviceIP,x.usimEnv.servicePort,function(c){b(a,u.length);return!0}):b(a,c)}1==a&&0<u.length?b(0,u.length):(C(1),k=-1,n="",0==a?O(a,c):O(a,b))})},HashData:function(a,b,c,d){r(function(){oa(a,b,c,d)})},EncryptData:function(a,b,c,d,e,f,g){r(function(){pa(a,b,c,d,e,f,g)})},DecryptData:function(a,b,c,d,e,f,g){r(function(){qa(a,b,c,d,e,f,g)})},EnvelopData:function(a,b,c,d){r(function(){var e=q[b-1];"kmcert"==a&&e.certIdentifier==e.kmcertIdentifier?d(-2):ra(a,q[b-1],c,d)},10)},DeenvelopData:function(a,b,c,d,e){r(function(){var f=q[b-1];"kmcert"==a&&f.keyIdentifier==f.kmkeyIdentifier?e(-2):sa(a,q[b-1],c,d,e)},11)},GetCertListWithP12:function(a,b,c,d,e){r(function(){C(1);ta(c,d,e)})},GetSelectUserCert:function(a,b){r(function(){C(2);L(q[a-1],b)})},CheckPassword:function(a,b,c,d){r(function(){k=-1;n="";R(q[a-1],b,0,c,!0,null,d)},9)},GetSignFileP7:function(a,b,c,d,e,f){r(function(){k=-1;n="";$(q[a-1],b,c,d,e,f)},1)},VerifySignedFile:function(a,b,c,d,e,f){r(function(){ja(a,b,c,d,e,f)})}}};