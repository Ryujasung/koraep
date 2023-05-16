var StorageHandler=function(storage,param){var __S_LOCAL_STORAGE=1;var __S_ETC=2;var __cur_storage=0;var __pre_stroage=0;if("number"!=typeof storage||(__S_LOCAL_STORAGE>storage||__S_ETC<=storage)){var err={};err.code=3001E4;err.message="[StorageHandler Initializing Failed] the parameter type of value or data is wrong.";err.detail=null;throw err;}if(!param||"undefined"===param){var err={};err.code=3E7;err.message="[StorageHandler Initializing Failed] the parameter value cannot be null.";err.detail=null;throw err;}__cur_storage=storage;var __init={};__init.enc_algo=param.enc_algo;__init.hash_algo=param.hash_algo;__init.pki=param.pki;__init.domain=param.domain;__init.err_code=param.error_code;var __ls_handler=null;if(__S_LOCAL_STORAGE===__cur_storage)try{__ls_handler=new LocalStorageHandler(__init)}catch(e){throw e;}return{SelectStorage:function(storage){if("number"!=typeof storage||(__S_LOCAL_STORAGE>storage||__S_ETC<=storage)){var err={};err.code=3001E4;err.message="[StorageHandler SelectStorage Failed] the parameter type of value or data is wrong.";err.detail=null;throw err;}__pre_stroage=__cur_storage;__cur_storage=storage;if(__S_LOCAL_STORAGE===__cur_storage)try{if(!__ls_handler)__ls_handler=new LocalStorageHandler(__init)}catch(e){throw e;}},InstallCACerts:function(pw){var ret=false;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.InstallCACerts(pw);else;}catch(e){throw e;}return ret},LoadAllCerts:function(pw){var ret=false;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.LoadAllCerts(pw);else;}catch(e){throw e;}return ret},GetCACerts:function(){var jsonObj=null;try{if(__S_LOCAL_STORAGE===__cur_storage)jsonObj=__ls_handler.GetCACerts();else;}catch(e){throw e;}return jsonObj},GetUserCerts:function(pw){var jsonObj=null;try{if(__S_LOCAL_STORAGE===__cur_storage)jsonObj=__ls_handler.GetUserCerts(pw);else;}catch(e){throw e;}return jsonObj},SetUserCertOnMemory:function(json_user_cert){var ret=false;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.SetUserCertOnMemory(json_user_cert);else;}catch(e){throw e;}return ret},SaveUserCert:function(ca,json_user_new_cert,pw,dupl_check_flag){var ret=false;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.SaveUserCert(ca,json_user_new_cert,pw,dupl_check_flag);else;}catch(e){throw e;}return ret},DeleteUserCertByIndex:function(index,pw){var ret=false;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.DeleteUserCertByIndex(index,pw);else;}catch(e){throw e;}return ret},DeleteUserCertByDN:function(ca,dn,pw){var ret=false;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.DeleteUserCertByDN(ca,dn,pw);else;}catch(e){throw e;}return ret},SetP12OnMemory:function(b64_p12,pw){var ret=null;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.SetP12OnMemory(b64_p12,pw);else;}catch(e){throw e;}return ret},SetP12HexOnMemory:function(hex_p12,hex_pw){var ret=null;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.SetP12HexOnMemory(hex_p12,hex_pw);else;}catch(e){throw e;}return ret},GetP12ForBuToPc:function(index,pw){var ret=null;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.GetP12ForBuToPc(index,pw);else;}catch(e){throw e;}return ret},GetP12ForBuToMo:function(index,encoding){var ret=null;try{if(__S_LOCAL_STORAGE===__cur_storage)ret=__ls_handler.GetP12ForBuToMo(index,encoding);else;}catch(e){throw e;}return ret}}};