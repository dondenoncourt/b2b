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
		<script>
	        function arStmt() {
	            var compCode = custSelectForm.compCode.value
	            var custNo = custSelectForm.custNo.value
	            $('custNo').selectedIndex = 0;
	            window.open ('arStmts?compCode='+compCode+'&custNo='+custNo, 'ARStmt', 'location=1,status=1,scrollbars=1,width=900,height=690');
	        }
			/* note: this is called from the layout and this override will NOT work if it is in the head tag */
			function onloadHandler() {
				$('custDataTableDiv').hide(); // Grails-UI gui:dialog has issues in IE with borders of "hidden" g:render contents 
			}
		</script>
    
        <div class="body">
            <h1>A/R Statements</h1>
            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            <form name="custSelectForm" id="custSelectForm" >
                <div>
                	<dl>
                        <jsec:hasRole name="${Role.KETTLER}">
		                    <dt class="name">Comp Code</dt><dd> <input type="text" size="2" maxlength="2" id="compCode" name="compCode"  value="${params.custNo?:'01'}"/></dd>
                        </jsec:hasRole>
	                    <dt class="name">Customer No:</dt>
			                    <dd class="value">
			                        <jsec:hasRole name="${Role.KETTLER}">
				                        <input type="text" size="7" maxlength="7" id="custNo" name="custNo" value="${params.custNo}" />
			                        </jsec:hasRole>
			                        <jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
				                        <input type="hidden" id="compCode" name="compCode" value="01"/>
				                        <input type="hidden" maxlength="7" id="custNos" name="custNos"/>
		    	                    	<g:select name="custNo" from="${customers}" onchange="arStmt();" optionKey="custNo" 
		    	                    	     noSelection="${['':'Select a customer...']}"/>
									</jsec:hasAnyRole>	                        
			                    </dd>
                    </dl>
                </div>
                <div class="buttons">
		  			<span class="menuButton">
                        <jsec:hasRole name="${Role.KETTLER}">
							<a class="table" href="#" onclick="arStmt();" >Show PDF</a>
						</jsec:hasRole>
						<a class="home" href="${createLinkTo(dir:'order')}/home.gsp">Home</a>
					</span>						
                </div>
            </form>
        </div>
    </body>
</html>
