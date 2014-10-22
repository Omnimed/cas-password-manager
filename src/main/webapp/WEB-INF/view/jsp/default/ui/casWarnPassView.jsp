<jsp:directive.include file="includes/top.jsp" />
<c:set var="ticketArg"  value="${serviceTicketId}" scope="page"/>
<c:if test="${fn:length(ticketArg) > 0}">
  <c:set var="ticketArg"  value="ticket=${serviceTicketId}"/>
</c:if>
<c:url var="changePasswordUrl" value="/cas/login">
  <c:param name="execution" value="${flowExecutionKey}"/>
  <c:param name="_eventId" value="changePassword"/>
</c:url>
<c:url var="ignoreUrl" value="/cas/login">
  <c:param name="execution" value="${flowExecutionKey}"/>
  <c:param name="_eventId" value="ignore"/>
</c:url>

<div class="warning">

  <c:choose>
    <c:when test="${empty passwordPolicyUrl}">
        <spring:message code="screen.warnpass.message.line1" arguments="${changePasswordUrl}" /></br>
        <spring:message code="screen.warnpass.message.line2" arguments="${ignoreUrl}" />
    </c:when>
    <c:otherwise>
        <spring:message code="screen.warnpass.message.line1" arguments="${passwordPolicyUrl}" /></br>
        <spring:message code="screen.warnpass.message.line2" arguments="${fn:escapeXml(param.service)}${fn:indexOf(param.service, '?') eq -1 ? '?' : '&'}${ticketArg}" />
    </c:otherwise>
  </c:choose>
</div>
<script type="text/javascript">
<!--

  function redirectTo(URL) {
    window.location = URL ;
  }
  setTimeout("redirectTo('/cas/login?service=${service}')", 10000);

</script>