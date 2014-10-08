
<jsp:directive.include file="includes/top.jsp" />
<link type="text/css" rel="stylesheet" href="<c:url value="/css/cas-pm.css" />" />

        <h2><spring:message code="pm.lockedOut.header" /></h2>
    <div id="msg" class="errors">
        
        <spring:message code="pm.lockedOut.text" />
    </div>

<div class="languageBar">
        <a href="<c:url value="/cas/login?service=${service}" />"><spring:message code="pm.helpDesk.exit-link.text" /></a>
</div>

<jsp:directive.include file="includes/bottom.jsp" />
