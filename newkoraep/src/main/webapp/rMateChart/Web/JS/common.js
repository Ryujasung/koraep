// setup event
function demoEvent(role, target, type, handler) {
	var event;
	if (role == "add") {
		event = "addEventListener";
		if (!window[event]) {
			event = "attachEvent";
			type = "on" + type;
		}
	} else {
		event = "removeEventListener";
		if (!window[event]) {
			event = "detachEvent";
			type = "on" + type;
		}
	}
	if (window[event])
		target[event](type, handler);
}

// get element id
function _$(id){
	return document.getElementById(id);
}

// return create element name
function _C(name){
	return document.createElement(name);
}

function getStyle(elem, name){
	if(window.getComputedStyle)
		return window.getComputedStyle(elem)[name];
	else{
		if(elem.style[name])
			return elem.style[name];
		else
			return elem.currentStyle[name];
	}
}

// change element classname 
function modiClass(target, role, name){
	var cname = target.className;
	if(role == "add")
		cname += " " + name;
	else
		cname = cname.replace(new RegExp(name, "gi"), "");
	target.className = cname;
}