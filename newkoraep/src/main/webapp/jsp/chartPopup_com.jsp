<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- rMateChart -->
<link rel="stylesheet" type="text/css" href="/rMateChart/rMateChartH5/Assets/Css/rMateChartH5.css"/>
<script language="javascript" type="text/javascript" src="/rMateChart/LicenseKey/rMateChartH5License.js"></script>
<script language="javascript" type="text/javascript" src="/rMateChart/rMateChartH5/JS/rMateChartH5.js"></script>
<script type="text/javascript" src="/rMateChart/rMateChartH5/Assets/Theme/theme.js"></script>

<!-- 샘플 작동을 위한 css와 js -->
<script type="text/javascript" src="/rMateChart/Web/JS/common.js"></script>
<script type="text/javascript" src="/rMateChart/Web/JS/sample_util.js"></script>
<link rel="stylesheet" type="text/css" href="/rMateChart/Web/sample.css"/>

<!-- SyntaxHighlighter -->
<script type="text/javascript" src="/rMateChart/Web/syntax/shCore.js"></script>
<script type="text/javascript" src="/rMateChart/Web/syntax/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="/rMateChart/Web/syntax/shCoreDefault.css"/>

<script type="text/javascript">
//-----------------------차트 설정 시작-----------------------

//rMate 차트 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
var chartVars = "rMateOnLoadCallFunction=chartReadyHandler";

//rMateChart 를 생성합니다.
//파라메터 (순서대로) 
//1. 차트의 id ( 임의로 지정하십시오. ) 
//2. 차트가 위치할 div 의 id (즉, 차트의 부모 div 의 id 입니다.)
//3. 차트 생성 시 필요한 환경 변수들의 묶음인 chartVars
//4. 차트의 가로 사이즈 (생략 가능, 생략 시 100%)
//5. 차트의 세로 사이즈 (생략 가능, 생략 시 100%)
rMateChartH5.create("chart1", "chartHolder", chartVars, "100%", "100%"); 

//차트의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
//rMate 차트 준비가 완료된 경우 이 함수가 호출됩니다.
//이 함수를 통해 차트에 레이아웃과 데이터를 삽입합니다.
//파라메터 : id - rMateChartH5.create() 사용 시 사용자가 지정한 id 입니다.
function chartReadyHandler(id) {
	document.getElementById(id).setLayout(layoutStr);
	document.getElementById(id).setData(opener.chartData);
}

//스트링 형식으로 레이아웃 정의.
var layoutStr = 
				'<rMateChart backgroundColor="#FFFFFF"  borderStyle="none">'
					+'<Options>'
						+'<Caption text="'+opener.textData['title']+'"/>'
						+'<SubCaption text="( % )" textAlign="right" />'
					+'</Options>'
					+'<NumberFormatter id="numFmt" useThousandsSeparator="true"/>'
					+'<Combination2DChart showDataTips="true">'
					/* 
					Combination2D 차트 생성시에 필요한 Combination2DChart 정의합니다 
					showDataTips : 데이터에 마우스를 가져갔을 때 나오는 Tip을 보이기/안보이기 속성입니다  
					 */		
						+'<horizontalAxis>'
							+'<CategoryAxis categoryField="STD" padding="0.7"/>' 
						+'</horizontalAxis>'
						+'<verticalAxis>'
							+'<LinearAxis id="vAxis1" formatter="{numFmt}" />' //maximum="2200"
						+'</verticalAxis>'
						+'<series>'
							+'<Column2DSet type="clustered">'
				 /*  
				Combination 차트에서는 Column차트와 Bar차트를 사용할때 Column2DSet(Colum2DSet),Bar2DSet(Bar2DSet)을 사용합니다
				예제로 Column2DSeries를 사용하려 할 때는 Column2DSet을 정의 후 +'<series>'와+'<Column2DSet>'을 정의합니다
				Column2DSet(Colum2DSet),Bar2DSet(Bar2DSet)의 Type은 일반 Type과 동일 합니다
				그러나 기본 Type은 overlaid입니다
				  */ 
								+'<series>'
									+'<Column2DSeries yField="VAL_1" displayName="'+opener.textData['displayNm1']+'" labelPosition="outside" showValueLabels="[]">'
										+'<fill>'
											+'<SolidColor color="#40b2e6"/>'
										+'</fill>'
										+'<showDataEffect>'
											+'<SeriesInterpolate/>' 
										+'</showDataEffect>'
									+'</Column2DSeries>'
									+'<Column2DSeries yField="VAL_2" displayName="'+opener.textData['displayNm2']+'" labelPosition="outside" showValueLabels="[]">'
										+'<fill>'
											+'<SolidColor color="#4453a8"/>'
										+'</fill>'
										+'<showDataEffect>'
											+'<SeriesInterpolate/>' 
										+'</showDataEffect>'
									+'</Column2DSeries>'
								+'</series>'
							+'</Column2DSet>'
							+'<Line2DSeries selectable="true" yField="VAL_LINE" radius="4.5" form="curve" displayName="'+opener.textData['displayNmLine']+'" itemRenderer="CircleItemRenderer">'
								+'<stroke>'
									+'<Stroke color="#f9bd03" weight="3"/>'
								+'</stroke>'
								+'<lineStroke>'
									+'<Stroke color="#f9bd03" weight="3"/>'
								+'</lineStroke>'
								+'<verticalAxis>'
									+'<LinearAxis id="vAxis2" formatter="{numFmt}" />' //interval="400" maximum="1800"
								+'</verticalAxis>'
								+'<showDataEffect>'
									+'<SeriesInterpolate/>' 
								+'</showDataEffect>'
							+'</Line2DSeries>'
						+'</series>'
						+'<verticalAxisRenderers>'
							+'<Axis2DRenderer axis="{vAxis1}" showLine="false"/>'
							+'<Axis2DRenderer axis="{vAxis2}" showLine="false"/>'
						+'</verticalAxisRenderers>'
					+'</Combination2DChart>'
				+'</rMateChart>';

//차트 데이터
var chartData = [{"Month":"Jan","Profit":400,"Cost":550,"Revenue":550},
						{"Month":"Feb","Profit":650,"Cost":800,"Revenue":900},
						{"Month":"Mar","Profit":1400,"Cost":1600,"Revenue":1500},
						{"Month":"Apr","Profit":1000,"Cost":700,"Revenue":900},
						{"Month":"May","Profit":300,"Cost":650,"Revenue":450},
						{"Month":"Jun","Profit":800,"Cost":700,"Revenue":780},
						{"Month":"Jul","Profit":600,"Cost":400,"Revenue":420}];

/**
* rMateChartH5 3.0이후 버전에서 제공하고 있는 테마기능을 사용하시려면 아래 내용을 설정하여 주십시오.
* 테마 기능을 사용하지 않으시려면 아래 내용은 삭제 혹은 주석처리 하셔도 됩니다.
*
* -- rMateChartH5.themes에 등록되어있는 테마 목록 --
* - simple
* - cyber
* - modern
* - lovely
* - pastel
* -------------------------------------------------
*
* rMateChartH5.themes 변수는 theme.js에서 정의하고 있습니다.
*/
rMateChartH5.registerTheme(rMateChartH5.themes);

/**
* 샘플 내의 테마 버튼 클릭 시 호출되는 함수입니다.
* 접근하는 차트 객체의 테마를 변경합니다.
* 파라메터로 넘어오는 값
* - simple
* - cyber
* - modern
* - lovely
* - pastel
* - default
*
* default : 테마를 적용하기 전 기본 형태를 출력합니다.
*/
function rMateChartH5ChangeTheme(theme){
	document.getElementById("chart1").setTheme(theme);
}

//-----------------------차트 설정 끝 -----------------------

	trgtId = '';
	trgtName = '';
	// 이미지 저장
	function saveAsImage(id){
		trgtId = id;
				
	    // IE 판별
	    if(compIE())
	        menus.items[0].callback();
	}
	
	function compIE(){
		   var agent = navigator.userAgent;
		    if(agent.indexOf("MSIE 7.0") > -1 || agent.indexOf("MSIE 8.0") > - 1 || agent.indexOf("Trident 4.0") > -1){
		        alert("IE7,8 에서는 이미지 변환 및 전송기능이 지원되지 않습니다.");
		       return false;
		   }
		   if(document.documentMode && document.documentMode <= 5){
		     alert("쿼크모드에서는 이미지 변환 및 전송기능이 지원되지 않습니다.");
		     return false;
		   }
		   return true;
	}
	/* 	// 데이터 에디터를 사용할 경우 
	chartVars += "&useDataEditor=true";
	
	// 차트 메뉴를 사용할 경우
	chartVars += "&chartMenu=menus"; */
	// 차트메뉴에 설정할 데이터
	var menus = {
	 options : {
	     textField : "name", // 메뉴에 출력할 메뉴 아이템의 문자열
	      callbackField : "callback" // 메뉴 아이템 클릭 시 실행할 콜백 함수
	 }, 
	 items : [
	       {
	           name : "PNG 저장",
	            callback : function(){
	              /**
	              * rMateChartH5 - 저장되어지는 파일 명
	                * png - 확장자
	                 * http://../downloadLocal.jsp - IE 9 혹은 로컬 다운로드를 지원하지 않는 브라우저를 위한 다운로드 jsp 서버 경로
	                * function(){ .. } - 다운받으려는 데이터 base64 인코딩 하여 반환하는 함수
	               */
	             rMateChartH5.downloadToLocal("rMateChartH5", "png", "http://demo.riamore.net/demo/chart/downloadLocal.jsp", function(){
	                 return document.getElementById(trgtId).saveAsImage();
	             });
	         }
	       }
	   ]
	};


</script>

<style>
.btn36 {display: inline-block; box-sizing: border-box; height: 36px; border: none; padding: 0 10px; border-radius: 5px; font-weight: 700; font-size: 14px; line-height: 34px; text-align: center; vertical-align: top; cursor: pointer; outline: none; -webkit-appearance: none; appearance: none; box-shadow: 0px 2px 0px 0px rgba(189, 189, 189, 1); transition: all .2s;}
.btn36.c2 {border: 1px solid #478bbd; background: #478bbd; color: #ffffff;} /* 푸른색 */
.btn36:hover {transform: translateY(2px); box-shadow: none;}
</style>

</head>
<body>

	<div class="wrapper">
		<div id="content" style="margin-top:10px">
			<!-- 차트가 삽입될 DIV -->
			<div id="chartHolder"></div>
		</div>
	</div>
		
	<div>
		<button type="button" class="btn36 c2" style="width: 100px;margin:10px" onclick="saveAsImage('chart1')" >이미지저장</button>
	</div>
		
</body>
</html>
