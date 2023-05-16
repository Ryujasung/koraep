<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
#header .layer {display: none;position: absolute;top: 90px;right: 17px;box-sizing: border-box;border-radius: 3px;width: 700px;padding: 18px 34px 18px 25px;border: 2px solid #ff3030;background: #ffffff;} /*background: #f2f2f2;*/
#header .layer:before {display: block; content: ''; position: absolute; top: -18px; right: 20px; width: 10px; height: 18px; background: url(../../images/common/alarm_layer_arr.png) 0 0 no-repeat;}

</style>
<header id="header">
	<!-- <button type="button" id="btn_aside_open" class="btn_aside_open"><span>전체메뉴 열기</span></button> -->
	<h1 class="logo"><a href="/MAIN.do"><img src="/images_m/common/logo.png" alt="KORA 한국순환자원유통지원센터"></a></h1>
	<!-- <button type="button" class="btn_alarm"><span class="length alarmCntDiv"><a href="#self" class="alarm" id="alarmCnt"></a></span><span class="hide">알람</span></button> -->
	<div class="layer" id="alarmDiv"></div>
</header><!-- id : header -->