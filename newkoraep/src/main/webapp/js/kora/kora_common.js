//전화지역번호 서울, 경기, 인천, 부산, 울산, 대구, 경북, 경남, 강원, 대전, 충남, 충북, 세종시, 광주, 전남, 전북, 제주, 개인, 전화정보, 인터넷
var gTelAreaNo = ["02", "031", "032", "051", "052", "053", "054", "055", "033", "042", "041", "043", "044", "062", "061", "063", "064", "050", "060", "070", "0502", "0505", "0506"];
var gHpAreaNo = ["010", "011", "015", "016", "018", "019"];
var gEmailDomain = ["naver.com", "daum.net", "gmail.com", "nate.com", "hotmail.com", "korea.com"];
var gExtArr = new Array("gif", "jpg", "jpeg", "png", "tif", "tiff", "bmp", "GIF", "JPG", "JPEG", "PNG", "TIF", "TIFF", "BMP"); 

var gZipCdId = "";	//우편번호 아이디
var gAddrId = "";	//주소 아이디 

var gUrl = location.href;
gUrl = gUrl.substring(gUrl.lastIndexOf("/")+1, gUrl.length);
if(gUrl.indexOf(".") > -1) gUrl = gUrl.substring(0, gUrl.lastIndexOf("."));

var gHelpWin;
var gHelpUrl = "";

var gGridStr = '	headerColors="[#788496,#788496]" alternatingItemColors="[#ffffff,#ffffff]" horizontalGridLineColor="#b4b4b4" verticalGridLineColor="#dfdfdf" ';
	//gGridStr += '	rollOverColor="#cccccc" colors="#555555"  rowHeight="30"  ';
	gGridStr += '	rollOverColor="#cccccc" colors="#555555" headerHeight="25" ';
	//gGridStr += '	fontFamily="gulim,굴림,Helvetica,AppleSDGothicNeo,sans-serif" fontWeight="normal" fontSize="12" '; 

var gtoken = $("meta[name='_csrf']").attr("content");
var gheader = $("meta[name='_csrf_header']").attr("content");
/*
//ajax 처리 세션체크용
var gxhr = new XMLHttpRequest();
var gtoken = $("meta[name='_csrf']").attr("content");
var gheader = $("meta[name='_csrf_header']").attr("content");
$.ajaxSetup({
	beforeSend: function(gxhr) {
		gxhr.setRequestHeader("AJAX", true);
		gxhr.setRequestHeader(gheader, gtoken);
    }
});
*/
var rtc_dt_list;
var rMateGridH5;
if($("#gridHolder") && rMateGridH5 != null) rMateGridH5.setAssetsPath("/rMateGrid/rMateGridH5/Assets/");

var kora;
if(!kora) kora={};
if(!kora.common) kora.common={};
if(!kora.common.formatter) kora.common.formatter={};

/*********************************************************************
 * value가 false로 평가되는 값(undefined, null, "")이면 ""로 반환한다.
 * value가 false로 평가되는 값일경우, def가 있으면 def를 반환한다.
 ********************************************************************/
 kora.common.null2void = function(value, def) {
 	if (!value)
 		return !def ? "" : def;
 	else
 		return $.trim(value);
 };


$(function(){

	/***************************************
	 * input box 화폐단위 표시 이벤트 처리
	 **************************************/
	$("input[format=money]").each(function(){
		kora.common.fn_keyDownNumberType($(this));
		$(this).keyup(function(){
			if ( $(this).val() != kora.common.format_comma($(this).val()) ){
				$(this).val(kora.common.format_comma($(this).val()));
			}	
		});

		$(this).focus(function(){
			$(this).select();
		});
	});
	
	/***************************************
	 * input box 숫자만 입력되도록 처리
	 **************************************/
	$.each($("input[format=number]"), function(i,v){
		//'한글'모드일때는 아래 처리를 무시하고  입력되기때문에 무시하기때문에 style에 다음 항목을 셋팅한다.
		//강제로 영어 모드로 전환시킨다.
		$(v).attr("style", "ime-mode:disabled;text-align:right;"+$(v).attr("style"));
		var textFieldGotFocus = false;
		
		$(this).focus(function(){
		    //this.select();
		    textFieldGotFocus = true;
		});
		
		$(this).mouseup(function(e){
			if(textFieldGotFocus == true){
		        //e.preventDefault();
		        textFieldGotFocus = false;
			}
		});
		        
		$(this).keydown(function(event){
			//shift 키가 눌려있을땐 특수문자 입력 불가
			//백스페이스(8), delete(46), 방향키(37~40) 은 허용함
			//숫자가 아닌 입력값 입력 불가
			if(  event.shiftKey || 
				(   !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || event.keyCode==13
						|| (event.keyCode>=37 && event.keyCode<=40)
						|| (event.ctrlKey && event.keyCode==67)
						|| (event.ctrlKey && event.keyCode==86))
				&& !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105) )
				)
			{
				event.returnValue=false;
				return false;
			}
		});
	});
	
	
	
	
	
	/***************************************
	 * input box 영/숫자만 입력되도록 처리
	 **************************************/
	$.each($("input[format=engNum]"), function(i,v){
		//'한글'모드일때는 아래 처리를 무시하고  입력되기때문에 무시하기때문에 style에 다음 항목을 셋팅한다.
		//강제로 영어 모드로 전환시킨다.
		$(v).attr("style", "ime-mode:disabled;"+$(v).attr("style"));
		
		$(this).keydown(function(event){
			//shift 키가 눌려있을땐 특수문자 입력 불가
			//백스페이스(8), delete(46), 방향키(37~40) 은 허용함
			//숫자가 아닌 입력값 입력 불가
			if(  event.shiftKey || 
				(   !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 
						|| (event.keyCode>=37 && event.keyCode<=40)
						|| (event.keyCode>=65 && event.keyCode<=90)
						|| (event.keyCode>=97 && event.keyCode<=122)
						|| (event.ctrlKey && event.keyCode==67)
						|| (event.ctrlKey && event.keyCode==86))
				&& !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105) )
				)
			{
				event.returnValue=false;
				return false;
			}
		});
	});


	/***************************************
	 * input box 주민(외국인)등록번호 체크
	 **************************************/
	$("input[format=ssn]").each(function(){
		$(this).attr("maxlength","13");
		
		$(this).change(function(){
		    if (!(fnrrnCheck($(this).val()) || fnfgnCheck($(this).val()))) {
				alertMsg("주민(외국인)등록번호를 확인하세요.");
				$(this).val("");
		    }
		});
	});

	/***************************************
	 * input box 사업자등록번호 체크
	 **************************************/
	$("input[format=bizno]").each(function(){
		kora.common.fn_keyDownNumberType($(this));
		
		$(this).change(function(){
		    if (!fnBizCheck($(this).val())) {
				alertMsg("사업자등록번호를 확인하세요.");
				$(this).val("");
		    }
		});
	});

	/***************************************
	 * input box 주민(사업자)등록번호 체크
	 **************************************/
	$("input[format=bizssn]").each(function(){
		kora.common.fn_keyDownNumberType($(this));
		
		$(this).change(function(){
			if(!fnRRNCheck($(this).val())){
				alertMsg("주민(사업자)등록번호를 확인하세요.");
				$(this).val("");
			}
		});
	});

	/***************************************
	 * input box 한글자동입력 체크
	 **************************************/
	$("input[format=kor]").each(function(){
		$(this).attr("style","ime-mode:active;"+$(this).attr("style"));
	});
	
	/***************************************
	* input box 영문입력 체크
	***************************************/
	$("input[format=eng]").each(function(){
		$(this).attr("style","ime-mode:disabled;"+$(this).attr("style"));
	});

	/***************************************
	* input box 날짜타입 입력 체크
	***************************************/
	$("input[format=date]").each(function(){
		kora.common.fn_keyDownNumberType($(this));
		
		$(this).change(function(){
			if ( jex.web.form.check.isFormat($(this)) == false) {
				$(this).val("");
				$(this).focus();
			}
			else {
				var strDate = $(this).val().replace(/\-/g,"");
				if($(this).val() != "" ){
					strDate = strDate.substring(0,4) + "-" + strDate.substring(4,6) + "-" + strDate.substring(6,8);
					$(this).val(strDate);
					
					// 변경이벤트 후처리(fn_해당ID_chng())
					var obj;
					try {
						obj	= eval("fn_"+$(this).attr("id")+"_chng");
					}
					catch(e) {
						return;
					}
					
					if(typeof obj != "undefined"){
						eval("fn_"+$(this).attr("id")+"_chng()");
					}
				}	
			}	
		});
	});

	/***************************************
	 * input box 날짜타입 입력 체크-년월
	 **************************************/
	$("input[format=mon]").each(function(){
		kora.common.fn_keyDownNumberType($(this));
		
		$(this).change(function(){
			if ( jex.web.form.check.isFormat($(this)) == false) {
				$(this).val("");
				$(this).focus();
			}
			else {
				var strDate = $(this).val().replace(/\-/g,"");
				if($(this).val() != "" ){
					strDate = strDate.substring(0,4) + "-" + strDate.substring(4,6);
					$(this).val(strDate);
					
					// 변경이벤트 후처리(fn_해당ID_chng())
					var obj;
					try {
						obj	= eval("fn_"+$(this).attr("id")+"_chng");
					}
					catch(e) {
						return;
					}
					
					if(typeof obj != "undefined"){
						eval("fn_"+$(this).attr("id")+"_chng()");
					}
				}	
			}	
		});
	});

	/***************************************
	 * input box 소수점 입력 체크
	 **************************************/
	$("input[format=rate]").each(function(){
		kora.common.fn_keyDownNumberType($(this),".");
		
		$(this).change(function(){
			if (isNaN(new Number(kora.common.format_noComma($(this).val())))) {
				alertMsg("항목의 입력형식이 잘못되었습니다.");
				$(this).val("0");
				$(this).focus();
			}
			
			if($(this).val()==""){
				$(this).val("0");
			}
			
			if($(this).val().substring($(this).val().length-1)=="."){
				$(this).val($(this).val().substring(0,$(this).val().length-1));
			}
			
		});

		$(this).keyup(function(){
			if ( $(this).val() != kora.common.format_comma($(this).val(),"rate") ){
				$(this).val(kora.common.format_comma($(this).val(),"rate"));
			}	
		});

		$(this).focus(function(){
			$(this).select();
		});
	});
	
	/***************************************
	 * input box 마이너스 입력 체크
	 ***************************************/
	$("input[format=minus]").each(function(){
		kora.common.fn_keyDownNumberType($(this),"-");
		
		$(this).change(function(){
			if (isNaN(new Number(kora.common.format_noComma($(this).val())))) {
				alertMsg("항목의 입력형식이 잘못되었습니다.");
				$(this).val("0");
				$(this).focus();
			}
			
			$(this).val(kora.common.format_comma(kora.common.null2void($(this).val(), "0")));
		});
		
		$(this).keyup(function(){
			if($(this).val() != "-"){
				if ( $(this).val().replace(/\-/g,"") == "0"){
					$(this).val("0");
				}
				else{
					if ( $(this).val() != kora.common.format_comma($(this).val()) ){
						$(this).val(kora.common.format_comma($(this).val()));
					}	
				}
			}
		});
		
		$(this).focus(function(){
			//$(this).select();
		});

	});
	
	/*********************************************
	* IE11버전에서 change event 부여
	*********************************************/
	if (!navigator.userAgent.match(/Trident\/11\./)){
		$('input:text').blur(function(){
			$(this).change();
		});
	}
	
	/***************************************
	 * input box byte length check
	 * event : keydown, change
	 **************************************/
	$("input[maxByteLength]").each(function(){
		var chkLength = kora.common.null2void($(this).attr("maxByteLength"));
		
		if(!isNaN(chkLength)){
			
			//keydown event
			$(this).keydown(function(event){
				
				var nChkLength = Number(chkLength);
				var nCurLength = kora.common.getByteLength($(this).val());
				
				if(nCurLength >= nChkLength){
					
					if(event.shiftKey || !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || (event.keyCode>=37 && event.keyCode<=40))){
						event.returnValue=false;
						return false;
					}
				}
			});
			
			//change event
			$(this).change(function(){
				
				var nChkLength = Number(chkLength);
				var nCurLength = kora.common.getByteLength($(this).val());
				
				if(nCurLength > nChkLength){
					
					alertMsg("한글 "+parseInt(chkLength/3)+"자(영문 "+chkLength+"자) 초과 입력할 수 없습니다.");
					$(this).val("");
					$(this).focus();
				}
			});
		}
	});
	
	/***************************************
	 * input box byte length check
	 * event : only change
	 **************************************/
	$("input[maxByteLength2], textarea[maxByteLength2]").each(function(){
		var chkLength = kora.common.null2void($(this).attr("maxByteLength2"));
		if(!isNaN(chkLength)){
			//change event
			$(this).change(function(){
				var data = $(this).val();
				
				var nChkLength = Number(chkLength);
				var nCurLength = kora.common.getByteLength(data);
				
				if(nCurLength > nChkLength){
					
					alertMsg("한글 "+parseInt(chkLength/2)+"자(영문 "+chkLength+"자) 초과 입력할 수 없습니다.");
					
					while(true){
						data = data.substr(0,data.length-1);
						nCurLength = kora.common.getByteLength(data);
						if(nCurLength <= nChkLength){
							$(this).val(data);
							break;
						}
					}
					
					$(this).focus();
				}
			});
		}

	});
});


/////////////////////////////////////////////////////////////////////////공통 함수/////////////////////////////////////////////////////////////////////////////////


//우편번호 검색 팝업 
// zipCdId : 우편번호입력 받을 id, addrId : 주소입력 받을 id 
function gfn_searchZip(zipCdId, addrId){
	gZipCdId = zipCdId;
	gAddrId = addrId;
	window.open("/SEARCH_ZIPCODE_POP.do", "searchZip", "width=550, height=600, menubar=no,status=no,toolbar=no, scrollbar=auto");
}
//우편번호 검색 결과받기
function gfn_setZipRtnValue(zipCd, addr){
	$("#" + gZipCdId).val(zipCd);
	$("#" + gAddrId).val(addr);
}



/********************************************************************
 * 입력값의 바이트 길이를 리턴
 * ex) if (kora.common.getByteLength(form.title) > 100) {
 *         alertMsg("제목은 한글 50자(영문 100자) 이상 입력할 수 없습니다.");
 *     }
 *******************************************************************/
kora.common.getByteLength = function(input) {
    var byteLength = 0;
    for (var inx = 0; inx < input.length; inx++) {
        var oneChar = escape(input.charAt(inx));
        if ( oneChar.length == 1 ) {
            byteLength ++;
        } else if (oneChar.indexOf("%u") != -1) {
            byteLength += 2;
        } else if (oneChar.indexOf("%") != -1) {
            byteLength += oneChar.length/3;
        }
    }
    return byteLength;
};

/*******************************************************************
 * 화폐단위 리턴
 ******************************************************************/
kora.common.moneyFormat = function(data){
	if(isNaN(new Number(data))) data = "0";
	return kora.common.format_comma(kora.common.null2void(data, "0"));
};

/*******************************************************************
 * number type input box key down event
 * parameter - obj:이벤트 대상
 * parameter - gubun: '.' 소수점표시, '-' 표시, 'all' 둘다 허용
 ******************************************************************/
kora.common.fn_keyDownNumberType = function(obj, gubun){
	$(obj).attr("style", "ime-mode:disabled;text-align:right;"+$(obj).attr("style"));
	$(obj).keydown(function(event){
		//shift 키가 눌려있을땐 특수문자 입력 불가
		//백스페이스(8), delete(46), 방향키(37~40) 은 허용함
		//숫자가 아닌 입력값 입력 불가
		
		// 구분이 있을경우 체크
		if(gubun != null && gubun != undefined){
			// 소수점 허용
			if(gubun == "."){
				var nDotCnt = 0;
				for(var i=0; i<$(obj).val().length; i++){
					if($(obj).val().charAt(i) == ".") nDotCnt++;
				}
				
				if(nDotCnt > 0){
					if( event.shiftKey || 
						    ( !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || (event.keyCode>=37 && event.keyCode<=40) ) &&
							  !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105))	
						){
							event.returnValue=false;
							return false;
						}
				}
				else{
					if( event.shiftKey || 
						    ( !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || event.keyCode==110 || event.keyCode==190 || (event.keyCode>=37 && event.keyCode<=40) ) &&
							  !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105))	
						){
							event.returnValue=false;
							return false;
						}
				}
				
			}
			// 마이너스 표시 허용
			else if(gubun == "-"){
				if( event.shiftKey || 
				    ( !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || event.keyCode==109 || event.keyCode==189 || (event.keyCode>=37 && event.keyCode<=40) ) &&
					  !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105))	
				){
					event.returnValue=false;
					return false;
				}
			}
			// 소수점, 마이너스 둘다 허용
			else if(gubun == "all"){
				if( event.shiftKey || 
					( !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || event.keyCode==109 || event.keyCode==189 || event.keyCode==110 || event.keyCode==190 || (event.keyCode>=37 && event.keyCode<=40) ) &&
					  !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105))	
				){
					event.returnValue=false;
					return false;
				}
			}
		}
		// only number type 체크
		else{
			if( event.shiftKey || 
			    ( !(event.keyCode==8 || event.keyCode==9 || event.keyCode==46 || (event.keyCode>=37 && event.keyCode<=40) ) &&
				  !(event.keyCode>=48 && event.keyCode<=57) && !(event.keyCode>=96 && event.keyCode<=105))	
			){
				event.returnValue=false;
				return false;
			}
		}
		
	});
};


/*******************************************************************
 * 분리자를 이용하여 날짜의 유효성 체크
 * 예) 2011-05-24 -> '-'을 이용하여 체크한다.
 * @param inputDate 체크할 날짜
 * @param point 년,월,일 분리자
 ******************************************************************/
kora.common.fnDateCheck = function(inputDate, point){
    var dateElement = new Array(3);
    
    if(point != ""){
        dateElement = inputDate.split(point);
        if(inputDate.length != 10 || dateElement.length != 3){
            return false;
        }
    }else{
        dateElement[0] = inputDate.substring(0,4);
        dateElement[1] = inputDate.substring(4,6);
        dateElement[2] = inputDate.substring(6,9);
    }
    //년도 검사
    if( !( 1800 <= dateElement[0] && dateElement[0] <= 4000 ) ) {
        return false;
    }

    //달 검사
    if( !( 0 < dateElement[1] &&  dateElement[1] < 13  ) ) {
        return false;
    }

    // 해당 년도 월의 마지막 날
    var tempDate = new Date(dateElement[0], dateElement[1], 0);
    var endDay = tempDate.getDate();

    //일 검사
    if( !( 0 < dateElement[2] && dateElement[2] <= endDay ) ) {
         return false;
    }

    return true;
}


/*******************************************************************
 * 외국인등록번호 유효성 검사
 ******************************************************************/
function fnfgnCheck(rrn){
    var sum = 0;
    
    if(rrn != ""){
        if (rrn.length != 13) {
            return false;
        }
        else if (rrn.substr(6, 1) != 5 && rrn.substr(6, 1) != 6 && rrn.substr(6, 1) != 7 && rrn.substr(6, 1) != 8) {
            return false;
        }
        if (Number(rrn.substr(7, 2)) % 2 != 0) {
            return false;
        }
        for (var i = 0; i < 12; i++) {
            sum += Number(rrn.substr(i, 1)) * ((i % 8) + 2);
        }
        if ((((11 - (sum % 11)) % 10 + 2) % 10) == Number(rrn.substr(12, 1))) {
            return true;
        }
        return false;
    }
    
    return true;
}


/****************************************************************************
 * 소수점 자르기
 ***************************************************************************/
kora.common.truncate = function(n) {
	  return Math[n > 0 ? "floor" : "ceil"](n);
};

/****************************************************************************
 * 소수점 절삭(자리수별 처리)
 * 예) kora.common.trunc("2.567",2) => 2.5
 ***************************************************************************/
kora.common.trunc = function(value, npos) { 
		
	if((value+"").indexOf(".") < 0) return value;
	if(Number((value+"").substr((value+"").indexOf(".")+1)) == 0) return parseInt(value);

	var roundValue = kora.common.makeRoundValue(npos); 
	var multiValue = Math.pow(10, npos - 1);
	
	var temp = (Number(kora.common.format_noComma(kora.common.null2void(value+"","0"))) - roundValue).toFixed(npos); 
	temp = (temp * multiValue).toFixed(npos); 
	temp = Math.round(temp); 
	temp = temp / multiValue; 

	return temp; 
}; 


kora.common.makeRoundValue = function(npos) { 
	if (npos <= 0) 
	return 0; 

	var result = 0.5; 

	for (var i = 1; i < npos; i++) { 
		result = result / 10; 
	} 

	return result; 
};


/**
 * 문자열 앞뒤 공백 삭제
 * @returns
 */
String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/gi, "");
};

/**
 * 문자열(str1)을 특정문자열(str2)로 모두 변경
 * @param str1
 * @param str2
 * @returns
 */
String.prototype.replaceAll = function(str1, str2){
	if(str1 == str2) return this;
	
	var temp_str = this.trim();
	if(this.trim() == "") return temp_str;

	return temp_str.replace( eval("/" + str1 + "/g"),str2);
};

/**************************************************************
 * 숫자에 3자리마다 콤마찍기(현금표시)
 *************************************************************/
kora.common.format_comma = function(val1, type){
  
	if(val1 == undefined || (val1+"") == "") return "";
	var newValue = val1+""; //숫자를 문자열로 변환
	var len = newValue.length;
	
	var minus = "";  
	var rate  = "";

	if( len > 1 ) {
		if( (type == null || type != "rate") && newValue.substring(0,1) == '0' ) 
			newValue = newValue.substring(1);

		len = newValue.length;

		if ( newValue.substring(0,1) == "-"  ) {
			minus = "-";
		}   
	}

	var ch="";
	var j=1;
	var formatValue="";

	// 콤마제거  
	newValue = newValue.replace(/\,/gi, '');
	newValue = newValue.replace(/\-/gi, '');

	// 소수점
	var rateVals = newValue.split(".");

	if(rateVals.length == 2){
		newValue = rateVals[0];
		rate = "."+rateVals[1];
	}

	// comma제거된 문자열 길이
	len = newValue.length;

	for(var i=len ; i>0 ; i--){
		ch = newValue.substring(i-1,i);
		formatValue = ch + formatValue;
		if ((j%3) == 0 && i>1 ){
			formatValue=","+formatValue;
		}
		j++;
	}

	formatValue = minus+formatValue+rate;

	return formatValue;
};

/**************************************************************
 * 콤마제거
 *************************************************************/
kora.common.format_noComma = function(val1){
	return (val1+"").replace(/\,/gi, '');
};


/**
 * form 안에 있는 object (name 이 있어야함.)를 json 형태로 반환
 * @param $form
 * @returns {"page":"1"}
 */
kora.common.gfn_formData = function(formId){
	var data = $("#"+formId).serializeArray();
    var indexed_array = {};
    $.map(data, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
    
    return indexed_array;
}

/**
 *  알림창 호출
 */
alertMsg =  function(val, func){

	var frameName = '';
	if(window.frameElement != undefined && window.frameElement != null){
		frameName = window.frameElement.name;
	}
	
	var options = {
			alertText : val,
			func : func,
			type : 'alert',
			alertPagedata : frameName
		}
	
	window.parent.NrvPub.AjaxPopup('/common/alert.html', '', options);

	$(':focus').blur();
}

/**
 *  기본 confirm창 변경
 */
window.confirm = function(val, func){

	var frameName = '';
	if(window.frameElement != undefined){
		frameName = window.frameElement.name;
	}
	
	var options = {
			alertText : val,
			func : func,
			type : 'confirm',
			alertPagedata : frameName
		}
	
	window.parent.NrvPub.AjaxPopup('/common/alert.html', '', options);
	
	$(':focus').blur();
}

/**
 *  confirm 호출
 */
kora.common.confirm = function(val, func){
	
	var frameName = '';
	if(window.frameElement != undefined){
		frameName = window.frameElement.name;
	}
	
	var options = {
			alertText : val,
			func : func,
			type : 'confirm',
			alertPagedata : frameName
		}
	
	window.parent.NrvPub.AjaxPopup('/common/alert.html', '', options);
	
	$(':focus').blur();
}


kora.common.chk_send = 0;
kora.common.btn_id = '';

//실행이력 저장용 클릭이벤트 감지
$(document).click(function(event) { 
    	if(kora.common.chk_send == 0 && event.target.id.indexOf('btn_') > -1){
		kora.common.btn_id = event.target.id;
	}else{
		
	}
});

/**
 * jquery ajax execute
 * url, dataBody, func(실행함수)
 * */
function ajaxPost(url, dataBody, func, pAsync){
//	alert('caonima');
	if(kora.common.chk_send == 0){
		kora.common.chk_send = 1;
	}else{
		//alertMsg("처리중입니다.");
		return false;
	}
	
	/*
	for (var key in dataBody){
		if (typeof dataBody[key] == "string"){
			if(dataBody[key] == undefined) continue;
			//dataBody[key] = dataBody[key].replace(/\%/gi,"%25");
			//dataBody[key] = dataBody[key].replace(/\+/gi,"%2B");
		}
		else if(typeof dataBody[key] == "object"){
			for(var i=0;i<dataBody[key].length;i++){
				if(dataBody[key][i] == undefined) continue;
				
				if(typeof dataBody[key][i] == "object"){
					for(var k=0;k<dataBody[key][i].length;k++){
						if(dataBody[key][i][k] == undefined) continue;
					//	dataBody[key][i][k] = dataBody[key][i][k].replace(/\%/gi,"%25");
					//	dataBody[key][i][k] = dataBody[key][i][k].replace(/\+/gi,"%2B");
					}
					continue;
				}
				
				//dataBody[key][i] = dataBody[key][i].replace(/\%/gi,"%25");
				//dataBody[key][i] = dataBody[key][i].replace(/\+/gi,"%2B");
			}
		}
	}
	*/
	
	if(kora.common.btn_id != ''){
		//버튼 아이디
		dataBody['PARAM_BTN_CD'] = kora.common.btn_id;
	}else if(event != undefined && event.target != undefined && event.target.id != undefined){
		
		dataBody['PARAM_BTN_CD'] = '';
		
		var eveId = $(event.target).attr("id");
		if(eveId == null || eveId == undefined){
			eveId = $(event.target).parent().attr("id");
		}

		if(eveId != null && eveId != undefined) dataBody['PARAM_BTN_CD'] = eveId;
		 
		//버튼 아이디
		 /*
		if(event.target.id.indexOf('btn_') > -1 ){
			dataBody['PARAM_BTN_CD'] = event.target.id;
		}else if(event.path != null && event.path[1].id.indexOf('btn_') > -1 ){
			dataBody['PARAM_BTN_CD'] = event.path[1].id;
		}else{
			dataBody['PARAM_BTN_CD'] = '';
		}
		*/
	}else{
		dataBody['PARAM_BTN_CD'] = '';
	}

	if(gUrl != 'MAIN'){ //레이어팝업일때 MAIN이 뜬다..
		//메뉴CD
		dataBody['PARAM_MENU_CD'] = gUrl;
	}
	
	var async = true;
	if(pAsync != null && pAsync != "undefined") async = pAsync;

	$.ajax({
		url : url,
		type : 'POST',
		data : dataBody,
		dataType : 'json',
		cache : false,
		async : async,
		traditional : true,
		beforeSend: function(request) {
		    request.setRequestHeader("AJAX", true);
		    request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
		},
		success : function(data) { 
			
			kora.common.chk_send = 0;
			kora.common.btn_id = '';
			func(data);
		},
		error : function(c) {
			//console.log(c);
			if(c.status == 401 || c.status == 403){
				//alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
				
				window.parent.location.href = "/login.do";
			}else if(c.responseText != null && c.responseText != ""){
				alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
			}
			kora.common.chk_send = 0;
			kora.common.btn_id = '';
		}
	});
}

//form 데이터용 ajax
 function fileajaxPost(url, dataBody_x, func, pAsync){
 	
 	if(kora.common.chk_send == 0){
 		kora.common.chk_send = 1;
 	}else{
 		//alertMsg("처리중입니다.");
 		return false;
 	}

 	var btnCd = "";
 	var menuCd = "";
	
 	if(kora.common.btn_id != ''){
	    //버튼 아이디
	    btnCd = kora.common.btn_id;
	}
 	else if(event != undefined && event.target != undefined && event.target.id != undefined){
	    btnCd = '';
		
	    var eveId = $(event.target).attr("id");

	    if(eveId == null || eveId == undefined){
		eveId = $(event.target).parent().attr("id");
	    }

	    if(eveId != null && eveId != undefined) btnCd = eveId;
	}
 	else{
	    btnCd = '';
	}

	if(gUrl != 'MAIN'){ //레이어팝업일때 MAIN이 뜬다..
	    //메뉴CD
	    menuCd = gUrl;
	}
	

	
	var async = true;
 	if(pAsync != null && pAsync != "undefined") async = pAsync;
 	
 	var frm = document.getElementById('fileForm');
    frm.method = 'POST';
    frm.enctype = 'multipart/form-data';
    var fileData = new FormData(frm);

    fileData.append('PARAM_BTN_CD', btnCd);
    fileData.append('PARAM_MENU_CD', menuCd);
        
 	$.ajax({
 		url : url,
 		type : 'POST',
 		data : fileData,
 		dataType : 'json',
 		async : async,
 		cache : false,
 		contentType:false,
        processData:false,
        beforeSend: function(request) {
		    request.setRequestHeader("AJAX", true);
		    request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
		},
 		success : function(data) { 
 			kora.common.chk_send = 0;
 			kora.common.btn_id = '';
 			func(data);
 		},
 		error : function(c) {
 			if(c.status == 401 || c.status == 403){
 				//alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
 				window.parent.location.href = "/login.do";
 			}else if(c.responseText != null && c.responseText != ""){
 				alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
 			}
 			kora.common.chk_send = 0;
 			kora.common.btn_id = '';
 		}
 	});
 }





/**
 * JSON 형태(object)로 리턴
 * 
 **/
function jsonObject(val){
	try{
		return eval('(' + val + ')');
	}
	catch(Exception){
		return null;
	}
}

/**
 * 입력값이 숫자인지 체크
 * @returns {Boolean}
 */
kora.common.gfn_keyNumCheck =function(){
	var e = event.keyCode;
	if(( e >=  48 && e <=  57 ) || ( e >=  96 && e <= 105 ) ||   //숫자열 0 ~ 9 : 48 ~ 57, 키패드 0 ~ 9 : 96 ~ 105
       e ==   8 ||    //BackSpace
       e ==  46 ||    //Delete
       //e == 110 ||    //소수점(.) : 문자키배열
       //e == 190 ||    //소수점(.) : 키패드
       e ==  37 ||    //좌 화살표
       e ==  39 ||    //우 화살표
       e ==  35 ||    //End 키
       e ==  36 ||    //Home 키
       e ==  16 ||    //Shift 키
       e ==  17 ||    //Ctrl 키
       e ==  18 ||    //Alt 키
       e ==   9 ){      //Tab 키
		return true;
	}else{
		return false;
	}
	
}


/**
 * 쿠키 세팅
 * @param cookieName
 * @param cookieValue
 */
function gfn_setCookie(cookieName, cookieValu){
	gfn_setCookie(cookieName, cookieValue, 1);
}

function gfn_setCookie(cookieName, cookieValue, term)
{
	var today = new Date();
	if(term == null || term == "") term = 1;
	today.setDate(today.getDate() + term);
	
	if(cookieValue == null || cookieValue == ""){
		var expireDate = new Date();
		expireDate.setDate( expireDate.getDate() - 1 );	//어제 날짜를 쿠키 소멸 날짜로 설정한다.
		document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
	}else{
		document.cookie = cookieName + "=" + escape( cookieValue ) + "; path=/; expires=" + today.toGMTString() + ";";
	}
	return true;
}

/**
 * 쿠키값 가져오기
 * @param cookieNm
 * @returns
 */
function gfn_getCookie(cookieNm)
{	
	var cookie = document.cookie;
	if(cookie.indexOf(";") > -1){
		var arr = cookie.split(";");
		for(var i=0; i<arr.length; i++){
			var tmpKey = arr[i].split("=");
			var key = $.trim(tmpKey[0]);
			var val = tmpKey[1];
			if(key == cookieNm)return unescape(val);
		}
		return "";
	}else{
		if(cookie.indexOf("=") > -1){
			var arr = cookie.split("=");
			var key = $.trim(arr[0]);
			var val = arr[1];
			if(key == cookieNm) return unescape(val);
			return "";
		}else{
			return "";
		}
	}
}

//천단위 콤마찍기
kora.common.gfn_setComma = function (str) {
	  str = String(str);
	   return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

//콤마제어
kora.common.gfn_removeComma = function (str) {
	  str = String(str);
	    return str.replace(/[^\d]+/g, '');
}


kora.common.excelExport = function(fileName,gridRoot,dataGrid){
	var collection = gridRoot.getCollection();
	// PagingCollection의 rowsPerPage를 0으로 세팅하여 전체 데이터를 보여주도록 하며 현재 페이지 번호를 저장합니다.
	var rowsPerPage = collection.getRowsPerPage();
	var currentPage = collection.getCurrentPage();
	collection.setRowsPerPage(0);
	// colNo 컬럼의 indexStartNo를 1로 초기화 해줍니다.
	var colNo = gridRoot.getObjectById("colNo");
	if (colNo)
		colNo.indexStartNo = 1;
	
	var now  = new Date(); 				     // 현재시간 가져오기
	var hour = new String(now.getHours());   // 시간 가져오기
	var min  = new String(now.getMinutes()); // 분 가져오기
	var sec  = new String(now.getSeconds()); // 초 가져오기
	var today = kora.common.gfn_toDay();
	
	dataGrid.exportFileName = fileName +"_" + today+hour+min+sec+".xlsx";

	gridRoot.addEventListener("exportSaveComplete", function() {
			// 내보내기 후에 불려져서 PagingCollection의 rowsPerPage, currentPage와 colNo컬럼의 indexStartNo를 원복합니다.
			collection.setRowsPerPage(rowsPerPage);
			collection.setCurrentPage(currentPage);
			if (colNo)
				colNo.indexStartNo = (currentPage - 1) * rowsPerPage + 1;
		}
	);
	gridRoot.excelExportSave("/jsp/saveExcel.jsp", false);
}

/**
 * 엑셀 업로드 팝업
 * @param callBackFunc - 업로드 결과를 받을 콜백함수
 */
var parent_item={}; 
kora.common.gfn_excelUploadPop = function(callBackFunc){
	if(callBackFunc == null || callBackFunc == ""){
		alertMsg("결과를 받을 콜백함수를 직정하세요");
		return;
	}
		parent_item["callBackFunc"] =callBackFunc;
		parent_item["msg"] ="";
		parent_item["list"] =[];
		parent_item["saveYn"] ="N";
		var pagedata = window.frameElement.name;
		window.parent.NrvPub.AjaxPopup('/POP_EXCEL_UPLOAD_VIEW.do', pagedata);

		//window.open("/POP_EXCEL_UPLOAD_VIEW.do?callBackFunc=" + callBackFunc, "excelUpload", "width=450 ,height=200 menubar=no,status=no,toolbar=no, scrollbar=auto");
}


/**
 * 리포트 출력 - 바닥페이지에 출력할 경우 iframe선언해야 함.
 * @param formId - 전송할 폼이름
 * @param ifrName - iframe이름, 없을경우 새창으로 띄움
 * 폼안에 CRF_NAME(리포트 파일명)이 반드시 있어야 함.
 */
kora.common.gfn_viewReport = function(formName, ifrName){
	//window.open("", "_report", "width=1024,height=800,menubar=no,status=no,toolbar=no,scrollbars=yes,resizable=1");
	var target = "_report";
	if(ifrName != null && ifrName != "") target = ifrName;
	var frm = document.forms[formName];
	frm.target = target;
	frm.method = "post";
	//frm.action = "/ClipReport4/viewReport.jsp?_csrf=" + gtoken;
	frm.action = "/ClipReport4/viewReport.jsp";
	frm.submit();
}


//오류 페이지 처리
function gfn_mobileCheck(){
	//모바일인경우
	if (navigator.userAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || navigator.userAgent.match(/LG|SAMSUNG|Samsung/) != null) {
		return true;
  	}else{
  		return false;
  	}
}



/*****************************************************************날짜 함수  시작******************************************************************************/
/**
 * 입력 문자열이 날짜형태인지 
 * @param v1 : '-'미포함 8자리 or '-'포함 10자리 
 * @returns {Boolean}
 */

kora.common.gfn_isDate =function(v1){
if(v1 == null || v1 == "") return true;
	v1 = v1.replaceAll("-","");
	if (v1.length!=8 || isNaN(v1)) return false;
	try{
		var y = parseInt(v1.substr(0,4),10);
		var m = parseInt(v1.substr(4,2),10)-1;
		if (m<0 && m>11) return false;
		var d = parseInt(v1.substr(6),10);
		var e = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
		if ((y % 4 == 0 && y % 100!=0) || y % 400 == 0) e[1] = 29;
		return (d>=1 && d<=e[m]);
	}
	catch(Exception){
		return false;
	}
	return true;
	
}


/**
 * 현재날짜 구하기
 * @returns {String}
 */

kora.common.gfn_toDay =function(){
	
	var date = new Date();
	var year = date.getFullYear();
	var month = new String(date.getMonth()+1);
	var day = new String(date.getDate()); 
	// 한자리수일 경우 0을 채워준다. 
	if(month.length == 1) month = "0" + month;
	if(day.length == 1) day = "0" + day;
	return year + "" + month + "" + day;
	
} 

/*********************************************************
 * 현재 년월일
 ********************************************************/
kora.common.rtnDate = function(value)
{
	var rtnDate = "";
	var date  = new Date();
	var Today = new Array();

	Today['Year']  = date.getFullYear();
	Today['Month'] = date.getMonth()+1;
	Today['Day']   = date.getDate();
	if(Today['Month']<10){
		var month= "0"+Today['Month'];
	}else{
		var month = Today['Month'];
	}
	if(Today['Day']<10){
		var day = "0"+Today['Day'];
	}else{
		var day = Today['Day'];
	}
	
	//년월일 구분자 제거 후 처리(2013-09-04 JDH)
	if(kora.common.null2void(value).length > 0){
		value = value.replace(/\-/g,"");
		value = value.replace(/\./g,"");
	}

	if(typeof(value) == "undefined" || value.length != 8 ){
		//현재 년월일
		rtnDate =  Today['Year']+"-"+month+"-"+day;
	}else{
		if (isNaN(new Number(value))) {
			rtnDate = Today['Year']+"-"+month+"-"+day;
		}else{
			rtnDate = value.substring(0,4)+"-"+value.substring(4,6)+"-"+value.substring(6,8);
		}
	}

	return rtnDate;
}

/*********************************************************
 * return Unique Time
 ********************************************************/
rtnUniqueTime = function(){
	var rtnVal = "";
	
	var now   		= new Date(); 				// 현재시간 가져오기
	var year  		= now.getYear(); 			// 년도 가져오기
	var month 		= now.getMonth()+1;			// 월 가져오기 (+1)
	var date  		= now.getDate(); 			// 날짜 가져오기
	var hour  		= now.getHours(); 			// 시간 가져오기
	var min   		= now.getMinutes(); 		// 분 가져오기
	var sec   		= now.getSeconds(); 		// 초 가져오기
	var mill_sec 	= now.getMilliseconds();	// 밀리초 가져오기
	
	rtnVal = hour + "" + min + "" + sec + "" + mill_sec;
	
	return rtnVal;
};


/**************************************************************************
 * 날짜 유효성 체크
 * param1 : format(예:YYYYMMDD)
 * param2 : data(예:20120201)
 * return : true/false
 *************************************************************************/
kora.common.fn_validDate = function(data, format,DList){
	
	var rtnVal    = true;
	var inpDate   = kora.common.null2void(data).replace(/[^0-9]/g, "");
	var inpFormat = kora.common.null2void(format,"YYYYMMDD");
	
	var p_yy="", p_mm="", p_dd="";
	var v_yy="", v_mm="", v_dd="";

	
	
	if(inpDate.length == 0) return false;
	else if (isNaN(data.replaceAll("-",""))) return false;
	
	if(inpFormat != "" && inpDate != ""){
		// 년월일
		if(inpFormat.toUpperCase() == "YYYYMMDD"){
			if(inpDate.length != 8) return false;
			
			p_yy = inpDate.substring(0,4);
			p_mm = inpDate.substring(4,6);
			p_dd = inpDate.substring(6,8);
			
		}
		// 년월
		else if(inpFormat.toUpperCase() == "YYYYMM"){
			if(inpDate.length != 6) return false;
			
			p_yy = inpDate.substring(0,4);
			p_mm = inpDate.substring(4,6);
			p_dd = "01";
		}
		// 년
		else if(inpFormat.toUpperCase() == "YYYY"){
			if(inpDate.length != 4) return false;
			
			p_yy = inpDate.substring(0,4);
			p_mm = "01";
			p_dd = "01";
		}
		
		var dateVar = new Date(p_yy, Number(p_mm)-1, p_dd);
		
		v_yy = dateVar.getFullYear();
		v_mm = dateVar.getMonth()+1<10?"0"+(dateVar.getMonth()+1):dateVar.getMonth()+1;
		v_dd = dateVar.getDate()<10?"0"+dateVar.getDate():dateVar.getDate();
		// 인수로 받은 년월일과 생성한 Date 객체의 년월일이 일치하면 true
		rtnVal = (v_yy==p_yy && v_mm==p_mm && v_dd==p_dd) ? true : false;
	}
	else{
		alertMsg("올바른 날짜 형식이 아닙니다.");
		return false;
	}
    
    return rtnVal;
};

//등록제한일자 검사
kora.common.fn_validDate_ck =function(sel_val, data, upd_std){
	var st_dt="";
	var end_dt="";
	var dt_flag;
	var inpDate   = kora.common.null2void(data).replace(/[^0-9]/g, "");
	
	if(rtc_dt_list !=undefined && rtc_dt_list != null){
				if(sel_val  =="R"){	//등록일경우 현재날짜 기준
					dt_flag = false;
				}else{					//수정일경우 등록날짜기준
					dt_flag = upd_std;
				}
				//시작일자
				if(rtc_dt_list.RTC_ST_SE	=="A"){
					st_dt		=	kora.common.getDate("yyyymmdd", "Y", -1, dt_flag).replaceAll('-','')
				}else if(rtc_dt_list.RTC_ST_SE	=="B" || rtc_dt_list.RTC_ST_SE	=="C" || rtc_dt_list.RTC_ST_SE	=="D" ){
					st_dt		=	kora.common.getDate("yyyymmdd", "D",Number(-rtc_dt_list.RTC_ST_DT) , dt_flag).replaceAll('-','');
				}else{
					st_dt		=	rtc_dt_list.RTC_ST_DT;
				}
				
				//종료일자
				if(rtc_dt_list.RTC_END_SE	=="A"){
					end_dt	= 	kora.common.getDate("yyyymmdd", "Y",1, dt_flag).replaceAll('-','')
				}else if(rtc_dt_list.RTC_END_SE	=="B" || rtc_dt_list.RTC_END_SE	=="C" || rtc_dt_list.RTC_END_SE	=="D" ){
					end_dt	= 	kora.common.getDate("yyyymmdd", "D",Number(rtc_dt_list.RTC_END_DT), dt_flag).replaceAll('-','');
				}else{
					end_dt	=	rtc_dt_list.RTC_END_DT;
				}
				
				//console.log(st_dt  +" : " +inpDate  +" :  " +end_dt );
				if(Number(st_dt)>Number(inpDate)){//시작날짜가 등록날짜보다 큰경우
					alertMsg(kora.common.formatter.datetime(st_dt,"yyyy-mm-dd")+" ~ "+kora.common.formatter.datetime(end_dt,"yyyy-mm-dd") +" 내의 일자만 등록 가능합니다.");
					return false;
				}else if(Number(inpDate)>Number(end_dt)){	//시작날짜가 등록날짜보다 작지만 등록일짜가 종료날짜 보다 클경우
					alertMsg(kora.common.formatter.datetime(st_dt,"yyyy-mm-dd")+" ~ "+kora.common.formatter.datetime(end_dt,"yyyy-mm-dd") +" 내의 일자만 등록 가능합니다.");
					return false;
				}else{
					return true;
				}				
	}//end of if(rtc_dt_list !=undefined)  
	
	return true;
}


/**
 *  시간 유효성 체크
 * 
 */
kora.common.fn_validTime =function(startDt , endDt){
		if(endDt < startDt){
			alertMsg("시간을 확인해주세요.\n정상적인 시간이 아닙니다."); 
			return; 
		}
	 
};

/*******************************************************
 * 두 날짜의 차이를 일자로 구한다.(조회 종료일 - 조회 시작일)
 * @param val1 - 조회 시작일(날짜 ex.2002-01-01)
 * @param val2 - 조회 종료일(날짜 ex.2002-01-01)
 * @return 기간에 해당하는 일자 
 ******************************************************/
kora.common.fnGetDateRange = function(val1, val2)
{
    var FORMAT = "-";

    // FORMAT을 포함한 길이 체크
    if (val1.length != 10 || val2.length != 10)
        return null;

    // FORMAT이 있는지 체크
    if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)
        return null;

    // 년도, 월, 일로 분리
    var start_dt = val1.split(FORMAT);
    var end_dt = val2.split(FORMAT);

    // 월 - 1(자바스크립트는 월이 0부터 시작)
    // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
    start_dt[1] = (Number(start_dt[1]) - 1) + "";
    end_dt[1] = (Number(end_dt[1]) - 1) + "";

    var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
    var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

   	return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
}

/*********************************************************************
 * 조회기간 날짜 제한 체크
 * param1:시작일자, param2:종료일자, param3:제한일수
 ********************************************************************/
kora.common.fnCheckDay = function(date1, date2, chkDate)
{
	var day = kora.common.fnGetDateRange(date1, date2)

	if(day>chkDate){
		alertMsg("조회기간이 " + chkDate + "일을 넘을 수 없습니다.");
		return false;
	}

	return true;
};


/*********************************************************************
 * 날짜 요청된 포맷형식으로 처리
 ********************************************************************/
kora.common.formatter.datetime = function(date, format) {
	if(!format){
		alertMsg("날짜 포맷을 입력해주세요");
		return false;
	}
		
	if(!date)	return "";

	//이미 포맷팅 되어있는값을 삭제한다.
	date = date.replace(/[^0-9]/g,"");
	
	//입력된 날짜의 길이가 포맷팅되어야 하는 길이보다 작으면 뒤에 0을 붙인다.
	var formatLength = format.replace(/[^a-z]/g, "").length;
	var dateLength = date.length;
	for(var i=0 ; i<formatLength-dateLength ; i++){
		date += '0';
	}
	
	if(format.replace(/[^a-z]/g, "")=="hhmiss" && date.length==6)
	{
		date = "00000000"+date;
	}
	
	var idx = format.indexOf("yyyy");
	if( idx > -1 ){
		format = format.replace("yyyy", date.substring(0,4));
	}
	idx = format.indexOf("yy");
	if( idx > -1 ){
		format = format.replace("yy", date.substring(2,4));
	}
	idx = format.indexOf("mm");
	if( idx > -1 ){
		format = format.replace("mm", date.substring(4,6));
	}
	idx = format.indexOf("dd");
	if( idx > -1 ){
		format = format.replace("dd", date.substring(6,8));
	}
	idx = format.indexOf("hh24");
	if( idx > -1 ){
		format = format.replace("hh24", date.substring(8,10));
	}
	idx = format.indexOf("hh");
	if( idx > -1 ){
		var hours = date.substring(8,10);
		hours = parseInt(hours,10)<=12?hours:"0"+String(parseInt(hours,10)-12);
		format = format.replace("hh", hours);
	}
	idx = format.indexOf("mi");
	if( idx > -1 ){
		format = format.replace("mi", date.substring(10, 12));
	}
	idx = format.indexOf("ss");
	if( idx > -1 ){
		format = format.replace("ss", date.substring(12));
	}
	idx = format.indexOf("EEE");
	if( idx > -1 ){
		var weekstr='일월화수목금토'; // 요일 스트링
		
		var day = weekstr.substr(new Date(date.substring(0,4), new Number(date.substring(4,6))-1, date.substring(6,8)).getDay(), 1);
		format = format.replace("EEE", day);
	}
	
	return format;
};
	
kora.common.getLastDate = function(yyyy, mm)
{
	if( yyyy==undefined || String(yyyy).length!=4 || mm==undefined || String(mm).length>2 )
		return 0;
	else
		return new Date(new Date(yyyy, mm, '1')-(60*60*24*1000)).getDate();
 };

kora.common.getDate = function(format,  c, i, sdate)
{
	var currentDate;
	if(sdate){
		currentDate = new Date(kora.common.formatter.datetime(sdate, "yyyy"), parseInt(kora.common.formatter.datetime(sdate, "mm"), 10)-1, kora.common.formatter.datetime(sdate, "dd"));
	}else{
		currentDate = new Date();
	}

	var _tmpDate;
	if(kora.common.null2void(c)!="")
	{
		switch( c.toUpperCase() ){
			case "Y":
				_tmpDate = new Date(currentDate.getFullYear()+i, currentDate.getMonth(), currentDate.getDate());
			break;
 			
			case "M":
				_tmpDate = new Date(currentDate.getFullYear(), currentDate.getMonth()+i,  1);
 				
				//beforeDate의 마지막 날짜가, 조회종료일자조건의 선택되어있는값보다 작으면
				//beforeDate의 마지막 날짜로 설정한다.
 				var lastDate = kora.common.getLastDate(_tmpDate.getFullYear(), _tmpDate.getMonth()+1);
 				if( lastDate < currentDate.getDate() )
 				{
 					_tmpDate.setDate(lastDate);
 				}
 				else
 				{
 					_tmpDate.setDate(currentDate.getDate());
 				}

 			break;

			case "W":
				_tmpDate = new Date(currentDate.getFullYear(), currentDate.getMonth(),  currentDate.getDate()+(i*7));
			break;

			case "D":
				_tmpDate = new Date(currentDate.getFullYear(), currentDate.getMonth(),  currentDate.getDate()-(i*-1));
			break;
			
			case "F":
				_tmpDate = new Date(currentDate.getFullYear(), currentDate.getMonth(),  1); //첫일
			break;
			
			case "L":
				_tmpDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1,  0); //말일
			break;

			default : 
				alertMsg("없는 기준 Flag입니다.("+c+")");
				return false;
			break;
		}
		currentDate = _tmpDate;
	}
	var year = String(currentDate.getFullYear());

	var month = currentDate.getMonth();
	month = month+1<10?"0"+String(month+1):String(month+1);

	var date = currentDate.getDate();
	date = date<10?"0"+String(date):String(date);

	var weekstr='일월화수목금토'; // 요일 스트링

	var day = weekstr.substr(currentDate.getDay() , 1);

	var hours = currentDate.getHours();
	hours = hours<10?"0"+String(hours):String(hours);

	var minutes =  currentDate.getMinutes();
	minutes = minutes<10?"0"+String(minutes):String(minutes);

	var seconds = currentDate.getSeconds();
	seconds = seconds<10?"0"+String(seconds):String(seconds);

	return kora.common.formatter.datetime(year+month+date+hours+hours+seconds, format);
};


/**************************************************************
 * 날짜 비교
 * 종료일이 시작일 보다 작을때 false 를
 * 정상 기간일 경우 true 를 리턴한다.
 * @param startDate 시작일
 * @param endDate 종료일
 * @param point 날짜 구분자
 ******************************************************************/

kora.common.fnDateCompare = function (startDate, endDate, point){
	
    //정상 날짜인지 체크한다.
    var startDateChk = fnDateCheck(startDate, point);
    if(!startDateChk){
        return false;
    }
    var endDateChk = fnDateCheck(endDate, point, "end");
    
    if(!endDateChk){
        return false;
    }

    //년 월일로 분리 한다.
    var start_Date = new Array(3);
    var end_Date   = new Array(3);

    if(point != ""){
        start_Date = startDate.split(point);
        end_Date = endDate.split(point);
        if(start_Date.length != 3 && end_Date.length != 3){
            return false;
        }
    }
    else{
        start_Date[0] = startDate.substring(0,4);
        start_Date[1] = startDate.substring(4,6);
        start_Date[2] = startDate.substring(6,9);

        end_Date[0] = endDate.substring(0,4);
        end_Date[1] = endDate.substring(4,6);
        end_Date[2] = endDate.substring(6,9);
    }

    //Date 객체를 생성한다.
    var sDate = new Date(start_Date[0], start_Date[1], start_Date[2]);
    var eDate = new Date(end_Date[0], end_Date[1], end_Date[2]);

    if(sDate > eDate){
        return false;
    }

    return true;
}


/*************************************************날짜 마지막****************************************************************************/


/*************************************************입력값 체크  시작********************************************************

/**
 * 패스워드 체크 특수문자 포함 8~16자리 또는 특수문자 미포함 10~16자리
 * @param str
 * @returns {Boolean}
 */

kora.common.gfn_pwValidChk = function(str) {
	var reg_id = /^.*(?=.{10,16})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    var reg_id2 = /^.*(?=.{8,16}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[~!@\#$%<>^&*\()\-=+_\']).*$/;
	
	if(reg_id.test(str) || reg_id2.test(str)){
		return true;
	}else{
		return false;
	}
	
}

//사업자 번호체크
kora.common.gfn_bizNoCheck = function(bizNo) {
	if(bizNo.indexOf("-") > -1) bizNo = bizNo.replace(/-/gi,'');
	if(bizNo.length != 10) return false;
	
	var checkNum = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1);
	var tmpBizNo;
	var chkSum=0;
	var remander;

	for (var i=0; i<=7; i++){
		chkSum += checkNum[i] * bizNo.charAt(i);
	}
	tmpBizNo = "0" + (checkNum[8] * bizNo.charAt(8));
	tmpBizNo = tmpBizNo.substring(tmpBizNo.length - 2, tmpBizNo.length);
	chkSum += Math.floor(tmpBizNo.charAt(0)) + Math.floor(tmpBizNo.charAt(1));
	remander = (10 - (chkSum % 10)) % 10 ;
	
	if (Math.floor(bizNo.charAt(9)) != remander) return false;
	
	return true;
	
}


kora.common.gfn_idValidChk = function (str){
	var reg_id = /(^[A-Za-z0-9_]{6,16}$)/; 
	
	/*/^.*(?=.{8,16})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;*/
	
	if(reg_id.test(str)){
		return true;
	}else{
		return false;
	}
}


kora.common.gfn_idPwChkValid = function (str){
	var SamePass_0 = 0; //동일문자 카운트
	var SamePass_1 = 0; //연속성(+) 카운드
	var SamePass_2 = 0; //연속성(-) 카운드

	var chr_pass_0;
	var chr_pass_1;

	for(var i=0; i < str.length; i++) {
		chr_pass_0 = str.charAt(i);
		chr_pass_1 = str.charAt(i+1);
		
		//동일문자 카운트
		if(chr_pass_0 == chr_pass_1){
			SamePass_0++;
			if(SamePass_0 > 1) {
				alertMsg("동일한 문자를 연속으로 3번 이상 사용할 수 없습니다.");
				return false;
			}
		}else{
			SamePass_0 = 0;
		}
		
		if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1){
			SamePass_1++;	//연속성(+) 카운드
			if(SamePass_1 > 1)  {
				//alertMsg("연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.");
				alertMsg("연속된 문자열(123, abc 등)을 3자 이상 사용 할 수 없습니다.");
				return false;
			}
		}else{
			SamePass_1 = 0;
		}
		
		/*
		if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1){
			SamePass_2++;	//연속성(-) 카운드
			if(SamePass_2 > 1)  {
				alertMsg("연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.");
				return false;
			}
		}else{
			SamePass_2 = 0;
		}
		*/
	}
	
	return true;
	
}


/***************************************
* 객체안의 필수값 체크
* - divId          
***************************************/
var chkTarget;
kora.common.cfrmDivChkValid = function(divId){
	var chkDiv = true;

	$("#"+divId).find(".i_notnull").each(function(){
		if($(this).css("display") != "none"){
			if($(this).val() == null || $(this).val() == ""){
				alertMsg($(this).attr("alt")+" 을(를) 확인하세요.", "kora.common.cfrmDivChkValid_focus");
				chkTarget = $(this);
				chkDiv = false;
				return false;
				
			}
		}
	});
	
	if(!chkDiv) return chkDiv; 
	
	$("#"+divId).find("input[format=number]").each(function(){
		
		if($(this).val() !=""){
				if($(this).css("display") != "none"){
					if(isNaN($(this).val()) ){
						alertMsg($(this).attr("alt")+" 은 숫자만 입력가능합니다.", "kora.common.cfrmDivChkValid_focus");
						chkTarget = $(this);
						chkDiv = false;
						return false;
					}
				}
				
				if(!/^[0-9]{1,}$/.test($(this).val()) ){
					alertMsg($(this).attr("alt")+' 은 정수만 입력 가능합니다.', "kora.common.cfrmDivChkValid_focus");
					chkTarget = $(this);
					chkDiv = false;
					return false;
				}
		}
		
	});
	
	return chkDiv;
};


kora.common.cfrmDivChkValid_focus = function(){
	chkTarget.focus();
}

kora.common.focus_target = function(target){
	$('#'+target).focus();
}


/***************************************
* 정수값 체크
***************************************/
kora.common.intChk = function(val){
	return /^[0-9]{1,}$/.test(val);
}

/*************************************페이지 이동  시작*************************
 * 페이지 이동
 *************************************************************/

kora.common.moving = '0';

kora.common.gfn_MoveUrl= function(url){
	/*
	gfn_setCookie("myMenu", "0");
	//location.href = url;
	if(document.getElementById("frmMoving") == null){
		var txt = new Array();
		txt.push('<form name="frmMoving" id="frmMoving" method="post">');
		txt.push('</form>');
		$(document.body).append(txt.join("").toString());
	}
	frmMoving.action = url;
	frmMoving.target = "_top";
	frmMoving.submit();
	*/
	
	//window.location.href = url + "?_csrf=" + gtoken;
	window.location.href = url;
}

kora.common.goPage = function(url, jsonInp, gubun){
	
	if(kora.common.moving == '1'){
		return;
	}
	kora.common.moving = '1';
	
	//페이지 이동시 현재 인자값을 그대로 가져감
	if(gubun != 'R'){ 
		//콜백 URL을 순서대로 저장   
		//페이지 이동이 연속으로 발생할 경우 순차적으로 돌아가도록 처리하기 위해
		if(kora.common.null2void(jsonInp.URL_CALLBACK) != ""){ 
			var ucList = new Array();
			if(kora.common.null2void(jsonInp.URL_CALLBACK_LIST) != ""){ //기존 저장된 콜백URL 복사
				ucList = jsonInp.URL_CALLBACK_LIST.slice(); //배열 복사
			}
			
			ucList.push(jsonInp.URL_CALLBACK);
			jsonInp.URL_CALLBACK_LIST = ucList;
		}
		
		//조회인자값 순서대로 저장 params
		var pList = new Array();
		var tList = new Array();
		if(kora.common.null2void(jsonInp.PARAMS_TEMP_LIST) != ""){ //기존 저장된 params 복사
			tList = jsonInp.PARAMS_TEMP_LIST.slice(); //배열 복사
			pList = jsonInp.PARAMS_TEMP_LIST.slice(); //배열 복사
		}
		jsonInp.PARAMS_LIST = tList; //이전 화면 이동시 사용할 params
	
		pList.push(jsonInp.PARAMS);
		jsonInp.PARAMS_TEMP_LIST = pList; //params 임시저장
	}
	
    var $form = $('<form></form>');
    url = url + "?_csrf=" + gtoken;
    $form.attr('action', url);
    $form.attr('method', 'post');

    if(kora.common.null2void(jsonInp) != ""){
        $form.append('<textarea name="INQ_PARAMS" style="display:none;">'+JSON.stringify(jsonInp)+'</textarea>');
    }
    
    $form.appendTo('body');
    kora.common.moving = '0';
    $form.submit();
    
};

kora.common.goPageB = function(url, jsonInp){
	
	if(kora.common.moving == '1'){
		return;
	}
	kora.common.moving = '1';
	
	var bUrl = '';
	if(kora.common.null2void(url) != ""){
		bUrl = url;
	}else{
		var ucList = new Array();
		ucList = jsonInp.URL_CALLBACK_LIST;
		if(ucList != undefined){
			bUrl = ucList.pop(); //맨 마지막 콜백URL 데이터 추출 및 제거
		}
	}
	
	var pList = new Array();
	var tList = new Array();
	pList = jsonInp.PARAMS_LIST;
	tList = jsonInp.PARAMS_TEMP_LIST;
	if(pList != undefined){
		jsonInp.PARAMS = pList.pop();
	}
	if(tList != undefined){
		tList.pop();
	}
	
    var $form = $('<form></form>');
    $form.attr('action', bUrl + "?_csrf=" + gtoken);
    $form.attr('method', 'post');

    if(kora.common.null2void(jsonInp) != ""){
        $form.append('<textarea name="INQ_PARAMS" style="display:none;">'+JSON.stringify(jsonInp)+'</textarea>');
    }
    
    $form.appendTo('body');
    kora.common.moving = '0';
    $form.submit();
    
};

kora.common.goPageM = function(url, jsonInp, tblId, sendYn){
    var $form = $('<form></form>');
    $form.attr('action', url + "?_csrf=" + gtoken);
    $form.attr('method', 'post');
    
    var sFnCallBack  = "";
    var sUrlCallBack = "";
    
    if(kora.common.null2void(jsonInp) != ""){
        $.each(jsonInp, function(i, v){
        	if(i=="FN_CALLBACK")  sFnCallBack  = v;
        	if(i=="URL_CALLBACK") sUrlCallBack = v;
        	$form.append('<input name="'+i+'" type="hidden" value="'+v+'" />');
        });
    }
    
    //조회조건 넘길 경우
    var jsonInq = {};
    if(kora.common.null2void(tblId) != ""){
    	jsonInq = kora.common.tableToJson(tblId);
    	jsonInq["FN_CALLBACK" ] = sFnCallBack;
    	jsonInq["URL_CALLBACK"] = sUrlCallBack;
    	
    	//상세조회 파이메터 추가. 20160325 DHC
    	if(kora.common.null2void(sendYn,"N") == "Y") {
    		jsonInq["DEPTH_SEQ"    ] = "1";
    		jsonInq["DEPTH_PARAMS1"] = jsonInp;
    	}
    	
    	$form.append('<textarea name="INQ_PARAMS" style="display:none;">'+JSON.stringify(jsonInq)+'</textarea>');
    }
    
    $form.appendTo('body');
    $form.submit();
};

kora.common.goPageM2 = function(url, jsonInp, tblId){
    var $form = $('<form></form>');
    $form.attr('action', url  + "?_csrf=" + gtoken);
    $form.attr('method', 'post');
    
    var sFnCallBack = "";
    
    if(kora.common.null2void(jsonInp) != ""){
    	$.each(jsonInp, function(i, v){
        	if(i=="FN_CALLBACK") sFnCallBack = v;
        });
    }
    
    $form.append('<textarea name="LIST" style="display:none;">'+JSON.stringify(jsonInp)+'</textarea>');
    
    //조회조건 넘길 경우
    var jsonInq = {};
    if(kora.common.null2void(tblId) != ""){
    	jsonInq = kora.common.tableToJson(tblId);
    	jsonInq["FN_CALLBACK"] = sFnCallBack;
    	$form.append('<textarea name="INQ_PARAMS" style="display:none;">'+JSON.stringify(jsonInq)+'</textarea>');
    }
    
    $form.appendTo('body');
    $form.submit();
};


kora.common.goPageD = function(url, jsonInp, jsonInq, goGubn){
	var $form = $('<form></form>');
	$form.attr('action', url + "?_csrf=" + gtoken);
	$form.attr('method', 'post');
	
	if(kora.common.null2void(jsonInp) != ""){
		$.each(jsonInp, function(i, v){
			$form.append('<input name="'+i+'" type="hidden" value="'+v+'" />');
		});
	}
	
	//조회조건 넘길 경우
	if(kora.common.null2void(jsonInq) != ""){
		
		//20160328 DHC 수정
		if(kora.common.null2void(jsonInq.DEPTH_SEQ) != ""){
			var nSeq = Number(jsonInq.DEPTH_SEQ);

			//상위 상세화면 이동
			if(kora.common.null2void(goGubn) == "M"){
				nSeq = nSeq - 1;
				if(nSeq > 0){
					var jsonCur = eval("jsonInq.DEPTH_PARAMS"+(nSeq+1));
					var jsonBak = eval("jsonInq.DEPTH_PARAMS"+nSeq);
					if(kora.common.null2void(jsonCur.URL_CALLBACK)!="") $form.attr('action', jsonCur.URL_CALLBACK);
					$.each(jsonBak, function(i, v){
						$form.append('<input name="'+i+'" type="hidden" value="'+v+'" />');
					});
					jsonInq["DEPTH_SEQ"] = nSeq+"";
				}
			}
			//하위 상세화면 이동
			else if(kora.common.null2void(goGubn) == "D"){
				nSeq = nSeq + 1;
				jsonInp["URL_CALLBACK"] = $(location).attr('pathname');
				
				jsonInq["DEPTH_SEQ"] = nSeq+"";
				jsonInq["DEPTH_PARAMS"+nSeq] = jsonInp;
			}
		}

		$form.append('<textarea name="INQ_PARAMS" style="display:none;">'+JSON.stringify(jsonInq)+'</textarea>');
	}
	
	$form.appendTo('body');
	$form.submit();
};



/*************************************페이지 이동  마지막*************************





/********************************************************************
 * 현재년도 기준 내림차순으로 해당년도까지 selectbox에 채우는 함수
 * - param1: 객체명
 * - param2: 시작년도 
 *********************************************************************/
kora.common.getComboYearDesc = function(objName, stYear, selYear){

	var date  = new Date();
	var Today = new Array();
	var now   = new Date();

	Today['Year']= date.getFullYear();
	Today['Month']=date.getMonth()+1;
	
	if(kora.common.null2void(selYear) == "") selYear = Today['Year'];
	
	for(var i=Today['Year']; i >= stYear ; i--) {

		if(now.getYear() != i) {
	    	$(objName).append("<option value='"+ i +"' "+(selYear==i?"selected":"")+" >"+i+"</option>");
	    } 
		else {
	    	$(objName).append("<option value='"+ i +"' "+(selYear==i?"selected":"")+" >"+i+"</option>");
	    }
	}
};

/********************************************************************
 * 현재년도 기준 내림차순으로 Term을 주어서 selectbox에 채우는 함수
 * - param1: 객체명
 * - param2: 구간 
 *********************************************************************/
kora.common.getYearTermDesc = function(objName, termYear, selYeal){

	var date  = new Date();
	var Today = new Array();
	var now   = new Date();

	Today['Year']= date.getFullYear();
	Today['Month']=date.getMonth()+1;
	
	if(kora.common.null2void(selYear) == "") selYear = Today['Year'];

	for(var i=Today['Year']; i > Today['Year']-termYear ; i--) {
	    if(now.getYear() != i) {
	    	$(objName).append("<option value='"+ i +"' "+(selYear==i?"selected":"")+" >"+i+"</option>");
	    } 
	    else {
	    	$(objName).append("<option value='"+ i +"' "+(selYear==i?"selected":"")+" >"+i+"</option>");
	    }
	}
};

/********************************************************************
 * 월을 selectbox에 채우는 함수
 * - param1: 객체명
 * - param2: 선택년도
 *********************************************************************/
kora.common.getComboMonth = function(objName, selMonth){
	var mon = ""
	if ( selMonth == "" ) selMonth = (new Date().getMonth()+1) + ""	
	for(i=1; i < 13 ; i++) {
		if ( i < 10 ) strMonth = ("0" + i);
		else strMonth = i;
		
    	$(objName).append("<option value='"+ strMonth +"' "+(Number(selMonth)==Number(strMonth)?"selected":"")+" >"+strMonth+"</option>");
	}
};
 
/*******************************************
 * 숫자로 구성된 문자열을 특정형식으로 포맷
 ******************************************/
kora.common.setDelim = function(str, delimPtrn){
	if($.trim(kora.common.null2void(str,"0")) == "0") return "";
	var rtnVal = "";
	
	for(var i=0,j=0; i<delimPtrn.length; i++){
		if(delimPtrn.charAt(i) == '9'){
			rtnVal += str.charAt(j);
			j++;
		}else{
			rtnVal += delimPtrn.charAt(i);
		}
	}
	
	return rtnVal;
};

/*******************************************
 * 콤보박스 자동완성
 * autoYn : default - 'Y', 일반콤보 - 'N'
 ******************************************/
kora.common.autoCompleteCombo = function(SelectTagId, autoYn){

	if(kora.common.null2void(autoYn,"Y") == "Y"){
		
		$.widget("custom.combobox", {
			_create: function() {
				
				var select = this.element;
				$("select[id="+SelectTagId+"]").css("display", "none");

				var opts = new Array();
				$('option',select).each(function(index) {
					var opt = new Object();
					opt.value = $(this).val();
					opt.label = $(this).text();
					opts[opts.length] = opt;
				});

				var span  = $("<span>");
				span.addClass("custom-combobox");
				span.insertAfter(select);
				
				var input = $("<input id='"+SelectTagId+"'>");
				input.insertAfter(select);
				input.autocomplete({
					change: function(event, ui) {
						if (!ui.item) {
							var enteredString = $(this).val();
							var stringMatch = false;
							for (var i=0; i < opts.length; i++){
								if(opts[i].label.toLowerCase() == enteredString.toLowerCase()){
									select.val(opts[i].value);
									$(this).val(opts[i].label);
									stringMatch = true;
									break;
								}
							}
							if(!stringMatch){
								$(this).val($(':selected',select).text());
							}
							return false;
						}
					},
					select: function(event, ui) {
						select.val(ui.item.value);
						$(this).val(ui.item.label);
						return false;
					},
					
					
					focus: function(event, ui) {
						if (event.which === 38 || event.which === 40){
							$(this).val(ui.item.label);
							return false;
						}
					},
					source: opts,
					open: function(event, ui) {
						input.attr("menustatus","open");
					},
					close: function(event, ui) {
						input.attr("menustatus","closed");
					},
					minLength: 0
				});
//				input.addClass("text ui-widget ui-widget-content ui-corner-left");
				input.addClass("text ui-widget-content");
				input.val($(':selected',select).text());

				input.attr("menustatus","closed");
				var form = $(input).parents('form:first');
				$(form).submit(function(e){
					return (input.attr('menustatus') == 'closed');
				});

				/*
				 * 2015-07-13 SHW : autocomplete 항목에서 엔터키를 눌렀을 경우 onsubmit return false 가 되지 않아서 키이벤트로 처리           
				 */
				input.keypress(function(e) {
				    var code = (e.keyCode ? e.keyCode : e.which);
				    if(code == 13) { //Enter keycode
				        return false;
				    }
				});

				span.append(input);

				var btn = $("<button>&nbsp;</button>");
				btn.insertAfter(input);
				btn.attr("tabIndex", -1);
				btn.click(function() {
					if (input.autocomplete("widget").is(":visible")) {
						input.autocomplete("close");

						return false;
					}

					input.autocomplete("search", "");
					input.focus();
					return false; 
				});
				btn.css({"width":"18px"});
				input.css({"font-size":"12px","height":select.outerHeight()-3,"width":select.outerWidth() - btn.outerWidth(true),"border":"1px solid #d3d3d3", "ime-mode":"active"});
				btn.css({"margin-left":"-2px"});
				btn.css({"height":select.outerHeight()-1,"background-position":"-65px -13px"});
				btn.css("background-image","url('/images/ui-icons_222222_256x240.png')");
				btn.css("border", "1px solid gray");
				$(".ui-autocomplete").css({"font-size":"12px","height": "200px", "overflow-y":"scroll", "overflow-x":"hidden", "white-space":"nowrap"});
					
			}
		});
		
		$("select[id="+SelectTagId+"]").combobox();
	}
};

/*******************************************
 * 은행별 거래계좌번호 자동완성 콤보박스
 ******************************************/
kora.common.autoCmboAcctNo = function(pBnkCd, pAcctNo){
	jex.web.setSelectBox('comm_0011_01_r001', "{BANK_CD:'"+pBnkCd+"'}", '', $("#"+pAcctNo), null, "3");
	kora.common.autoCompleteCombo(pAcctNo);
};

/*******************************************
 * 은행별 거래계좌번호 자동완성 텍스트박스
 ******************************************/
kora.common.autoTextAcctNo = function(pBnkCd, acctId){
	$("#"+acctId).autocomplete({
		source: kora.common.selAcctNoByBnk(pBnkCd),
		minLength: 0
	})
	.focus(function(){ 
		//$(this).val("");
    });
	
};

/*******************************************
 * 은행별 거래계좌번호 조회
 ******************************************/
kora.common.selAcctNoByBnk = function(pBnkCd){
	
	var rtnVal = {};

	jex.web.Ajax("comm_0011_01_r001", {BANK_CD:pBnkCd}, function(dat) {
    	rtnVal = dat;
    },"jct", "3");

	var acctValRec = [];
	$.each(rtnVal.REC, function(i, v){
		acctValRec[i] = v.DAT;
	});
	
	//alertMsg(JSON.stringify(acctValRec));
	return acctValRec;

};


/**************************************************************
 * 공통코드 콤보박스 셋팅
 * @input         : 그룹코드
 * @selectedValue : 기본선택값. 값이 있으면 option의 value가 해당 값인 항목이 기본선택.
 * @selector      : jquery객체의 셀렉터 ex)$(this) 또는 $("#ID")...
 *************************************************************/
kora.common.setCommCmBx = function(input, selectedValue, selector) {
	var selectbo = selector;
	var _style = selectbo.attr("style");
	var _class = selectbo.attr("class");

	// 기존에 option 항목이 존재하면 삭제.
	selectbo.children(".generated").remove();

	var json = {};
	json["GRP_CD"] = input;
	
	var url = "/SELECT_COMMON_CD_LIST.do";
	ajaxPost(url, json, function(rtnData){
		try {
			$.each(rtnData, function(i, v) {
				if (v.ETC_CD == undefined || v.ETC_CD == null || v.ETC_CD == "null")
					v.ETC_CD = "";
				if (v.ETC_CD == selectedValue)
					selectbo.append("<option class='generated' value='" + v.ETC_CD + "' selected>"
							+ v.ETC_CD_NM + "</option>");
				else
					selectbo.append("<option class='generated' value='" + v.ETC_CD + "'>" + v.ETC_CD_NM
							+ "</option>");
			});

			selectbo.attr("style", _style);
			selectbo.attr("class", _class);
		} 
		catch (e) {
			alertMsg("SELECT BOX 그리기 실패! [" + url + "]");
			return;
		}
	});
};

/**************************************************************
 * 은행코드 콤보박스 셋팅
 * @selectedValue : 기본선택값. 값이 있으면 option의 value가 해당 값인 항목이 기본선택.
 * @selector      : jquery객체의 셀렉터 ex)$(this) 또는 $("#ID")...
 *************************************************************/
kora.common.setBnkCmBx = function(input, selectedValue, selector) {
	var selectbo = selector;
	var _style = selectbo.attr("style");
	var _class = selectbo.attr("class");
	
	// 기존에 option 항목이 존재하면 삭제.
	selectbo.children(".generated").remove();
	
	var json = {};
	
	var url = "/SELECT_BANK_CD_LIST.do";
	ajaxPost(url, json, function(rtnData){
		try {
			$.each(rtnData, function(i, v) {
				if (v.BANK_CD == undefined || v.BANK_CD == null || v.BANK_CD == "null")
					v.BANK_CD = "";
				if (v.BANK_CD == selectedValue)
					selectbo.append("<option class='generated' value='" + v.BANK_CD + "' selected>" + v.BANK_NM + "</option>");
				else
					selectbo.append("<option class='generated' value='" + v.BANK_CD + "'>" + v.BANK_NM + "</option>");
			});
			
			selectbo.attr("style", _style);
			selectbo.attr("class", _class);
		} 
		catch (e) {
			alertMsg("SELECT BOX 그리기 실패! [" + url + "]");
			return;
		}
	});
};

/**************************************************************
 * 전화번호 국번 콤보박스 셋팅
 *************************************************************/
kora.common.setTelArrCmBx = function(selectedValue, selector) {
	kora.common.setEtcCmBx(gTelAreaNo, selectedValue, selector)
};

/**************************************************************
 * 핸드폰번호 국번 콤보박스 셋팅
 *************************************************************/
kora.common.setHpArrCmBx = function(selectedValue, selector) {
	kora.common.setEtcCmBx(gHpAreaNo, selectedValue, selector)
};

/**************************************************************
 * 메일도메인 콤보박스 셋팅
 *************************************************************/
kora.common.setMailArrCmBx = function(selectedValue, selector) {
	kora.common.setEtcCmBx(gEmailDomain, selectedValue, selector)
};

kora.common.setEtcCmBx = function(jsonData, selectedValue, selector) {
	var selectbo = selector;
	var _style = selectbo.attr("style");
	var _class = selectbo.attr("class");
	
	// 기존에 option 항목이 존재하면 삭제.
	selectbo.children(".generated").remove();
	
	var cmbTxt = new Array();
	$.each(jsonData, function(i, v) {
		if (v == selectedValue){
			cmbTxt.push("<option class='generated' value='" + v + "' selected>" + v + "</option>");
			//selectbo.append("<option class='generated' value='" + v + "' selected>" + v + "</option>");
		}else{
			cmbTxt.push("<option class='generated' value='" + v + "'>" + v + "</option>");
			//selectbo.append("<option class='generated' value='" + v + "'>" + v + "</option>");
		}
	});
	if(cmbTxt.length > 0){
		selectbo.append(cmbTxt.join("").toString());
	}
	
	selectbo.attr("style", _style);
	selectbo.attr("class", _class);

};



/**************************************************************
 * 테이블 내용 JSON 데이터 변환
 *************************************************************/
kora.common.tableToJson = function(tblId){
	var resJson = {};
	var tr = $("#"+tblId+" tbody tr");
	var td = tr.find("td");
	var input = tr.find(":input");
	
	$.each(input, function(i, v){
		/*
		var $input = $(this).find(":input");
		
		if( $input ){
			//checkbox, radio
			if($input.attr("type") == "checkbox" || $input.attr("type") == "radio"){
				resJson[$input.attr("name")] = $input.val();
			}
			else{
				resJson[$input.attr("id")] = $input.val();
			}
		}
		*/
		//checkbox, radio
		if($(this).attr("type") == "checkbox" || $(this).attr("type") == "radio"){
			resJson[$(this).attr("name")] = $(this).val();
		}
		else{
			resJson[$(this).attr("id")] = $(this).val();
		}
	});
	
	return resJson;
};

/**************************************************************
 * JSON 데이터를 테이블에 반영
 *************************************************************/
kora.common.jsonToTable = function(tblId, jData){
	$.each(jData, function(i, v) {
		if($("#"+tblId).find("#"+i).attr("type") == "checkbox"){
			//$("#"+tblId).find("input:checkbox[id='"+i+"']").attr("checked", true);
			var name = i;
			$.each(v, function(i, v) { 
				$("#"+tblId).find("input:checkbox[name='"+name+"'][value="+v+"] ").attr("checked", true);
			});
		}
		else if($("#"+tblId).find("#"+i).attr("type") == "radio"){
			$("#"+tblId).find("input:checkbox[id='"+i+"']").attr("checked", true);
		}
		else{
			$("#"+tblId).find("#"+i).val(kora.common.null2void(v));
		}
	});
};

/**************************************************************
 * 생산자별 직매장/공장 콤보박스 셋팅
 *************************************************************/
kora.common.setDtssCmb = function(input, selector) {
	var selectbo = selector;
	var _style = selectbo.attr("style");
	var _class = selectbo.attr("class");
	
	// 기존에 option 항목이 존재하면 삭제.
	selectbo.find("option").remove()

	var bAllOpt = true;		//전체 옵션 생성여부
	var bSelOpt = true;		//조회 여부
	var vSelectedVal = "";	//default value
	
	//센터
	if(gfn_getCookie("MBR_SE_CD") == "A"){
		//생산자 전체 선택 시 직매장 조회하지 않음.
		if(kora.common.null2void(input.MFC_BIZRNO) == ""){
			bSelOpt = false;
		}
	}
	//생산자
	if(gfn_getCookie("MBR_SE_CD") == "B"){
		//생산자 본사 아닌 경우 전제 제거
		if(gfn_getCookie("CG_DTSS_NO") != "9999999999"){
			bAllOpt = false;
			vSelectedVal = gfn_getCookie("CG_DTSS_NO");
		}
	}
	//도매업자
	else{
		//생산자 전체 선택 시 직매장 조회하지 않음.
		if(kora.common.null2void(input.MFC_BIZRNO) == ""){
			bSelOpt = false;
		}
	}
	
	if(bAllOpt)	selectbo.append('<option value="" '+(vSelectedVal==""?"selected":"")+'>전체</option>');
	
	if(!bSelOpt) return;
	
	ajaxPost("/EPMM/EPMMALDP_DTSS_SELECT.do", input, function(rtnData){
		kora.common.setEtcCmBx2(rtnData.dtssNoList ,"", "", selector, "KEY", "DAT", "N");
	}, false);
};

/**************************************************************
 * 생산자별 도매업자 콤보박스 셋팅
 * input - MFC_BIZRNO(생산자사업자번호), DTSS_NO(직매장번호)
 *************************************************************/
kora.common.setWhsldBizCmb = function(input, selector, select2Yn) {
	if(gfn_getCookie("MBR_SE_CD") == "A"  || gfn_getCookie("MBR_SE_CD") == "B"){
		if(select2Yn == "Y")
			selector.select2("val","");
		else
			selector.val("");
		
		ajaxPost("/EPMM/EPMMALDP_WHSLD_BIZRNO_SELECT.do", input, function(rtnData){
			kora.common.setEtcCmBx2(rtnData.whsldBizrnoList ,"", "", selector, "KEY", "DAT", "N");
		}, false);
	}
};


/**************************************************************
 * 데이터 콤보박스 셋팅
 * data : json data
 * dynVal : 데이터중 표시할 항목 설정(예: IN => 1|2|3 , NOT IN =>!1|2|3) 
 * selectedValue : 기본값
 * selector : 콤보박스 그려질 항목 객체
 * code, value : 콤보박스 key, data
 * disYn : 비활성화 여부 (Y or N)
 * add : 최상단 선택 or 전체 추가 (S or T)
 *************************************************************/
kora.common.setEtcCmBx2 = function(data, dynVal, selectedValue, selector, code, value, disYn, add) {
	var selectbo = selector;
	var _style = selectbo.attr("style");
	var _class = selectbo.attr("class");
	
	// 기존에 option 항목이 존재하면 삭제.
	//selectbo.children(".generated").remove();
	selectbo.children().remove();

	var bDivYn = true;
	if(dynVal.substring(0,1) == "!"){
		bDivYn = false;
		dynVal = dynVal.substring(1);
	}
	
	var arrDyn = dynVal.split("|");
	
	try {
		
			if(add == 'S'){
				selectbo.append("<option value=''>"+parent.fn_text('cho')+"</option>");
			}else if(add == 'T'){
					selectbo.append("<option value=''>"+parent.fn_text('whl')+"</option>");
			}
		
	/*	if(data.length !=1){
			console.log(code+" :  "+data.length)
			if(add == 'S'){
				selectbo.append("<option value=''>"+parent.fn_text('cho')+"</option>");
			}else if(add == 'T'){
				selectbo.append("<option value=''>"+parent.fn_text('whl')+"</option>");
			}
		}*/
		
		var cmbTxt = new Array();
		
		$.each(data, function(i, v) {
		
			var $code  = eval("v."+code); 
			var $value = eval("v."+value);
			
			if(arrDyn.length > 1){
				var nMatch = 0;
				for(var j=0; j<arrDyn.length; j++){
					if(bDivYn){
						if(arrDyn[j] == $code){
							nMatch++;
						}
					}
					else{
						if(arrDyn[j] == $code){
							nMatch = 0;
							break;
						}
						else{
							nMatch++;
						}
					}
				}
				
				if(nMatch == 0) return true;
			}
			
			if ($code == undefined || $code == null || $code == "null") return true;

			if ($code == selectedValue){
				cmbTxt.push("<option class='generated' value='" + $code + "' selected>" + kora.common.null2void($value) + "</option>")
				//selectbo.append("<option class='generated' value='" + $code + "' selected>" + kora.common.null2void($value) + "</option>");
			}else{
				cmbTxt.push("<option class='generated' value='" + $code + "'>" + kora.common.null2void($value) + "</option>");
				//selectbo.append("<option class='generated' value='" + $code + "'>" + kora.common.null2void($value) + "</option>");
			}
		});
		
		if(cmbTxt.length > 0){
			selectbo.append(cmbTxt.join("").toString());
		}
		
		if(disYn == "Y") selectbo.attr("disabled","true");

		selectbo.attr("style", _style);
		selectbo.attr("class", _class);
	} 
	catch (e) {
		alertMsg("SELECT BOX 그리기 실패! [" + url + "]");
		return;
	}
};



/***************************************업무 함수 는 여기에 적음   시작************************************************************************************


/**
 * 문의하기 보임 및 문의메일 숨김
 */
kora.common.gfn_callView = function(){
	$("#callImg").css("display", "block");	//문의하기 버튼 보임
	$("#callMail").css("display", "none");	//문의메일 숨김
}

//이용약관 약관동의 팝업
function gfn_agrPop(num){   //EPMN :EP87
	var tmpUrl = "/EP87/EPMNCNBM" + num + ".do";
	window.open(tmpUrl, "agrPop", "width=800, height=580, menubar=no,status=no,toolbar=no, scrollbars=yes");
}

//문의하기 팝업
function gfn_notiPop(){
	var tmpUrl = "/EP87/EPMNCNPF1_POP.do";
	window.open(tmpUrl, "notiPop","width=825, height=620, menubar=no,status=no,toolbar=no, scrollbars=1");
}



/***************************************업무 함수 는 여기에 적음   끝*******************************************************************************************************



/***************************************사용안함*******************************************************************************************************


/***************************************사용안함****************************
 * 아이프레임 리사이즈  ==> 쓰는 데가 없음
 * @param id
 */
function gfn_resizeIframe(id){
	$('#'+id).load(function() {
		$(this).height($(this).contents().find('body')[0].scrollHeight+30);
	});
	/*
	var obj = document.getElementById("id");
	if(obj.contentWindow){
		obj.style.height = obj.contentWindow.document.body.scrollHeight + "px";
    } else {
    	obj.style.height = obj.contentDocument.body.offsetHeight + 40 + "px";
    }
    */
} 


//권한 없음 메세지
function gfn_noAuthMsg(){
	alertMsg("선택 메뉴에 대한 권한이 존재하지 않습니다.");
	return;
}


//콜센터 안내 메세지
function gfn_callInfoMsg(){
	alertMsg("지급관리시스템 통합문의 콜센터 1522-0082 \n운영시간 : 평일(월~금) 9시~21시 \n토,일요일과 공휴일은 운영하지 않습니다.");
}


/*******************************************************************
 * 사업자등록번호 유효성 검사
 ******************************************************************/
function fnBizCheck(rrn){ 
    var sum = 0;
    
    if(rrn != ""){
        var getlist  = new Array(10);
        var chkvalue = new Array("1","3","7","1","3","7","1","3","5");
        
        for(var i=0; i<10; i++) { 
        	getlist[i] = rrn.substring(i, i+1); 
        }
        
        for(var i=0; i<9; i++) { 
        	sum += getlist[i]*chkvalue[i]; 
        }
        
        sum = sum + parseInt((getlist[8]*5)/10);
        sidliy = sum % 10;
        sidchk = 0;
        
        if(sidliy != 0) { 
        	sidchk = 10 - sidliy; 
        }
        else { 
        	sidchk = 0; 
        }
        
        if(sidchk != getlist[9]) { 
        	return false; 
        }
        
        return true;
    }
    
    return true;
} 


/**
 * 도움말
 */
function gfn_help(){
	/*
	var tmpStr = "EPCMCRDP,EPCMRCDP,EPCMRUDP,EPCMSLDP,EPCMVCDP,EPDMDLDP,EPDMELDP,EPDMRDDP,";
	tmpStr = tmpStr + "EPDMREDP,EPDMRLDP,EPDMRVDP,EPDMRYDP,EPGMIBDP,EPGMIHDP,EPGMILDP,EPGMMRDP,EPGMPLDP,";
	tmpStr = tmpStr + "EPGMRPDP,EPGMULDP,EPMBAADP,EPMBFQDP,EPMBNLDP,EPMMALDP,EPMMBLDP,EPMMCLDP,";
	tmpStr = tmpStr + "EPMMMLVM,EPMMOMDP,EPMMTMDP,EPVSBSDP,EPVSDCDP,EPVSESDP,EPVSLDDP,EPVSLSDP,";
	tmpStr = tmpStr + "EPVSSSDP,EPVSTDDP,EPVSTSDP,EPVSYSDP";
	var tmpArr = tmpStr.split(",");
	if($.inArray(gHelpUrl, tmpArr) < 0){
		alertMsg("도움말 서비스를 지원하지 않는 메뉴입니다.");
		return;
	}
	*/   //EPMP  :EP55   EPMN:EP87   EPMO:EP72
	if(gHelpUrl.indexOf("EPCE55") > -1 || gHelpUrl.indexOf("EPCE87") > -1 || gHelpUrl.indexOf("EPCE72") > -1
			|| gHelpUrl.indexOf("EPCE3949301") > -1){
		alertMsg("도움말 서비스를 지원하지 않는 메뉴입니다.");
		return;
	}
	
	var url = "/POP_HELP.do?HELP_URL=" + gHelpUrl;
	window.open(url, "help", "width=890, height=580, menubar=no,status=no,toolbar=no, scrollbars=yes");
}

//마우스 우클릭 방지
function gfn_click() {
	if((event.button==2) || (event.button==3)) {
	  alertMsg("오른쪽 버튼은 사용하실 수 없습니다");
	  return false;
	}
}


/*******************************************************************
 * 주민(외국인)등록번호 유효성 검사
 ******************************************************************/
function fnRRNCheck(rrn){
    if (fnrrnCheck(rrn) || fnfgnCheck(rrn) || fnBizCheck(rrn)) {
        return true;
    }
    
    return false;
}

/*******************************************************************
 * 주민등록번호 유효성 검사
 ******************************************************************/
function fnrrnCheck(rrn){
    var sum = 0;
    
    if(rrn != ""){
        if (rrn.length != 13) {
            return false;
        }
        else if (rrn.substr(6, 1) != 1 && rrn.substr(6, 1) != 2 && rrn.substr(6, 1) != 3 && rrn.substr(6, 1) != 4) {
            return false;
        }
        for (var i = 0; i < 12; i++) {
            sum += Number(rrn.substr(i, 1)) * ((i % 8) + 2);
        }
        if (((11 - (sum % 11)) % 10) == Number(rrn.substr(12, 1))) {
            return true;
        }
        return false;
    }
    
    return true;
}


/**
 * enter key 이벤트
 * @param func
 */
function gfn_enter(func){
	if (event.keyCode != 13) return;
	eval(func+'()');
}

//특수키 사용금지
function gfn_keypressed() {
	var key=event.keyCode;
	//if(key==16) { alertMsg('Shift키는 사용 불가능합니다.'); return false; }
	if(key==17) { alertMsg('Ctrl키는 사용 불가능합니다.'); return false; }
	if(key==18) { alertMsg('Alt키는 사용 불가능합니다.'); return false; }
	if(key==93) { alertMsg('메뉴키는 사용 불가능합니다.'); return false; }
	if(key==41) { alertMsg('메뉴키는 사용 불가능합니다.'); return false; }
}


//agent 호출용
function requestObj(url,obj){
	//obj:{}
	var vArr = new Array();
	vArr.push("");
	for (var key in obj){
		if (typeof obj[key] == "string"){
			var v1 = obj[key].replace(/\%/gi,"%25");
			v1 = v1.replace(/\+/gi,"%2B");
			vArr.push(key + "=" + v1 + "&");
		}
		else if(typeof obj[key] == "object"){
			if (obj[key].length==undefined || obj[key].length==null) continue;
			for(var i=0;i<obj[key].length;i++){
				var v1 = obj[key][i].replace(/\%/gi,"%25");
				v1 = v1.replace(/\+/gi,"%2B");
				vArr.push(key + "=" + v1 + "&");
			}
		}
	}
	//serializeArray
	$.each(obj, function(i, key){
		vArr.push(key.name + "=" + key.value + "&");
	});
	var result = httpRequest("POST",url,vArr.join(""),false);
	if (result==null) result = {};
	return result;
}


function httpRequest(reqType, url, data, asynch){
	var request=null;    // URL 요청에 대한 응답을 받아올 객체
	var result=null;
	try{
		if(window.XMLHttpRequest){
			request = new XMLHttpRequest();
		}
		else if(window.ActiveXObject){
			request = new ActiveXObject("MSXML2.XMLHTTP");  // IE 6 이만
			if(!request)
				request = new ActiveXObject("Microsoft.XMLHTTP");  // IE 6 이상
		}
		if(request!=null){
			request.onreadystatechange = function(e){
				if(request.readyState == 4){
					if(request.status == 200){
//						result = jsonObject(request.responseText);
					}
				}
			};  // CallBack 함수 지정  

			if(reqType.toLowerCase() == "post"){
				request.open(reqType, url, asynch);
				//request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charaset=UTF-8");
				request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
				request.send(encodeURI(data));
			}
			else{
				request.open(reqType, url, asynch);
				request.send(null);
			}
			//alertMsg(request.responseText);
			result = jsonObject(request.responseText);
		}
		else{
			alertMsg("XMLHttpRequest not found.");
		}
	}
	catch(Exception){
		alertMsg(Exception);
	}
	return result;
}


/*******************************************************
 * 날짜조회기간 (1주일,15일,1개월,3개월...)
 ******************************************************/
kora.common.setCalendarBetween = function(startId, endId, betweenDv, num){
	if(isNaN(new Number(num)))	return false;
	
	var $start = $("#"+startId);
	var $end = $("#"+endId);
	var _endDate = $end.val().replace(/-/g, "");
	
	//당일이 아닌경우 조회종료일자 조건에 선택되어있는 값을 기준으로 조회시작일자 날짜를 계산한다.
	if( betweenDv!="d" || num>0 ){
		$start.val(kora.common.getDate("yyyy-mm-dd", betweenDv, num, _endDate));
	}else if(betweenDv=="d" || num>0 ){
		$start.val(kora.common.getDate("yyyy-mm-dd", betweenDv, num, _endDate));
	}
	//당일일경우 현재날짜로.
	else{
		$start.val(kora.common.getDate("yyyy-mm-dd"));
		$end.val(kora.common.getDate("yyyy-mm-dd"));
	}
};



/*******************************************************************
 * 주민등록번호 FORMAT
 ******************************************************************/
kora.common.formatSsn = function(value){
	var tmpSSN = "";
	if(kora.common.null2void (value) != ""){
		tmpSSN = value.replace(/\-/g,"");
		
		if(value.length == 13){
			tmpSSN = tmpSSN.substring(0,6)+"-"+tmpSSN.substring(6,7)+"******";    
		}
		else{
			tmpSSN = tmpSSN;
		}
	}
	
	return tmpSSN;
};

/**************************************************************
 * 새창 여는 함수
 *************************************************************/
kora.common.uf_frmNewWin = function(userFrm, url, winName, sizeW, sizeH) {
    var nLeft  = screen.width/2 - sizeW/2 ;
    var nTop  = screen.height/2 - sizeH/2 ;
    var winObj;

    opt = ",toolbar=no,menubar=no,location=no,scrollbars=no,status=no, resizable = no";
    
    winObj = window.open("", winName, "left=" + nLeft+ ",top=" + nTop + ",width=" + sizeW + ",height=" + sizeH  + opt );

    if (winObj == null) {
        alertMsg("팝업차단 기능을 해지하십시오.\n\n[ 도구->인터넷옵션->개인 정보->팝업차단] 체크해지");
        return;
    }

    userFrm.target = winName;
    userFrm.action = url;
    userFrm.submit();
};

/***************************************
* Html로 구성된 리스트 객체안의 필수값 체크
* - tblId          
***************************************/
kora.common.cfrmHtmlListChkValid = function(tblId){
	var rtnChk = true;

	var mstrTbl1 = $("#"+tblId+" tbody tr");

    for(var idx = 1;idx < mstrTbl1.size();idx++){
        var tbody  = $("#" + tblId + " tbody").find("tr:eq("+idx+")");

        tbody.find(".list_notnull").each(function(){
    		if($(this).css("display") != "none"){
    			if($(this).val() == null || $(this).val() == ""){
    				
    				if ( kora.common.null2void($(this).attr("fieldName")) != "") {
    					alertMsg($(this).attr("fieldName")+" 을(를) 확인하세요.");
    				}
    				else {
    					alertMsg($(this).parents("td").prev().text()+" 을(를) 확인하세요.");
    				}
    				
    				$(this).focus();
    				rtnChk = false;
    				return false;
    			}
    		}
    	});
        if ( !rtnChk ) break;
    }
	
	return rtnChk;
};

/*******************************************************************
 * number type input box key press event
 ******************************************************************/
fn_keyPressNumberType = function(obj){
	//숫자가 아닌 입력값 입력 불가
	if ((event.keyCode> 47) && (event.keyCode < 58)){
		event.returnValue=true;
	} 
	else 
	{ 
		event.returnValue=false;
	}

	$(obj).attr("style", "ime-mode:disabled;"+$(obj).attr("style"));
};


/**
 * 그리드 엑셀 다운로드 - column이나 column헤드 텍스트 없을시 스킵.
 * @param fileNm	- 엑셀다운로드 파일명
 * @param column	- 그리드에서 엑셀로 저장할 컬럼을 ',' 로구분한 문자열, 공백사용하지말것 예제-"MENU_GRP_CD,MENU_GRP_NM";
 * 					- null, ''이면 전체컬럼,
 * 					- 컬럼 또는 헤드 텍스트가 없는것을 지정하면 오류 발생 
 * @param gridRoot - 그리드 루트(데이터와 그리드를 포함하는 객체)
 */
function gfn_excelDown(fileNm, column, gridRoot, dataGrid){
	
	var flag = true;
	var colId;
	var colTxt;
	if(column != null && column != ""){
		colId = column.split(",");
		colTxt = new Array(colId.length);
		flag = false;
	}else{
		colId = new Array();
		colTxt = new Array();
	}
	
	
	var columns = dataGrid.getColumns();
	for(var i=0; i<columns.length; i++){
		 var columnObj = columns[i];   //그리드의 Header 정보 가져오기
		 if(columnObj.getDataField() == null || columnObj.getDataField() == undefined
			 || columnObj.getHeaderText() == null || columnObj.getHeaderText() == undefined) continue;
		 var col = columnObj.getDataField();
		 var colNm = columnObj.getHeaderText();
		 
		 if(flag){
			 colId.push(col);
			 colTxt.push(colNm);
		 }else{
			 var idx = $.inArray(col, colId);
			 if(idx >= 0){
				 colTxt[idx] = columnObj.getHeaderText();
			 }
		 }
	}
	
	if(document.getElementById("frmExcelDown") == null){
		var txt = new Array();
		txt.push('<form name="frmExcelDown" id="frmExcelDown" method="post" action="/EXCEL_DOWN.do">');
		txt.push('<input type="hidden" name="EXCEL_NAME" />');
		txt.push('<input type="hidden" name="COLUMN" />');
		txt.push('<input type="hidden" name="TITLE" />');
		txt.push('<input type="hidden" name="list" />');
		txt.push('</form>');
		$(document.body).append(txt.join("").toString());
	}
	frmExcelDown.target = "_new";
	frmExcelDown.list.value = JSON.stringify(gridRoot.getCollection().getSource());
	frmExcelDown.COLUMN.value = colId.join(",").toString();
	frmExcelDown.TITLE.value = colTxt.join(",").toString();
	frmExcelDown.EXCEL_NAME.value = fileNm;
	frmExcelDown.submit();
}



/**
 * 전각을 반각으로 변환
 * @param str
 * @returns {String}
 */
function gfn_Convert2ByteChar(str) {
	var rtnVal = new String;
    var len = str.length;
    for (var i = 0; i < len; i++) {
    	var c = str.charCodeAt(i);
    	if (c >= 65281 && c <= 65374 && c != 65340) {
    		rtnVal += String.fromCharCode(c - 65248);
    	} else if (c == 8217) {
    		rtnVal += String.fromCharCode(39);
    	} else if (c == 8221) {
    		rtnVal += String.fromCharCode(34);
    	} else if (c == 12288) {
    		rtnVal += String.fromCharCode(32);
    	} else if (c == 65507) {
    		rtnVal += String.fromCharCode(126);
    	} else if (c == 65509) {
    		rtnVal += String.fromCharCode(92);
    	} else {
    		rtnVal += str.charAt(i);
    	}
    }
    return rtnVal;
}


var loadingBarCk = true;
/**
 * 그리드 loading bar on
 */
kora.common.showLoadingBar = function (dataGrid, gridRoot) {
	var $dataGrid = dataGrid;
	var $gridRoot = gridRoot;
	
	if($dataGrid != null && $dataGrid != "undefined"){
		
		if(loadingBarCk){
			$dataGrid.setEnabled(false);
			$gridRoot.addLoadingBar();
			loadingBarCk = false;
		}
	
	}	
}

/**
 * 그리드 loading bar off
 */
kora.common.hideLoadingBar = function (dataGrid, gridRoot) {
	var $dataGrid = dataGrid;
	var $gridRoot = gridRoot;

	if($dataGrid != null && $dataGrid != "undefined"){
		$dataGrid.setEnabled(true);
		$gridRoot.removeLoadingBar();
		loadingBarCk = true;
	}
}

//그리드 컬럼 저장
kora.common.saveLayout = function (val) {
	/* ---------------드레그 컬럼 저장---------------------------------------------------------- */
		if(val ==undefined) val="";
		url ="/GRID_INFO.do"
		dataGrid = eval('gridRoot'+val).getDataGrid();
		columns = dataGrid.getGroupedColumns();
		
		var colArray = [];
		for (var i = 0 ; i < columns.length ; i++ ){
			var colInfo = {};
			// 그룹일 경우
			if ( columns[i].children ) {
				colInfo["headerText"] = columns[i].getHeaderText() ? columns[i].getHeaderText() : columns[i].getDataField();
				var gCol = [];
				for ( var j = 0 ; j < columns[i].children.length ; j++ ) {
					colInfoC = {};
					colInfoC["headerText"] = columns[i].children[j].getHeaderText() ? columns[i].children[j].getHeaderText() : columns[i].children[j].getDataField();
					gCol.push(colInfoC);
				}
				colInfo["children"] = gCol;
				colArray.push(colInfo);
			} else {
				colInfo["headerText"] = columns[i].getHeaderText() ? columns[i].getHeaderText() : columns[i].getDataField();
				colArray.push(colInfo);
			}
		}
		// JSON 문자열 형태로 파싱하여 저장합니다.
		var columnStr = JSON.stringify(colArray);
		//localStorage.setItem("rMateGrid", columnStr);
		var input ={};
		input["PRAM"]  		= columnStr
		input['MENU_CD'] 	= 	gUrl;
		input['GRID_ID'] 		= "dataGrid"+val;
		
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else if( rtnData.RSLT_CD == '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}
		}); 

		/* ------------------------------------------------------------------------- */
}

//---------------------start of autoComplete----------------------------------------------------------------------------------------------

kora.common.autoComplete = function () {
	//autoComplete 생산자
  	$('#data-ax5autocomplete_M').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     mfc_bizrnmList.forEach(function (n) {				//리스트정보
                         if (n.BIZRNM.match(regExp)) {		//비교 대상 설정
                             myOptions.push({
                                 value: n.BIZRID_NO,			//SELECTBOX value
                                 text: n.BIZRNM					//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                 }, 150);
             }
      });
  	
    //autoComplete 생산자   ,직매장/공장
  	$('#data-ax5autocomplete_M_BRCH').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     mfc_bizrnmList.forEach(function (n) {				//리스트정보
                         if (n.BIZRNM.match(regExp)) {		//비교 대상 설정
                             myOptions.push({
                                 value: n.BIZRID_NO,			//SELECTBOX value
                                 text: n.BIZRNM					//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                 }, 150);
             }
      });
  	
		
	//autoComplete 빈용기명
  	$('#data-ax5autocomplete_C').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     ctnrNmList.forEach(function (n) {				//리스트정보
                         if (n.CTNR_NM.match(regExp)) {		//비교 대상 설정
                             myOptions.push({
                                 value: n.CTNR_CD,					//SELECTBOX value
                                 text: n.CTNR_NM					//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                 }, 150);
             }
      });
		
  	//autoComplete 도매업자
  	$('#data-ax5autocomplete_W').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     whsdlList.forEach(function (n) {				//리스트정보
                         if (n.CUST_BIZRNM.match(regExp)) {		//비교 대상 설정
                             myOptions.push({
                                 value: n.CUST_BIZRID_NO,			//SELECTBOX value
                                 text: n.CUST_BIZRNM					//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                 }, 150);
             }
      });

	//autoComplete 지역
  	$('#data-ax5autocomplete_A').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     areaList.forEach(function (n) {				//리스트정보
                         if (n.ETC_CD_NM.match(regExp)) {		//비교 대상 설정
                             myOptions.push({
                                 value: n.ETC_CD,						//SELECTBOX value
                                 text: n.ETC_CD_NM					//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                 }, 150);
             }
      });
  	
}

//autoComplete 도매업자 멀티 SELECTBOX
kora.common.fn_autoCompleteSelected = function (data,target_id){
		 if(target_id =="data-ax5autocomplete_M" ){//생산자
			 acSelected_M = new Array();
			 if(data.length>0){
		   		 for(var i =0;i<data.length ;i++){
		   			var input={};
		   			var arrM =new Array();
		   			arrM		=data[i].value.split(";");
		   			input["MFC_BIZRNO"]		=arrM[1];
	   				input["MFC_BIZRID_NO"]  	=data[i].value;
	   				input["MFC_BIZRNM"] 		=data[i].text;
				    acSelected_M.push(input);
		   		 }
		   		kora.common.fn_mfc_bizrnm();
			 }
		 }else  if(target_id =="data-ax5autocomplete_M_BRCH" ){//생산자 , 직매장/공장
			 acSelected_M = new Array();
			 if(data.length>0){
		   		 for(var i =0;i<data.length ;i++){
		   			var input={};
		   			var arrM =new Array();
		   			arrM		=data[i].value.split(";");
		   			input["MFC_BIZRID"]			=arrM[0];
		   			input["MFC_BIZRNO"]		=arrM[1];
	   				input["MFC_BIZRID_NO"]  	=data[i].value;
	   				input["MFC_BIZRNM"] 		=data[i].text;
				    acSelected_M.push(input);  
		   		 }
		   		kora.common.fn_mfc_bizrnm();
			 }//end of  if(data.length>0)
			 fn_mfc_brch(); //직매장/공장
		 }else  if(target_id =="data-ax5autocomplete_C" ){//용기코드
			 acSelected_C = new Array();
			 if(data.length>0){
		   		 for(var i =0;i<data.length ;i++){
		   			var input={};
				    input["CTNR_CD"]			=data[i].value
					input["CTNR_NM"] 		=data[i].text;
				    acSelected_C.push(input);
		   		 }
			 }
		 }else  if(target_id =="data-ax5autocomplete_W" ){//도매업자
		   	 acSelected_W = new Array();
			 if(data.length>0){
		   		 for(var i =0;i<data.length ;i++){
  					var input={};
	   				input["WHSDL_BIZRID_NO"]  	=data[i].value
					input["WHSDL_BIZRNM"] 		=data[i].text;
				    acSelected_W.push(input);
		   		 }
			 }
		 }else  if(target_id =="data-ax5autocomplete_A" ){//지역
		   	 acSelected_A = new Array();
			 if(data.length>0){
		   		 for(var i =0;i<data.length ;i++){
	   				var input={};
				    input["AREA_CD"]			=data[i].value
					input["AREA_NM"] 		=data[i].text;
				    acSelected_A.push(input);
		   		 }
			 }
		 }//end of else if
		 window.frameElement.style.height = $('.iframe_inner').height()+'px'; //height 조정
		  
}    
	
	//생산자 변경시 빈용기명 조회
	kora.common.fn_mfc_bizrnm = function (){	 
		var ctnrArr = new Array();
		if( typeof(ctnrNmList_C) == 'undefined' )
		{
			return;
		}
	   	if( acSelected_M.length !=0){ 	//생산자 선택시   
	   	    	for(var i =0 ;i <ctnrNmList_C.length;i++){	//용기리스트
	   	    		for(var k=0; k<acSelected_M.length; k++){//생산자리스트 
	   	    			 if( $("#PRPS_CD").val() !="" &&  $("#PRPS_CD").val() !=undefined ){//용도명 선택시 	빈용기용도랑 생산자사업자번호랑 같을경우
	   	    				 	if(  (ctnrNmList_C[i].PRPS_CD ==$("#PRPS_CD").val() && ctnrNmList_C[i].MFC == acSelected_M[k].MFC_BIZRNO)
	   	    				 		|| (ctnrNmList_C[i].PRPS_CD ==$("#PRPS_CD").val() && ctnrNmList_C[i].MFC == '0000000000')  ){
			        		    		ctnrArr.push(ctnrNmList_C[i]);
			    	    			 	break;
	   	    				 	}
	       		    	 }else{//용도명 전체
		        		    		 if(ctnrNmList_C[i].MFC == acSelected_M[k].MFC_BIZRNO ||  ctnrNmList_C[i].MFC == '0000000000' ){
			        		    		ctnrArr.push(ctnrNmList_C[i]);
			    	    			 	break;
		 	    				 	}
		    		     }//end of if
	   	    		}//end of for(var k=0; k<acSelected_M.length; k++)
	   	    	}//end of for(var i =0 ;i <ctnrNmList_C.length;i++)
	   	    	ctnrNmList = ctnrArr;
	   	}else{	//생산자 전체시
	       		if( $("#PRPS_CD").val() !=""){//용도 선택시 용도에 맞는 용기코드
	       	    	for(var i =0 ;i <ctnrNmList_C.length;i++){ 
	       		    	 if( ctnrNmList_C[i].PRPS_CD ==  $("#PRPS_CD").val()){
	       		    		 ctnrArr.push(ctnrNmList_C[i]);
	       		    	 }
	       	    	}
	       	    	ctnrNmList = ctnrArr;
	           	}else{//용도 전체시 모든 용기코드
	           		ctnrNmList =ctnrNmList_C;
	           	}
	   	}//end of else
	}

	//도매업자 조회
	kora.common.fn_whsl_se_cd = function (){	 
		var whslArr = new Array();
		if( $("#BIZR_TP_CD").val() !=""){//도매업자구분 
		   	for(var i =0 ;i <whsdlList_C.length;i++){
			    	 if( whsdlList_C[i].BIZR_TP_CD ==  $("#BIZR_TP_CD").val()){
			    		 whslArr.push(whsdlList_C[i]);
			    	 }
		   	}
			whsdlList = whslArr;
		}else{
			whsdlList =whsdlList_C;
		}
		
	}
	
	// os 확인 
	kora.common.getUserAgent = function (){
		
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.search("android") > -1){
			return "android";
		} else if ((userAgent.search("iphone") > -1) || (userAgent.search("ipod") > -1)
					|| (userAgent.search("ipad") > -1)){
			return "ios";
		}else{
			return "";
		}
	}
/*	
	//웹액션 호출 
	kora.common.iWebAction = function (actionCode, actionData){
		
		var userAgent = kora.common.getUserAgent();
		var action = {
			_action_code : actionCode
		};
		
		if (actionData != null || actionData != undefined) {
			action._action_data = actionData; 
		}
			   
		if ( userAgent == "ios") {
			alert("iWebAction:" + JSON.stringify(action));
		}else if ( userAgent == 'android'){
			window.BrowserBridge.iWebAction(JSON.stringify(action));
		}
	}
*/	
//---------------------end of autoComplete----------------------------------------------------------------------------------------------

