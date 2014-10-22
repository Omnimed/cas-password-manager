<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--

    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.

--%>

<%@ page contentType="text/html; charset=UTF-8"%>

<jsp:directive.include file="includes/top.jsp" />


<div>
	<form:form method="post" commandName="${commandName}" htmlEscape="true">

		<form:errors path="*" cssClass="errors" id="status" element="div" />

		<div>
			<div>
				<c:if test="${not empty sessionScope.openIdLocalId}">
					<strong>${sessionScope.openIdLocalId}</strong>
					<input type="hidden" id="username" name="username"
						value="${sessionScope.openIdLocalId}" />
				</c:if>
				<c:if test="${empty sessionScope.openIdLocalId}">
					<form:input cssErrorClass="error" id="username" size="25"
						tabindex="1" path="username" autocomplete="false"
						htmlEscape="true" />
				</c:if>
			</div>
		</div>

		<div>
			<div>
				<form:password cssErrorClass="error" id="password" size="25"
					tabindex="2" path="password" htmlEscape="true" autocomplete="off" onkeypress="capLock(event)" />
				<div id="divMayus" class="capsLock"><spring:message code="screen.capsLockOn" /></div>
			</div>
		</div>
		<div class="row btn-row">
			<input type="hidden" name="lt" value="${loginTicket}" /> <input
				type="hidden" name="execution" value="${flowExecutionKey}" /> <input
				type="hidden" name="_eventId" value="submit" />

			<div style="height: 70px;">
				<input class="btn-submit" name="submit" accesskey="l"
					value="<spring:message code="screen.welcome.button.login" />"
					tabindex="4" type="submit" />
			</div>
		</div>
		
		<script type="text/javascript">
			function capLock(e){
				 kc = e.keyCode?e.keyCode:e.which;
				 sk = e.shiftKey?e.shiftKey:((kc == 16)?true:false);
				 if(((kc >= 65 && kc <= 90) && !sk)||((kc >= 97 && kc <= 122) && sk))
				  document.getElementById('divMayus').style.visibility = 'visible';
				 else
				  document.getElementById('divMayus').style.visibility = 'hidden';
				}
		</script>
	</form:form>
</div>


<div class="languageBar">
	<c:set var="googleUrl"
		value="https://support.google.com/chrome/bin/answer.py?hl=" />
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
	<a href="${googleUrl}${googleLangageUrl}${googleEndUrl}"
		target="_blank"> <spring:message
			code="screen.welcome.changelanguage" />
	</a> <a style="float: right;"
		href="<c:url value="login"/>?execution=${flowExecutionKey}&_eventId=forgotPassword"><spring:message
			code="screen.welcome.link.forgotPassword" /></a>

</div>
<script type="text/javascript">
	$(document).ready(function() {
	    $('#username').watermark('<spring:message code="screen.welcome.label.netid" />');
	    $('#password').watermark('<spring:message code="screen.welcome.label.password" />');
    });
</script>