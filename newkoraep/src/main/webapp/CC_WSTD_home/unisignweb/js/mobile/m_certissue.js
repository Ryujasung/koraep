var __certissue=function(a){var m=function(e){function g(b){if(!b)return!1;var d=document.getElementById("m-us-cert-issue-ref-number-textbox"),c=document.getElementById("m-us-cert-issue-auth-code-textbox");if(!d.value)return a.uiUtil().msgBox(b.IDS_MSGBOX_ERROR_PLEASE_INPUT_REF_NUM),d.focus(),!1;if(!c.value)return a.uiUtil().msgBox(b.IDS_MSGBOX_ERROR_PLEASE_INPUT_AUTH_CODE),c.focus(),!1;e.onConfirm(d.value,c.value);return!0}var f=function(){var b;b=window.XMLHttpRequest?new window.XMLHttpRequest:
new ActiveXObject("MSXML2.XMLHTTP.3.0");b.open("GET",a.ESVS.SRCPath+"unisignweb/rsrc/layout/mobile/m_certissue.html?version="+a.ver,!1);b.send(null);return b.responseText},c=function(){var b;b=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");b.open("GET",a.ESVS.SRCPath+"unisignweb/rsrc/lang/certissue_"+a.ESVS.Language+".js?version="+a.ver,!1);b.send(null);return b.responseText},h=a.ESVS.TabIndex;return function(){var b=eval(f),d=eval(eval(c)());a.ESVS.TargetObj.innerHTML=
b();document.getElementById("m-us-cert-issue-lbl-title").appendChild(document.createTextNode(d.IDS_CERT_ISSUE));b=document.getElementById("m-us-cert-issue-cls-btn-img");b.setAttribute("alt",d.IDS_CERT_ISSUE_CLOSE,0);b.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/mobile/m_x-btn.png",0);document.getElementById("m-us-cert-issue-notice-lbl").appendChild(document.createTextNode(d.IDS_CERT_ISSUE_NOTICE));document.getElementById("m-us-cert-issue-ref-number-lbl").appendChild(document.createTextNode(d.IDS_CERT_ISSUE_REF_NUM));
document.getElementById("m-us-cert-issue-ref-number-textbox").setAttribute("tabindex",h,0);document.getElementById("m-us-cert-issue-auth-code-lbl").appendChild(document.createTextNode(d.IDS_CERT_ISSUE_AUTH_CODE));document.getElementById("m-us-cert-issue-auth-code-textbox").setAttribute("tabindex",h+1,0);b=document.getElementById("m-us-cert-issue-confirm-btn");b.setAttribute("value",d.IDS_CONFIRM,0);b.setAttribute("title",d.IDS_CONFIRM+d.IDS_BUTTON,0);b.setAttribute("tabindex",h+2,0);b.onclick=function(){g(d)};
b=document.getElementById("m-us-cert-issue-cls-img-btn");b.setAttribute("tabindex",h+3,0);b.onclick=function(){e.onCancel()};return document.getElementById("m-us-div-cert-issue")}()};return function(e){var g=a.uiLayerLevel,f=a.uiUtil().getOverlay(g),c=m({type:e.type,args:e.args,onConfirm:e.onConfirm,onCancel:e.onCancel});c.style.zIndex=g+1;a.ESVS.TargetObj.insertBefore(f,a.ESVS.TargetObj.firstChild);var h=window.onorientationchange;return{show:function(){f.style.display="block";var b=a.uiUtil().getNumSize(a.uiUtil().getStyle(c,
"height","height")),b=-1===b?a.uiUtil().getScrollTop()+a.uiUtil().getViewportHeight()/6:a.uiUtil().getScrollTop()+(a.uiUtil().getViewportHeight()-b)/3;c.style.top=0>b?"0px":b+"px";c.style.left=a.uiUtil().getScrollLeft()+(a.uiUtil().getViewportWidth()-a.uiUtil().getNumSize(a.uiUtil().getStyle(c,"width","width")))/2+"px";c.style.display="block";var d=0,e=0,g=0,l=0;0==window.orientation||180==window.orientation?(d=a.uiUtil().getViewportWidth(),e=a.uiUtil().getViewportHeight()):(g=a.uiUtil().getViewportWidth(),
l=a.uiUtil().getViewportHeight());window.addEventListener("orientationchange",function(){var b=0,k=0;"android chrome"==a.browserName||"unknown"==a.browserName?0==window.orientation||180==window.orientation?0<d?(b=d,k=e):(b=l+87,k=g-40):0<g?(b=g,k=l):(b=e+87,k=d-40):(b=a.uiUtil().getViewportWidth(),k=a.uiUtil().getViewportHeight());var f=a.uiUtil().getNumSize(a.uiUtil().getStyle(c,"width","width"));-1<f&&(b=a.uiUtil().getScrollLeft()+(b-f)/2+"px",c.style.left=b);b=a.uiUtil().getNumSize(a.uiUtil().getStyle(c,
"height","height"));k=-1===b?a.uiUtil().getScrollTop()+k/6:a.uiUtil().getScrollTop()+(k-b)/3;c.style.top=k+"px";h&&h()});a.uiLayerLevel+=10;a.ESVS.TabIndex+=30;setTimeout(function(){var a=c.getElementsByTagName("input");if(0<a.length)for(var b=0;b<a.length;b++)"m-us-cert-issue-ref-number-textbox"==a[b].id&&a[b].focus()},10)},hide:function(){f.style.display="none";c.style.display="none"},dispose:function(){window.addEventListener("orientationchange",function(){h&&h()});c.parentNode.removeChild(c);
f.parentNode.removeChild(f);a.uiLayerLevel-=10;a.ESVS.TabIndex-=30}}}};
