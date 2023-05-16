/*
	CrossEX Prototype Interface
	iniLINE Co.,Ltd.
	%VERSIONINFO%
*/

// TODO Plugin Object Define
var TOUCHENEX;

var downBasePath = location.protocol+"//"+location.host;


// TODO Plugin Info Set
var touchenexInfo = {
	"exPluginCallName"	: "TOUCHENEX",			// 제품명
	"exPluginName"		: "TOUCHENEX",			// exinterface.js 최상단에 정의한 객체명
	"exPluginInfo"		: "touchenexInfo",		// exinterface.js 정의한 protocolInfo 객체명
	"exModuleName"		: "nxkey",			// 모듈명
	"tkInstallpage"		: "/TouchEn/install/install.html"+"?"+"&url=" + encodeURIComponent(window.location.href),// 설치페이지
	"tkMainpage"		: "/MAIN.do",		//설치완료 후 이동페이지 
	"tkInstalled"		: false,
	"exInstalled"		: false,
	"clInstalled"		: false,
	"lic"				: "eyJ2ZXJzaW9uIjoiMS4wIiwiaXNzdWVfZGF0ZSI6IjIwMjEwOTE3MTAzNTI0IiwicHJvdG9jb2xfbmFtZSI6InRvdWNoZW5leCIsInV1aWQiOiI1YmEwNmIwZjVmYjc0NDExOGVmMzRlNWU1NGE0ZTZhZCIsImxpY2Vuc2UiOiJYZWVEaDRCU3NTbzM3Z1lVUFl3QXpYWHp4Q3dFMFpIeDcxZUY1VGhEdllGOGdIY0xGOVN5REVVTHAzZlN1ZE5cL3dONHJLZkVwejZJMmIzbWt6cklkSFhOa2V1cFozbTVGSjNtZDdHVWpPRk9CSEZuMHdVdEs1VnJGUXVEaFNFdmNGRjU5YmcycGZTbUZXVUMxaXdJd3pQc1U4dXVhUFwveTB2UEFYK1RKMndqQkVKSzQrMmZEWEwyRm5HRDZVUTFOSjlIbTJBSnRVYmhVMno2SGFraXk1TDVFaTVyOHJ0bmlJQW4yTVl2MFJWY0U9In0=",
//	"lic"				: "eyJ2ZXJzaW9uIjoiMS4weyJ2ZXJzaW9uIjoiMS4wIiwiaXNzdWVfZGF0ZSI6IjIwMTUxMDA4MTc0NjQwIiwicHJvdG9jb2xfbmFtZSI6InRvdWNoZW5leCIsInV1aWQiOiIwOWM4ZDg5NTNjOWE0YTMxYmEyNzcyMjQ2N2NmNWZmZSIsImxpY2Vuc2UiOiJRblVtUXB4ODUwTThjVnJkZHlMdW04RUR2NEZaMUhiVUYrUjV3eVpRQndBTGV3dCsxZDdMUGhFb3ViVHB6REFnN0VFR1pnZ2NOQ294VnFMQW1IUW1cL1wvZjl4aFBcL29JVWlEeFV2OGFDZlwvY289In0=IiwiaXNzdWVfZGF0ZSI6IjIwMTUxMDA4MTc0NjQwIiwicHJvdG9jb2xfbmFtZSI6InRvdWNoZW5leCIsInV1aWQiOiIwOWM4ZDg5NTNjOWE0YTMxYmEyNzcyMjQ2N2NmNWZmZSIsImxpY2Vuc2UiOiJRblVtUXB4ODUwTThjVnJkZHlMdW04RUR2NEZaMUhiVUYrUjV3eVpRQndBTGV3dCsxZDdMUGhFb3ViVHB6REFnN0VFR1pnZ2NOQ294VnFMQW1IUW1cL1wvZjl4aFBcL29JVWlEeFV2OGFDZlwvY289In0=",	//임시라이선스

	// Module Info, 플러그인 설치파일 경로
	"moduleInfo" : {
		"exWinVer"			: "1.0.0.17",
		"exWinClient"		: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_32bit.exe",
		"exWin64Ver"		: "1.0.0.17",
		"exWin64Client"		: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_64bit.exe"
	},

	// EX Protocol Info, EX를 포함한 플러그인 클라이언트 파일 경로
	"exProtocolInfo" : {
		"exWinProtocolVer"			: "1.0.1.745",
		"exWinProtocolDownURL"		: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_32bit.exe",
		"exWin64ProtocolDownURL"	: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_64bit.exe"
	},

	//////////////////////////////////////////////////////////////
	//////       CrossEX AREA DO NOT EDIT !!
	//////////////////////////////////////////////////////////////
	"isInstalled"		: false,
	"exProtocolName"	: "touchenex",
	"exExtHeader"		: "touchenex",
	"exNPPluginId"		: "touchenexPlugin",
	"exNPMimeType"		: "application/x-raon-touchenex",
	"exFormName"		: "__TOUCHENEX_FORM__",
	"exFormDataName"	: "__CROSSEX_DATA__",

	// Extension Info
	"exExtensionInfo" : {
		"exChromeExtVer"		: "1.0.1.6",
		"exChromeExtDownURL"	: "https://chrome.google.com/webstore/detail/dncepekefegjiljlfbihljgogephdhph",
		"exFirefoxExtVer"		: "1.0.1.9",
		"exFirefoxExtDownURL"	: downBasePath + touchenexBaseDir + "/nxKey/module/touchenex_firefox.xpi",
		"exFirefoxExtIcon"		: "",//48*48 icon
		"exOperaExtVer"			: "1.0.1.6",
		"exOperaExtDownURL"		: downBasePath + touchenexBaseDir + "/nxKey/module/touchenex_opera.nex"
	}
};


// TODO Plugin Interface Define
var touchenexInterface = {
	TestEXPush : function( params ){
		TOUCHENEX.SetPushCallback("new", params);
	},

	TestEXPushAdd : function( params ){
		TOUCHENEX.SetPushCallback("add", params);
	},

	//////////////////////////////////////////////
	// UserDefinition Interface Code Area......
	//////////////////////////////////////////////


	//=======================================================
	// start here...

	TK_Request : function( params, callback ){
		var exCallback = "touchenexInterface.TK_RequestCallback";
		TOUCHENEX.Invoke("Request", params, exCallback, callback);
	},

	TK_RequestCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_RequestCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_RequestCallback [exception] result", result);
			exalert("touchenexInterface.TK_RequestCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	GetEncData : function( params, callback){
			var exCallback = "touchenexInterface.GetEncDataCallback";
			TOUCHENEX.Invoke("GetEncData", params, exCallback, callback);
	},


	GetEncDataCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.GetEncDataCallback", result);
			if(result.callback){
				eval(result.callback)(result);
			}
		} catch (e) {
			exlog("touchenexInterface.GetEncDataCallback [exception] result", result);
			exalert("touchenexInterface.GetEncDataCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},


	TK_Start : function( params, callback ){
		exlog("TK_Start.params", params);
		var exCallback = "touchenexInterface.TK_StartCallback";
		TOUCHENEX.Invoke("Key_Start", params, exCallback, callback);
	},

	TK_StartCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_StartCallback", result);
			//exalert("touchenexInterface.TK_StartCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_StartCallback [exception] result", result);
			exalert("touchenexInterface.TK_StartCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_Init : function( params, callback ){
		exlog("TK_Init.params", params);
		var exCallback = "touchenexInterface.TK_InitCallback";
		TOUCHENEX.Invoke("Key_Init", params, exCallback, callback);
	},

	TK_InitCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_InitCallback", result);
			//exalert("EXInterface.TK_StartCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_InitCallback [exception] result", result);
			exalert("touchenexInterface.TK_InitCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_Stop : function( params, callback ){

		var exCallback = "touchenexInterface.TK_StopCallback";
		TOUCHENEX.Invoke("Key_Stop", params, exCallback, callback);
	},

	TK_StopCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_StopCallback", result);
			//exalert("touchenexInterface.TK_StopCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_StopCallback [exception] result", result);
			exalert("touchenexInterface.TK_StopCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_RealStop : function( params, callback ){

		var exCallback = "touchenexInterface.TK_RealStopCallback";
		TOUCHENEX.Invoke("Key_RealStop", params, exCallback, callback);
	},

	TK_RealStopCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_RealStopCallback", result);
			//exalert("touchenexInterface.TK_StopCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_RealStopCallback [exception] result", result);
			exalert("touchenexInterface.TK_RealStopCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_KeyDown : function( params, callback ){

		var exCallback = "touchenexInterface.TK_KeyDownCallback";
		TOUCHENEX.Invoke("Key_Keydown", params, exCallback, callback);
	},

	TK_KeyDownCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_KeyDownCallback", result);
			//exalert("touchenexInterface.TK_KeyDownCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_KeyDownCallback [exception] result", result);
			exalert("touchenexInterface.TK_KeyDownCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	}

};
