<%@ page import="com.kettler.domain.actrcv.share.ReturnItem" %>
<%@ page import="com.kettler.domain.actrcv.share.Return" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Create Return</title>
      <g:javascript library="prototype" />
  </head>
<body >
    <div class="body">
		<g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
		<g:hasErrors bean="${ra}"><div class="errors"><g:renderErrors bean="${ra}" as="list" /></div></g:hasErrors>
		<g:form action="createReturn" method="post" >
			<dl>
		    	<dt>Cust No:</dt>	<dd><g:textField name="custNo" size="7"/></dd>
		    	<dt>Order No:</dt>	<dd><g:textField name="orderNo" size="7"/></dd>
			</dl>	             
            <div class="buttons">
  				<g:submitButton class="create" name="create" value="Create" />
  			</div>
        </g:form>
	</div>   
</body>
</html>
