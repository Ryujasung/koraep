<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="/common/css/common.css"/>

<script type="text/javaScript" language="javascript">

	function confirmExec(v){
		if(v == 'Y'){
			if($("#func").val() != ''){
				var pframe = window.frames[$("#alertLayer").find("#alertPagedata").val()];
				
				if(pframe == undefined){
					if($("#func").val().indexOf('(') < 0){
						eval($("#func").val()+'()');
					}else{
						eval($("#func").val());
					}
				}else{
					if($("#func").val().indexOf('(') < 0){
						eval('pframe.'+$("#func").val()+'()');
					}else{
						eval('pframe.'+$("#func").val());
					}
				}
			}
			$('#alertClose').trigger('click');
		}else if(v =='N'){
			$('#alertClose').trigger('click');
		}
	}

</script>
<div id="alertLayer">
	<input type="hidden" id="alertPagedata"/>
	<input type="hidden" id="func"/>
 </div>
<div id="layerPop" class="layer_popup alert" style="width:100%;hight:100%;">
	<div class="layer_head c1">
		<h1 class="layer_title">Alert Dialog</h1>
	</div>
	<div class="layer_body">
		<p class="txt mb25" id="alertText" style=""></p>
		<div id="alert">
			<button class="btn30 c3" style="width: 87px;" onclick="confirmExec('Y')" id="alertOk">OK</button>
		</div>
		<div id="confirm" style="display:none">
			<button class="btn30 c3" style="width: 87px;" onclick="confirmExec('Y')">YES</button>
			<button class="btn30 c3" style="width: 87px;" onclick="confirmExec('N')">NO</button>
		</div>
		
		<button class="btn30 c3" style="width: 87px;display:none" layer="close" id="alertClose">CLOSE</button>
		
	</div>
</div>
