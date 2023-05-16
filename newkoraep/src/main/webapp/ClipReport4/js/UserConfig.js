/**
 * 리포트 결과에 따른 event의 값으로 함수를 호출합니다. <br>
 * 
 * @example 사용자는 아래에 기본 설정된 함수가 아닌 다른 기능으로 대체하여 사용하실 수 있습니다.
 *  case 8:ReportWebLog("리포트 서버가 정상적으로 설치되지 않았습니다.!!"); break;
 *  //위에 코드 대신
 *  case 8:alert("관리자에게 문의 하세요"); break;
 * 
 * @method UserConfig
 * @param event {Integer} 값
 * @since version 1.0.0.9
 */
function ReportEventHandler(event){
	switch(event){
		case 0: 
		case 1:
		case 2:
		case 3:
		case 4:
		case 5: 
		case 6: 
		case 7: 
		case 8:ReportWebLog("Report Server is not installed properly.!!"); break;
		case 10: ReportWebLog("It is during the generation of reports.!!"); break;
		case 20: ReportWebLog("Target and become TAG (div or body) is NULL.!!"); break;
		case 30: ReportWebLog("There is a problem with the creation of the report.!!");break;
		case 40: ReportWebLog("It failed to connect to the report server.!!");break;
		case 50: ReportWebLog("Failed to delete the report.!!");break;
		case 60: ReportWebLog("Section of the report server has ended.!!");break;
		case 70: ReportWebLog("There was a problem OOF document.!!");break;
		case 100: ReportWebLog("not found pdf reader ."); break;
		case 101: ReportWebLog("not found hwp viewer."); break;
		case 102: ReportWebLog("There was a problem to html Print."); break;
		case 150: ReportWebLog("pdf reader version is low.."); break;
		case 200: ReportWebLog("The report was completed successfully.");break;
		case 1000:
		case 1001:
		case 1002:
		case 1003: ReportWebLog("In connection with the license problem occurred.");break;
	}
}

/**
 * console이 존재할 경우 메시지를 console에 출력합니다.<br>
 * console이 없는 브라우져는 alert 창으로 메시지를 출력합니다.
 * 
 * @method UserConfig
 * @param message {String} 값
 * @since version 1.0.0.9
 */
function ReportWebLog(message){
	if(window.console){
		window.console.log(message);
	}
	else{
		alert(message);
	}
}

/**
 * 뷰어가 호출 하기 전 기본 뷰어의 디자인을 표현할 수 있도록 제공하는 함수입니다.
 * 
 * @method UserConfig
 * @param targetId {String} 리포트를 표현할 Tag의 id
 * @since version 1.0.0.17
 */
function ReportViewForm(targetId){
	var targetDom = document.getElementById(targetId);
	if(null != targetDom){
		targetDom.innerHTML = "<div style=\"position:absolute;left:0px;right:0px;top:0px;bottom:0px;border:0px solid;overflow:hidden;\"><div id=\"re_menud94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_div\" style=\"display:;\"><table class=\"report_menu_table\" vertical-align=\"middle\"><tbody><tr><td class=\"report_menu_table_td\"><div class=\"report_menu_table_td_div\"><nobr><button title=\"저장\" id=\"re_saved94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_save_button report_menu_save_button_svg\" style=\"\"></button><button title=\"pdf 저장\" id=\"re_pdfd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_pdf_button report_menu_pdf_button_svg\" style=\"\"></button><button title=\"엑셀 저장\" id=\"re_exceld94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_excel_button report_menu_excel_button_svg\" style=\"\"></button><button title=\"한글 저장\" id=\"re_hwpd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_hwp_button report_menu_hwp_button_svg\" style=\"\"></button><button title=\"프린트\" id=\"re_printd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_print_button report_menu_print_button_svg\"></button><button title=\"첫 페이지\" id=\"re_firstd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_leftEnd_button report_menu_leftEnd_button_svg\" style=\"\"></button><button title=\"이전 페이지\" id=\"re_prevd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_left_button report_menu_left_button_svg\" style=\"\"></button><input title=\"페이지\" id=\"re_inputd94a5a8a3b4f4f58bc851c1a9d171cb6\" type=\"text\" value=\"1\" class=\"report_menu_pageCount_input\"><input title=\"전체 페이지\" id=\"re_totalCountNumberd94a5a8a3b4f4f58bc851c1a9d171cb6\" value=\"/&nbsp;0\" class=\"report_menu_pageCount_span\" style=\"\" readonly=\"\"><span id=\"re_totalCountd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_pageCount_span\" style=\"border:0px;\"></span><button title=\"다음 페이지\" id=\"re_nextd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_right_button report_menu_right_button_svg\" style=\"\"></button><button title=\"마지막 페이지\" id=\"re_lastd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_rightEnd_button report_menu_rightEnd_button_svg\" style=\"\"></button><select title=\"화면 비율 선택\" onchange=\"m_reportHashMap['d94a5a8a3b4f4f58bc851c1a9d171cb6'].zoomIn(this)\" name=\"zoomSelect\" id=\"re_zoomSelectd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_zoom_combo\" style=\"\">;<option name=\"p50\" value=\"0.5\" class=\"report_menu_zoom_combo_option\">50%</option><option name=\"p75\" value=\"0.75\" class=\"report_menu_zoom_combo_option\">75%</option><option name=\"p100\" value=\"1\" class=\"report_menu_zoom_combo_option\" selected=\"\">100%</option><option name=\"p125\" value=\"1.25\" class=\"report_menu_zoom_combo_option\">125%</option><option name=\"p150\" value=\"1.5\" class=\"report_menu_zoom_combo_option\">150%</option><option name=\"p200\" value=\"2\" class=\"report_menu_zoom_combo_option\">200%</option><option name=\"p300\" value=\"3\" class=\"report_menu_zoom_combo_option\">300%</option><option name=\"p400\" value=\"4\" class=\"report_menu_zoom_combo_option\">400%</option><option name=\"pWidth\" value=\"PageWidth\" class=\"report_menu_zoom_combo_option\">PageWidth</option><option name=\"pWholePage\" value=\"WholePage\" class=\"report_menu_zoom_combo_option\">WholePage</option></select><button title=\"등록 정보\" id=\"re_reportInfod94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_reportInfo_button report_menu_reportInfo_button_svg\" style=\"\"></button><button title=\"닫기\" id=\"re_closed94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_menu_button report_menu_close_button report_menu_close_button_svg\" style=\"\" onclick=\"document.getElementById('"+targetId+"').innerHTML='';return false;\"></button></nobr></div></td></tr></tbody></table></div><div id=\"re_paintDivd94a5a8a3b4f4f58bc851c1a9d171cb6\" class=\"report_paint_div\" style=\"overflow: auto;\"></div></div>";
	}
}


/**
 * 리포트 전체에 저장 선택부분에서 기본 타입을 지정합니다.<br>
 * @example
 *{String} excel, pdf, hwp, rtf, ppt, html, html5, hancell, doc
 * 
 * @method UserConfig
 * @since version 1.0.0.18
 */
function getDefaultSaveOption(){
	return "excel";
}


/**
 * 전체 리포트에 대한 Excel 저장 옵션 기본값을 설정합니다.<br>
 * @example
 * exportMethod {Integer} <br>
 * 1 = 페이지 마다 <br>
 * 2 = 하나의 시트 <br>
 * 3 = 하나의 시트(페이지영역 무시)<br>
 * 4 = 리포트 마다<br>
 * mergeCell {Boolean} 셀 합치기<br>
 * mergeEmptyCell {Boolean} 공백 셀일 경우 합치기<br>
 * splitCellAtPageSize {Boolean} 페이지 크기로 셀 분리<br>
 * rightToLeft {Boolean} 열이 오른쪽에서 왼쪽으로 진행<br>
 * widthRate {Integer} 가로 비율<br>
 * heightRate {Integer} 세로 비율<br>
 * coordinateErrorLimit {Integer} 좌표 오차 범위<br>
 * processGerenalFormat {Integer}<br>
 * 1 = 텍스트<br>
 * 2 = 일반<br>
 * printingMagnification {Integer} 인쇄 확대/축소 비율<br>
 * 
 * @method UserConfig
 * @since version 1.0.0.18
 */
function getDefaultSaveExcelOption(){
	var option = {
			exportMethod : 1,
			mergeCell : true,
			mergeEmptyCell : false,
			splitCellAtPageSize : true,
			rightToLeft : false,
			widthRate : 100,
			heightRate : 100, 
			coordinateErrorLimit : 10,
			processGerenalFormat : 1,
			printingMagnification : 100
	};
	return option;
}

/**
 * 전체 리포트에 대한 HWP 저장 옵션 기본값을 설정합니다.<br>
* @example
* fixSize {Boolean} 크기 고정<br>
* allowOverlay {Boolean} 겹침 허용<br>
* setPageBottomMarginToZero {Boolean} 페이지 바닥 여백을 0으로 설정<br>
* outputLikeWord {Boolean} 글자처럼 출력<br>
* tableSplitMethod {Integer}<br>
* 1 = 나눔 <br>
* 2 = 셀 단위로 나눔 <br>
* 3 = 나누지 않음 <br>
* defaultCharGap {Integer} 기본 자간<br>
* charRatio {Integer} 자평<br>
* putCheckboxIntoCell {Boolean} 셀 안에 체크박스 넣기(version 1.0.0.22)<br>
* splitTextByLine {Boolean} 텍스트를 라인별로 나눠서 표현(version 1.0.0.23)<br>
* 
* @method UserConfig
* @since version 1.0.0.18
* 
*/
function getDefaultSaveHWPOption(){
	var option = {
			fixSize : true,
			allowOverlay : true,
			setPageBottomMarginToZero : true,
			outputLikeWord : false,
			tableSplitMethod : 2,
			defaultCharGap : -8,
			charRatio : 100,
			putCheckboxIntoCell : false,
			splitTextByLine : true
	};
	return option;
}

/**
 * 전체 리포트에 대한 RTF 저장 옵션 기본값을 설정합니다.<br>
 * @example
 * splitTextLine {Boolean} 문자열을 여러 줄로 나누어 표현<br>
 * processAsUnicode {Boolean} 유니코드로 문자열을 처리 <br>
 * processEqualAlign {Integer} <br>
 * 1 = 왼쪽 정렬 <br>
 * 2 = 가운데 정렬 <br>
 * 3 = 오른쪽 정렬 <br>
 * 4 = 양쪽 정렬 <br>
 * defaultCharSpace {Double} 기본 자간 <br>
 * tableWrapperBottomGap {Integer} 표를 감싸는 객체의 아래쪽 여백 <br>
 
 * @method UserConfig
 * @since version 1.0.0.18
 */
function getDefaultSaveRTFOption(){
	var option = {
	splitTextLine : true,
	processAsUnicode : true,
    processEqualAlign : 4,
    defaultCharSpace : -0.5,
    tableWrapperBottomGap : 0
	};
	return option;
}

/**
 * 전체 리포트에 대한 DOC 저장 옵션 기본값을 설정합니다.<br>
 * @example
 * splitTextLine {Boolean} 문자열을 여러 줄로 나누어 표현<br>
 * processAsUnicode {Boolean} 유니코드로 문자열을 처리 <br>
 * processEqualAlign {Integer} <br>
 * 1 = 왼쪽 정렬 <br>
 * 2 = 가운데 정렬 <br>
 * 3 = 오른쪽 정렬 <br>
 * 4 = 양쪽 정렬 <br>
 * defaultCharSpace {Double} 기본 자간 <br>
 * tableWrapperBottomGap {Integer} 표를 감싸는 객체의 아래쪽 여백 <br>
 
 * @method UserConfig
 * @since version 1.0.0.23
 */
function getDefaultSaveDOCOption(){
	var option = {
	splitTextLine : true,
	processAsUnicode : true,
    processEqualAlign : 4,
    defaultCharSpace : -0.5,
    tableWrapperBottomGap : 0
	};
	return option;
}

/**
 * 전체 리포트에 대한 HTML 저장 옵션 기본값을 설정합니다.<br>
 * @example
 * processCellLikeShape {Boolean} 테이블 셀을 라벨처럼 저정 <br>
 * displayPageLine {Boolean} 페이지 분리선 표시 <br>
 * keepPageHeight {Boolean} 페이지 높이 유지 <br>
 * applyWordBreak {Boolean} 글자 감싸기 적용 <br>
 * setTextProperiesToEmptyCell {Boolean} 빈 셀에 택스트 속성 설정 <br>
 * putTagIntoEmptyCell {Boolean} 빈 셀에 공백 삽입 <br>
 * textOverflowHidden {Boolean} overflow=hidden 스타일 적용 <br>
 * coordinateRateForX {Double} X축 비율 <br>
 * coordinateRateForY {Double} Y축 비율 <br>
 * encodingType {Integer} 인코딩 <br>
 * 1 = UTF=8 <br>
 * 2 = Unicode <br>
 * 3 = EUC-KR <br>
 * 
 * @method UserConfig
 * @since version 1.0.0.18
 */
function getDefaultSaveHTMLOption(){
	var option = {
		processCellLikeShape : false,
		displayPageLine : true,
		keepPageHeight : true,
		applyWordBreak : false,
		setTextProperiesToEmptyCell : false,
		putTagIntoEmptyCell : false,
		textOverflowHidden : false,
		coordinateRateForX : 2.6,
		coordinateRateForY : 2.6,
		encodingType : 1
	};
	return option;
}

/**
 * 전체 리포트에 대한 PDF 저장 옵션 기본값을 설정합니다.<br>
 * @example
 *  isSplit {Boolean} 분할 저장 선택<br>
 *  pageCount {Integer} 페이지 수<br>
 *  userpw {String} 문서암호 (version 1.0.0.25) <br>
 *  textToImage {Boolean} pdf에 문자를 이미지로 표현 (version 1.0.0.29) <br>
 *  importOriginImage {Boolean} 원본 이미지 사용 (version 1.0.0.31) <br> 
 * 
 * @method UserConfig
 * @since version 1.0.0.18
 * 
 */
function getDefaultSavePDFOption(){
	var option = {
		isSplite : false,
		spliteValue : 1,
		userpw : "",
		textToImage : false,
		importOriginImage : false
	};
	return option;
}

/**
 * 전체 리포트에 대한 HanCell 저장 옵션 기본값을 설정합니다.<br>
 * @example
 * exportMethod {Integer} <br>
  * 1 = 페이지 마다 <br>
 * 2 = 하나의 시트 <br>
 * 3 = 하나의 시트(페이지영역 무시)<br>
 * 4 = 리포트 마다<br>
 * mergeCell {Boolean} 셀 합치기<br>
 * mergeEmptyCell {Boolean} 공백 셀일 경우 합치기<br>
 * splitCellAtPageSize {Boolean} 페이지 크기로 셀 분리<br>
 * rightToLeft {Boolean} 열이 오른쪽에서 왼쪽으로 진행<br>
 * widthRate {Integer} 가로 비율<br>
 * heightRate {Integer} 세로 비율<br>
 * coordinateErrorLimit {Integer} 좌표 오차 범위<br>
 * processGerenalFormat {Integer}<br>
 * 1 = 텍스트<br>
 * 2 = 일반<br>
 * printingMagnification {Integer} 인쇄 확대/축소 비율<br>
 * 
 * @method UserConfig
 * @since version 1.0.0.18
 * 
 */


function getDefaultSaveHanCellOption(){
	var option = {
			exportMethod : 1,
			mergeCell : true,
			mergeEmptyCell : false,
			splitCellAtPageSize : true,
			rightToLeft : false,
			widthRate : 100,
			heightRate : 100, 
			coordinateErrorLimit : 10,
			processGerenalFormat : 1,
			printingMagnification : 100
	};
	return option;
}

/**
 * 전체 리포트에 대한 html5 저장 옵션 기본값을 설정합니다.<br>
 * @example
 * isSplite {Boolean} 페이지 구분<br>
 * dpiValue {Integer} DPI 값<br>
 * 
 * @method UserConfig
 * @since version 1.0.0.22
 * 
 */
function getDefaultSaveHTML5Option(){
	var option = {
			isSplite : true,
			dpiValue : 96
	};
	return option;
}

/**
 * 빠른 PDF 저장 대한 옵션 기본값을 설정합니다.<br>
 * @example
 *  fileName{String} 문서를 저장 할 파일 이름<br>
 *  isSplit {Boolean} 분할 저장 선택<br>
 *  pageCount {Integer} 페이지 수<br>
 *  userpw {String} 문서암호 (version 1.0.0.25) <br>
 *  textToImage {Boolean} pdf에 문자를 이미지로 표현 (version 1.0.0.29) <br>
 *  importOriginImage {Boolean} 원본 이미지 사용 (version 1.0.0.31) <br> 
 * 
 * @method UserConfig
 * @since version 1.0.0.20
 * 
 */
function getDirectSavePDFOption(){
	var option = {
			fileName : "report",
			isSplite : false,
			spliteValue : 1,
			userpw : "",
			textToImage : false,
			importOriginImage : false
		};
		return option;
}

/**
 * 빠른 HWP 저장 대한 옵션 기본값을 설정합니다.<br>
* @example
* fileName{String} 문서를 저장 할 파일 이름<br>
* fixSize {Boolean} 크기 고정<br>
* allowOverlay {Boolean} 겹침 허용<br>
* setPageBottomMarginToZero {Boolean} 페이지 바닥 여백을 0으로 설정<br>
* outputLikeWord {Boolean} 글자처럼 출력<br>
* tableSplitMethod {Integer}<br>
* 1 = 나눔 <br>
* 2 = 셀 단위로 나눔 <br>
* 3 = 나누지 않음 <br>
* defaultCharGap {Integer} 기본 자간<br>
* charRatio {Integer} 자평<br>
* putCheckboxIntoCell {Boolean} 셀 안에 체크박스 넣기(version 1.0.0.22)<br>
* splitTextByLine {Boolean} 텍스트를 라인별로 나눠서 표현(version 1.0.0.23)<br>
* 
* @method UserConfig
* @since version 1.0.0.20
* 
*/
function getDirectSaveHWPOption(){
	var option = {
			fileName : "report",
			fixSize : true,
			allowOverlay : true,
			setPageBottomMarginToZero : true,
			outputLikeWord : false,
			tableSplitMethod : 2,
			defaultCharGap : -8,
			charRatio : 100,
			putCheckboxIntoCell : false,
			splitTextByLine : true
	};
	return option;
}

/**
 * 빠른 EXCEL 저장 대한 옵션 기본값을 설정합니다.<br>
 * @example
 * fileName{String} 문서를 저장 할 파일 이름<br>
 * exportMethod {Integer} <br>
 * 1 = 페이지 마다 <br>
 * 2 = 하나의 시트 <br>
 * 3 = 하나의 시트(페이지영역 무시)<br>
 * 4 = 리포트 마다<br>
 * mergeCell {Boolean} 셀 합치기<br>
 * mergeEmptyCell {Boolean} 공백 셀일 경우 합치기<br>
 * splitCellAtPageSize {Boolean} 페이지 크기로 셀 분리<br>
 * rightToLeft {Boolean} 열이 오른쪽에서 왼쪽으로 진행<br>
 * widthRate {Integer} 가로 비율<br>
 * heightRate {Integer} 세로 비율<br>
 * coordinateErrorLimit {Integer} 좌표 오차 범위<br>
 * processGerenalFormat {Integer}<br>
 * 1 = 텍스트<br>
 * 2 = 일반<br>
 * printingMagnification {Integer} 인쇄 확대/축소 비율<br>
 * 
 * @method UserConfig
 * @since version 1.0.0.20
 * 
 */
function getDirectSaveEXCELOption(){
	var option = {
			fileName : "report",
			exportMethod : 1,
			mergeCell : true,
			mergeEmptyCell : false,
			splitCellAtPageSize : true,
			rightToLeft : false,
			widthRate : 100,
			heightRate : 100, 
			coordinateErrorLimit : 10,
			processGerenalFormat : 1,
			printingMagnification : 100
	};
	return option;
}
