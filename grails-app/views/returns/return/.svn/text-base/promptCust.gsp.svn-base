<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.actrcv.share.Customer" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Create Return</title>
      <gui:resources components="['dataTable']"/>
      <g:javascript library="prototype" />
  </head>
<body >
    <div class="body">
		<g:if test="${message}"><div class="message">${message}</div></g:if>
		<h1>Select a customer</h1>
		<g:form action="return" method="post" >
			<dl>
	            <jsec:hasRole name="${Role.KETTLER}">
			    	<dt>Comp Code:</dt>	<dd><g:textField name="compCode" size="2" value="${(compCode?:'01')}"/></dd>
	    			<dt>Cust No:</dt>	<dd><g:textField name="custNo"   size="7" value="${(custNo)}"/></dd>
				</jsec:hasRole>		
				<jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
					<g:hiddenField name="compCode" value="${user.compCode}"/>
					<dt>Customer:</dt>
					<dd>
					<g:select name="custNo" from="${user.customers}" 
						  optionKey="custNo" noSelection="${['':'Select a customer...']}"/>
					</dd>
				</jsec:hasAnyRole>           
			</dl>	             
            <g:render template="/order/custDataTableDialog"/>
		    	
            <div class="buttons">
  				<g:submitButton class="create" name="next" value="Next" />
                 <input type="button" class="search" id="showCustDataTableDialog"  value="Search" 
                     title="Click to search for an item" 
                     onclick="$('custDataTableDialog').setStyle({left: '0em'});$('custDataTableDiv').show();return false;"/>
  			</div>
        </g:form>
	</div>   
</body>
</html>
