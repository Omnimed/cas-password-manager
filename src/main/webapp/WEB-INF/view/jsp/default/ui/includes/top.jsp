<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:theme code="mobile.custom.css.file" var="mobileCss" text="" />
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<head>
		<title>
			<spring:message code="application.title" />
		</title>
		
		<spring:theme code="standard.custom.css.file" var="customCssFile" />
		
		<link type="text/css" rel="stylesheet" href="<c:url value="${customCssFile}" />" />
		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<script type="text/javascript" src="<c:url value="/js/jquery.min.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery-ui.min.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/cas.js" />"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery.watermark.min.js" />"></script>

		<link rel="icon" href="<c:url value="/favicon.ico" />" type="image/x-icon" />
	</head>

	<body>

		<div class="centered">
			<img alt="<spring:message code="application.title" />" src="<c:url value="/images/logo.png"/>">
		</div>

		<div class="content">
