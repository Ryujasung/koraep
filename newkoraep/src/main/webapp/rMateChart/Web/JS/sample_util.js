// sample url load complete handler
window.onload = function(){
	frameLoadHandler();
};

// unload handler - remove event
function frameUnLoadHandler(event){
	var remove = "remove",
		layout = _$("updaterTareaLayout"),
		data = _$("updaterTareaData");

	demoEvent(remove, _$("updaterTabUl"), "click", tabMouseHandler);
	demoEvent(remove, _$("btn_update"), "click", updateClickHandler);

	demoEvent(remove, layout, "keydown", textAreaEventHandler);
	demoEvent(remove, layout, "keyup", textAreaEventHandler);
	demoEvent(remove, layout, "focus", textAreaEventHandler);

	demoEvent(remove, data, "keydown", textAreaEventHandler);
	demoEvent(remove, data, "keyup", textAreaEventHandler);
	demoEvent(remove, data, "focus", textAreaEventHandler);

	demoEvent(remove, window, "unload", frameUnLoadHandler);
}

function sampleCheck(str){
	var i, compSample = ["Slide"];
	str = str.substring(str.lastIndexOf("/") + 1, str.length);

	for(i = 0 ; i < compSample.length ; i += 1){
		if(str.indexOf(compSample[i]) > -1)
			return false;
	}
	return true;
}

// sample load complete handler
function frameLoadHandler(){

	return; //에러남...
	
	var dataTabStr = "",
		layoutTabStr = "",
		tarea = _$("updaterTarea"),
		layout = _$("updaterTareaLayout"),
		data = _$("updaterTareaData"),
		updatePossible = sampleCheck(this.location.href);
	
	if(updatePossible && window.layoutStr){
		layoutTabStr = inputTab(window.layoutStr);
	}else{
		layoutTabStr = "해당 샘플은 레이아웃을 수정할 수 없습니다.";
		layout.disabled = true;
	}

	if(updatePossible && window.chartData && typeof window.chartData[0] == "object" && !window.chartData[0].length && !window.chartData[0].items)
		dataTabStr = objectToString(window.chartData);
	else{
		dataTabStr = "해당 샘플은 데이터를 수정할 수 없습니다."
		data.disabled = true;
	}

	//stringToObject(dataTabStr);
	
	// highlighter의 버그로 tadiv에 더블클릭 시 이벤트 전파를 중단한다.
	if(tarea.addEventListener)
		tarea.addEventListener("dblclick", dblclickStop, true);
	else
		tarea.attachEvent("dblclick", dblclickStop, true);

	layout.value = layoutTabStr;
	data.value = dataTabStr;

	layout.style.height =  layout.scrollHeight + "px";
	data.style.height =  data.scrollHeight + "px";
	
	if(window.location.pathname.indexOf("HugeData") > -1)
		changeTab(_$("updaterTabUlLayout"));
	else
		changeTab(_$("updaterTabUlSource"));
	
	addEventHandler();
}

// add event
function addEventHandler(){
	var add = "add",
		layout = _$("updaterTareaLayout"),
		data = _$("updaterTareaData");

	demoEvent(add, _$("updaterTabUl"), "click", tabMouseHandler);
	demoEvent(add, _$("btn_update"), "click", updateClickHandler);

	demoEvent(add, layout, "keydown", textAreaEventHandler);
	demoEvent(add, layout, "keyup", textAreaEventHandler);
	demoEvent(add, layout, "focus", textAreaEventHandler);

	demoEvent(add, data, "keydown", textAreaEventHandler);
	demoEvent(add, data, "keyup", textAreaEventHandler);
	demoEvent(add, data, "focus", textAreaEventHandler);

	demoEvent("add", window, "unload", frameUnLoadHandler);
}

function tabMouseHandler(event){
	var target = event.target || event.srcElement,
		id = target.id;
	
	if(id.length < 1 || target === event.currentTarget)
		return;
	
	changeTab(_$(id));
}

// double click event stop propagation updaterTarea
function dblclickStop(event){
	event.stopPropagation();
}

// acitve tab change
function changeTab(elem){
	var tabs, role, tarea,
		updateBtn = _$("btn_update"),
		dataTab = _$("updaterTabUlData"),
		layoutTab = _$("updaterTabUlLayout"),
		sourceTab = _$("updaterTabUlSource");
	
	if(elem === _$("updaterTabUlBlank") || elem === updateBtn)
		return;

	tabs = [layoutTab, dataTab, sourceTab];

	for(var i = 0, n = tabs.length ; i < n ; i += 1){
		role = (tabs[i] === elem) ? "add" : "remove";
		modiClass(tabs[i], role, "active_tab");
		
		tarea = _$(tabs[i].id.replace("TabUl", "Tarea"));
		tarea.style.display = role == "add" ? "inline-block" : "none";
	}
	// display change update button
	updateBtn.style.display = (elem.id.indexOf("Source") > -1) ? "none" : "inline-block";

	if(elem === sourceTab && !elem._highlightInit && (elem._highlightInit = true)){
		var script, scripts = document.getElementsByTagName("script");
		for(var i = 0, n = scripts.length ; i < n ; i += 1){
			script = scripts[i];
			if(script.nodeType === 1 && script.nodeName.toLowerCase() === "script" && script.text !== "")
				break;
		}

		_$("updaterTareaSource").innerHTML = script.text.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\r/g, "").replace(/\r\t/g, "&nbsp;&nbsp;&nbsp;&nbsp;").replace(/\n/g, "<br>");

		// source 탭이 활성화 되어있을 경우에만 HighLighter 실행
		SyntaxHighlighter.config.bloggerMode = true;
		SyntaxHighlighter.highlight();
		SyntaxHighlighter.all();
	}
}

// count를 가지고 여백을 추가한다. 지금은 &nbsp; * 4
function addTabTag(count){
	var tabStr = "";
	for (var i = 0, n = count; i < n; i++)
		tabStr += "    ";
	return tabStr;
}

// 일렬로 된 layout을 가지고 개행처리와 들여쓰기를 적용합니다.
function inputTab(layout) {
	
	var i, n,
		str,
		retStr = "",
		tabCount = 0, // 들여쓰기 카운트
		strArr = layout.split("<");

	for (i = 0, n = strArr.length; i < n; i++) {
		str = strArr[i];

		if (str === "")
			continue;

		// split으로 인하여 "<"가 제거가 됨 이를 다시 더해줌
		str = "<" + str;
		str = str.replace(/^\s+|\s+$/g, '');

		// 주석이면 indent없이 문장만 더함
		if (str.indexOf("<!--") === 0) {
			retStr += (str + "\n");
			continue;
		}

		// str이 "</"으로 시작한다면 tabCount를 빼준다.
		if (str.indexOf("</") > -1)
			tabCount--;

		// tabCount를 가지고 들여쓰기를 설정합니다.
		retStr += (addTabTag(tabCount) + str + "\n");

		// "/>" 나 "</"가 아닐 경우 tabCount를 더해준다.
		if (str.indexOf("/>") < 0 && str.indexOf("</") < 0)
			tabCount++;
	}
	return retStr;
}

// 배열 데이터를 스트링 형태로 변환한다
function objectToString(obj) {
	var data,
		retStr = "";
	for (var i = 0, n = obj.length; i < n; i++) {
		data = obj[i];
		retStr += "{\n";
		for (var o in data) {
			retStr += addTabTag(2) + "\"" + o + "\" : ";
			if (typeof data[o] === "string")
				retStr += "\"" + data[o] + "\"";
			else if(data[o] == null)
				retStr += "null";
			else if(data[o].length != undefined)
				retStr += "[" + data[o] + "]";
			else
				retStr += data[o];
			retStr += ",\n";
		}
		retStr = retStr.substring(0, retStr.length - 2) + "\n}";	 // 2는 ", " 를 지우기위해
		if (i != obj.length - 1)
			retStr += ",";
	}
	return retStr;
}

// data tab에서 변경된 스트링 데이터들을 배열형태로 변경해준다
function stringToObject(str) {
	var o,
		item,
		strArr,
		field, value,
		data = [];

	if(!str)
		return [];

	str = (str + ",").replace(/{|"|\r|\n/g,"");
	strArr = str.split("},");
	for (var i = 0, n = strArr.length; i < n; i++) {
		str = strArr[i];
		if (str == "")
			continue;
		str = str.split(", ");
		o = {};
		for (var j = 0, m = str.length; j < m; j++) {
			item = str[j].split(":");
			field = item[0].trim();
			value = item[1].trim();
			
			// datetime value
			if(item.length > 2)
				value = str[j].substring(str[j].indexOf(":") + 1, str[j].length).trim();

			if(value.charAt(0) == "[" && value.charAt(value.length - 1) == "]"){
				var tempValue = value.replace(/\[|\]/g, "").split(",");
				value = [];
				for(var strI = 0, strN = tempValue.length ; strI < strN ; strI += 1)
					value.push(Number(tempValue[strI]));
			}

			o[field] = !isNaN(value) ? Number(value) : value;
		}
		data.push(o);
	}
	return data;
}

// check layout
function checkXML(layout){
	var xml, parser;
	try{
		if(window.DOMParser){
			parser = new DOMParser();
			xml = parser.parseFromString(layout, "text/xml");
		}else{
			xml = new ActiveXObject("Microsoft.XMLDOM");
			xml.async = false;
			xml.loadXML(layout);
		}
	}catch(e){
		return false;
	}

	if(!xml || xml.textContent === "")
		return false;

	parser = xml.documentElement;

	if((!parser && xml.parseError) || (!parser || !parser.nodeName || parser.nodeName === "parsererror") || (parser.firstElementChild && parser.firstElementChild.nodeName === "parsererror"))
		return false;

	return true;
}

//updateButtonClick Handler
function updateClickHandler(e){
	//window.scroll(0, 0);
	var data, tempLayout,
		tlayout = _$("updaterTareaLayout"),
		tdata = _$("updaterTareaData"),
		chart = document.getElementById("chart1");
	
	if(tarea_layout_dirty){
		tempLayout = tlayout.value;
		if(tempLayout.length < 1 || !checkXML(tempLayout)){
			alert("레이아웃의 XML 형태가 올바르지 않습니다.\n확인 후 다시 시도하여 주십시오.");
			return;
		}
		
		tempLayout = tempLayout.replace(/rMateChart/g, "");
		if(!tempLayout.match(/Chart|Gauge/)){
			alert("레이아웃에 Chart 혹은 Gauge객체가 설정되어있지 않습니다.\n확인 후 다시 시도하여 주십시오.");
			return;
		}
		chart.setLayout(tlayout.value);
	}

	if(tarea_data_dirty){
		data = stringToObject(tdata.value);
		if(!(typeof data === "object" && data.length >= 0)){
			alert("데이터의 배열 형태가 올바르지 않습니다.\n확인 후 다시 시도하여 주십시오.");
			return;
		}
		chart.setData(data);
	}

	window.scroll(0, 0);

	//초기화
	tarea_layout_dirty = tarea_data_dirty = false;

	if(window.updateClickAfter)
		window.updateClickAfter();
}

var shiftDirty = false,
	tarea_layout_dirty = false, // layout textarea가 수정되었는지
	tarea_data_dirty = false; // data textarea가 수정되었는지
// 이 값을 보고 layout만 변경할지 data만 변경할지 모두 변경할지 결정합니다.

// textarea, textdata event handler
function textAreaEventHandler(event){
	var tarea = event.target || event.srcElement,
		keyCode = event.keyCode,
		tareaHeight = 0,
		tadiv = _$("updaterTarea"),
		updiv = _$("updater"),
		resize = false, // 엔터, 백스페이스 등이 눌렸을 때 ( 개행처리 변경 )
		headText, // 키 커서를 기준으로 이전 텍스트들
		tailText, // 키 커서를 기준으로 다음 텍스트들
		space = "    ", // tab키를 눌렀을 경우 추가 텍스트
		sindex, // 키 커서 시작 인덱스
		pageY = window.pageYOffset, // 스크롤 위치
		textAreaMaxHeight = parseInt(getStyle(tarea, "maxHeight"));

	switch(event.type){
		case "keydown":
				if (keyCode == 9) { // tab 키
					if (!tarea.selectionStart)
						alert("IE 7, 8에서는 Tab키를 지원하지 않습니다.");
					sindex = tarea.selectionStart;
					if(!shiftDirty){
						headText = tarea.value.substring(0, sindex);
						tailText = tarea.value.substring(sindex, tarea.value.length);
						tarea.value = headText + space + tailText;
						tarea.selectionStart = tarea.selectionEnd = sindex + space.length;
					}else
						tarea.selectionStart = tarea.selectionEnd = sindex - space.length;
					if (event.preventDefault)
						event.preventDefault();
				} else if (keyCode == 13 || keyCode == 46 || keyCode == 8)
					resize = true;
				else if(keyCode == 16)
					shiftDirty = true;
			break;
		case "keyup":
				if (keyCode == 8)
					resize = true;
				else if(keyCode == 16)
					shiftDirty = false;
			break;
		case "focus":
			shiftDirty = false;
			break;
		default:
			break;
	}

	// 개행처리가 변경이 되었을 경우
	if(resize){
		tarea.style.height = "1px";
		tareaHeight = tarea.scrollHeight;
		if(keyCode == 13)
			tareaHeight += 16;
		if(tareaHeight > textAreaMaxHeight){
			tareaHeight = textAreaMaxHeight;
		}
		tarea.style.height = tareaHeight + "px";

		if(keyCode == 13 || keyCode == 46 || keyCode == 8)
			window.scroll(0, pageY || tarea.scrollHeight);
	}

	if (tarea === _$("updaterTareaLayout"))
		tarea_layout_dirty = true;
	else if (tarea === _$("updaterTareaData"))
		tarea_data_dirty = true;

	if (keyCode == 9)
		return false;
}