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
<link type="text/css" rel="stylesheet"
	href="<c:url value="/css/cas-pm.css" />" />
<c:url var="formActionUrl" value="/login" />
<c:set var="language" value="${pageContext.request.locale.language}" />
<div id="admin" class="useradmin">
	<form method="post" action="${formActionUrl}" class="fm-v clearfix"
		id="">
		<c:if test="${not empty securityQuestionValidationError}">
			<div class="errors" style="width: 250px;">
				<spring:message code="pm.answerSecurityQuestion.error" />
			</div>
		</c:if>
		<!-- Verify your identity by answering the security question. -->
		<div class="info">
			<spring:message code="pm.answerSecurityQuestion.heading-text" />
		</div>
		<c:forEach items="${securityChallenge.questions}" var="question"
			varStatus="status">
			<div class="row fl-controls-left">
				<input type="text" autocomplete="off" size="25" value=""
					accesskey="n" tabindex="1" class="required"
					name="response${status.index}" id="username_${status.index}">
			</div>
			<script type="text/javascript">
			var text = "${question.questionText}";
			if (text.indexOf("(en)") > -1) {
				if (${language == 'en'}) {
					text = text.substr(4, text.indexOf("(fr)") - 4);
				} else {
					text = text.substr(text.indexOf("(fr)") + 4);
				}
			}
			$('#username_${status.index}').watermark(text);
		</script>
		</c:forEach>
		<div class="row btn-row">
			<input type="hidden" value="submitAnswer" name="_eventId"  /> <input
				type="hidden" name="lt" value="${loginTicket}" /> <input
				type="hidden" name="execution" value="${flowExecutionKey}" />

			<div style="height: 70px;">
				<input class="btn-submit" name="submit" accesskey="l"
					value="<spring:message code="screen.welcome.button.submit" />"
					tabindex="4" type="submit" />
			</div>
		</div>
	</form>
</div>

<div class="languageBar">
	<c:set var="googleUrl"
		value="https://support.google.com/chrome/bin/answer.py?hl=" />
	<c:set var="googleEndUrl" value="&answer=95416&topic=1678461&ctx=topic" />
	<c:choose>
		<c:when test="${language == 'en'}">
			<c:set var="googleLangageUrl" value="en" />
		</c:when>
		<c:otherwise>
			<c:set var="googleLangageUrl" value="fr" />
		</c:otherwise>
	</c:choose>
	<a href="${googleUrl}${googleLangageUrl}${googleEndUrl}"
		target="_blank"> <spring:message
			code="screen.welcome.changelanguage" />
	</a>

</div>