function UnisignWeb(a){a||alert("Failed to initialize module.");return new UnisignWebPlugIn({Mode:a.Mode,EncAlgo:a.EncAlgo,HashAlgo:a.HashAlgo,PKI:a.PKI,SRCPath:a.SRCPath,Language:a.Language,TargetObj:a.TargetObj,TabIndex:a.TabIndex,Embedded:a.Embedded,LimitNumOfTimesToTryToInputPW:a.LimitNumOfTimesToTryToInputPW,CMPIP:a.CMPIP,CMPPort:a.CMPPort,NimCheckURL:a.NimCheckURL,Media:a.Media,Organization:a.Organization,Policy:a.Policy,ShowExpiredCerts:a.ShowExpiredCerts,LimitMinNewPWLen:a.LimitMinNewPWLen,
LimitMaxNewPWLen:a.LimitMaxNewPWLen,LimitNewPWPattern:a.LimitNewPWPattern,ChangePWByNPKINewPattern:a.ChangePWByNPKINewPattern,License:a.License})}
var UnisignWebPlugIn=function(a){a||alert("Failed to initialize Unisign Web Plugin.");var b;b=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");b.open("GET",a.SRCPath+"unisignweb/js/unisignweb.js?version=1.0.15.0",!1);b.send(null);eval(b.responseText);this.WebPlugIn=new (eval("UnisignWebEngine"))({Mode:a.Mode,EncAlgo:a.EncAlgo,HashAlgo:a.HashAlgo,SecureKeyboardType:a.SecureKeyboardType,PKI:a.PKI,SRCPath:a.SRCPath,Language:a.Language,TargetObj:a.TargetObj,TabIndex:a.TabIndex,
Embedded:a.Embedded,LimitNumOfTimesToTryToInputPW:a.LimitNumOfTimesToTryToInputPW,CMPIP:a.CMPIP,CMPPort:a.CMPPort,NimCheckURL:a.NimCheckURL,Media:a.Media,Organization:a.Organization,Policy:a.Policy,ShowExpiredCerts:a.ShowExpiredCerts,LimitMinNewPWLen:a.LimitMinNewPWLen,LimitMaxNewPWLen:a.LimitMaxNewPWLen,LimitNewPWPattern:a.LimitNewPWPattern,ChangePWByNPKINewPattern:a.ChangePWByNPKINewPattern,License:a.License},{NAME:"unisignweb.js",DATA:b.responseText})};
UnisignWebPlugIn.prototype={IsValidity:function(){return this.WebPlugIn.IsValidity()},GetLastError:function(a){this.WebPlugIn.GetLastError(a)},SetEmbeddedUI:function(a){this.WebPlugIn.SetEmbeddedUI(a)},DigitalSignature:function(a,b,c){this.WebPlugIn.SignDataP1(a,b,c)},VerifyDigitalSignature:function(a,b,c,d){return this.WebPlugIn.VerifySignedDataP1(a,b,c,d)},SignData:function(a,b,c){this.WebPlugIn.SignDataP7(a,b,!0,null,c)},VerifySignData:function(a,b){return this.WebPlugIn.VerifySignedDataP7(a,b)},
SignDataForCertTransferring:function(a,b,c){this.WebPlugIn.SignDataP7Ext("DIGITAL_SIGNATURE_P7_EXT_DISABLE_SECTOKEN",null,a,null,b,c)},SelectMediaForCertTransferring:function(a,b){this.WebPlugIn.SelectMediaForCertImporting(a,b)},ExportCertForCertTransferring:function(a,b){return this.WebPlugIn.ExportCert(a,b)},ImportCertForCertTransferring:function(a,b,c,d,e,f){return this.WebPlugIn.ImportCert(a,b,c,d,e,f)},IssueCert:function(a,b,c){this.WebPlugIn.IssueCert(a,b,c)},RenewCert:function(a){this.WebPlugIn.RenewCert(a)},
RevocateCert:function(a){this.WebPlugIn.RevocateCert(a)},SOECert:function(a){this.WebPlugIn.SOECert(a)},VerifyVID:function(a,b){this.WebPlugIn.VerifyVID(a,b)},ManageCert:function(){this.WebPlugIn.ManageCert()},ManageCertByType:function(a){this.WebPlugIn.ManageCertByType(a)},ImportCertFromMobileApp:function(a,b){return this.WebPlugIn.ImportCertFromMobileApp(a,b)},SetSelectedDevice:function(a){return this.WebPlugIn.SetSelectedDevice(a)},NimServiceLoaded:function(){return this.WebPlugIn.NimServiceLoaded()},
SecureMail_Corporation:function(a,b,c,d){this.WebPlugIn.SecureMail(0,a,b,c,d)},SecureMail_Private:function(a,b,c,d){this.WebPlugIn.SecureMail(1,a,b,c,d)},DecryptData:function(a,b){return this.WebPlugIn.DecryptData(a,b)},getFileDownload:function(a,b){this.WebPlugIn.getFileDownload(a,b)},SetUBIKeyEnvInfo:function(a,b,c,d){this.WebPlugIn.SetUBIKeyEnvInfo(a,b,c,d)},SignDataNGetIdentifierByEnvlp:function(a,b,c,d){this.WebPlugIn.SignDataP7(a,b,!0,c,d)},SignData_noConWithHash:function(a,b,c,d){this.WebPlugIn.SignData_noConWithHash(a,
b,c,null,d)},SignDataNGetIdentifierByEnvlp_noConWithHash:function(a,b,c,d,e){this.WebPlugIn.SignData_noConWithHash(a,b,c,d,e)},VerifySignData_noConWithHash:function(a,b,c){return this.WebPlugIn.VerifySignData_noConWithHash(a,b,c)},SignMultiData:function(a,b,c){this.WebPlugIn.SignMultiDataP7(a,null,b,!0,null,c)},SignMultiDataExcludeContent:function(a,b,c){this.WebPlugIn.SignMultiDataP7(a,null,b,!1,null,c)},VerifyExcludedContentSignData:function(a,b,c){return this.WebPlugIn.VerifySignedDataP7ExcludedContent(a,
b,c)},Base64Encoding:function(a){return this.WebPlugIn.Base64Encoding(a)},Base64Decoding:function(a){return this.WebPlugIn.Base64Decoding(a)},SignPersonInfoReq:function(a,b,c,d){this.WebPlugIn.SignPersonInfoReqP7(a,b,c,!0,d)},MultiDigitalSignature:function(a,b,c){this.WebPlugIn.SignMultiDataP1(a,b,c)},SignDataExcludeContent:function(a,b,c){this.WebPlugIn.SignDataP7(a,b,!1,null,c)},SignDataNVerifyVID:function(a,b,c,d){this.WebPlugIn.SignDataP7AndVerifyVID(a,b,c,d)},SignMultiDataNVerifyVID:function(a,
b,c,d){this.WebPlugIn.SignMultiDataP7NVerifyVID(a,null,b,!0,c,d)},MakeHash:function(a,b,c){return this.WebPlugIn.MakeHash(a,b,"PlainText",c)},MakeFileHash:function(a,b,c){return this.WebPlugIn.MakeHash(a,b,"FilePath",c)},EncryptData:function(a,b,c,d,e){this.WebPlugIn.EncryptData(a,b,c,d,e)},EncryptDataWithSymmKey:function(a,b,c,d,e){return this.WebPlugIn.EncryptDataWithSymmKey(a,b,c,d,e)},DecryptDataWithSymmKey:function(a,b,c,d,e,f){return this.WebPlugIn.DecryptDataWithSymmKey(a,b,c,d,e,f)},SetConfigInfo:function(a){this.WebPlugIn.SetConfigInfo(a)},
SignFile:function(a,b,c){this.WebPlugIn.SignFileP7(a,b,0,null,!0,c)},SignFileExcludeContent:function(a,b,c){this.WebPlugIn.SignFileP7(a,b,0,null,!1,c)},SignMultiFile:function(a,b,c){this.WebPlugIn.SignMultiFileP7(a,b,0,null,!0,c)},SignMultiFileExcludeContent:function(a,b,c){this.WebPlugIn.SignMultiFileP7(a,b,0,null,!1,c)},VerifyKeyPair:function(a){this.WebPlugIn.VerifyKeyPair(a)},SignMultiDataNGetIdentifierByEnvlp:function(a,b,c,d){this.WebPlugIn.SignMultiDataP7(a,null,b,!0,c,d)},SetMobileTokenEnvInfo:function(a,
b,c,d,e){this.WebPlugIn.SetMobileTokenEnvInfo(a,b,c,d,e)},SignFileEx:function(a,b,c,d,e){this.WebPlugIn.SignFileP7(a,b,c,d,!0,e)},SignFileExcludeContentEx:function(a,b,c,d,e){this.WebPlugIn.SignFileP7(a,b,c,d,!1,e)},VerifyP7SignedFileWithFile:function(a,b,c,d){this.WebPlugIn.VerifyP7SignedFileWithFile(null,a,b,c,d)},VerifyP7SignedDataWithFile:function(a,b,c,d){this.WebPlugIn.VerifyP7SignedDataWithFile(null,a,b,c,d)},VerifyExcludeContentP7SignedDataWithFile:function(a,b,c,d,e){this.WebPlugIn.VerifyP7SignedDataWithFile(a,
b,c,d,e)},RenewCertNSignedSubjectDn:function(a){this.WebPlugIn.RenewCertNSignedSubjectDn(a)},SetOptions:function(a,b){this.WebPlugIn.SetOptions(a,b)}};
