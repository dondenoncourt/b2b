<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Marketing Mass Email to Retail</title>
    <meta name="layout" content="main" />
</head>
<body>
<div class="body">
    <h2>Marketing Mass Email to ${kount} Retail Customers</h2>
	<br/>
    <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
	<g:form action="massRetailEmail">
		<div >
			<dl>
				<dt>Subject:</dt>			<dd><input type="text" name="subject" size="50" value="${params.subject}"/></dd>
				<dt>From:</dt>				<dd><input type="text" name="from" size="50" value="${params.from?:'webmaster@kettlerusa.com'}"/></dd>
			</dl>
		</div>
		<br/>
		<h3>Message Content</h3>
	 	Sending HTML Content: <g:checkBox name="html" value="${params.html!=null?params.html:true}"/>
		<div>
			<textarea rows="100" cols="120" name="body">${params.body}</textarea>
		</div>
		<div class="buttons" >
			<g:submitButton class="search" name="massRetailEmail" value="Send" onclick="return confirm('Are you sure?');" /> 
		</div>
	</g:form>
	    
</div>
</body>
</html>
