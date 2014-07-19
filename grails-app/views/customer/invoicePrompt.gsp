<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="org.jsecurity.SecurityUtils" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <gui:resources components="['dataTable', 'toolTip']"/>
		<g:javascript library="prototype" />
		<title>Select Invoice for Reprint</title>
    </head>
    <body>
		<script>
	        function invoicePdf() {
	            var compCode = invSelectForm.compCode.value
	            var invNo = invSelectForm.invNo.value
	            window.open ('printInvoice?compCode='+compCode+'&invNo='+invNo, 'invoicePdf', 'location=1,status=1,scrollbars=1,width=900,height=690');
	        }
		</script>
    
        <div class="body">
            <h1>Invoice Reprint</h1>
            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            <form name="invSelectForm" id="invSelectForm" >
                <div>
                	<dl>
                        <jsec:hasRole name="${Role.KETTLER}">
		                    <dt class="name">Comp Code:</dt><dd> <input type="text" size="2" maxlength="2" id="compCode" name="compCode"  value="${params.compCode?:'01'}"/></dd>
                        </jsec:hasRole>
                        <jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN,Role.CUSTOMER,Role.CUST_ADMIN]}">  
                            <% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()) %>
                            <g:hiddenField name="compCode" value="${user.compCode}"/>
                        </jsec:hasAnyRole>                        
	                    <dt class="name">Invoice No:</dt><dd><input type="text" size="7" maxlength="7" id="invNo" name="invNo"  onkeypress="checkNumeric(event);" value="${params.invNo}" /></dd>
                    </dl>
                </div>
                <div class="buttons">
		  			<span class="menuButton">
						<a class="table" href="#" onclick="invoicePdf();" >Show PDF</a>
						<a class="home" href="${createLinkTo(dir:'order')}/home.gsp">Home</a>
					</span>						
                </div>
            </form>
        </div>
    </body>
</html>
