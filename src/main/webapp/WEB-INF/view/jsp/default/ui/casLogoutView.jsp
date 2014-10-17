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

		<div id="msg" class="success">
			<spring:message code="screen.logout.success" />
		</div>
		<div class="" style="padding-bottom: 10px;">
			<spring:message code="screen.logout.security" /></br></br>
			<c:set var="googleUrl" value="http://support.google.com/chrome/bin/answer.py?hl=" />
			<c:set var="googleEndUrl" value="&answer=95582" />
			<c:set var="language" value="${pageContext.request.locale.language}" />

			<a href="${googleUrl}${language}${googleEndUrl}" target="_blank" >
				<spring:message code="screen.logout.deletecache" />
			</a>
		</div>
		<div class="languageBar">
			<a href="/omnimed"><spring:message code="pm.helpDesk.exit-link.text" /></a>   
		</div>
<jsp:directive.include file="includes/bottom.jsp" />
