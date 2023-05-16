﻿var __nimservice = function( __SANDBOX ) {
	
	var messageNumber = 0;
	var sessionID = Math.random();
	
	this.operation = new Array();
	this.operation[0]			= "GetTokenList";			// gettokenlist
	this.operation[1]			= "GetCertificateList";		// getcertlist
	this.operation[2]			= "GetCertificate";			// getcert
	this.operation[3]			= "GenerateSignature";		// signdata
	this.operation[4]			= "IssueCertificate";		// IssueCertificate
	this.operation[5]			= "DeleteCertificate";		// DeleteCertificate
	this.operation[6]			= "UpdateCertificate";		// UpdateCertificate
	this.operation[7]			= "RevokeCertificate";		// RevokeCertificate
	this.operation[8]			= "GetVersion";				// GetVersion
	this.operation[9]			= "ChangeStorage";			// ChangeStorage
	this.operation[10]			= "ValidateCertificate";	// ValidateCertificate
	this.operation[11]			= "ExportCertificate";		// ExportCertificate
	this.operation[12]			= "ImportCertificate";		// ImportCertificate
	this.operation[13]			= "ChangePin";				// ChangePin
	this.operation[14]			= "VerifySignature";		// VerifySignature
	this.operation[15]			= "VerifyVID";				// VerifyVID
	this.operation[16]			= "SetTokenOptions";		// SetTokenOptions	
	this.operation[17]			= "GetCACertificate";		// GetCACertificate	
	
	var iframeLoaded = false;
	
	var currentVersion = null;
	
	var curIndex = 0;
	var curOperation = this.operation[0];
	
	var tokenList = new Array();
	var certList = new Array();
	
	var __device = 0;
	var __drive = 0;
	var __pin = "";
	var __policy = null;
	
	var __callback = null;
	var errCode = "";
	var errMsg = "";
	
	var iframesrc = 'https://127.0.0.1:14461';

	var getjustdiskList = 0;
	
	// nhkim 20151007
	var __USFB_M_DISK =	{'device':1, 'name':'DISK DRIVE'};  // Removable Disk
	var __USFB_M_HSMKEY =	{'device':2, 'name':'PKCS#11 TOKEN'};  // Security Token
	var __USFB_M_SMARTCARD =	{'device':3, 'name':'SmartCard TOKEN'};  // Smart Card
	var __USFB_M_MOBILE =	{'device':4, 'name':'Ubikey'};  // Mobile Phone
	var __USFB_M_HDD =	{'device':5, 'name':'DISK DRIVE'};  // Hard Disk
	var __USFB_M_MOBILETOKEN =	{'device':13, 'name':'smartsign'};  // Mobile Token (USIM)

	var cntAdd = 0;
	
	function trace(str){
		if(document.getElementById("tconsole") != null) document.getElementById("tconsole").value += ">> " + str + "\n";
	}
	
	function sendMessage(fn, json){
		try {
			var target = document.getElementById("hsmiframe");
			
			if(typeof window.postMessage === 'undefined'){
				eval(CODE);
				var util = window.crosscert.util || {};
				var IE7_IMG = iframesrc + '/TIC';
				var IE7_FORM = iframesrc + '/VestCert/MangoFS.jsp';
				var ID_IFRAME = "IFR_SERVER";
				var ID_FORM = "FRM_SENDER";
				
				var iframe = document.getElementById(ID_IFRAME);
				var form = document.getElementById(ID_FORM);
				var message = document.getElementById("message");
				var returnURL = document.getElementById("returnURL");

				if(iframe != null) iframe.parentNode.removeChild(iframe);
				if(form != null) form.parentNode.removeChild(form);
				
				if (navigator.userAgent.indexOf("MSIE 7.0") != -1) {
					iframe = document.createElement('<iframe id="' + ID_IFRAME + '" name="' + ID_IFRAME + '" src="' + IE7_IMG + '" />');
					iframe.style.display = "none";
					document.body.appendChild(iframe);
					
					form = document.createElement('<form id="' + ID_FORM + '" action="' + IE7_FORM + '" method="post" target="' + ID_IFRAME + '" > </form>');
					form.style.display = "none";
					document.body.appendChild(form);
				} else {
					iframe = document.createElement('iframe');
					iframe.setAttribute('id', ID_IFRAME);
					iframe.setAttribute('name', ID_IFRAME);
					iframe.setAttribute('src', IE7_IMG);
					iframe.style.display = "none";
					document.body.appendChild(iframe);
					
					form = document.createElement('form');
					form.setAttribute('id', ID_FORM);
					form.setAttribute('action', IE7_FORM);
					form.setAttribute('method', 'post');
					form.setAttribute('target', ID_IFRAME);
					form.style.display = "none";
					document.body.appendChild(form);
				}
				
				message = document.createElement('input');
				message.setAttribute('id', 'message');
				message.setAttribute('name', 'message');
				message.value = util.bytesToHex(util.encodeUtf8(json));
				form.appendChild(message);
				
				returnURL = document.createElement('input');
				returnURL.setAttribute('id', 'fsreturnURL');
				returnURL.setAttribute('name', 'returnURL');
				form.appendChild(returnURL);
				var url = location.href;
				returnURL.value = util.bytesToHex(util.encodeUtf8(url));
				
				try{
					addEvent(iframe, 'onload', function(e){
						var obj = document.getElementById(ID_IFRAME);
						var res;
						var evnt = {};
						
						try {
							res = obj.contentWindow.name;
						} catch (excep) {
							throw (excep);
						}
						
						try {
							evnt.data = util.decodeUtf8(util.decode64(res));
							evnt.origin = iframesrc;
						} catch (nob64) {
							return;
						}
						receivedData( evnt );
	                });
				}catch(e){
					alert(e.message);
				}
				
                form.submit();
                
            } else {
                target.contentWindow.postMessage(json, iframesrc);
            }
			
		}catch(e) {
			if(__callback != null) __callback(-1);
		}
	}
	
	function removeEvent(obj, evnt, rcallback){
		if(obj == null) obj = window;
		cntAdd--;
		if (typeof obj.addEventListener === 'function') {
			if(evnt == null) evnt = 'message';
			obj.removeEventListener(evnt, rcallback, false);
		} else if (typeof obj.attachEvent === 'function') {
			if(evnt == null) evnt = 'onmessage';
			obj.detachEvent(evnt, rcallback);
		} else {
			if(evnt == null) evnt = 'onmessage';
			obj.detachEvent(evnt, rcallback);
		}
	}
	
	function addEvent(obj, evnt, rcallback)
	{
		if(obj == null) obj = window;
		if(rcallback == null) rcallback = receivedData;
		if(cntAdd > 0) removeEvent(obj, evnt, rcallback);
		
		if (typeof obj.addEventListener === 'function') {
			if(evnt == null) evnt = 'message';
			obj.addEventListener(evnt, rcallback, false);
		} else if (typeof obj.attachEvent === 'function') {
			if(evnt == null) evnt = 'onmessage';
			obj.attachEvent(evnt, rcallback);
		} else {
			if(evnt == null) evnt = 'onmessage';
			obj.attachEvent(evnt, rcallback);
		}
		cntAdd++
	}
	
	// send
	function GetTokenIdentifier( _device, _drive )
	{	
		var len = tokenList.length;
		for (var i = 0 ; i < len ; i++)
		{
			var objToken = tokenList[i];
			if (objToken.device == _device && objToken.drive == _drive)
			 	return "" + objToken.tokenIdentifier;
		}
		
		return ""; 	
	}
	
	function IssueCert(cmpIP, cmpPort, refNumber, authCode){					
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[4];
		var jsonGetTokenList = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"CAType" : "crosscert",
			"referenceNumber" : refNumber,
			"authenticationCode" : authCode,
			"options":{
				"CAServiceIP" : cmpIP,
				"CAServicePort" : cmpPort
			}
		};
		
		sendMessage("IssueCertificate", JSON.stringify(jsonGetTokenList));
	}
	
	function RenewCert(cmpIP, cmpPort, cert){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[6];
		var jsonGetTokenList = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"CAType": "crosscert",
			"oldcertIdentifier" : cert.certIdentifier,
			"oldKeyIdentifier" : cert.keyIdentifier,
			"options":{
				"CAServiceIP" : cmpIP,
				"CAServicePort" : cmpPort
			}
		};
		
		sendMessage("UpdateCertificate", JSON.stringify(jsonGetTokenList));
	}
	
	function DeleteCert(cert){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[5];
		var jsonGetTokenList = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"certIdentifier" : cert.certIdentifier,
			"KeyIdentifier" : cert.keyIdentifier
		};
		
		sendMessage("DeleteCertificate", JSON.stringify(jsonGetTokenList));
	}
	
	function RevokeCert(cmpIP, cmpPort, reason, cert){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[7];
		var jsonGetTokenList = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"CAType": "crosscert",
			"certIdentifier" : cert.certIdentifier,
			"keyIdentifier": cert.keyIdentifier,
			"options":{
				"CAServiceIP" : cmpIP,
				"CAServicePort" : cmpPort,
				"reason": reason
			}
		};
		
		sendMessage("RevokeCertificate", JSON.stringify(jsonGetTokenList));
	}
	
	function GetAllTokenList( certReload ){
		tokenList.length = 0;
		// 인증서 이동시 디스크로 복사할때 이부부이 실행되면서 선택창에 떠 있는 인증서 리스트가 사라짐
		//certList.length = 0;
		
		curOperation = this.operation[0];
		var jsonGetTokenList = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"reload" : certReload // 1일 경우 재로딩하지 않음. reload가 undefine dlrjsk 0일 경우 token과 인증서 재로딩
		};
		
		sendMessage("GetAllTokenList", JSON.stringify(jsonGetTokenList));
	}
	
	function GetVersion(){
		tokenList.length = 0;
		
		// 인증서 이동시 디스크로 복사할때 이부부이 실행되면서 선택창에 떠 있는 인증서 리스트가 사라짐
		//certList.length = 0;
		curOperation = this.operation[8];
		
		var jsonGetVersion = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation
		};
		
		sendMessage("GetVersion", JSON.stringify(jsonGetVersion));
	}
	
	function GetAllUserCertNum()
	{
		// nhkim 20150818
		certList.length = 0;
		
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 )
			return false;
		
		curOperation = this.operation[1];
		// nhkim 20150910
		var jsonGetCertList = null;
		if (__policy != null) {
			__policy = __policy.replace(/\|/gi, ";");
			jsonGetCertList = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,
				/* 1(개인 범용), 2(법인 범용), 4(개인 증권/보험), 8(신용카드) */
				"filter":{
					"mode": "",
					"OID": __policy  /* 요청할 인증서의 OID 목록 */
				}
			};
		} else {
			jsonGetCertList = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier
			};
		}
		
		__policy = null;
		sendMessage("GetAllUserCertNum", JSON.stringify(jsonGetCertList));
	}
	
	function GetUserCert( cert )
	{	
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[2];
		var jsonGetCert = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"certIdentifier": cert.certIdentifier
		};
		
		sendMessage("GetUserCert", JSON.stringify(jsonGetCert));
	}
	
	// nhkim 20150818
	function GetSignData( cert, pwd, plainText, inclCon, b64kmCert ) {
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[3];
		
		var typeSign = "2";  // pkcs7
		if ( inclCon == false )
			typeSign = "4"; // pkcs7(not include plain)
			
		// nhkim 20150810 - get vid
		if ( b64kmCert != null ) {
			var jsonGetSignData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,
				"pin": pwd,
				"certIdentifier": cert.certIdentifier,
				"keyIdentifier": cert.keyIdentifier,
				"plain": plainText,
				"options": {
					"vid": {"recipientCertificate": b64kmCert,
							"type": "1"  // pkcs7 envelop
						 },
					
					"signtype": typeSign,
					"encoding" : "0"  //base64							
				}
			};	
			sendMessage("GetSignData", JSON.stringify(jsonGetSignData));	
		} else {		
			var jsonGetSignData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,
				"pin": pwd,
				"certIdentifier": cert.certIdentifier,
				"keyIdentifier": cert.keyIdentifier,
				"plain": plainText,
				"options": {
					"signtype": typeSign,
					"encoding" : "0"  //base64						
				}					
			};
			sendMessage("GetSignData", JSON.stringify(jsonGetSignData));
		}
	}
	
	function GetSignP1Data( cert, pwd, plainText, b64kmCert ) {
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[3];
		
			// nhkim 20150810 - get vid
		if ( b64kmCert != null ) {
			var jsonGetSignData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,			
				"pin": pwd,
				// P1을 위해서는  certIdentifier 항목 없앰
				"keyIdentifier": cert.keyIdentifier,
				"plain": plainText,
				"options": {
					"vid": {"recipientCertificate": b64kmCert,
							"type": "1"
					},
					
					"signtype": "0",
					"encoding" : "0"  //base64						
				}
			};
			
			sendMessage("GetSignP1Data", JSON.stringify(jsonGetSignData));
		} else {
			var jsonGetSignData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,			
				"pin": pwd,
				// P1을 위해서는  certIdentifier 항목 없앰
				"keyIdentifier": cert.keyIdentifier,
				"plain": plainText,
				"options": {
					"signtype": "0",
					"encoding" : "0"  //base64						
				}				
			};
			
			sendMessage("GetSignP1Data", JSON.stringify(jsonGetSignData));
		}	
	}
	
	function ChangeStorage(tDevice, tDrive, cert, isDel){
		
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 )
			return false;
			
		var newTokenIdentifier = GetTokenIdentifier( tDevice, tDrive );
		if ( newTokenIdentifier == null || newTokenIdentifier.length <= 0 )
			return false;
					
		if(isDel == null || isDel == false) isDel = "0";
		else isDel = "1";
		
		curOperation = this.operation[9];
		
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"manager": "Manager",
			"operation": curOperation,			
			"tokenIdentifier": tokenIdentifier,
			"newTokenIdentifier": newTokenIdentifier,
			"certIdentifier": cert.certIdentifier,
			"keyIdentifier": cert.keyIdentifier,
			"deleteCert": isDel
		};
		
		sendMessage("ChangeStorage", JSON.stringify(jsonData));
	}
	
	// nhkim 20150918
	function ValidateCert( cert ){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[10];
		var jsonValidateCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"manager" : "Manager",
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"certIdentifier": cert.certIdentifier,
			"mode" : ""
		};
		
		sendMessage("ValidateCertificate", JSON.stringify(jsonValidateCertificate));
	}
	
	function ExportCertificate(cert, reuse){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[11];
		
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"manager": "Manager",
			"operation": curOperation,			
			"tokenIdentifier": tokenIdentifier,
			"certIdentifier": cert.certIdentifier,
			"keyIdentifier": cert.keyIdentifier,
			"reusePin": 1
		};
				
		sendMessage("ExportCertificate", JSON.stringify(jsonData));
	}
	
	function ImportCertificate(){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[12];
		
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"manager": "Manager",
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier
		};
		
		sendMessage("ImportCertificate", JSON.stringify(jsonData));
	}
	
	function ChangePin( cert ){
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;
		
		curOperation = this.operation[13];
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"manager": "Manager",
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"certIdentifier": cert.certIdentifier,
			"keyIdentifier": cert.keyIdentifier
		};
		
		sendMessage("ChangePin", JSON.stringify(jsonData));
	}
	
	//00
	function MakeTokenList( jsonData ){

		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[0] != obj.operation || obj.sessionID != sessionID ) return false;
	
		var objToken = eval(obj.list);
		
		// nhkim 20151016
		if (obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;			
			__callback(-1);
			return false;
		}
		
		var sectokenIndex = 1; 
		var smartCardIndex = 1; 
		var len = objToken.length;
		
		for (var i = 0 ; i < len ; i++) {
			var token = objToken[i];
			var struct = new Object();
			
			struct['tokenIdentifier'] = token.tokenIdentifier;
			struct['name'] = token.name;
			struct['type'] = token.type;
			
			// nim hard:0, removal:1,2,3
			// disk: 1, hsm: 2, save:3, mobile:4, hard:5
			if ( token.type == __USFB_M_HDD.name ) {
				if ( token.systemDrive == true )
					struct['device'] = __USFB_M_HDD.device;
				else
					struct['device'] = __USFB_M_DISK.device;
			}
			else if ( token.type == __USFB_M_MOBILE.name ) {
				struct['device'] = __USFB_M_MOBILE.device;
			}
			else if ( token.type == __USFB_M_HSMKEY.name ) {
				struct['device'] = __USFB_M_HSMKEY.device;
			}
			else if ( token.type == __USFB_M_SMARTCARD.name ) {
				struct['device'] = __USFB_M_SMARTCARD.device;
			}			
			else
				struct['device'] = 0;						
			/*
			struct['device'] = 0;
			if ( token.systemDrive == true )
				struct['device'] = 5;
			else if ( token.systemDrive == false )
				struct['device'] = 1;
			else  // ubikey returned
				struct['device'] = 4;
			*/
			
			// this is UI index
			// movable disk index start from 1. so, vestcert's movable disk index start from 1. just assist 
			struct['drive'] = 0;
			if ( struct['device'] == __USFB_M_HDD.device || struct['device'] == __USFB_M_DISK.device )
				struct['drive'] = token.tokenIdentifier;
			else if ( struct['device'] == __USFB_M_SMARTCARD.device ) {
				struct['drive'] = smartCardIndex;
				smartCardIndex = smartCardIndex + 1;				
			}
			else {
				struct['drive'] = sectokenIndex;
				sectokenIndex = sectokenIndex + 1;
				struct['trusted'] = token.trusted;			
			}			
			
			tokenList[i] = struct;				
		}
	
		if ( getjustdiskList ) {
			__callback(len);
			return false;
		}
		else
			return true;
	}
	
	function MakeCertList( jsonData ) {
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[1] != obj.operation || obj.sessionID != sessionID ){
			__callback(-1);
			return false;
		}
		
		// nhkim 20151016
		if (obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;			
			__callback(-1);
			return false;
		}
			
		var objToken = eval(obj.list); 
		var len = objToken.length;
		for (var i = 0 ; i < len ; i++)
		{
			var token = objToken[i];
			var struct = new Object();
			
			struct['subject'] = token.subject;
			struct['issuer'] = token.issuer;
			struct['serial'] = token.serial;
			struct['validFrom'] = token.validFrom;			
			struct['validTo'] = token.validTo;			
			struct['certIdentifier'] = token.certIdentifier;			
			struct['keyIdentifier'] = token.keyIdentifier;		
			
			struct['kmcertIdentifier'] = token.kmCertIdentifier;		/* 해당 인증서가 없을 경우 certIdentifier와 동일한 값 */	
			struct['kmkeyIdentifier'] = token.kmKeyIdentifier;		 /* 해당 키파일이 없을 경우 keyIdentifier와 동일한 값 */
			
			// nhkim 20150910
			var stPolicy = new Object();	
			stPolicy['id'] = token.policy.id;
			stPolicy['userNotice'] = token.policy.userNotice;	
			struct['policy'] = stPolicy;
			
			struct['cert'] = "";		
			
			certList[i] = struct;
		}
		
		__callback(certList.length);
	}
	
	function MakeCert( jsonData )
	{
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[2] != obj.operation || obj.sessionID != sessionID ){
			__callback("");
			return false;
		}
		
		if ( obj.resultCode != 0 && obj.resultMessage != "ok") {
			
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback("");
		}

		certList[curIndex].cert = obj.certificate;
		__callback(obj.certificate);
	}
	
	function MakeIssueCert( jsonData )
	{
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[4] != obj.operation || obj.sessionID != sessionID ){
			__callback("");
			return false;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback(errMsg, errCode);
		}else{
			__callback("success", 0);
		}
	}
	
	function UpdateCert ( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
	
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[6] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"OPERATION ERROR ( UpdateCert )"});
			return false;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
		__callback("ok");
	}
	
	function DeleteCertCheck ( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		if ( this.operation[5] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"OPERATION ERROR ( DeleteCertCheck )"});
			return false;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
		
		__callback("ok");
	}
	
	function RevokeCertCall( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
				
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[7] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"OPERATION ERROR ( RevokeCertCall )"});
			return false;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
		
		__callback("ok");
	}
	
	function GetVersionCall( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 )
			return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[8] != obj.operation || obj.sessionID != sessionID ){
			return false;
		}
		currentVersion = obj.list[0].version;
		
		getjustdiskList = 1;
		GetAllTokenList( getjustdiskList );
	}
	
	function MakeSignData( jsonData )
	{
		if ( jsonData == null || jsonData.length <= 0 )
			return false;
			
			
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[3] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"operation[3] Exception"});
			return false;
		}
			
		// nhkim 20150818 - get vid
		if (obj.encryptedVIDRandom != undefined) {
			__callback(obj.resultCode, obj.resultMessage, obj.signature, obj.encryptedVIDRandom);
		}
		else {
			__callback(obj.resultCode, obj.resultMessage, obj.signature, "");
		}			
	}
	
	function ChangeStorageCall( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 )
			return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[9] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"operation[9] Exception"});
			return;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
		
		__callback(obj.resultMessage);
	}
	
	// nhkim 20150918
	function ReceiveValidateCert( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[10] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"operation[10] Exception"});
			return;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
		
		__callback(obj.resultCode, obj.resultMessage, obj.validCode, obj.validMessage);
	}
	
	function ReceiveExportCertificate( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[11] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"operation[11] Exception"});
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
			
		__callback(obj.resultMessage);
	}
	
	function ReceiveImportCertificate( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[12] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"operation[12] Exception"});
			return;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			
			__callback({code: errCode, msg:errMsg});
			return;
		}
		
		__callback(obj.resultMessage);
	}
	
	function ReceiveChangePassword( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[13] != obj.operation || obj.sessionID != sessionID ){
			__callback({code: -1, msg:"operation[13] Exception"});
			return;
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
				
			__callback({code: errCode, msg:errMsg});
			return;
		}
		
		__callback(obj.resultMessage);
	}
	
	
	// nhkim 20151006
	function VerifyP7SignedData( b64PlainData, signedData ){
	
		curOperation = this.operation[14];
		var jsonData;
	
		if ( b64PlainData == null ) {
			jsonData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": "0", // for extension. just dummy data
				"signature" : signedData,
				"options":{
					"signtype": "2" /* 0: pkcs1, 2: pkcs7, 4: pkcs7 (not include plain) */
				}
			};			
		}
		else {		
			jsonData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"operation": curOperation,
				"tokenIdentifier": "0", // for extension. just dummy data
				"signature" : signedData,
				"params" : {
					"plain" : b64PlainData
				},
				"options":{
					"signtype": "4" /* 0: pkcs1, 2: pkcs7, 4: pkcs7 (not include plain) */
				}
			};			
		}		
		
		sendMessage("VerifySignature", JSON.stringify(jsonData));
	}	
	

	function VerifyP1SignedData( b64PlainData, signedData, cert ) {
	
		curOperation = this.operation[14];
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": "0", // for extension. just dummy data
			"signature" : signedData,
			"params" : {
				"plain" : b64PlainData,
				"type" : 0, // cert
				"certOrKey" : cert
			},
			
			"options":{
				"signtype": "0" /* 0: pkcs1, 2: pkcs7, 4: pkcs7 (not include plain) */
			}
		};
		
		sendMessage("VerifySignature", JSON.stringify(jsonData));
	}	
	
	function ReceiveVerifySignedData( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
	
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[14] != obj.operation || obj.sessionID != sessionID ){
			__callback(-1, "");
		}
		
		errCode = obj.resultCode;
		errMsg = obj.resultMessage;
		
		__callback(obj.resultCode, obj.verifyResult);
	}	
	
	
	function VerifyVIDWithSSN( cert, pwd, ssn ) {
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;

		curOperation = this.operation[15];
		var jsonData;
		
		if (pwd == null) {
			jsonData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"manager": "Manager",
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,
				"certIdentifier": cert.certIdentifier,
				"keyIdentifier": cert.keyIdentifier,
				"idn" : ssn
			};			
		} 
		else {
			jsonData = {
				"messageNumber": messageNumber,
				"sessionID": "" + sessionID,
				"manager": "Manager",
				"operation": curOperation,
				"tokenIdentifier": tokenIdentifier,
				"pin": pwd,
				"certIdentifier": cert.certIdentifier,
				"keyIdentifier": cert.keyIdentifier,
				"idn" : ssn
			};				
		}
		
		sendMessage("VerifyVID", JSON.stringify(jsonData));
	}	
	
	function ReceiveVerifyVID( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
	
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[15] != obj.operation || obj.sessionID != sessionID ){
			__callback(-1, "");
		}
		
		errCode = obj.resultCode;
		errMsg = obj.resultMessage;
		
		__callback(obj.resultCode, obj.resultMessage);
	}	
	
	function SetTokenOptions( device, options, version )	{
		curOperation = this.operation[16];
		
		var wParam = "";
		if (device == __USFB_M_MOBILETOKEN.device)
			wParam = "USIM|NULL|";
		else
			wParam = "INFOVINE|NULL|";
			
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": "0", // for extension. just dummy data
			"options" : {
				"wParam" : wParam,
				"lParam" : options, 
				"version" : version,
				"url" : ""
			}
		};
		
		sendMessage("SetTokenOptions", JSON.stringify(jsonData));		
	}
	
	function ReceiveSetMediaOptions( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
	
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[16] != obj.operation || obj.sessionID != sessionID ){
			__callback(-1);
		}
		
		errCode = obj.resultCode;
		errMsg = obj.resultMessage;
		
		__callback(obj.resultCode);
	}	
	
	function GetCACertificate( cert )	{
		var tokenIdentifier = GetTokenIdentifier( __device, __drive );
		if ( tokenIdentifier == null || tokenIdentifier.length <= 0 ) return false;

		curOperation = this.operation[17];
			
		var jsonData = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": curOperation,
			"tokenIdentifier": tokenIdentifier,
			"certIdentifier" : cert.certIdentifier
		};
		
		sendMessage("GetCACertificate", JSON.stringify(jsonData));		
	}
	
	function ReceiveGetCACertificate( jsonData ){
		if ( jsonData == null || jsonData.length <= 0 ) return false;
		
	
		var obj = JSON.parse(jsonData);
		messageNumber = obj.messageNumber + 1;
		
		if ( this.operation[17] != obj.operation || obj.sessionID != sessionID ){
			__callback(-1);
		}
		
		if ( obj.resultCode != 0 || obj.resultMessage != "ok") {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
				
			__callback(errCode);
			return;
		}
		
		__callback(obj.resultCode, obj.caCertificate, obj.rootCertificate);
	}			
	//	

	var receivedData = function (event)
	{
		if(event.origin == iframesrc)
		{
			iframeLoaded = true;
			if (curOperation == this.operation[0]) {
				if ( MakeTokenList( event.data ) == false ){
					return;
				}
				GetAllUserCertNum();
			}
			else if (curOperation == this.operation[1])
				MakeCertList( event.data );
			else if (curOperation == this.operation[2])
				MakeCert( event.data );			
			else if (curOperation == this.operation[3])
				MakeSignData( event.data );
			else if (curOperation == this.operation[4])
				MakeIssueCert( event.data );
			else if (curOperation == this.operation[5])
				DeleteCertCheck( event.data );
			else if (curOperation == this.operation[6])
				UpdateCert( event.data );
			else if (curOperation == this.operation[7])
				RevokeCertCall( event.data );
			else if (curOperation == this.operation[8])
				GetVersionCall( event.data );
			else if (curOperation == this.operation[9])
				ChangeStorageCall( event.data );
			else if (curOperation == this.operation[10])
				ReceiveValidateCert( event.data );
			else if (curOperation == this.operation[11])
				ReceiveExportCertificate( event.data );
			else if (curOperation == this.operation[12])
				ReceiveImportCertificate( event.data );
			else if (curOperation == this.operation[13])
				ReceiveChangePassword( event.data );
			else if (curOperation == this.operation[14])
				ReceiveVerifySignedData( event.data );
			else if (curOperation == this.operation[15])
				ReceiveVerifyVID( event.data );
			else if (curOperation == this.operation[16])
				ReceiveSetMediaOptions( event.data );	
			else if (curOperation == this.operation[17])
				ReceiveGetCACertificate( event.data );	
							
				
		} else {
			return;
		}
	}
	
	var fnInstallCheck = function(rv){
		var fnResult = function(obj, r){
			rv(r);
			obj.parentNode.removeChild(obj);
		}
		
		var chkImg;
		if (navigator.userAgent.indexOf("MSIE 7.0") != -1) {
			chkImg = document.createElement("<img id='hsmImg' src='"+iframesrc + '/TIC' + "' onload='fnResult(this, true)' onerror='fnResult(this, false)' />");
			chkImg.style.display = "none";
		} else {
			chkImg = document.createElement('img');
			chkImg.setAttribute('id', "hsmImg");
			chkImg.setAttribute('src', iframesrc + '/TIC');
			chkImg.onerror = function() {fnResult(chkImg, false);};
			chkImg.onload = function() {fnResult(chkImg, true);};
			chkImg.style.display = "none";
		}
		document.body.appendChild(chkImg);
	};
	
	fnInstallCheck(function(r){
		iframeLoaded = r;
		if(r){
			var hsmiframe = document.getElementById("hsmiframe");
			if(hsmiframe != null) hsmiframe.onload = function() {
				addEvent();
			};
		}else{
			alert(__SANDBOX.uiUtil().getErrorMessageLang().IDS_ERROR_NIM_NOT_INSTALL);
			if(parent != null) parent.document.location = __SANDBOX.nimCheckUrl;
			else document.location = __SANDBOX.nimCheckUrl;
		}
	});
	
	addEvent();
	
	/*
	var hsmiframe = document.getElementById("hsmiframe");
	if(hsmiframe != null) hsmiframe.onload = function() {
		if(iframeLoaded == false) addEvent();
	};
	
	if(iframeLoaded == false) addEvent();
	
	var checkCount = 0;
	var CheckForIframeLoad = function () {
		if(iframeLoaded == false){
			if(document.getElementById("hsmiframe") != null){
				if(checkCount == 5){
					//document.getElementById("hsmiframe").src = "mangowire:///";
				}else{
					if(document.getElementById("hsmiframe").src != iframesrc) document.getElementById("hsmiframe").src = iframesrc;
					if(checkCount > 19){
						iframeLoaded = null;
						errCode = -1;
						return;
					}
					//load 시점에 따라 메시지를 받을수가 없어서 새로 등록후 메시지 계속 발송.
					addEvent();
					setTimeout(GetVersion, 200);
				}
				
				setTimeout(function(){
					checkCount++;
					CheckForIframeLoad();
				}, 1000);
			}
		}
    }
	CheckForIframeLoad();*/
	
	
	var nimCall = function(fn){
		fnInstallCheck(function(r){
			if(r){
				if(iframeLoaded == false){
					var just = function(){
						if(iframeLoaded == false) setTimeout(just, 300);
						else fn();
					}
					just();
				}else fn();
			}else{
				document.location = "mangowire:///";
				setTimeout(fn, 1500);
			}
		});
	};
	
	return {	
		Version : function() {
			return currentVersion;
		},
		
		GetLastErrorCode : function() {
			return errCode;
		},
		
		GetLastErrorMessage : function() {
			return errMsg;
		},
		
		IsAvailable : function(){
			return iframeLoaded;
		},
					
		// nhkim 20150910 - filter policy
		GetAllUserCertListNum: function( device, drive, pin, policy, callback ) {
			function goRun() {
				errCode = -1;
				errMsg = "";
				
				getjustdiskList = 0;
				__device = device;
				__drive = drive;
				__pin = pin;
				__policy = policy;
						
				__callback = callback;
				
				// get data
				GetAllTokenList( getjustdiskList );
			}
			
			nimCall(goRun);
		},
		
		GetUserSignCertFromCertList : function( index, callback ) {
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__callback = callback;
				curIndex = index-1;
				
				GetUserCert( certList[curIndex] );
			}
			nimCall(goRun);
		},
		
		// nhkim 20150818 - get vid, add b64KmCert param
		GetSignDataP7 : function( index, pwd, plainText, inclCon, b64KmCert, callback ) {
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__callback = callback;
				curIndex = index-1;
				
				GetSignData( certList[curIndex], pwd, plainText, inclCon, b64KmCert );
			}
			nimCall(goRun);
		},
		
		GetAllUserCert : function( certsCnt, rvCallback ) {
			function goRun(){
				var index = 0;
				var listArr = new Array();	
				function SetUserCert( cert ) {
					if (cert != null && cert.length > 0) {
					    var struct = new Object();
					    struct['index'] = index + 1;
						//nimservice Indexvalue Check! +1

						struct['cert'] = cert;
						listArr[index] = struct;
					}
					if (certsCnt == listArr.length) {
						__callback = null;
						rvCallback( listArr );
					} else {
						index = index + 1;
						curIndex = index;
						GetUserCert( certList[index] );
					}
				}
				__callback = SetUserCert;
				curIndex = index;
				GetUserCert(certList[index]);
			}
			nimCall(goRun);
		},
		
		GetSignDataP1: function( index, pwd, plainText, b64KmCert, callback ) {
			function goRun(){
				errCode = -1;
				errMsg = "";
							
				__callback = callback;
				curIndex = index-1;
				
				GetSignP1Data( certList[curIndex], pwd, plainText, b64KmCert );
			}
			nimCall(goRun);
		},
		
		GetCert: function( index ) {
			curIndex = index-1;
			return certList[curIndex].cert;
		},
		
		GetIframeLoaded: function(){
			return iframeLoaded;
		},
		
		ExpireCertificate: function(){
			function goRun(){
				
			}
			nimCall(goRun);
		},
		
		DeleteCertificate: function( device, drive, index, callback){
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__device = device;
				__drive = drive;
				__callback = callback;
				curIndex = index-1;
				
				DeleteCert(certList[curIndex]);
			}
			nimCall(goRun);
		},
		
		RenewCertificate: function( cmpIP, cmpPort, device, drive, index, callback ){
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__device = device;
				__drive = drive;
				__callback = callback;
				curIndex = index-1;
				
				RenewCert(cmpIP, cmpPort, certList[curIndex]);
			}
			nimCall(goRun);
		},
		RevokeCertificate: function( cmpIP, cmpPort, device, drive, index, reason, callback ){
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__device = device;
				__drive = drive;
				__callback = callback;
				curIndex = index-1;
				
				RevokeCert(cmpIP, cmpPort, reason, certList[curIndex]);
			}
			nimCall(goRun);
		},
		IssueCertificate: function( cmpIP, cmpPort, device, drive, pin, refNumber, authCode, callback ){
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__device = device;
				__drive = drive;
				__pin = pin;
				
				__callback = callback;
				
				IssueCert(cmpIP, cmpPort, refNumber, authCode);
			}
			nimCall(goRun);
		},		
		GetDiskListNum: function( device, callback )	{
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				getjustdiskList = 1;
				__device = device;	
		
				function ReceivedTokenList( nCertCnt ) {
					var i = 0;
					var nTokenCnt = tokenList.length;
					var nDiskCnt = 0;
					for (i = 0 ; i < nTokenCnt ; i++) {
						if (tokenList[i].device == device)
							nDiskCnt++;
					}	
					
					callback(nDiskCnt);
				}
			
				__callback = ReceivedTokenList;		
				
				// get data
				GetAllTokenList( getjustdiskList );
			}
			nimCall(goRun);
		},
		GetDiskDriveName: function( index )	{
			var i = 0;
			var nTokenCnt = tokenList.length;
			// device === 1(removable)
			for (i = 0 ; i < nTokenCnt ; i++) {
				if ( tokenList[i].device == __USFB_M_DISK.device && tokenList[i].drive == index )
					return tokenList[i].name;
			}		
			
			return "";
		},

		// nhkim 20150918
		ValidateCertificate: function ( index, callback ) {
			function goRun(){
				errCode = -1;
				errMsg = "";
				
				__callback = callback;
				curIndex = index-1;
				
				ValidateCert(certList[curIndex]);
			}
			nimCall(goRun);
		},
		CopyCert: function( device, drive, tDevice, tDrive, index, isdel, rvCallback ){
			function goRun(){
				__device = device;
				__drive = drive;
				
				__callback = rvCallback;
				curIndex = index-1;
				
				ChangeStorage(tDevice, tDrive, certList[curIndex], isdel);
			}
			nimCall(goRun);
		},
		ImportCert: function( device, drive, rvCallback ){
			function goRun(){
				__device = device;
				__drive = drive;
				
				__callback = rvCallback;
				
				ImportCertificate();
			}
			nimCall(goRun);
		},
		ExportCert: function( device, drive, index, reuse, rvCallback ){
			function goRun(){
				__device = device;
				__drive = drive;
				
				__callback = rvCallback;
				curIndex = index-1;
				
				ExportCertificate(certList[curIndex], reuse);
			}
			nimCall(goRun);
		},
		ChangePassword: function( device, drive, index, rvCallback ){
			function goRun(){
				__device = device;
				__drive = drive;
				
				__callback = rvCallback;
				curIndex = index-1;
				
				ChangePin(certList[curIndex]);
			}
			nimCall(goRun);
		},
		VerifySignedData: function( b64PlainText, signedData, rvCallback ) {
			function goRun(){
				__callback = rvCallback;
				VerifyP7SignedData( b64PlainText, signedData );
			}
			nimCall(goRun);
		},
		VerifySignature: function( b64PlainText, signedData, cert, rvCallback ) {
			function goRun(){
				__callback = rvCallback;
				VerifyP1SignedData( b64PlainText, signedData, cert );
			}
			nimCall(goRun);
		},
		GetSecureTokenName: function( index )	{
			var i = 0;
			var nTokenCnt = tokenList.length;
			// device === 1(removable)
			for (i = 0 ; i < nTokenCnt ; i++) {
				if ( tokenList[i].device == __USFB_M_HSMKEY.device && tokenList[i].drive == index )
					return tokenList[i].name + "|" + tokenList[i].type + "|" + tokenList[i].trusted;
			}					
			return "";
		},
			
		GetMobileTokenName: function( index )	{
			var i = 0;
			var nTokenCnt = tokenList.length;

			for (i = 0 ; i < nTokenCnt ; i++) {
				if ( tokenList[i].device == __USFB_M_MOBILETOKEN.device && tokenList[i].drive == index )
					return tokenList[i].name + "|" + tokenList[i].type + "|" + tokenList[i].trusted;
			}		
			
			return "";
		},			
		
		VerifyVID: function( index, pwd, ssn, rvCallback ) {
			function goRun(){
				curIndex = index-1;	
				__callback = rvCallback;	
				
				VerifyVIDWithSSN( certList[curIndex], pwd, ssn );
			}
			nimCall(goRun);
		},
		
		SetDeviceOptions : function( device, version, options, rvCallback ) {
			function goRun(){
				curIndex = index-1;	
				__callback = rvCallback;	
				
				SetTokenOptions( device, options, version );
			}
			nimCall(goRun);					
		},
		
		GetCACertificates : function( index, rvCallback ) {
			function goRun(){
				curIndex = index-1;	
				__callback = rvCallback;	
				
				GetCACertificate( certList[curIndex] );
			}
			nimCall(goRun);										
		}
		//		
	}
};