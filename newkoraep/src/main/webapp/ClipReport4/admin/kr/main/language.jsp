<%@ page import="java.io.File" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.clipsoft.clipreport.server.service.admin.serviceconfig.ServiceConfigManager" %>

<% 
	Locale theLocale = null;
	if (null != ServiceConfigManager.getInstance().getServiceProperties()) {
		theLocale = ServiceConfigManager.getInstance().getServiceProperties().getLocale();
	} else {
		String propertyPath = (String) request.getSession().getAttribute("clipreport_propertyPath");
		String propertiesFilePath = new File(propertyPath).getParentFile().getPath() + File.separator + "Service.properties";
		theLocale = ServiceConfigManager.getInstance().getServiceProperties().getLocaleByPropertiesFile(propertiesFilePath);	
	}
	
%>
<script type="text/javascript">
	function changeServiceLanguage(form, btn) {
		var locale = btn.name;
		form.locale.value = locale;
		form.submit();
	}
</script>
<form action="index.jsp" method="post">
	<div style="width: 95%; background-color: black; text-align:right;">
		<input type="hidden" name="ClipID" value="E161">
		<input type="hidden" name="locale" value="">
		<div class="btn-group" style="padding-right:-20px;">
			<% if (theLocale.equals(Locale.KOREA)) { %>
				<button type="button" class="btn btn-mini btn-info" name="ko_KR" onclick="changeServiceLanguage(this.form, this)">KOREAN</button>
			<% } else { %>
				<button type="button" class="btn btn-mini btn-inverse" name="ko_KR" onclick="changeServiceLanguage(this.form, this)">KOREAN</button>
			<% } %>
			
			<% if (theLocale.equals(Locale.US)) { %>
				<button type="button" class="btn btn-mini btn-info" name="en_US" onclick="changeServiceLanguage(this.form, this)">ENGLISH</button>
			<% } else { %>
				<button type="button" class="btn btn-mini btn-inverse" name="en_US" onclick="changeServiceLanguage(this.form, this)">ENGLISH</button>
			<% } %>
			
			<%-- <% if (theLocale.equals(Locale.JAPAN)) { %>
				<button type="button" class="btn btn-mini btn-info" name="ja_JP" onclick="changeServiceLanguage(this.form, this)">JAPANESE</button>
			<% } else { %>
				<button type="button" class="btn btn-mini btn-inverse" name="ja_JP" onclick="changeServiceLanguage(this.form, this)">JAPANESE</button>
			<% } %> --%>
		</div>
	</div>
</form>