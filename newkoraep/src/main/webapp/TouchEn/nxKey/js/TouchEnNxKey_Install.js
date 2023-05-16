/**
 * fileDownload sample script
 */
var TOUCHENEX_INSTALL = {
	
	installWindow : null,
	
	download : function( moduleName, type ) {
		
		var pluginInfo = {};
		for(var i = 0; i < TOUCHENEX_CONST.pluginInfo.length; i++){
			if(TOUCHENEX_CONST.pluginInfo[i].exModuleName == moduleName){
				pluginInfo = TOUCHENEX_CONST.pluginInfo[i];
				//exlog("_INSTALL.download", pluginInfo);
				break;
			}
		}
		var dummyParam = "dummy="+Math.floor(Math.random() * 10000) + 1;
		
		// Extension
		if(type == "extension"){
			
			if(TOUCHENEX_UTIL.isChrome()){
				
				if(!this.installWindow || this.installWindow.closed){
					this.installWindow = window.open(touchenexInfo.exExtensionInfo.exChromeExtDownURL);
					if(this.installWindow == null) alert("팝업차단을 확인해주세요.");
				}
				
			} else if(TOUCHENEX_UTIL.isFirefox()) {
				
				var params = {};
				dummyParam = "ver=" + touchenexInfo.exExtensionInfo.exFirefoxExtVer;
				
				params[touchenexInfo.exProtocolName + "_firefox"] = {
					URL: touchenexInfo.exExtensionInfo.exFirefoxExtDownURL + "?" + dummyParam,
					IconURL: touchenexInfo.exExtensionInfo.exFirefoxExtIcon
				};
				InstallTrigger.install(params);
				
			} else if(TOUCHENEX_UTIL.isOpera()) {
				
				dummyParam = "ver=" + touchenexInfo.exExtensionInfo.exOperaExtVer;
				location.href = touchenexInfo.exExtensionInfo.exOperaExtDownURL + "?" + dummyParam;
			} else {
				alert("현재 브라우저는 extension 설치를 지원하지 않습니다.");
			}
			return;
		}
		
		// EX
		if(type == "EX"){
			var downURL = "";
			
			if(TOUCHENEX_UTIL.isWin()){
				if(TOUCHENEX_UTIL.isIE() && (TOUCHENEX_UTIL.getBrowserBit() == "64")){
					downURL = touchenexInfo.exProtocolInfo.exWin64ProtocolDownURL;
				} else {
					downURL = touchenexInfo.exProtocolInfo.exWinProtocolDownURL;
				}
			} else if(TOUCHENEX_UTIL.isMac()){
				downURL = touchenexInfo.exProtocolInfo.exMacProtocolDownURL;
			} else if(TOUCHENEX_UTIL.isLinux()){
				// TODO
			}
			
			if(!TOUCHENEX_UTIL.isIE()){
				dummyParam = "ver=" + touchenexInfo.exProtocolInfo.exWinProtocolVer;
				location.href = downURL + "?" + dummyParam;
			} else {
				location.href = downURL;
			}
			return;
		}
		
		// Client
		if(type == "client"){
			var downURL = "";
			
			if(TOUCHENEX_UTIL.isWin()){
				if(TOUCHENEX_UTIL.isIE() && (TOUCHENEX_UTIL.getBrowserBit() == "64")){
					downURL = touchenexInfo.moduleInfo.exWin64Client;
				} else {
					downURL = touchenexInfo.moduleInfo.exWinClient;
				}
			} else if(TOUCHENEX_UTIL.isMac()){
				downURL = touchenexInfo.moduleInfo.exMacClient;
			} else if(TOUCHENEX_UTIL.isLinux()){
				// TODO
			}
			
			if(!TOUCHENEX_UTIL.isIE()){
				dummyParam = "ver=" + touchenexInfo.moduleInfo.exWinVer;
				location.href = downURL + "?" + dummyParam;
			} else {
				location.href = downURL;
			}
			return;
		}
	}
};

