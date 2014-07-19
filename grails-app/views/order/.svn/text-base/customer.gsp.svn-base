<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <gui:resources components="['dataTable', 'toolTip']"/>
		<g:javascript library="prototype" />
		<title>Select Customer</title>
    </head>
    
    <body>
        <div class="body">
            <h1>Enter a customer number</h1>
            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${cmd}">
	            <div class="errors">
	                <g:renderErrors bean="${cmd}" as="list" />
	            </div>
            </g:hasErrors>
            <g:form action="selectCustomer" method="post" >
                <div>
                	<dl>
	                    <dt valign="top" class="name">
	                        <label for="custNo">Customer No:</label>
	                    </dt>
	                    <dd valign="top" class="value">
	                        <jsec:hasAnyRole in="${[Role.KETTLER, Role.REP_PLUS]}">
		                        <input type="text" maxlength="7" id="custNo" name="custNo" value="${cmd?.custNo}"/>
		                        <g:render template="custDataTableDialog"/>
                          </jsec:hasAnyRole>
	                        <jsec:hasAnyRole in="${[Role.REP,Role.REP_ADMIN]}">
    	                    	<g:select name="custNo" from="${customers}" onchange="this.form.submit();" optionKey="custNo" 
    	                    	     noSelection="${['':'Select a customer...']}"/>
                          </jsec:hasAnyRole>
	                    </dd>
                    </dl>
                </div>
                <div class="buttons">
                    <g:submitButton class="save" name="selectCustomer" value="Select" />
		  			<span class="menuButton">
                        <jsec:lacksAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
			  				<a href="#" id="showCustDataTableDialog" class="search" title="Click to search for a customer." 
				   				 onclick="$('custDataTableDialog').setStyle({left: '0em'});$('custDataTableDiv').show();return false;">Search</a>
				   		</jsec:lacksAnyRole>
						<a class="home" href="${createLinkTo(dir:'order')}/home.gsp">Home</a>
					</span>						
                </div>
            </g:form>
        </div>
    </body>
</html>
