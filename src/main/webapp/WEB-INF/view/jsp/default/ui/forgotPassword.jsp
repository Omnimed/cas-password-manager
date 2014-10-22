<%--
  ~ Licensed to Jasig under one or more contributor license
  ~ agreements. See the NOTICE file distributed with this work
  ~ for additional information regarding copyright ownership.
  ~ Jasig licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file
  ~ except in compliance with the License.  You may obtain a
  ~ copy of the License at the following location:
  ~
  ~   http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<jsp:directive.include file="includes/top.jsp" />
<link type="text/css" rel="stylesheet" href="<c:url value="/css/cas-pm.css" />" />
<%-- <jsp:directive.page import="net.tanesha.recaptcha.ReCaptcha" /> --%>
<%-- <jsp:directive.page import="net.tanesha.recaptcha.ReCaptchaFactory" /> --%>
<%-- <c:set var="recaptchaPublicKey" scope="page" value="${recaptchaPublicKey}"/> --%>
<%-- <c:set var="recaptchaPrivateKey" scope="page" value="${recaptchaPrivateKey}"/> --%>

<c:url value="/login" var="formActionUrl" />

<div id="admin" class="useradmin">
    <form:form method="post" action="${formActionUrl}" cssClass="fm-v clearfix" modelAttribute="netIdBean">
   
        <c:if test="${not empty forgotPasswordValidationError}">
        <div class="errors" style="width:250px;">
            <spring:message code="pm.form.netid.error.empty" />
        </div>
        </c:if>
		<form:errors path="*" cssClass="errors" id="status" element="div" />
        <p class="info"><spring:message code="pm.forgotPassword.heading-text" /></p>
        <div class="row fl-controls-left">
            <form:input path="netId" type="text" autocomplete="false" size="25" tabindex="1" cssClass="required" id="netId"/>
        </div>
        
        <div class="row btn-row">
            <input type="hidden" name="execution" value="${flowExecutionKey}"/>
            <input type="hidden" name="_eventId" value="submitId">
            <input type="hidden" name="lt" value="${loginTicket}"/>
            
		<div style="height:70px;">
			<input class="btn-submit" name="submit" accesskey="l" value="<spring:message code="screen.welcome.button.submit" />" tabindex="4" type="submit" />
		</div>
        </div>
    
    </form:form>
</div>
<div class="languageBar">
	<c:set var="googleUrl" value="https://support.google.com/chrome/bin/answer.py?hl=" />
	<c:set var="googleEndUrl" value="&answer=95416&topic=1678461&ctx=topic" />
	<c:set var="language" value="${pageContext.request.locale.language}" />
	<c:choose>
		<c:when test="${language == 'en'}">
			<c:set var="googleLangageUrl" value="fr" />
		</c:when>
		<c:otherwise>
			<c:set var="googleLangageUrl" value="en" />
		</c:otherwise>
	</c:choose>
	<a href="${googleUrl}${googleLangageUrl}${googleEndUrl}" target="_blank">
		<spring:message code="screen.welcome.changelanguage" />
	</a>

</div>
<script type="text/javascript">
	$(document).ready(function() {
		$('#netId').watermark('<spring:message code="screen.welcome.label.netid" />');
	});
</script>
