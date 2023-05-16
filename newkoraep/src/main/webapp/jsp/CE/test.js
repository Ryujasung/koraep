 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
	 var rowIndexValue =0;
     var whsdl_cd_list;								//도매업자
     var dps_fee_list;									//회수용기 보증금,취급수수료
     var whsdl_bizrnm_chk;
	 
     $(function() {
    	 
    	INQ_PARAMS 				= jsonObject($("#INQ_PARAMS").val());	
    	whsdl_cd_list 				= jsonObject($("#whsdl_cd_list").val());		
    	 //초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	 
    	//그리드 셋팅
		fnSetGrid1();
		 
		//날짜 셋팅
  	    $('#RTRVL_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 		});
		
		/************************************
		 * 도매업자  변경 이벤트
		 ***********************************/
		$("#WHSDL_BIZRNM").change(function(){
			fn_whsdl_bizrnm();
		});
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").click(function(){
			    var rtn_dt = $("#RTRVL_DT").val();
			    rtn_dt   =  rtn_dt.replace(/-/gi, "");
			    $("#RTRVL_DT").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").change(function(){
		     var dt = $("#RTRVL_DT").val();
		     dt   =  dt.replace(/-/gi, "");
			 if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
	     	 $("#RTRVL_DT").val(dt) 
	     	 if($("#RTRVL_DT").val() !=flag_DT){ 		//클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
			     	flag_DT = $("#RTRVL_DT").val();  	//변경시 날짜 
			     	fn_rtrvl_dt();
	   		  } 
		});
		
		/************************************
		 * 행 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del();
		});
		
		/************************************
		 * 행 변경 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		/************************************
		 * 행 추가 클릭 이벤트
		 ***********************************/
		$("#btn_reg2").click(function(){
			fn_reg2();
		});
		
		/************************************
		 * 추가 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/************************************
		 * 취소버튼 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
	
		/************************************
		 * 양식다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_dwnd").click(function(){
			fn_excelDown();
		});
		
		/************************************
		 * 엑셀등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel_reg").click(function(){
			
			if( $("#WHSDL_BIZRNM").val()=="" ){
				alertMsg("도매업자를  선택해 주세요.");
				return;
			}else if(  $("#WHSDL_BIZRNM").val() != ""  ) {
				$("#WHSDL_BIZRNM").prop("disabled",true);
				kora.common.gfn_excelUploadPop("fn_popExcel");
				whsdl_bizrnm_chk = $("#WHSDL_BIZRNM").val(); 
			}
			
		});
	});
     
     //초기화
     function fn_init(){
    	 
			kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');	//도매업자
			kora.common.setEtcCmBx2([], "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
			kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');		//지점
				
			$("#RTRVL_QTY").val("");
			$("#REG_RTRVL_FEE").val("");
			$("#RMK").val("");
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			flag_DT = $("#RTRVL_DT").val(); 
			 
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
			//div필수값 alt
			$("#RTRVL_DT").attr('alt',parent.fn_text('rtrvl_dt2'));   						//회수일자
			$("#RTRVL_QTY").attr('alt',parent.fn_text('rtrvl_qty2'));   					//회수량
			$("#REG_RTRVL_FEE").attr('alt',parent.fn_text('rtl_fee2'));   					//소매수수료
			$("#RTL_CUST_BIZRNM").attr('alt',parent.fn_text('reg_cust_nm'));   		//회수처
			$("#RTL_CUST_BIZRNO").attr('alt',parent.fn_text('reg_cust_bizrno'));   	//회수처사업자번호
			$("#RTRVL_CTNR_CD").attr('alt',parent.fn_text('ctnr_nm2'));   			//회수용기
			$("#WHSDL_BRCH_NM").attr('alt',parent.fn_text('brch'));   				//도매업자 지점

			//select2
			$("#WHSDL_BIZRNM").select2();
     }
   
   //도매업자 선택 변경시
   function fn_whsdl_bizrnm(){
	 		var url = "/CE/EPCE2925831_19.do" 
			var input ={};
			var arr=[];
			if($("#WHSDL_BIZRNM").val() !=""){
					arr = $("#WHSDL_BIZRNM").val().split(";"); 
					input["BIZRID"] 	= arr[0];
					input["BIZRNO"] 	= arr[1];
					input["RTRVL_DT"] 	= $("#RTRVL_DT").val();
					ajaxPost(url, input, function(rtnData) {
		    				if ("" != rtnData && null != rtnData) {   
		    						dps_fee_list = rtnData.dps_fee_list;
		    						kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');//지점
		    						kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
		    						
		    						for(var i=0 ; i <whsdl_cd_list.length ;i++){
		    							if(whsdl_cd_list[i].BIZRID_NO == $("#WHSDL_BIZRNM").val()  ){
		    								$("#WHSDL_BIZRNO").text(kora.common.setDelim(whsdl_cd_list[i].BIZRNO_DE, "999-99-99999"));
		    								$("#WHSDL_BIZRNO").val(kora.common.setDelim(whsdl_cd_list[i].BIZRNO_DE, "999-99-99999"));
		    								break;
		    							}
		    						}
		    				
		    				}else{
		    					 alertMsg("error");
		    				}
					});
			}else{
					$("#WHSDL_BIZRNO").text("");
					kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');	 //지점
					kora.common.setEtcCmBx2([], "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명(소매)
			}
	   
   }
 
   //회수일자 변경시
   function fn_rtrvl_dt(){
		var url = "/CE/EPCE2925831_192.do"; 
		var input ={};
		input["RTRVL_DT"] = $("#RTRVL_DT").val();
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					dps_fee_list = rtnData.dps_fee_list;
   					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
   				}else{
					alertMsg("error");
   				}
   		});
   }
	 
	 //행등록
	function fn_reg2(){
		if($("#WHSDL_BIZRNM").val() ==""){
			alertMsg("도매업자를 선택해주세요.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){  
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return;
		}else if(!kora.common.gfn_bizNoCheck($('#RTL_CUST_BIZRNO').val())){
			alertMsg("정상적인 사업자등록번호가 아닙니다.");
			$('#RTL_CUST_BIZRNO').focus();
			return;
		}else if( $("#WHSDL_BIZRNM").val() != "" ) {
			$("#WHSDL_BIZRNM").prop("disabled",true);
			whsdl_bizrnm_chk = $("#WHSDL_BIZRNM").val(); 
		}
		var input 	=	insRow("A");
		if(!input){
			return;
		}
		gridRoot.addItemAt(input);
		dataGrid.setSelectedIndex(-1);			

	}
	 //행 수정
	function fn_upd(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) {	//필수값 체크
			return;
		}else if(!kora.common.gfn_bizNoCheck($('#RTL_CUST_BIZRNO').val())){
			alertMsg("정상적인 사업자등록번호가 아닙니다.");
			$('#RTL_CUST_BIZRNO').focus();
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}
		var item = insRow("M");
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		dataGrid.setSelectedIndex(-1);			
	}
	 
	 
	//행삭제
	function fn_del(){
		var idx = dataGrid.getSelectedIndex();

		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot.removeItemAt(idx);
	}
	 
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
			var input 				= {};
		    var gridData			= gridRoot.getChangedData();
	
		    for(var i=0; i<gridData.length; i++) {
		    	if(gridData[i].data["RTRVL_CTNR_CD"] == $("#RTRVL_CTNR_CD").val() &&  gridData[i].data["RTL_CUST_BIZRNO"] == $("#RTL_CUST_BIZRNO").val()
		    		&&gridData[i].data["RTRVL_DT"] == $("#RTRVL_DT").val()  &&gridData[i].data["WHSDL_BRCH_NM_CD"] == $("#WHSDL_BRCH_NM").val()   ) { 
					if(gbn == "M") {
						if(rowIndexValue != gridData[i].idx) {
				    		alertMsg("동일한 빈용기명이 있습니다.");
				    		return false;
				    	}
					} else {
			    		alertMsg("동일한 빈용기명이 있습니다..");
			    		return false;
					}
				}
		    }
		  
			for(var i=0; i<dps_fee_list.length; i++){
				if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) {
						input["CTNR_NM"] 					= 	$("#RTRVL_CTNR_CD option:selected").text();	//빈용기명
					    input["RTRVL_CTNR_CD"] 			= 	$("#RTRVL_CTNR_CD").val(); 							//빈용기 코드
						input["CPCT_NM"] 					= 	dps_fee_list[i].CPCT_NM;								//용량ml
						input["PRPS_NM"] 					= 	dps_fee_list[i].PRPS_NM;								//용도
					    input["RTRVL_QTY"] 					= 	$("#RTRVL_QTY").val();									//회수량
					    input["RTRVL_GTN"] 				= 	input["RTRVL_QTY"] * dps_fee_list[i].RTRVL_DPS; 	//보증금(원) - 합계
					    input["REG_RTRVL_FEE"]    		=	$("#REG_RTRVL_FEE").val();									//등록소매수수료
					    input["RTRVL_RTL_FEE"]    			=	input["RTRVL_QTY"] *dps_fee_list[i].RTRVL_FEE;		//회수소매수수료
					    input["AMT_TOT"] 					=	Number(input["RTRVL_GTN"])+ Number(input["REG_RTRVL_FEE"]);  //총합계
						break;		
				}
			}
			input["RTRVL_DT"]					= 	$("#RTRVL_DT").val();                           			//회수일자
			var arr = $("#WHSDL_BIZRNM").val().split(";"); 													//도매업자
			input["WHSDL_BIZRID"] 			= arr[0];
			input["WHSDL_BIZRNO"] 			= arr[1];
			input["WHSDL_BIZRNM"] 			= 	$("#WHSDL_BIZRNM option:selected").text();	// 도매업자명
			
			var arr2 = $("#WHSDL_BRCH_NM").val().split(";"); 												//도매업자 지점
			input["WHSDL_BRCH_ID"] 			= arr2[0];
			input["WHSDL_BRCH_NO"] 		= arr2[1];
			input["WHSDL_BRCH_NM"] 		= 	$("#WHSDL_BRCH_NM option:selected").text();	// 지점
			input["WHSDL_BRCH_NM_CD"] 	= 	$("#WHSDL_BRCH_NM").val();						// 지점 ID+NO
			
		    input["REG_CUST_NM"] 			= 	$("#RTL_CUST_BIZRNM").val(); 						//회수처
		    input["RTL_CUST_BIZRNO"] 		= 	$("#RTL_CUST_BIZRNO").val();  						//회수처사업자번호
		    
			if($("#RMK").val() ==""){
     			input["RMK"]					=	" ";												
     		}else{
     			input["RMK"]					=	$("#RMK").val();						
     		}
			input["SYS_SE"]						= 'W';															//시스템구분	
			input["ALL_CFM"]						= 'F';																//회수등록구분 
			return input;   
	};	
	
	//등록
	function fn_reg(){
		 
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE2925831_09.do"; 
		var changedData = gridRoot.getChangedData();
		if (changedData.length <1){
				alertMsg("데이터를 입력해주세요")
				return;
		}else if(	whsdl_bizrnm_chk !=$("#WHSDL_BIZRNM").val() ){
				alertMsg("변조된데이터 입니다");
				return;
		}else if(0 != changedData.length){
				var collection = gridRoot.getCollection();
			 	for(var i=0;i<collection.getLength(); i++){
			 		var tmpData = gridRoot.getItemAt(i);
			 		row.push(tmpData);//행 데이터 넣기
			 	}//end of for
			 	
				data["list"] = JSON.stringify(row);
				showLoadingBar();
				ajaxPost(url, data, function(rtnData){
					if(rtnData != null && rtnData != ""){
							if(rtnData.RSLT_CD =="A003"){ // 중복일경우
								alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
							}else if(rtnData.RSLT_CD =="0000"){
								alertMsg(rtnData.RSLT_MSG);
			  					fn_init(); //입력창 초기화
			  					fn_cnl();
							}
					}else{
							alertMsg("error");
					}
					hideLoadingBar();
				});//end of ajaxPost
		}else{
			alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
		}
		 
	}
	
	  //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/CE/EPCE2925801.do', INQ_PARAMS);
    }
    
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		$("#WHSDL_BRCH_NM").val( item["WHSDL_BRCH_NM_CD"]).prop("selected", true);  	//지점
		$("#RTRVL_CTNR_CD").val( item["RTRVL_CTNR_CD"]).prop("selected", true); 				//회수용기
		$("#RTRVL_DT").val(item["RTRVL_DT"] );  																//회수일
		$("#RTRVL_QTY").val( item["RTRVL_QTY"]);   															//회수량(개)
		$("#REG_RTRVL_FEE").val(item["REG_RTRVL_FEE"]);													//소매수수료
		$("#RMK").val(item["RMK"]);																				//비고
		$("#RTL_CUST_BIZRNM").val(item["REG_CUST_NM"]); 											//회수처
		$("#RTL_CUST_BIZRNO").val(item["RTL_CUST_BIZRNO"]); 										//회수처 사업자번호
	}
	
	function fn_dataSet(item){
		var input	={};
		var url 	 	= "/CE/EPCE2925831_19.do"; 
		dps_fee_list=[];
		input["BIZRID"] 		= item["WHSDL_BIZRID"];	//도매업자아이디
		input["BIZRNO"] 		= item["WHSDL_BIZRNO"];//도매업자사업자번호
		input["RTRVL_DT"] 	= item["RTRVL_DT"];			//회수일자 

       	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					dps_fee_list = rtnData.dps_fee_list
   					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
					kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');//지점
   				}else{
					alertMsg("error");
   				}
		},false);
	}
	  
  	//양식다운로드
     function fn_excelDown() {
    	 downForm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
     	 downForm.submit();
     };
     
     /**
      * 엑셀 업로드 후처리
      */
     function fn_popExcel(rtnData) {
	     	gridRoot.removeAll();
	     	var input  	= {};
	     	var ctnrCd 	= "";
	     	var url 		= "/CE/EPCE2925831_193.do";
	     	var flag 		= false;
	     	var dup_cnt 		= 0;		//동일한 용기코드 + 도매업자지점 + 회수사업자번호 가 있을경우
	    	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	    	var err_msg="";
	    	var err_msg2="";
	    //	var arr3 =new Array();		//나중에 필요할때 쓰자;;
	    //	var arr4 =new Array();		//나중에 필요할때 쓰자;;
			arr		=[];
			arr 	= $("#WHSDL_BIZRNM").val().split(";"); 	//도매업자
			
	    	 for(var i=0; i<rtnData.length ;i++) {
	    		
	    		 if(!kora.common.gfn_bizNoCheck(rtnData[i].회수처사업자번호)){
	    				alertMsg(rtnData[i].회수처사업자번호 + "가정상적인 사업자등록번호가 아닙니다.");
	    				$('#RTL_CUST_BIZRNO').focus();
	    				return;
	    		 }else if(	rtnData[i].회수일자 =="" ||
		    			rtnData[i].회수처명 =="" ||	
		    			rtnData[i].회수처사업자번호 =="" ||
		    			rtnData[i].회수용기코드 =="" ||
		    			rtnData[i].회수량 =="" ||
		    			rtnData[i].소매수수료 ==""||
		    			rtnData[i].도매업자지점 =="" 	){
		    			alertMsg("필수입력값이 없습니다.")
		    			return;
	    		 }
	    	 }
			
	     	 for(var i=0; i<rtnData.length ;i++) {
	     		 
	     		flag= false
	     		input["WHSDL_BIZRID"]			=	arr[0];									//도매업자 사업자아이디
	     		input["WHSDL_BIZRNO"]		=	arr[1];									//도매업자 사업자 번호
	     		input["RTRVL_DT"]				=	rtnData[i].회수일자						
	     		input["REG_CUST_NM"]			=	rtnData[i].회수처명			
	     		input["RTL_CUST_BIZRNO"]	=	rtnData[i].회수처사업자번호
	     		input["RTRVL_CTNR_CD"]		=	rtnData[i].회수용기코드		
	     		input["RTRVL_QTY"]				=	rtnData[i].회수량		
	     		input["REG_RTRVL_FEE"]		=	rtnData[i].소매수수료	
	     		input["WHSDL_BRCH_NO"]	=	rtnData[i].도매업자지점			
	     		if(rtnData[i].비고 ==""){
	     			input["RMK"]					=	" ";												
	     		}else{
	     			input["RMK"]					=	rtnData[i].비고								
	     		}
	     		  ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {   
		    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
			    						var gridData = gridRoot.getChangedData();
									    for(var i=0; i<gridData.length; i++) {
									    	if(gridData[i].data["RTRVL_CTNR_CD"] == rtnData.selList[0].RTRVL_CTNR_CD // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
									    			&&  gridData[i].data["RTL_CUST_BIZRNO"] == rtnData.selList[0].RTL_CUST_BIZRNO 
									    			&& gridData[i].data["RTRVL_DT"] ==  rtnData.selList[0].RTRVL_DT &&gridData[i].data["WHSDL_BIZRNO"] == rtnData.selList[0].WHSDL_BIZRNO   ) {
									    			flag =true;
									    		//	arr3[dup_cnt]=input["RTL_CUST_BIZRNO"]+input["RTRVL_DT"]+" ,"+input["RTRVL_CTNR_CD"];
									    			dup_cnt++;
											}
									    }	//end of for
										if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
		    					}else{// 쿼리상 데이터가 없을경우
		    					//	arr4[err_cnt]=input["RTL_CUST_BIZRNO"]+input["RTRVL_DT"]+" ,"+input["RTRVL_CTNR_CD"];
		    						err_cnt++;
		    					}
	    				}else{
							alertMsg("error");
	    				}
	    		},false);  
	     	 }
	     	 
	     		err_msg = dup_cnt+" 개의 동일한 정보를 제외하고 등록 하였습니다. \n"  ;
	     		err_msg2 =err_cnt+" 개의 확인되지 않은 정보가 등록 제외되었습니다.\n" ;
	     
		     	if(dup_cnt >0 && err_cnt >0){
		     		alertMsg(err_msg+"\n"+err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다.");
		        }else if(dup_cnt >0){
		        	alertMsg(err_msg+"\n등록 정보를 다시 확인해주시기 바랍니다.");
	     		}else if(err_cnt >0){
	     			alertMsg(err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다." );
	     		}
		     	
     }
	