<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script language="javascript" defer="defer">

var rtnData;

$(document).ready(function(){
	
	$("#btn_prev1").click(function(){	//이전 개인정보처리방침
		$(".layer_close").trigger("click");
		NrvPub.AjaxPopup('/jsp/privacy_160121.jsp');
	});
	
	$("#btn_prev2").click(function(){	//이전 개인정보처리방침
		$(".layer_close").trigger("click");
		NrvPub.AjaxPopup('/jsp/privacy_180701.jsp');
	});
	
	$("#btn_prev3").click(function(){	//이전 개인정보처리방침
		$(".layer_close").trigger("click");
		NrvPub.AjaxPopup('/jsp/privacy_190211.jsp');
	});
	
	$("#btn_prev4").click(function(){	//이전 개인정보처리방침
		$(".layer_close").trigger("click");
		NrvPub.AjaxPopup('/jsp/privacy_190326.jsp');
	});	
	
	$("#btn_prev5").click(function(){	//이전 개인정보처리방침
		$(".layer_close").trigger("click");
		NrvPub.AjaxPopup('/jsp/privacy_190529.jsp');
	});	
	
});

</script>
</head>
<body>
	<div class="layer_popup" style="width:722px;">
		<div class="layer_head">
			<h1 class="layer_title">개인정보처리방침</h1>
			<button type="button" class="layer_close" layer="close">팝업닫기</button>
		</div>
		<div class="layer_body" style="height:450px;overflow-y:scroll;">
			<div class="terms_wrap">
				<div class="terms_date">
					<span>2020. 3. 10. 시행</span>
				</div>
                <div class="terms_body">
                    <div>
                        <p class="tit">◎ 한국순환자원유통지원센터(이하 “센터”)는 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 개인정보 처리방침을 두고 있습니다.</p>
                    </div>
                    <div>
                        <p class="tit">제1조 개인정보의 처리 목적</p>
                        <p>센터는 다음의 목적을 위하여 필요한 최소한의 개인정보를 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 개인정보보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.</p>
                        <br>
                        <ol>
                            <li>- "빈용기보증금 및 취급수수료 지급관리시스템" 이용을 위한 회원가입, 민원처리, 본인확인, 각종 서비스 제공 등을 목적으로 개인정보를 처리합니다.</li>
                            <li>- "빈용기보증금 및 취급수수료 지급관리시스템" 관리를 위한 본인 식별․인증, 회원자격 유지․관리, 중복•부정가입 방지, 서비스 부정이용 방지, 각종 고지․통지, 분쟁 조정을 위한 기록 보존, 서비스의 유효성 확인 등에 활용</li>
                            <li>- 빈용기보증금 및 취급수수료 지급관리(자원의 절약과 재활용촉진에 관한 법률 제15조의2 및 제28조의2 등)를 위한 출고정보, 반환정보 등 자료 접수 및 관리 등에 활용</li>
                            <li>- 빈용기보증금 및 취급수수료 지급관리시스템의 효율적 운영을 위한 편의기능 추가와 서비스 개선 등에 활용</li>
                            <li>- 이용자는 센터가 수집하는 개인정보에 대해 동의를 거부할 권리가 있으며 동의 거부 시에는 회원가입, 사이트 이용 서비스가 제한될 수 있습니다.</li>
                            <li>- 기타 서비스 제공, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다.</li>                                
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제2조 처리하는 개인정보의 항목</p>
                        <p>센터는 아래와 같이 개인정보를 수집합니다.</p>
                        <table>
                            <colgroup>
                                <col style="width:15%">
                                <col style="width:3%">
                                <col style="width:47%">
                                <col style="width:15%">
                                <col style="width:15%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th colspan="2">구분</th>
                                    <th>수집항목</th>
                                    <th>이용목적</th>
                                    <th>보유기간</th>
                                </tr>
                                <tr>
                                    <td rowspan="2" align=center>지급관리시스템<br>사용자 정보</td>
                                    <td>필<br>수</td>
                                    <td>사업자명, 사업자등록번호, 업종, 업태, 대표자명, 관리자성명, 이메일, 관리자 아이디, 관리자 휴대전화번호, 사업장주소, 업무담당자의 부서명, 성명, 아이디, 비밀번호 이메일 및 휴대전화번호</td>
                                    <td rowspan="2" align=center>회원가입 및<br>지급관리시스템<br>관리</td>
                                    <td rowspan="2" align=center>회원탈퇴 후 5일</td>
                                </tr>
                                <tr>
                                    <td>선<br>택</td>
                                    <td>대표 전화번호, 관리자 전화번호, 업무 담당자 전화번호, FAX 번호</td>
                                </tr>
                                <tr>
                                    <td rowspan="2" align=center>보증금 및<br>취급수수료<br>지급관리정보</td>
                                    <td>필<br>수</td>
                                    <td>수납계좌번호, 수납계좌예금주명, 거래내역</td>
                                    <td rowspan="2" align=center>빈용기보증금 및<br>취급수수료<br>지급관리 </td>
                                    <td rowspan="2" align=center>준영구</td>
                                </tr>
                                <tr>
                                    <td>선<br>택</td>
                                    <td>-</td>
                                </tr>
                                <tr>
                                    <td rowspan="2" align=center>지급관리시스템<br>접속정보</td>
                                    <td>필<br>수</td>
                                    <td>서비스 이용기록, 접속로그, 쿠키, 접속 IP Adress, 불량이용기록</td>
                                    <td rowspan="2" align=center>사용자 접속이력<br>기록 및 서비스<br>개선</td>
                                    <td rowspan="2" align=center>3개월</td>
                                </tr>
                                <tr>
                                    <td>선<br>택</td>
                                    <td>-</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div>
                        <p class="tit">제3조 개인정보의 처리 및 보유기간</p>
                        <ol>
                            <li>1. 센터는 법령에 따른 개인정보 보유․이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다. 원칙적으로 개인정보의 처리목적이 달성되면 지체 없이 파기합니다. 탈퇴를 요청하거나 동의를 철회하는 경우에도 지체 없이 파기합니다. 단, 관계법령의 규정에 의해 보존할 필요가 있는 경우 관계법령에서 정한 일정한 기간 동안 최소한의 회원정보를 보유합니다.</li>
                            <br>
                            <li>- 관계 법령 위반에 따른 수사․조사 등이 진행중인 경우 : 해당 수사․조사 종료시까지</li>
                            <li>- 홈페이지 이용에 따른 채권․채무관계 잔존시 : 해당 채권․채무관계 정산시까지</li>
                            <li>- 기타 회원의 동의를 득한 경우 : 동의를 득한 기간까지</li>
                            <br>
                            <li>2. 관련 법령에 따라 지급관리시스템을 1년의 기간 동안 이용하지 않는 이용자의 개인정보를 보호하기 위해 유효기간 경과 후 즉시 파기하거나 분리하여 보관합니다.</li>
                            <br>
                            <li>- 개인정보 주체에게 30일 전에 해당 사실을 통지하고, 명시한 기한 내에 로그인하지 않을 경우에는 회원 자격을 상실시킬 수 있습니다. 이 경우 회원 아이디를 포함한 회원의 개인정보 및 서비스 이용 정보는 파기, 삭제됩니다.</li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제4조 개인정보의 제3자 제공</p>
                        <ol>
                            <li>1. 센터는 이용자의 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서 처리하며, 개인정보보호법 제17조에 따라 이용자의 사전 동의 없이 본래의 범위를 초과하여 처리하거나 제3자에게 제공하지 않습니다. 다만, 다른 법률에 특별한 규정이 있는 경우 또는 범죄의 수사와 같이 개인정보보호법 제18조제2항에 해당되는 경우는 예외로 처리됩니다.</li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제5조 개인정보 처리의 위탁</p>
                        <p>센터는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.</p>
                        <table>
                            <colgroup>
                                <col style="width:30%">
                                <col style="width:70%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>수탁업체</th>
                                    <th>위탁업무내용</th>
                                </tr>
                                <tr>
                                    <td align=center>리드정보기술(주)</td>
                                    <td align=center>지급관리시스템 개발 및 유지보수 용역사업</td>
                                </tr>
                                <tr>
                                    <td align=center>부일정보링크(주)</td>
                                    <td align=center>빈용기보증금제고 민원통합 및 지급관리시스템 Help-desk 운영</td>
                                </tr>
                                <tr>
                                    <td align=center>한국모바일인증(주)</td>
                                    <td align=center>본인확인</td>
                                </tr>
                            </tbody>
                        </table>
                        <p>센터는 위탁계약 체결 시 개인정보보호법 제26조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적․관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리․감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는 지를 감독하고 있습니다. 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
                    </div>
                    <div>
                        <p class="tit">제6조 정보주체의 권리·의무 및 그 행사방법</p>
                        <ol>
                            <li>1) 이용자는 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다. 다만, 다음 각 호의 요구에 따라 서비스 이용이 제한될 수 있습니다.
                                <ol>
                                    <li>가. 개인정보 열람요구</li>
                                    <li>나. 오류 등이 있을 경우 정정 요구</li>
                                    <li>다. 삭제요구</li>
                                    <li>라. 처리정지 요구</li>
                                </ol>
                            </li>
                            <li>2) 제1항에 따른 권리 행사는 개인정보보호법 시행규칙 별지 제8호 서식에 따라 작성 후 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며, 한국순환자원유통지원센터(이하 ‘센터’)는 이에 대해 지체 없이 조치하겠습니다.</li>
                            <li>3) 이용자가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다. </li>
                            <li>4) 제1항에 따른 권리 행사는 이용자의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.</li>
                            <li>5) 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제4항, 제37조 제2항에 의하여 제한되거나 거절될 수 있습니다.</li>
                            <li>6) 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.</li>
                            <li>7) 개인정보의 삭제 요구는 회원 탈퇴 시에만 가능합니다.</li>
                            <li>8) 이용자 권리에 따른 열람의 요구, 정정•삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.</li>
                            <li>9) 이용자의 요청에 의해 삭제되는 개인정보는 개인정보의 처리 및 보유기간에 따라 처리합니다.</li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제7조 개인정보의 파기</p>
                        <p>센터는 원칙적으로 개인정보 보존기간이 경과하였거나 처리목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다. 다만, 관계법령에 의해 보관해야 하는 정보는 법령이 정한 기간 동안 보관한 후 파기하나, 이때 별도 저장 관리되는 개인정보는 법령에 정한 경우가 아니고서는 절대 다른 용도로 이용되지 않습니다.</p>
                        <ol>
                            <li>1) 파기절차
                                <ol>
                                    <li>이용자가 입력한 정보는 목적 달성 후 내부방침 및 기타 관련 법령에 따라 일정기간 저장된 후 파기됩니다. 이 때, DB로 저장된 개인정보는 법률에 의한 경우가 아닌 목적으로 이용되지 않습니다.</li>
                                </ol>
                            </li>
                            <li>2) 파기기한
                                <ol>
                                    <li>이용자의 개인정보는 개인정보의 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지 등 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 해당 개인정보를 파기합니다.</li>
                                </ol>
                            </li>
                            <li>3) 파기방법
                                <ol>
                                    <li>센터에서 처리하는 개인정보를 파기할 때에는 다음의 방법으로 파기 합니다.</li>
                                    <li>가. 전자적 파일 형태인 경우 : 복원이 불가능한 방법으로 파기 합니다.</li>
                                    <li>나. 전자적 파일의 형태 외의 기록물, 인쇄물, 서면, 그 밖의 기록매체인 경우 : 파쇄 또는 소각</li>
                                </ol>
                            </li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제8조 개인정보의 안전성 확보 조치</p>
                        <p>센터는「개인정보보호법」제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적, 관리적, 물리적 조치를 하고 있습니다.</p>
                        <ol>
                            <li>1) 내부 관리계획의 수립 및 시행 : 센터는 ‘개인정보의 안전성 확보조치 기준’(행정안전부고시 제2017-제1호)에 의거하여 내부 관리계획(’18.3.30.)을 수립 및 시행합니다.</li>
                            <li>2) 개인정보취급자 지정의 최소화 및 교육 : 개인정보취급자의 지정을 최소화하고 정기적인 교육을 시행하고 있습니다.</li> 
                            <li>3) 개인정보에 대한 접근 제한 : 개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여, 변경, 말소를 통하여 개인정보에 대한 접근을 통제하고, 침입차단시스템과 탐지시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있으며 개인정보취급자가 정보통신망을 통해 외부에서 개인정보처리시스템에 접속하는 경우에는 온라인원격근무서비스(VPN : Virtual Private Network)을 이용하고 있습니다. 또한 권한 부여, 변경 또는 말소에 대한 내역을 기록하고, 그 기록을 최소 3년간 보관하고 있습니다.</li> 
                            <li>4) 접속기록의 보관 및 위변조 방지 : 지급관리시스템에 접속한 기록(웹 로그, 요약정보 등)을 최소 6개월 이상 보관, 관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 관리하고 있습니다.</li> 
                            <li>5) 개인정보의 암호화 : 이용자의 개인정보는 암호화 되어 저장 및 관리되고 있습니다. 또한 중요한 데이터는 저장 및 전송 시 암호화하여 사용하는 등의 별도 보안기능을 사용하고 있습니다.</li> 
                            <li>6) 해킹 등에 대비한 기술적 대책 : 센터는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적, 물리적으로 감시 및 차단하고 있습니다.</li> 
                            <li>7) 물리적 안전조치 : 센터는 통신실, 문서고 등 개인정보를 보관하고 있는 물리적 보관장소에 대해 출입통제 절차 등 물리적인 안전조치를 운영하고 있습니다.</li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제9조 권익침해 구제방법</p>
                        <p>개인정보 주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다. </p>
                        <ol>
                            <li>1) 개인정보분쟁조정위원회 : 1833-6972 (http://www.kopico.go.kr)</li>
                            <li>2) 개인정보침해신고센터 : (국번없이) 118 (http://privacy.kisa.or.kr)</li>
                            <li>3) 대검찰청 사이버범죄수사단 : 02-3480-3582 (http://www.spo.go.kr/)</li> 
                            <li>4) 경찰청 사이버안전국 : (국번없이) 182 (http://www.police.go.kr/www/security/cyber.jsp)</li> 
                        </ol>
                        <p>「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대하여 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.</p>
                        <ol>
                            <li>1) 개인정보분쟁조정위원회 : 1833-6972 (http://www.kopico.go.kr)</li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제10조 쿠키(cookie)에 의한 개인정보 수집 및 거부에 관한 사항</p>
                        <p>센터는 지급관리시스템 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다.</p>
                        <ol>
                            <li>1) 쿠키의 사용목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.</li>
                            <li>2) 쿠키의 설치∙운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부할 수 있습니다.</li>
                            <li>3) 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.</li> 
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제11조 개인정보 보호책임자</p>
                        <p>센터는 개인정보를 보호하고 개인정보와 관련된 사항을 처리하기 위하여 아래와 같이 개인정보 보호책임자 및 실무담당자를 지정하고 있습니다.</p>
                        <ol>
                            <li>1) 개인정보관리 보호책임자 : 기획경영본부장</li>
                            <li>•성명 : 양재영 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; •메일 : yjyang@kora.or.kr</li>
                            <li>•전화번호 : 02-768-1610 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; •Fax : 02-768-1699</li>
                            <li>2) 개인정보보호 담당자 : 운영지원팀장</li>
                            <li>•성명 : 유순주 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; •부서 : 운영지원팀 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; •메일 : sjyu@kora.or.kr</li>
                            <li>•전화번호 : 02-768-1681 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; •Fax : 02-768-1695</li>
                        </ol>
                    </div>
                    <div>
                        <p class="tit">제12조 개인정보의 처리방침의 변경</p>
                        <p>본 지침에에 대한 추가, 삭제 및 수정이 있을 경우에는 시행하는 날로부터 최소 7일전에 공지사항 등을 통해 이용자에게 설명 드리겠습니다. 다만 이용자의 소중한 권리 또는 의무에 중요한 내용 변경은 최소 30일 전에 알려 드리겠습니다.</p>
                        <p> - 이전의 개인정보처리방침은 아래에서 확인할 수 있습니다.</p>
   						<p style="color:#1d70ee;"><a class="" id="btn_prev1" style="cursor: pointer;">•2016.1.21. ~ 2018.7.1. 적용 이전의 개인정보처리방침</a></p>
   						<p style="color:#1d70ee;"><a class="" id="btn_prev2" style="cursor: pointer;">•2018.7.1. ~ 2019.2.11. 적용 이전의 개인정보처리방침</a></p>
   						<p style="color:#1d70ee;"><a class="" id="btn_prev3" style="cursor: pointer;">•2019.2.11. ~ 2019.3.26. 적용 이전의 개인정보처리방침</a></p>
   						<p style="color:#1d70ee;"><a class="" id="btn_prev4" style="cursor: pointer;">•2019.3.26. ~ 2019.5.29. 적용 이전의 개인정보처리방침</a></p>
   						<p style="color:#1d70ee;"><a class="" id="btn_prev5" style="cursor: pointer;">•2019.5.29. ~ 2020.3.10. 적용 이전의 개인정보처리방침</a></p>
                    </div>
                    <!-- <div>
                        <p class="tit">[부칙]</p>
                        <p class="mgT15">[별표1] - 개인정보의 보관</p>
                        <table>
                            <colgroup>
                                <col style="width:25%">
                                <col>
                                <col style="width:25%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>보관되는 개인정보</th>
                                    <th>운영근거</th>
                                    <th>보유기간</th>
                                </tr>
                                <tr>
                                    <td>지급관리시스템 사용자 정보</td>
                                    <td>이용자의 동의 </td>
                                    <td>회원탈퇴 의사표시 후 5일까지</td>
                                </tr>
                                <tr>
                                    <td>보증금 및 취급수수료 지급관리정보</td>
                                    <td>자원의 절약과 재활용촉진에 관한 법률</td>
                                    <td>준영구</td>
                                </tr>
                                <tr>
                                    <td>지급관리시스템 사용 정보</td>
                                    <td>자원의 절약과 재활용촉진에 관한 법률, 개인정보 보호법 제29조, 통신비밀보호법</td>
                                    <td>3개월</td>
                                </tr>
                            </tbody>
                        </table>
                        <p class="mgT15">[별표2] - 개인정보의 제3자 제공</p>
                        <table>
                            <colgroup>
                                <col style="width:35%">
                                <col style="width:30%">
                                <col style="width:35%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>서비스명</th>
                                    <th>제공받는자</th>
                                    <th>개인정보항목</th>
                                </tr>
                                <tr>
                                    <td>빈용기보증금 및 취급수수료 지급관리</td>
                                    <td>주식회사 기업은행</td>
                                    <td>빈용기보증금 및 취급수수료 지급관리정보</td>
                                </tr>
                            </tbody>
                        </table>
                    </div> -->
                    <div></div>
                </div>           				      
			</div>
		</div>
	</div>
</body>
</html>
