document.writeln("<iframe  src='https://127.0.0.1:14461/' name='hsmiframe' id='hsmiframe' style='visibility:hidden;position:absolute'></iframe>");

//document.writeln("<div id='ESignWindow'></div>");
//for IE7
var winTarget = document.createElement('div');
winTarget.id = 'ESignWindow';
document.body.insertBefore( winTarget, document.body.firstChild );
//for IE7   

// MODE 4 = NIM, nim + webstorage = 6
var unisign = UnisignWeb({
    Mode: 4,
    
    PKI: 'NPKI',
    SRCPath: '../CC_WSTD_home/',
    Language: 'ko-kr',
    TargetObj: document.getElementById('ESignWindow'),
    TabIndex: 1000,
    LimitNumOfTimesToTryToInputPW: 3,
 
    /* // TODO : 저장매체 추가시 수정해야될 부분 */
    //Media: {'defaultdevice':'harddisk', 'list':'removable|sectoken|savetoken|mobilephone|harddisk'},/* plugin mode(Mode:1) media list */
    //Media: {'defaultdevice':'webstorage', 'list':'webstorage|touchsign|smartsign|websectoken|websofttoken'},/* plugin-free mode(Mode:2) media list */
    Media: {'defaultdevice':'harddisk', 'list':'mobiletoken|sectoken|mobilephone|removable|harddisk'},/* all media(Mode:3) list */
    
/*
	// 개인상호연동용(범용)                            //
	1.2.410.200004.5.2.1.2          // 한국정보인증               개인                                             
	1.2.410.200004.5.1.1.5          // 한국증권전산               개인                                             
	1.2.410.200005.1.1.1          // 금융결제원                 개인                                             
	1.2.410.200004.5.4.1.1          // 한국전자인증               개인                                             
	1.2.410.200012.1.1.1          // 한국무역정보통신           개인 
	
	// 개인 용도제한용 인증서정책(OID)                 용도                    공인인증기관
	 1.2.410.200004.5.4.1.101        // 은행거래용/보험용       한국전자인증
	 1.2.410.200004.5.4.1.102        // 증권거래용              한국전자인증
	 1.2.410.200004.5.4.1.103        // 신용카드용              한국전자인증
	 1.2.410.200004.5.4.1.104        // 전자민원용              한국전자인증
	 1.2.410.200004.5.2.1.7.1        // 은행거래용/보험용       한국정보인증
	 1.2.410.200004.5.2.1.7.2        // 증권거래용/보험용       한국정보인증
	 1.2.410.200004.5.2.1.7.3        // 신용카드용              한국정보인증
	 1.2.410.200004.5.1.1.9          // 증권거래용/보험용       한국증전산
	 1.2.410.200004.5.1.1.9.2        // 신용카드용              한국증전산
	 1.2.410.200005.1.1.4            // 은행거래용/보험용       금융결제원
	 1.2.410.200005.1.1.6.2          // 신용카드용              금융결제원
	 1.2.410.200012.1.1.101          // 은행거래용/보험용       한국무역정보통신
	 1.2.410.200012.1.1.103          // 증권거래용/보험용       한국무역정보통신
	 1.2.410.200012.1.1.105           // 신용카드용              한국무역정보통신
	
	// 법인상호연동용(범용)    				
	1.2.410.200004.5.2.1.1          // 한국정보인증               법인
	1.2.410.200004.5.1.1.7          // 한국증권전산               법인, 단체, 개인사업자
	1.2.410.200005.1.1.5          // 금융결제원                 법인, 임의단체, 개인사업자
	1.2.410.200004.5.4.1.2          // 한국전자인증               법인, 단체, 개인사업자
	1.2.410.200012.1.1.3         // 한국무역정보통신           법인
*/

	// 개인범용 인증서만 보이게 설정
    //Policy: '1.2.410.200004.5.2.1.2|1.2.410.200004.5.1.1.5|1.2.410.200005.1.1.1|1.2.410.200004.5.4.1.1|1.2.410.200012.1.1.1',

	// 개인 범용인증서 + 은행(인터넷뱅킹용)
    //Policy: '1.2.410.200004.5.2.1.2|1.2.410.200004.5.1.1.5|1.2.410.200005.1.1.1|1.2.410.200004.5.4.1.1|1.2.410.200012.1.1.1|1.2.410.200005.1.1.4',

	// 사업자범용 인증서만 보이게 설정
    Policy: '1.2.410.200004.5.2.1.1|1.2.410.200004.5.1.1.7|1.2.410.200005.1.1.5|1.2.410.200004.5.4.1.2|1.2.410.200012.1.1.3',

	// 개인범용+사업자범용 인증서만 보이게 설정
    //Policy: '1.2.410.200004.5.2.1.2|1.2.410.200004.5.1.1.5|1.2.410.200005.1.1.1|1.2.410.200004.5.4.1.1|1.2.410.200012.1.1.1|1.2.410.200004.5.2.1.1|1.2.410.200004.5.1.1.7|1.2.410.200005.1.1.5|1.2.410.200004.5.4.1.2|1.2.410.200012.1.1.3',

	
	//ShowExpiredCerts: false,
    
     //CMPIP: 'testca.crosscert.com',  //CMP IP
    CMPIP: '211.180.234.216',  //CMP IP
    CMPPort: 4502,  //CMP Port
    
    LimitMinNewPWLen: 8,
    LimitMaxNewPWLen: 64,
    LimitNewPWPattern: 0,

	NimCheckURL : './InstallVestCert.html' //설치페이지 URL설정
});
