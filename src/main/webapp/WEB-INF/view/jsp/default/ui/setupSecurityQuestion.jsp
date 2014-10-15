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
  ~zz
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

<div id="admin" class="useradmin">
	<form:form method="post" action="${formActionUrl}"
		modelAttribute="securityQuestion" cssClass="fm-v clearfix">

		<h2>
			<spring:message code="pm.setupSecurityQuestion.header" />
		</h2>
		<p class="info">
			<spring:message code="pm.setupSecurityQuestion.heading-text" />
		</p>
		<div class="row fl-controls-left">
			 <input type="text" disabled="disabled"
				autocomplete="false" size="25" value="${username}" tabindex="1"
				class="required" name="username" id="username" />
		</div>
		<div class="row fl-controls-left">
			<form:input path="questionText" type="text" autocomplete="off"
				size="25" value=""
				tabindex="2" cssClass="required" id="questionText" />
			<form:errors path="questionText" cssClass="errors" element="div" />
		</div>
		<div class="row fl-controls-left">
			<form:input path="responseText" type="text" autocomplete="off"
				size="25" value="" tabindex="3"
				cssClass="required" id="responseText" />
			<form:errors path="responseText" cssClass="errors" element="div" />
		</div>
		<div class="row btn-row">
			<input type="hidden" name="lt" value="${loginTicket}" /> <input
				type="hidden" name="_eventId" value="setupSubmit" /> <input
				type="hidden" name="execution" value="${flowExecutionKey}" /> <input
				type="submit" tabindex="5"
				value="<spring:message code="pm.form.submit" />" name="submit"
				class="btn-submit"> <input type="reset" tabindex="6"
				value="<spring:message code="pm.form.clear" />" name="reset"
				class="btn-reset">
		</div>

	</form:form>
</div>
<script type="text/javascript">
	$(document).ready(function() {
	    $('#username').watermark('<spring:message code="pm.form.netid" />');
	    $('#questionText').watermark('<spring:message code="pm.setupSecurityQuestion.prompt.question" />');
	    $('#responseText').watermark('<spring:message code="pm.setupSecurityQuestion.prompt.answer" />');
    });
</script>

<jsp:directive.include file="includes/bottom.jsp" />