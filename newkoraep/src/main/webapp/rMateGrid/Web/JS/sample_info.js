// sample기본 주소
var baseurl = "./Samples/",

	// 기본 타입
	default_types_1 = [
		{
			"n":"그리드 외형/데이터 설정", "c":[
				{"n":"Layout(외형)과 Data 설정", "u":"LayoutData"},
				{"n":"외형(Layout) URL/String 형식 동적으로 설정", "u":"Dynamic_Change"},
				{"n":"Data 문자열 형식(JSON, XML, CSV, TSV)", "u":"Set_Data_String"},
				{"n":"Data URL 형식(JSON, XML, CSV, TSV)", "u":"Set_Data_URL"},
				{"n":"Lazy loading", "u":"LazyLoading"},
				{"n":"데이터 제어 + 필드 데이터 제어", "u":"Data_Collection_Control"},
				{"n":"XML 데이터 제어", "u":"JavaScript_XMLParser"}
			]
		},{
			"n":"그리드 속성 제어", "c":[
				{"n":"그리드 전체 속성 조정 <DataGrid>", "u":"DataGrid_Properties"},
				{"n":"컬럼 속성 조정 <DataGridColumn>", "u":"DataGridColumn_Properties"},
				{"n":"Javascript 함수 호출로 속성정보 넣기", "u":"Span_Function"},
				{"n":"사용자지정에 의한 헤더/셀 데이터팁 변경", "u":"DataGrid_DataTipJsFunction"},
				{"n":"사용자지정에 의한 라벨 변경", "u":"Column_LabelJsFunction"}
			]
		},{
			"n":"그리드 스타일 제어", "c":[
				{"n":"그리드 스타일 조정", "u":"DataGrid_Styles"},
				{"n":"개별 스타일명에 의한 스타일 지정", "u":"Style_StyleName"},
				{"n":"행/셀 속성지정(스타일,배경색,잠금,포맷,높이)", "u":"Span_RowCellAttr"},
				{"n":"사용자지정에 의한 스타일 변경", "u":"Column_StyleJsFunction"},
				{"n":"3.1이전 버젼 스타일 사용", "u":"SetConfig_Style3"}
			]
		},{
			"n":"그리드 이벤트 제어", "c":[
				{"n":"GridRoot 이벤트", "u":"GridRoot_Event"},
				{"n":"DataGrid 이벤트", "u":"DataGrid_Event"},
				{"n":"기타 이벤트", "u":"Event_Etc"}
			]
		},{
			"n":"조회와 관련한 기능", "c":[
				{"n":"컬럼 정렬", "u":"Column_Sorting_JSON"},
				{"n":"컬럼 이동(잠금), 틀고정, 컬럼 숨기기", "u":"Column_ShiftLockShow"},
				{"n":"Context Menu 지정", "u":"ContextMenu_Create"},
				{"n":"페이징 구현 (setDataURLEx)", "u":"Data_Paging"},
				{"n":"페이징 구현 (PagingCollection)", "u":"Data_PagingCollection"},
				{"n":"Live Scrolling", "u":"LiveScrolling"},
				{"n":"숫자형 Formatter", "u":"Formatter_NumberFormatter"},
				{"n":"날짜형 Formatter", "u":"Formatter_DateFormatter"},
				{"n":"퍼센트형 Formatter", "u":"Formatter_PercentFormatter"},
				{"n":"숫자마스크형 Formatter", "u":"Formatter_NumberMaskFormatter"},
				{"n":"통화형 Formatter", "u":"Formatter_CurrencyFormatter"}
			]
		},{
			"n":"편집(입력,수정,삭제 등)", "c":[
				{"n":"JavaScript연동 편집(XML)", "u":"Editing_Javascript_XML"},
				{"n":"JavaScript연동 편집(Object)", "u":"Editing_Javascript_Object"},
				{"n":"Popup연동 (windows.open)", "u":"Editing_Popup"},
				{"n":"그리드내 편집", "u":"Editing_DataGrid"},
				{"n":"입력 길이 제한", "u":"Editing_MaxChars"},
				{"n":"그리드 편집용 컴포넌트 사용", "u":"Editing_Editor"},
				{"n":"ComboBox 컴포넌트로 편집", "u":"Editing_ComboCode"},
				{"n":"DynamicComboBox 컴포넌트로 편집", "u":"Editing_Dynamic_ComboCode"},
				{"n":"필드에 ComboBox 컴포넌트 선택 넣기", "u":"Editing_ItemRendererDataProviderField"},
				{"n":"편집가능 ComboBox 컴포넌트로 편집", "u":"Editing_ExComboBox"},
				{"n":"TextArea 컴포넌트로 편집", "u":"Editing_TextArea"},
				{"n":"자동완성 TextInput 컴포넌트 사용", "u":"Editing_Autocomplete"},
				{"n":"CheckBox 기본값", "u":"Editing_TrueValue_FalseValue"},
				{"n":"Excel 키보드 모드", "u":"Editing_EditingKeyMode"},
				{"n":"계층형 편집", "u":"Editing_Hierarchy_JSON"},
				{"n":"Undo, Redo", "u":"Editing_UndoRedo_JSON"},
				{"n":"편집가능 여부 제어", "u":"Editing_ItemEditBeginningJsFunction"},
				{"n":"편집내용 검사", "u":"Editing_ItemEditEndJsFunction"},
				{"n":"편집종료 이벤트 받기", "u":"Editing_ItemEditCompletet_Event"},
				{"n":"변경시 이벤트 받기", "u":"Editing_ItemDataChanged_Event"},
				{"n":"편집후 서버에 저장", "u":"Editing_SubmitToServer"},
				{"n":"Editor 속성 지정", "u":"Editing_EditorProperties"},
				{"n":"Editor Instance 제어", "u":"Editing_ItemFocusInJsFunction"},
				{"n":"편집오류 처리 속성", "u":"Editing_EndEditOnBlur"},
				{"n":"추가,수정,삭제 표시 컬럼", "u":"Editing_DataGridRowStateColumn"},
				{"n":"수정가능 아이콘 표시", "u":"Editing_ShowEditableIcon"}
			]
		},{
			"n":"렌더러(셀표시 객체)", "c":[
				{"n":"Html + Link + HtmlHeader", "u":"Renderer_Html"},
				{"n":"함수를 이용한 Html 표시", "u":"Renderer_Html_LabelJsFunction"},
				{"n":"Image가 들어가는 컬럼", "u":"Renderer_Image"},
				{"n":"ItemRendererDataProvider", "u":"Renderer_DataProvider"},
				{"n":"Icon 일괄 / 선택 적용", "u":"Renderer_Icon_Column"},
				{"n":"Icon 사용자정의 적용", "u":"Renderer_IconLabelFunction"},
				{"n":"Index No.", "u":"Renderer_IndexNo"},
				{"n":"CheckBoxItem", "u":"Renderer_CheckBox"},
				{"n":"CheckBoxHeader", "u":"Renderer_CheckBoxHeader"},
				{"n":"편집가능 Html", "u":"Renderer_HtmlEditable"},
				{"n":"ComboBoxItem / Header", "u":"Renderer_ComboBox"},
				{"n":"TextAreaItem", "u":"Renderer_TextArea"},
				{"n":"SparkLine", "u":"Renderer_SparkLine"},
				{"n":"SparkColumn", "u":"Renderer_SparkColumn"},
				{"n":"SparkWinLoss", "u":"Renderer_SparkWinLoss"}
			]
		},{
			"n":"엑셀(Excel)", "c":[
				{"n":"Excel import", "u":"Excel_Import"},
				{"n":"Excel import option", "u":"Excel_Import_Option"},
				{"n":"Excel import parseFunction", "u":"Excel_Import_ParseFunction"},
				{"n":"Excel CSV import", "u":"Excel_CSV_Import"},
				{"n":"Excel export", "u":"Excel_Export"},
				{"n":"Excel export 제목  꼬릿말", "u":"Excel_Export_TitleFooter"},
				{"n":"Excel export 컬럼지정", "u":"Excel_Export_Columns"},
				{"n":"Excel export 비동기모드", "u":"Excel_Export_Async"},
				{"n":"Excel export 진행바 표시", "u":"Excel_Export_Async_Progress"},
				{"n":"Excel export upload", "u":"Excel_Export_Upload"},
				{"n":"Excel export CSV", "u":"Excel_Export_Csv"},
				{"n":"Excel multi export", "u":"Excel_Export_Multi"}
			]
		},{
			"n":"선택 제어", "c":[
				{"n":"한행 선택 / 여러행 / 한셀 / 여러셀", "u":"Select_SingleMultiRowCell"},
				{"n":"마우스로 행 / 셀 선택", "u":"DragSelectable_MultiCellsRows"},
				{"n":"선택내역 Copy", "u":"Clipboard_Copy"},
				{"n":"선택내역 Paste", "u":"Clipboard_Paste"},
				{"n":"선택내역 Paste ParseFunction", "u":"Clipboard_PasteParseFunction"},
				{"n":"CheckBox로 선택 / Radio 변경", "u":"Selector_CheckBoxRadioItem"},
				{"n":"CheckBox 선택 설정", "u":"Selector_CheckBoxItem_Set"},
				{"n":"CheckBox enabled 제어", "u":"Selector_CheckBoxItem_SecondLabelFunction"},
				{"n":"CheckBox 선택 연동", "u":"Selector_SelectionMode"},
				{"n":"셀렉터 이벤트", "u":"Selector_ChangeEvent"},
				{"n":"선택행 삭제", "u":"Selector_RemoveSelection"}
			]
		},{
			"n":"계층 및 그룹핑", "c":[
				{"n":"계층형 XML자료 보이기", "u":"Hierarchy_XML_Data"},
				{"n":"계층형 JSON자료 보이기(셀속성 포함)", "u":"SpanHierarchy_JSON_Data"},
				{"n":"그룹핑 기능(합산)", "u":"GroupingAndSummary_Data"},
				{"n":"그룹핑 기능(셀 속성 포함)", "u":"SpanGrouping_Data"},
				{"n":"그룹핑 판넬", "u":"DataGridGroupingPanel"},
				{"n":"SQL connect by 계층형 변환", "u":"Level_To_Hierarchy_JSON_Data"}
			]
		},{
			"n":"셀 병합 및 합산", "c":[
				{"n":"필드 자동 병합 및 필드별 소계 및 전체 합계", "u":"Summary_Total"},
				{"n":"합산의 라벨 변경", "u":"Summary_LabelJsFunction"},
				{"n":"합산 레코드 제어", "u":"SummaryRow_Control"}
			]
		},{
			"n":"푸터", "c":[
				{"n":"푸터 속성", "u":"Footer_Properties"},
				{"n":"푸터 labelJsFunction", "u":"Footer_LabelJsFunction"},
				{"n":"푸터 스타일 조정", "u":"Footer_Styles"}
			]
		},{
			"n":"필터링 및 검색", "c":[
				{"n":"필터링", "u":"Filtering_Data"},
				{"n":"컬럼 필터링", "u":"Column_Filterable"},
				{"n":"컬럼 필터 함수", "u":"Column_FilterFunction"},
				{"n":"검색", "u":"Searching_Data"},
				{"n":"컬럼 검색", "u":"Searching_Column_Data"}
			]
		},{
			"n":"피벗", "c":[
				{"n":"PivotDataGrid", "u":"PivotDataGrid"},
				{"n":"다차원 Pivot", "u":"PivotDataGrid_MultiDimensions"},
				{"n":"Pivot 질의", "u":"PivotDataGrid_Dynamic"}
			]
		},{
			"n":"기타", "c":[
				{"n":"다국어 지원", "u":"Locale"},
				{"n":"웹접근성", "u":"Accessibility"},
				{"n":"다수 컬럼", "u":"Many_Columns"},
				{"n":"그리드 위에 메세지 표시", "u":"Display_Message"},
				{"n":"로딩표시 보이기/숨기기", "u":"LoadingBar"},
				{"n":"진행바 표시", "u":"ProgressBar"}
			]
		}
	],

	// default_types_2
	default_types_2 = [
		{
		// 조회 기능
			"n":"조회 기능", "c":[
				// n - name
				// u - url
				{"n":"체크정보 푸터 표시", "u":"Sample_Inquiry_CheckInfoInFooter"},
//				{"n":"선택한 데이터만 엑셀 추출", "u":"0"},
				{"n":"정렬상태로 그리드 로드", "u":"Sample_Inquiry_LoadOnSorted"},
				{"n":"중복 필터링", "u":"Sample_Inquiry_Multi_Filtering"},
				{"n":"Icon 사용자정의 적용", "u":"Sample_Inquiry_IconJsFunction"},
				{"n":"별점 아이콘", "u":"Sample_Inquiry_Icon_Star"},
				{"n":"그리드 전체 높이 자동조정", "u":"Sample_Inquiry_AutoHeight"},
//				{"n":"두개 그리드에서 비교형 출력", "u":"0"},
				{"n":"두개 그리드 연동 필터링 조회형", "u":"Sample_Inquiry_SubGrid_Filtering"},
				{"n":"마우스 우클릭 메뉴(아이콘 삽입, 열 숨기기, 행고정)", "u":"Sample_Inquiry_RightClick_Menu"},
				{"n":"그리드 숨김상태로 엑셀 다운로드", "u":"Sample_Inquiry_ExcelExport_HiddenGrid"}
			]
		},{
		// 입력/수정/삭제 기능
			"n":"입력/수정/삭제 기능", "c":[
				{"n":"키보드 수정", "u":"Sample_Editing_Keyboard"},
				{"n":"추가된 행만 수정 가능", "u":"Sample_Editing_Editable_NewRow"},
				{"n":"레이어팝업으로 수정", "u":"Sample_Editing_Layer_PopUp"},
				{"n":"체크박스 선택 복사, 삭제", "u":"Sample_Editing_CheckBox_AddDeleteRow"},
				{"n":"일괄데이터 변경", "u":"Sample_Editing_CheckedValue"},
				{"n":"행 위/아래로 이동", "u":"Sample_Editing_Move_Row"},
//				{"n":"수정/삭제 표시한 행 되돌리기", "u":"Sample_Editing_UnDo_RemovedRow"},
				{"n":"두개의 그리드 연동 수정", "u":"Sample_Editing_Grid_Data_Transfer"}
			]
		},{
		// 데이터 처리
			"n":"데이터 처리", "c":[
				{"n":"개별 행, 열 병합", "u":"Sample_Data_SpanEachColumns"},
				{"n":"전체데이터 로드후 페이징", "u":"Sample_Data_PaginAfterLoadComplete"},
				{"n":"페이징에서 필터링", "u":"Sample_Data_FilteringInPaging"},
				{"n":"SQL connect by 변환", "u":"Sample_Data_SQL_ConnectBy"},
				{"n":"대용량 데이터와 Live Scrolling", "u":"Sample_Data_BigData_LiveScrolling"},
				{"n":"합산 레코드 변경", "u":"SummaryRow_Control_MinMax"}
			]
		},{
		// 그리드 외부 연동
			"n":"그리드 외부 연동", "c":[
				{"n":"그리드 jQuery 탭", "u":"Sample_External_jQuery_Tab"},
				{"n":"그리드 jQuery resizable", "u":"Sample_External_jQuery_Resizable"},
				{"n":"그리드 jQuery 레이어 팝업", "u":"Sample_External_jQuery_LayerPopup"}
			]
		}

	],

	// 홈 화면 이미지 경로
	images = [{
			"n":"CheckBox 선택 설정", "u":"checkbox", "w":"선택 제어"
		},{
			"n":"Context Menu 지정", "u":"context", "w":"조회와 관련한 기능"
		},{
			"n":"Excel Import / Export", "u":"excel", "w":"엑셀(Excel)"
		},{
			"n":"다국어 지원", "u":"lang", "w":"기타"
		},{
			"n":"그룹 컬럼 생성", "u":"group", "w":"그리드 기본기능"
		},{
			"n":"그리드 편집용 컴포넌트 사용", "u":"date", "w":"편집(입력,수정,삭제 등)"
		},{
			"n":"SparkLine", "u":"spark", "w":"렌더러(셀표시 객체)"
		},{
			"n":"계층형 데이터", "u":"hirarch", "w":"계층 및 그룹핑"
		},{
			"n":"추가,수정,삭제 표시 컬럼", "u":"rowstate", "w":"편집(입력,수정,삭제 등)"
		},{
			"n":"Icon 일괄 / 선택 적용", "u":"icon", "w":"렌더러(셀표시 객체)"
		},{
			"n":"필드별 소계 및 전체 합계", "u":"sumsub", "w":"셀 병합 및 합산"
		},{
			"n":"푸터 스타일 조정", "u":"sum", "w":"푸터"
		}
],

tutorialContent = [{
		"index":0,"content":"<pre><font color='#0000ff'>&#60;!DOCTYPE html&#62;<br>&#60;html&#62;<br>&#60;head&#62;<br>&#60;meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /&#62;<br></font></pre>","className":"active_tutorial_child"
	},{
		"index":1,"content":'<pre>'
		+'<font color="#4BBF5A">&#60;!-- rMateGridH5 css --&#62;</font><br>'
		+'<font color="#0000ff">&#60;link <font color="#ff0000">rel="stylesheet" type="text/css" href="../rMateGridH5/Assets/rMateH5.css"</font>/&#62;<br><br>'
		+'<font color="#4BBF5A">&#60;!-- rMateGridH5 라이센스 --&#62;</font><br>'
		+'<font color="#0000ff">&#60;script <font color="#ff0000">language="javascript" type="text/javascript" src="../LicenseKey/rMateGridH5License.js"</font>&#62;<br>&#60;/script&#62;</font><br><br>'
		+'<font color="#4BBF5A">&#60;!-- 실제적인 rMateGridH5 라이브러리 --&#62;</font><br>'
		+'<font color="#0000ff">&#60;script <font color="#ff0000">language="javascript" type="text/javascript" src="../rMateGridH5/JS/rMateGridH5.js"</font>&#62;<br>&#60;/script&#62;</font><br><br>'
		+'</pre>'
		,"className":"none_tutorial_child","displayList":true,"displayIndex":0
		,"displayBtn":"그리드생성에 필요한 css와 js를 include 합니다.<br>"
	},{
		"index":2,"content":'<pre><font color="#0000ff">&#60;script <font color="#ff0000">type="text/javascript"</font>></font><br>'
		+'<font color="#4BBF5A">// 그리드 생성 준비가 완료된 후(DOM ready) 호출할 함수를 지정합니다.</font><br>'
		+'<font color="#0000ff">var <font color="#792929">jsVars = "rMateOnLoadCallFunction=gridReadyHandler";</font><br><br>'
		+'<font color="#4BBF5A">// rMateGrid 를 생성합니다.<br>'
		+'// 파라메터 (순서대로) <br>'
		+'//  1. 그리드의 id ( 임의로 지정하십시오. ) <br>'
		+'//  2. 그리드가 위치할 div 의 id (즉, 그리드의 부모 div 의 id 입니다.)<br>'
		+'//  3. 그리드 생성 시 필요한 환경 변수들의 묶음인 jsVars<br>'
		+'//  4. 그리드의 가로 사이즈 (생략 가능, 생략 시 100%)<br>'
		+'//  5. 그리드의 세로 사이즈 (생략 가능, 생략 시 100%)</font><br>'
		+'<font color="#792929">rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%"); </font><br><br>'
		+'<font color="#0000ff">var <font color="#792929">gridApp, gridRoot, dataGrid, collection;</font><br><br>'
		+'<font color="#4BBF5A">// 그리드 생성시 전달된 jsVars에 설정한 rMateOnLoadCallFunction 으로 설정된 함수.<br>'
		+'// 그리드 생성 준비가 완료된 경우 이 함수가 호출됩니다.<br>'
		+'// 이 함수를 통해 그리드에 레이아웃과 데이터를 삽입합니다.<br>'
		+'// 파라메터 : id - rMateGridH5.create() 실행 때 사용자가 지정한 id 입니다.</font><br>'
		+'function <font color="#792929">gridReadyHandler(id) {<br>'
		+'	gridApp = document.getElementById(id);	// 그리드를 포함하는 div 객체<br>'
		+'	gridRoot = gridApp.getRoot();	// 데이터와 그리드를 포함하는 객체<br><br>'
		+'	gridApp.setLayout(layoutStr);<br>'
		+'	gridApp.setData(gridData);<br><br>'
		+'	var layoutCompleteHandler = function(event) {<br>'
		+'		dataGrid = gridRoot.getDataGrid();	// 생성된 그리드 객체<br>'
		+'	}<br>'
		+'	var dataCompletedHandler = function(event) {<br>'
		+'		collection = gridRoot.getCollection();	// 그리드의 데이터가 저장된 객체<br>'
		+'	}<br><br>'
		+'	// 레이아웃에 의해 그리드가 생성된 후 layoutComplete 이벤트가 발생합니다.<br>'
		+'	gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);<br>'
		+'	// 그리드에 데이터가 설정된 후 dataComplete이벤트가 발생합니다.<br>'
		+'	gridRoot.addEventListener("dataComplete", dataCompletedHandler);<br>'
		+'}</font></font><br><br>'
		+'</pre>'
		,"className":"none_tutorial_child","displayList":true,"displayIndex":2
		,"displayBtn":"그리드를 생성하는 스크립트를 작성 합니다.<br>"
						+"주석처리된 부분을 읽어 보시기 바랍니다."
	},{
		"index":3,"content":'<pre>'
		+'<font color="#4BBF5A">// 스트링 형식으로 레이아웃 정의.</font><br>'
		+'<font color="#0000ff">var</font> <font color="#792929">layoutStr = &#39;&#60;rMateGrid>&#39;<br>'
		+'			+&#39;&#60;DataGrid  id="dg1" sortableColumns="true" headerHeight="50" rowHeight="30" draggableColumns="true" showHeaders="true" horizontalScrollPolicy="auto" variableRowHeight="false" selectionMode="singleRow" textAlign="center" verticalAlign="middle">&#39;<br>'
		+'				+&#39;&#60;columns>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col1" dataField="Year"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col2" dataField="Quarter"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col3" dataField="Month"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col4" dataField="Seoul" textAlign="right"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col5" dataField="Pusan" textAlign="right"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col6" dataField="Incheon" textAlign="right"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col7" dataField="NewYork" textAlign="right"/>&#39;<br>'
		+'					+&#39;&#60;DataGridColumn id="dg1col8" dataField="LA" textAlign="right"/>&#39;<br>'
		+'				+&#39;&#60;/columns>&#39;<br>'
		+'			+&#39;&#60;/DataGrid>&#39;<br>'
		+'		+&#39;&#60;/rMateGrid>&#39;;</font><br><br>'
		+'</pre>'
		,"className":"none_tutorial_child","displayList":true,"displayIndex":3
		,"displayBtn":"그리드의 외형인 레이아웃을 용도에 맞게 설정합니다."
	},{
		"index":4,"content":'<pre>'
		+'<font color="#4BBF5A">// 그리드 데이터<br></font>'
		+'<font color="#0000ff">var</font> <font color="#792929">gridData = [{"Year":2007, "Quarter":"1/4", "Month":1, "Seoul":109520, "Pusan":40454, "Incheon":82477, "NewYork":47424, "LA":103225, "Washington":61161, "Revenue":444260, "Percent":40},<br>'
		+'		{"Year":2007, "Quarter":"1/4", "Month":2, "Seoul":15749, "Pusan":29714, "Incheon":31393, "NewYork":45006, "LA":17945, "Washington":90148, "Revenue":229956, "Percent":20},<br>'
		+'		{"Year":2007, "Quarter":"1/4", "Month":3, "Seoul":14766, "Pusan":97314, "Incheon":103216, "NewYork":86072, "LA":52863, "Washington":93789, "Revenue":448020, "Percent":40},<br>'
		+'		{"Year":2007, "Quarter":"2/4", "Month":4, "Seoul":52352, "Pusan":56859, "Incheon":15688, "NewYork":65438, "LA":39181, "Washington":109514, "Revenue":339031, "Percent":31},<br>'
		+'		{"Year":2007, "Quarter":"2/4", "Month":5, "Seoul":100842, "Pusan":30391, "Incheon":23745, "NewYork":72742, "LA":102195, "Washington":30407, "Revenue":360322, "Percent":33},<br>'
		+'		{"Year":2007, "Quarter":"2/4", "Month":6, "Seoul":19217, "Pusan":75298, "Incheon":70807, "NewYork":36447, "LA":100805, "Washington":84934, "Revenue":387508, "Percent":36},<br>'
		+'		{"Year":2007, "Quarter":"3/4", "Month":7, "Seoul":74324, "Pusan":64947, "Incheon":101350, "NewYork":34673, "LA":24486, "Washington":57781, "Revenue":357561, "Percent":28},<br>'
		+'		{"Year":2007, "Quarter":"3/4", "Month":8, "Seoul":85932, "Pusan":95733, "Incheon":40327, "NewYork":69255, "LA":80024, "Washington":102739, "Revenue":474011, "Percent":37},<br>'
		+'		{"Year":2007, "Quarter":"3/4", "Month":9, "Seoul":101804, "Pusan":65098, "Incheon":79194, "NewYork":101669, "LA":30608, "Washington":73020, "Revenue":451393, "Percent":35},<br>'
		+'		{"Year":2007, "Quarter":"4/4", "Month":10, "Seoul":92130, "Pusan":91881, "Incheon":45166, "NewYork":65524, "LA":45348, "Washington":72708, "Revenue":412757, "Percent":36},<br>'
		+'		{"Year":2007, "Quarter":"4/4", "Month":11, "Seoul":80925, "Pusan":70537, "Incheon":25347, "NewYork":29360, "LA":76296, "Washington":42766, "Revenue":325230, "Percent":29},<br>'
		+'		{"Year":2007, "Quarter":"4/4", "Month":12, "Seoul":99008, "Pusan":30598, "Incheon":99124, "NewYork":22776, "LA":107805, "Washington":38384, "Revenue":397696, "Percent":35},<br>'
		+'		{"Year":2008, "Quarter":"1/4", "Month":1, "Seoul":68503, "Pusan":10155, "Incheon":47908, "NewYork":60857, "LA":104179, "Washington":109097, "Revenue":400699, "Percent":31},<br>'
		+'		{"Year":2008, "Quarter":"1/4", "Month":2, "Seoul":80573, "Pusan":75743, "Incheon":107750, "NewYork":76243, "LA":79265, "Washington":85345, "Revenue":504918, "Percent":40},<br>'
		+'		{"Year":2008, "Quarter":"1/4", "Month":3, "Seoul":23435, "Pusan":30538, "Incheon":86528, "NewYork":36735, "LA":96031, "Washington":96928, "Revenue":370196, "Percent":29},<br>'
		+'		{"Year":2008, "Quarter":"1/4", "Month":4, "Seoul":23435, "Pusan":30538, "Incheon":86528, "NewYork":36735, "LA":96031, "Washington":96928, "Revenue":370196, "Percent":29}];</font><br><br>'
		+'</pre>'
		,"className":"none_tutorial_child","displayList":true,"displayIndex":4
		,"displayBtn":"그리드에서 사용하게 될 데이터를 설정합니다."
	},{
		"index":5,"content":'<pre><font color="#0000ff">&#60/script></font><br><br></pre>',"className":"none_tutorial_child","displayList":true,"displayIndex":2
	},{
		"index":6,"content":"<pre><font color='#0000ff'>&#60;/head&#62;<br>&#60;body&#62;</font></pre>","className":"active_tutorial_child"
	},{
		"index":7,"content":'<pre>'
		+'	<font color="#0000ff">&#60;div><br>'
		+'		<font color="#4BBF5A">&#60;!-- 그리드가 삽입될 DIV --></font><br>'
		+'		&#60;div <font color="#ff0000">id="gridHolder" style="width:600px; height:400px;"</font>><br>'
		+'		&#60;/div><br>'
		+'	&#60;/div></font><br><br>'
		+'</pre>'
		,"className":"none_tutorial_child","displayList":true,"displayIndex":1
		,"displayBtn":"그리드가 보여질 영역을 설정합니다.<br>id 와 크기를 지정합니다."
	},{
		"index":8,"content":'<pre>'
		+'<font color="#0000ff">&#60;/body><br>'
		+'&#60;/html></font>'
		+'</pre>'
		,"className":"active_tutorial_child"
	},{
		"index":9,"content":''
		,"className":"none_tutorial_child","displayList":true,"displayIndex":5
		,"displayBtn":""
	}
],

/*
	properties이외에 추가로 테마 적용하지 않을 목록들
	n : 이름	c : 자식(서브메뉴)	u : URL
	t : 보여주지 않을 테마
		-1 : 모두
		0(오른쪽) ~ 6(왼쪽)
*/

none_theme = [];