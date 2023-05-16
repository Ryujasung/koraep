;(function($, window, undefined){
	'use strict';

	/* 캘린더 */
	$.fn.YJcalendar = function(options){
		// from, to input name 저장
		var fromName = options.fromName;
		var toName = options.toName;
		
		if(!this.length) return this;

		if(this.length > 1){
			this.each(function(){
				$(this).YJcalendar(options);
			});
			return this;
		}

		var defaults = {
			// 옵션 기본값
			triggerBtn : false,
			format : 'yyyy-mm-dd',
			monthNavi : true,
			yearNavi : true,
			yearText : '년',
			monthText : '월',
			yearSelect : false,
			monthSelect : false,
			yearSelectStart : null,
			yearSelectEnd : null,
			fromName : null,
			toName : null,
			todayBtn : true,
			todayBtnText : '오늘',
			closeBtn : true,
			closeBtnText : '닫기',
			weekEndDisabled : false,
			daysName : ['일','월','화','수','목','금','토'],
			headMonth : ['01','02','03','04','05','06','07','08','09','10','11','12'],
			btnPrevMonthText : '이전달',
			btnNextMonthText : '다음달',
			btnPrevYearText : '이전해',
			btnNextYearText : '다음해',
			disabledDay : [], //특정 일 형식 mmdd , yyyymmdd
			holiday : ['0101','0301','0505','0525','1225'], //공휴일 형식 mmdd , yyyymmdd

			dateSetting : '', //셋팅일자
			
			//callback함수
			changeDate : function(){}
		}

		var el		= el = this;
		var object	= object = {};
		var option	= option = {};
    
		var init = function(){
			initSetting();
			setup();
		}

		var initSetting = function(){
			//변수저장
			option = $.extend({}, defaults, options);
			option.typeBLOCK = el[0].tagName == 'DIV';
			option.typeINPUT = el[0].tagName == 'INPUT';
			object.weekCount = 0;

			formatCheck();
			newDate();
		}

		var setup = function(){
			//마크업셋팅
			if(option.typeBLOCK){
				DIVsettings(option.type);
			}
			if(option.typeINPUT){
				INPUTsettings();
			}

			start();
		}

		var start = function(){
			//실행함수
			makeCalendar();

			if(option.typeINPUT){
				bindInputFocus();
				bindSetDate();
			}
		}

		var makeCalendar = function(){
			dateSettings();

			object.markup = '';
			
			getPrevMonth(); //이전달 구하기 : object.date.prevMonth
			getMonthOneDay(); //이달 1일의 요일 구하기 : object.date.thisMonthOneDay
			theadMarkup(); //달력 head 마크업

			//이전달 마크업
			for(var i = 1 ; i <= object.date.thisMonthOneDay ; i++){
				if(object.weekCount == 0){
					object.markup += '<tr>';
				}
				object.markup += '<td class="disabled">' + (object.date.monthLength[object.date.prevMonth] - object.date.thisMonthOneDay + i) +'</td>';
				object.weekCount++;
			}

			//이번달 마크업
			for(var i = 1 ; i <= object.date.monthDate ; i++){
				object.date.date = i;
				object.date.dateStr = String((object.date.date)).length == 1 ? '0'+String((object.date.date)) : String((object.date.date));
				object.date.dateDNA = object.date.yearMonthStr+object.date.dateStr;

				if(object.weekCount == 0){
					object.markup += '<tr>';
				}

				object.markup += '<td date="'+object.date.dateDNA+'">'+i+'</td>';

				object.weekCount++;

				if(object.weekCount == 7){
					object.markup += '</tr>';
					object.weekCount = 0;
				}
			}

			//다음달 마크업
			for(var i = 1 ; object.weekCount !=0 ; i++){
				if(object.weekCount == 7){
					object.markup += '</tr>';
					object.weekCount = 0;
				}else{
					object.markup += '<td class="disabled">'+i+'</td>';
					object.weekCount++;
				}
			}

			object.markup += '</tbody></table>';

			object.body.html(object.markup);

			addHeadMarkup(); // 달력 상단 마크업
			dateCellAddClass(); // td에 클래스 입히기
			bindCellClick(); // cell클릭 이벤트
			bindBtnClick(); // 이전달 다음달 버튼 클릭 이벤트
			addFootButton(); //당력 하단 마크업
		}

		var theadMarkup = function(){
			object.markup += '<table>'+
							 '<thead>';
			for(var i = 0 ; i < 7 ; i++){
				object.markup += '<th>'+option.daysName[i]+'</th>';
			}
			object.markup += '</tr>'+
							 '</thead>'+
							 '<tbody>';
		}

		var defaultDate = function(){
			object.input.format = object.input.val();

			var dna = object.input.format;
			var dnaYear, dnaMonth, dnaDate;

			object.input.dnaYear = String(dna.substring(option.formatYs, option.formatYe));
			object.input.dnaMonth = String(dna.substring(option.formatMs, option.formatMe));
			object.input.dnaDate = String(dna.substring(option.formatDs, option.formatDe));

			object.input.dna = object.input.dnaYear+object.input.dnaMonth+object.input.dnaDate;

			object.input.attr('date', object.input.dna);
		}

		var newDate = function(){
			object.date = new Date();
			object.date.todayYear = object.date.getFullYear();
			object.date.todayMonth = object.date.getMonth();
			object.date.monthLength = [31,28,31,30,31,30,31,31,30,31,30,31];

			dateSettings();

			object.date.todayDNA = object.date.dateDNA;
		}

		var addFootButton = function() {
		    object.foot.empty();
		    
		    if(option.todayBtn){
			object.foot.append('<button class="YJcalendar-btn-today">'+option.todayBtnText+'</button>');
			bindTodayClick();
		    }

		    if(option.closeBtn){
			object.foot.append('<button class="YJcalendar-btn-close">'+option.closeBtnText+'</button>');
			bindCloseClick();
		    }
		}
		
		var addHeadMarkup = function(){
			object.head.empty();
			object.head.yearMonth = object.head.append('<div class="YJcalendar-select-area"></div>').children('.YJcalendar-select-area');

			if(option.yearSelect){
				addYearSelect();
			}else{
				object.head.yearMonth.append('<span class="YJcalendar-year">'+object.date.year+option.yearText+'</span>');
			}

			if(option.monthSelect){
				addMonthSelect();
			}else{
				object.head.yearMonth.append('<span class="YJcalendar-month">'+(object.date.thisMonth+1)+option.monthText+'</span>');
			}

			if(option.monthNavi){
				object.head.prevMonth = object.head.append('<button class="YJcalendar-month-prev">'+option.btnPrevMonthText+'</button>').children('.YJcalendar-month-prev');
				object.head.nextMonth = object.head.append('<button class="YJcalendar-month-next">'+option.btnNextMonthText+'</button>').children('.YJcalendar-month-next');
			}

			if(option.yearNavi){
				object.head.prevYear = object.head.append('<button class="YJcalendar-year-prev">'+option.btnPrevYearText+'</button>').children('.YJcalendar-year-prev');
				object.head.nextYear = object.head.append('<button class="YJcalendar-year-next">'+option.btnNextYearText+'</button>').children('.YJcalendar-year-next');
			}
			
		}

		var addYearSelect = function(){
			object.head.yearSelect = '<select class="YJcalendar-year-select">';
			option.yearSelectStart = option.yearSelectStart ? option.yearSelectStart : object.date.todayYear - 100;
			option.yearSelectEnd = option.yearSelectEnd ? option.yearSelectEnd : object.date.todayYear;
			for(var i = option.yearSelectEnd ; i >= option.yearSelectStart ; i--){
				if(i == object.date.year){
					object.head.yearSelect += '<option value="'+i+'" selected>'+i+'</option>';
				}else{
					object.head.yearSelect += '<option value="'+i+'">'+i+'</option>';
				}
			}
			object.head.yearSelect += '</select>'+option.yearText;
			
			object.head.yearMonth.append(object.head.yearSelect);

			object.head.yearSelect = object.head.yearMonth.find('.YJcalendar-year-select');
			object.head.yearSelect.option = object.head.yearSelect.find('option');

			yearSelectChange();
		}

		var yearSelectChange = function(){
			object.head.yearSelect.change(function(){
				object.date.setFullYear($(this).val());
				makeCalendar();
			});
		}

		var addMonthSelect = function(){
			object.head.monthSelect = '<select class="YJcalendar-month-select">';
			for(var i = 1 ; i <= 12 ; i++){
				if(i == (object.date.thisMonth+1)){
					object.head.monthSelect += '<option value="'+i+'" selected>'+i+'</option>';
				}else{
					object.head.monthSelect += '<option value="'+i+'">'+i+'</option>';
				}
			}
			object.head.monthSelect += '</select>'+option.monthText;
			
			object.head.yearMonth.append(object.head.monthSelect);

			object.head.monthSelect = object.head.yearMonth.find('.YJcalendar-month-select');
			object.head.monthSelect.option = object.head.monthSelect.find('option');

			monthSelectChange();
		}

		var monthSelectChange = function(){
			object.head.monthSelect.change(function(){
				object.date.setMonth(($(this).val()-1));
				makeCalendar();
			});
		}

		var bindTodayClick = function(){
			object.foot.today = object.foot.find('.YJcalendar-btn-today');
			
			object.foot.today.on('click', function(){
				newDate();
				makeCalendar();
			});
		}
		
		var bindCloseClick = function() {
			object.foot.close = object.foot.find('.YJcalendar-btn-close');
			
			object.foot.close.on('click', function(){
			    	$('.YJcalendar-wrap').removeClass('open');
			});
		    
		}

		var bindCellClick = function(){
			object.cell.on('click', function(){
				if($(this).hasClass('disabled')) return;


				if(option.typeINPUT){
					object.input.dna = this.date;
					object.input.format = formatConvert(this.date);

					object.input.attr('date',this.date);
					object.input.val(object.input.format);
					object.wrap.removeClass('open');
				}

				if(option.typeINPUT){
					option.changeDate(object.input.dna, object.input.format);
				}

				
				// 종료일이 시작일보다 클 경우 같은 일자로 셋팅
				if(fromName){
					object.from = $('input[name='+fromName+']');
					object.from.date = object.from.attr('date');
					
					if(this.date < object.from.date){
						object.from.attr('date', this.date);
						object.from.val(formatConvert(this.date));
					}
				}

				// 시작일이 종료일보다 클 경우 같은 일자로 셋팅
				if(toName){
					object.to = $('input[name='+toName+']');
					object.to.date = object.to.attr('date');
					
					if(this.date > object.to.date){
						object.to.attr('date', this.date);
						object.to.val(formatConvert(this.date));
					}
				}
			
				
				//날짜 선택시 change 이벤트
				object.input.trigger('change');
				
			});
		}

		var formatCheck = function(){
			var format = option.format;
			option.formatYs = format.indexOf('y');
			option.formatYe = format.lastIndexOf('y')+1;
			option.formatMs = format.indexOf('m');
			option.formatMe = format.lastIndexOf('m')+1;
			option.formatDs = format.indexOf('d');
			option.formatDe = format.lastIndexOf('d')+1;

			option.formatYear = String(format.substring(option.formatYs, option.formatYe));
			option.formatMonth = String(format.substring(option.formatMs, option.formatMe));
			option.formatDate = String(format.substring(option.formatDs, option.formatDe));
		}

		var formatConvert = function(dateDNA){
			
			if(dateDNA == '') return '';
			
			var format, year, month, date;

			if(option.formatYear.length == 2){
				year = String(dateDNA.substring(2, 4));
			}else{
				year = String(dateDNA.substring(0, 4));
			}
			month = String(dateDNA.substring(4, 6));
			date = String(dateDNA.substring(6, 8));

			format = option.format.replace(option.formatYear, year).replace(option.formatMonth, month).replace(option.formatDate, date);

			return format;
		}

		var dateCellAddClass = function(){
			object.cell = object.body.find('td');

			object.cell.each(function(){
				this.index = $(this).index(); //해당요일
				this.date = $(this).attr('date'); //해당날짜 ex) 20161102
				this.mmdd = String(this.date).substring(4, 8);

				for(var i = 0 ; i < option.disabledDay.length ; i++){
					if(option.disabledDay[i].length == 4 && this.mmdd == option.disabledDay[i]){
						$(this).addClass('disabled');
					}
					if(option.disabledDay[i].length == 8 && this.date == option.disabledDay[i]){
						$(this).addClass('disabled');
					}
				};

				for(var i = 0 ; i < option.holiday.length ; i++){
					if(option.holiday[i].length == 4 && this.mmdd == option.holiday[i]){
						$(this).addClass('holiday');
					}
					if(option.holiday[i].length == 8 && this.date == option.holiday[i]){
						$(this).addClass('holiday');
					}
				};

				if(this.index == 0){
					$(this).addClass('sunday');
					if(option.weekEndDisabled){
						$(this).addClass('disabled');
					}
				};

				if(this.index == 6){
					$(this).addClass('saturday');
					if(option.weekEndDisabled){
						$(this).addClass('disabled');
					}
				}

				if(this.date == object.date.todayDNA) $(this).addClass('today');

				if(option.typeINPUT){
					if(object.input.dna && object.input.dna == this.date){
						$(this).addClass('selected');
					};

					if(option.fromName && object.from.date == this.date){
						$(this).addClass('selected');
					};

					if(option.fromName && object.input.dna && object.from.date < this.date && object.input.dna > this.date){
						$(this).addClass('selected');
					};

					if(option.toName && object.to.date == this.date){
						$(this).addClass('selected');
					};

					if(option.toName && object.input.dna && object.to.date > this.date && object.input.dna < this.date){
						$(this).addClass('selected');
					};
				};

				if(option.fromName && object.from.date){
					if(this.date < object.from.date){
						//disable 하지 않고 선택 가능하도록 수정
						//$(this).addClass('disabled');
					}
				};

				if(option.toName && object.to.date){
					if(this.date > object.to.date){
						//disable 하지 않고 선택 가능하도록 수정
						//$(this).addClass('disabled');
					}
				};
			});
		}

		var dateSettings = function(){
			object.date.year = object.date.getFullYear();
			object.date.thisMonth = object.date.getMonth();
			object.date.thisMonthStr = String((object.date.thisMonth+1)).length == 1 ? '0'+String((object.date.thisMonth+1)) : String((object.date.thisMonth+1));

			//윤달계산 실행
			getLeapMonth();

			object.date.monthDate = object.date.monthLength[object.date.thisMonth];
			object.date.yearMonth = object.date.year+'. '+(object.date.thisMonth+1);
			object.date.yearMonthStr = object.date.year+object.date.thisMonthStr;

			object.date.date = object.date.getDate();
			object.date.dateStr = String((object.date.date)).length == 1 ? '0'+String((object.date.date)) : String((object.date.date));
			object.date.dateDNA = object.date.yearMonthStr+object.date.dateStr;

			if(option.fromName){
				object.from = $('input[name='+option.fromName+']');
				object.from.date = object.from.attr('date');
			}

			if(option.toName){
				object.to = $('input[name='+option.toName+']');
				object.to.date = object.to.attr('date');
			}
		}

		var DIVsettings = function(){
			object.wrap = el.html('<div class="YJcalendar-wrap YJcalendar-type-block" />').children('.YJcalendar-wrap');
			layoutSettings();
		}

		var INPUTsettings = function(){
			el.wrap('<div class="YJcalendar-wrap YJcalendar-type-input" />');
			object.wrap = el.parent();
			object.input = el;
			object.input.dna = object.input.val();
			
			if(option.dateSetting != ''){

				object.date.setFullYear(option.dateSetting.substring(0,4));
				object.date.setMonth(option.dateSetting.substring(4,6) - 1);

				//기본일자셋팅
				object.input.dna = option.dateSetting;
				object.input.format = formatConvert(option.dateSetting);
				object.input.attr('date', option.dateSetting);
				object.input.val(object.input.format);

			}
			
			if(option.triggerBtn){
				object.input.triggerBtn = object.wrap.append('<button class="YJcalendar-trigger">달력열기</button>').children('.YJcalendar-trigger');
			}

			layoutSettings();

			if(el.val()){
				defaultDate();
			}
		}

		var layoutSettings = function(){
			object.wrap.inner = object.wrap.append('<div class="YJcalendar-inner" />').children('.YJcalendar-inner');
			object.wrap.inner.append('<div class="YJcalendar-head" />');
			object.wrap.inner.append('<div class="YJcalendar-body" />');
			object.wrap.inner.append('<div class="YJcalendar-foot" />');
			object.head = object.wrap.inner.children('.YJcalendar-head');
			object.body = object.wrap.inner.children('.YJcalendar-body');
			object.foot = object.wrap.inner.children('.YJcalendar-foot');
		}

		var getLeapMonth = function(){
			if((object.date.year % 4 == 0 && object.date.year % 100 != 0) || object.date.year % 400 == 0){
				object.date.monthLength[1] = 29;
			}else{
				object.date.monthLength[1] = 28;
			}
		}

		var getPrevMonth = function(){
			object.date.setMonth(object.date.getMonth()-1);
			object.date.prevMonth = object.date.getMonth();
			object.date.setMonth(object.date.getMonth()+1);
		}

		var getMonthOneDay = function(){
			object.date.setDate(1);
			object.date.thisMonthOneDay = object.date.getDay();
		}

		var bindBtnClick = function(){
			if(option.monthNavi){
				object.head.prevMonth.on('click', function(){
					object.date.setMonth(object.date.getMonth() - 1);
					if(option.yearSelect && object.date.getFullYear() < option.yearSelectStart){
						return;
					}else{
						makeCalendar();
					}
				});

				object.head.nextMonth.on('click', function(){
					object.date.setMonth(object.date.getMonth() + 1);
					if(option.yearSelect && object.date.getFullYear() > option.yearSelectEnd){
						return false;
					}else{
						makeCalendar();
					}
				});
			}
			
			if(option.yearNavi){
				object.head.prevYear.on('click', function(){
					object.date.setFullYear(object.date.getFullYear() - 1);
					if(option.yearSelect && object.date.getFullYear() < option.yearSelectStart){
						return;
					}else{
						makeCalendar();
					}
				});

				object.head.nextYear.on('click', function(){
					object.date.setFullYear(object.date.getFullYear() + 1);
					if(option.yearSelect && object.date.getFullYear() < option.yearSelectStart){
						return;
					}else{
						makeCalendar();
					}
				});
			}
		}

		var bindInputFocus = function(){
			var clickAction = function(e){
				
				if(object.wrap.attr('class') != 'YJcalendar-wrap YJcalendar-type-input open'){
					$('.YJcalendar-wrap').removeClass('open');
					object.wrap.addClass('open');
					
					//input 상의 날짜를 달력으로 셋팅
					object.input.trigger('setDate');
					
					makeCalendar();

				}else{
					$('.YJcalendar-wrap').removeClass('open');
				}
				
					
				/* 190212 박세현 수정
				 * kora_common.js의 실행이력 저장용 클릭이벤트 감지와 동일 이벤트를 사용하여 
				 * 달력이벤트 발생 후 클릭이벤트 unbind후 다시 등록
				 */
				$(document).unbind('click');
				
				$(document).on('click', function(){
					//달력 숨기기
					object.wrap.removeClass('open');
					
					//실행이력 저장용 클릭이벤트 감지
					if(kora.common.chk_send == 0 && event.target.id.indexOf('btn_') > -1){
						kora.common.btn_id = event.target.id;
					}else{
						
					}
				});
				
				
				object.wrap.inner.click(function(e){
					e.stopPropagation();
				});


				e.stopPropagation();
			}

			object.input.on('click', clickAction);
			if(option.triggerBtn){
				object.input.triggerBtn.on('click', clickAction);
			}
		}

		
		//날짜 수동 셋팅
		var bindSetDate = function(){
			var setDateAction = function(e){

				if(object.input.val() == ''){
					object.input.dna = '';
					object.input.attr('date', '');
					object.input.val('');
				}else{
				
					if(kora.common.fn_validDate(object.input.val(), '')){
					 
						object.date.setFullYear(object.input.val().substring(0,4));
						object.date.setMonth(object.input.val().replace(/-/g, "").substring(4,6) - 1);

						//기본일자셋팅 ㅇㄷ
						object.input.dna = object.input.val().replace(/-/g, "");
						object.input.format = formatConvert(object.input.val().replace(/-/g, ""));
						object.input.attr('date', object.input.val().replace(/-/g, ""));
						object.input.val(object.input.format);

					}else{
						
						/*object.input.dna = '';
						object.input.attr('date', '');
						object.input.val('');*/
					}
				}
				
				//달력상 일자표시 셋팅
				if(option.fromName){
					object.from = $('input[name='+option.fromName+']');
					
					//object.from.dna = object.from.val().replace(/-/g, "");
					//object.from.format = object.from.val();
					object.from.attr('date', object.from.val().replace(/-/g, ""));
					object.from.date = object.from.attr('date');
					
					//console.log(object.from.dna+";"+object.from.format+";"+object.from.attr('date')+";"+object.from.date);
				}

				if(option.toName){
					object.to = $('input[name='+option.toName+']');
					
					//object.to.dna = object.to.val().replace(/-/g, "");
					//object.to.format = object.to.val();
					object.to.attr('date', object.to.val().replace(/-/g, ""));
					object.to.date = object.to.attr('date');
					
					//console.log(object.to.dna+";"+object.to.format+";"+object.to.attr('date')+";"+object.to.date);
				}
				
			}
	
			object.input.on('setDate', setDateAction);
		}
		
		
		init();

		return this;
	};

	/* 타겟팅 */
	$.fn.YJtarget = function(options){
		if(!this.length) return this;

		if(this.length > 1){
			this.each(function(){
				$(this).YJtarget(options);
			});
			return this;
		}

		var defaults = {
			target : false,
			action : function(){}
		}

		var opt = $.extend({}, defaults, options);
		var p = this[0], t;

		var event = 'click.YJtarget';

		$(document).on(event, function(e){
			t = e.target;

			if(t === p && opt.target){
				opt.action(p);
				return;
			}else{
				while(t !== p){
					if(t === this){
						break;
					}else{
						if(t === null){
							break;
						}
						t = t.parentNode;
					}
				}
				if(t === p){
					if(opt.target){
						opt.action(p);
					}
				}else{
					if(!opt.target){
						opt.action(p);
					}
				}
				return;
			}
		});
	}

	/* 이미지로딩 */
	$.fn.ImagesLoaded = function(){
		var $imgs = this.find('img[src!=""]');
		if (!$imgs.length) {return $.Deferred().resolve().promise();}

		var dfds = [];

		$imgs.each(function(){
			var dfd = $.Deferred();
			dfds.push(dfd);
			var img = new Image();
			img.onload = function(){dfd.resolve();}
			img.onerror = function(){dfd.resolve();}
			img.src = this.src;
		});

		return $.when.apply($,dfds);
	}
	
	
	/* 날짜 수동 셋팅 */
	$.fn.YJdate = function(options){

		$(this).val(options.dateSetting);
		$(this).trigger('setDate');

		/*
		var el = el = this;
		var object	= object = {};
		
		object.input = el;
		object.input.dna = object.input.val();
		
		object.input.dna = '20171201';
		object.input.format = '2017-12-01';
		*/
	}
	
})(jQuery, window);