(function() {
	return {
		IDS_VERIFY_CERT: 									"인증서 검증",
		IDS_VERIFY_CERT_CLOSE: 								"인증서 검증창 종료",
		IDS_CONFIRM: 										"확인",
		IDS_BUTTON: 										"버튼",
		
		IDS_VERIFY_CERT_OK: 								"유효한 인증서 입니다.",
		IDS_VERIFY_CERT_ERROR_INVALID_TYPE: 				"인증서 형식이 올바르지 않습니다.",
		IDS_VERIFY_CERT_ERROR_DECODING_FAIL:				"인증서 디코딩을 실패하였습니다.",
		IDS_VERIFY_CERT_ERROR_LOADING_FAIL: 				"인증서 로딩에 실패하였습니다.",
		IDS_VERIFY_CERT_ERROR_EXPIRED:						"인증서의 유효 기간이 만료되었거나 아직 유효하지 않습니다.",
		IDS_VERIFY_CERT_ERROR_NO_DP: 						"인증서 폐지목록(CRL) 배포지점 정보가 없는 인증서입니다.",
		IDS_VERIFY_CERT_ERROR_WRONG_DP: 					"인증서 폐지목록(CRL) 배포지점 정보가 잘못된 인증서입니다.",
		IDS_VERIFY_CERT_ERROR_WRONG_CRL: 					"인증서 폐지목록(CRL) 형식이 올바르지 않습니다.",
		IDS_VERIFY_CERT_ERROR_EXPIRED_CRL: 					"인증서 폐지목록(CRL)의 유효 기간이 만료되었습니다.",
		IDS_VERIFY_CERT_ERROR_GETTING_CRL_FROM_LDAP_FAIL: 	"LDAP 서버에서 인증서 폐지목록(CRL)을 가져오는데 실패하였습니다.",
		IDS_VERIFY_CERT_ERROR_CHECKING_ISSUER_FAIL: 		"인증서의 발급자 정보 확인에 실패하였습니다.",
		IDS_VERIFY_CERT_ERROR_CA_CERT_PATH: 				"발급자 인증서를 가져오는데 실패하였습니다.",
		IDS_VERIFY_CERT_ERROR_ROOTCA_CERT_PATH: 			"신뢰된 최상위 인증기관 인증서를 가져오는데 실패하였습니다.",
		
		IDS_VERIFY_CERT_ERROR_HOLDED: 						"인증서가 효력정지 되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED:						"인증서가 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_KEYCOMPROMISE: 		"인증서가 개인키 신뢰 손상으로 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_CACOMPROMISE: 		"인증서가 발급자 인증서의 전사서명키 손상으로 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_AFFILIATIONCHANGED: 	"인증서가 소속이나 이름 변경으로 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_SUPERSEDED: 			"키 손상 없이 인증서가 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_UNSUPERSEDED: 		"특별한 사유 없이 인증서가 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_REMOVEFROMCRL: 		"Delta CRL에서 인증서가 제거되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_CESSATIONOFOPERATION: "인증서가 사용 해지로 폐지되었습니다.",
		IDS_VERIFY_CERT_ERROR_REVOKED_HOLD:					"인증서가 효력정지 되었습니다.",
		
		IDS_VERIFY_CERT_ERROR_UNKNOWN:						"인증서 검증에 실패하였습니다.",
		
		IDS_MSGBOX_PLUGIN_ERROR_UNLOAD: 					"UniSignWeb Plug-In 이 장시간 미사용 등의 이유로 언로드 되었습니다.\n페이지 새로 고침을 하시거나 첫 페이지로 이동하셔서 재시도 해주십시오.",
		// nhkim 20151016
		IDS_MSGBOX_NIM_ERROR_UNLOAD: 						"VestCert가  언로드 되었습니다.\n페이지 새로 고침을 하시거나 첫 페이지로 이동하셔서 재시도 해주십시오."
	
	}
})();		
		