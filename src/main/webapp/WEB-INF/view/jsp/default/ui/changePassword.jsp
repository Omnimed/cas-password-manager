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

<c:url value="/login" var="formActionUrl" />

<div id="admin" class="useradmin">
	<form:form method="post" action="${formActionUrl}"
		class="fm-v clearfix" modelAttribute="changePasswordBean">

		<form:errors path="username" cssClass="errors" element="div" />
		<form:errors path="oldPassword" cssClass="errors" element="div" />
		<form:errors path="newPassword" cssClass="errors" element="div" />
		<form:errors path="confirmNewPassword" cssClass="errors" element="div" />

		<div class="row fl-controls-left">
			<c:choose>
				<c:when test="${username != null}">
					<form:input style="display: none;" path="username" type="text"
						disabled="true" autocomplete="false" size="25" value="${username}"
						accesskey="n" tabindex="1" cssClass="required" id="username" />
				</c:when>
				<c:otherwise>
					<form:input path="username" type="text" autocomplete="false"
						size="25" tabindex="1" cssClass="required" name="username"
						id="username" />
				</c:otherwise>
			</c:choose>
		</div>
		<c:if test="${flowRequestContext.currentState.id != 'setPassword'}">
			<div class="row fl-controls-left">
				<form:input path="oldPassword" type="password" autocomplete="off"
					size="25" tabindex="2" cssClass="required" id="oldPassword" />
			</div>
		</c:if>
		<div class="row fl-controls-left">
			<form:input path="newPassword" type="password" autocomplete="off" onkeypress="newPasswordcapLock(event)"
				size="25" tabindex="3" cssClass="required" id="newPassword" />
				<div id="newPasswordCapsLock" class="capsLock"><spring:message code="screen.capsLockOn" /></div>
		</div>
		<div class="row fl-controls-left">
			<form:input path="confirmNewPassword" type="password" onkeypress="confirmNewPasswordcapLock(event)"
				autocomplete="off" size="25" tabindex="4" cssClass="required"
				id="confirmNewPassword" />
			<div id="confirmNewPasswordCapsLock" class="capsLock"><spring:message code="screen.capsLockOn" /></div>
		</div>
		<div class="row btn-row">
			<input type="hidden" value="${loginTicket}" name="lt"> <input
				type="hidden" value="submitChangePassword" name="_eventId">
			<input type="hidden" value="${flowExecutionKey}" name="execution">

			<div style="height: 70px;">
				<input id="submit" class="btn-submit" name="submit" accesskey="l"
					value="<spring:message code="screen.welcome.button.submit" />"
					tabindex="4" type="submit" />
			</div>
		</div>
		<div id="pswd_info">
			<h4><spring:message code="pm.changePassword.validate.title" /></h4>
			<ul>
				<li id="capital" class="invalid"><spring:message code="pm.changePassword.validate.capital" /></li>
				<li id="number" class="invalid"><spring:message code="pm.changePassword.validate.number" /></li>
				<li id="length" class="invalid"><spring:message code="pm.changePassword.validate.length" /></li>
				<li id="same" class="invalid"><spring:message code="pm.changePassword.validate.same" /></li>
			</ul>
		</div>
		<script type="text/javascript">
//			Validate the condition on each keyup, show the dialog on focus and hide the dialog on blur
			$('#newPassword').keyup(function() {
				// set password variable
				var pswd = $(this).val();
				
				//validate the length
				validateCondition($('#length'), pswd.length < 8);

				//validate capital letter
				validateCondition($('#capital'), pswd.match(/[A-Z]/) && pswd.match(/[a-z]/));

				//validate number
				validateCondition($('#number'), pswd.match(/\d/));
				
				isSubmitReady();
			}).focus(function() {
				showNewPasswordConfirmation();
				isSubmitReady();
			}).blur(function() {
				$('#pswd_info').hide();
			});
			
// 			Validate the condition on each keyup, show the dialog on focus and hide the dialog on blur
			$('#confirmNewPassword').keyup(function() {
				// set password variable
				var newPswd = $('#newPassword').val();
				var pswd = $(this).val();
				
				//validate the length
				validateCondition($('#same'), pswd != newPswd);
				
				isSubmitReady();
			}).focus(function() {
				showConfirmNewPasswordConfirmation();
				isSubmitReady();
			}).blur(function() {
				$('#pswd_info').hide();
			});
			
// 			Validate the condition and set the right state to the element
			function validateCondition(element, condition) {
				if (condition) {
					element.removeClass('invalid').addClass('valid');
				} else {
					element.removeClass('valid').addClass('invalid');
				}
			}
			
// 			Display the pwd confirmation box for the right input box
			function showNewPasswordConfirmation() {
				$('#same').hide();
				$('#capital').show();
				$('#length').show();
				$('#number').show();
				$('#pswd_info').css({ top: $(this).offset().top - 50 + 'px' });
				$('#pswd_info').css({ left: $(this).width() + $(this).offset().left + 30 + 'px' });
				$('#pswd_info').show();				
			}
			
			function showConfirmNewPasswordConfirmation() {
				$('#same').show();
				$('#capital').hide();
				$('#length').hide();
				$('#number').hide();
				$('#pswd_info').css({ top: $(this).offset().top - 15 + 'px' });
				$('#pswd_info').css({ left: $(this).width() + $(this).offset().left + 30 + 'px' });
				$('#pswd_info').show();			
			}
			
// 			Validate if the submit button should be enable or disable and apply the good state			
			function isSubmitReady() {

				var newPswd = $('#newPassword').val();
				var confirmPswd = $('#confirmNewPassword').val();
				
				var isReady = false;
				
				if ( newPswd.length >= 8 ) {
					if ( newPswd.match(/[A-Z]/) && newPswd.match(/[a-z]/)) {
						if ( newPswd.match(/\d/) ) {
							if ( newPswd === confirmPswd) {
								isReady = true;
							}
						}
					}
				}

				if (isReady) {
					$('#submit').removeAttr('disabled');
				} else {
					$('#submit').attr('disabled','disabled');
				}
				
			}
			
// 			Validate if the caps lock key is on. Call made in the form:input
			function newPasswordcapLock(e){
				 if(isCapsLockOn(e))
				  document.getElementById('newPasswordCapsLock').style.visibility = 'visible';
				 else
				  document.getElementById('newPasswordCapsLock').style.visibility = 'hidden';
				}
			function confirmNewPasswordcapLock(e){
				 if(isCapsLockOn(e))
				  document.getElementById('confirmNewPasswordCapsLock').style.visibility = 'visible';
				 else
				  document.getElementById('confirmNewPasswordCapsLock').style.visibility = 'hidden';
				}
			
			function isCapsLockOn(e) {
				kc = e.keyCode?e.keyCode:e.which;
				sk = e.shiftKey?e.shiftKey:((kc == 16)?true:false);
				return ((kc >= 65 && kc <= 90) && !sk)||((kc >= 97 && kc <= 122) && sk);
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
	</a>

</div>
<script type="text/javascript">
	$(document).ready(function() {
	    $('#username').watermark('<spring:message code="screen.welcome.label.netid" />');
	    $('#oldPassword').watermark('<spring:message code="pm.changePassword.form.password.old" />');
	    $('#newPassword').watermark('<spring:message code="pm.changePassword.form.password.new" />');
	    $('#confirmNewPassword').watermark('<spring:message code="pm.changePassword.form.password.confirm" />');
    });
</script>