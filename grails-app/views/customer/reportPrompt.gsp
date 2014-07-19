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
	        function showPdf() {
	            var compCode = selectForm.compCode.value
	            var orderNo = selectForm.orderNo.value
	            var shipNo = selectForm.shipNo.value
	            if (orderNo.length == 0 || shipNo.length == 0 || compCode == 0) {
	              alert('Please enter a value for all input fields');
	              return;
	            }
	            window.open ('${params.report}?compCode='+compCode+'&orderNo='+orderNo+'&shipNo='+shipNo, '${params.report}', 'location=1,status=1,scrollbars=1,width=900,height=690');
	        }
			/* note: this is called from the layout and this override will NOT work if it is in the head tag */
			function onloadHandler() {
				$('custDataTableDiv').hide(); // Grails-UI gui:dialog has issues in IE with borders of "hidden" g:render contents 
			}
		</script>
 
        <div class="body">
            <h1>Enter Order Number for PDF Generation</h1>
            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            <form name="selectForm" id="selectForm" >
                <div>
                	<dl>
                        <jsec:hasRole name="${Role.KETTLER}">
		                    <dt class="name">Comp Code</dt><dd> <input type="text" size="2" maxlength="2" id="compCode" name="compCode"  value="${params.custNo?:'01'}"/></dd>
                        </jsec:hasRole>
                        <jsec:lacksRole name="${Role.KETTLER}">
                        	<input type="hidden" id="compCode" name="compCode" value="01"/>
                        </jsec:lacksRole>
	                    <dt class="name">Order No:</dt><dd><input type="text" size="6" maxlength="6" id="orderNo" name="orderNo" value="${params.orderNo}"  onkeypress="checkNumeric(event);"/></dd>
	                    <dt class="name">Ship No:</dt><dd><input type="text" size="2" maxlength="2" id="shipNo" name=""shipNo"" value="${(params."shipNo")?:'01'}"  onkeypress="checkNumeric(event);"/></dd>
                    </dl>
                </div>
                <div class="buttons">
		  			<span class="menuButton">
						<a class="table" href="#" onclick="showPdf();" >Show PDF</a>
						<a class="home" href="${createLinkTo(dir:'order')}/home.gsp">Home</a>
					</span>						
                </div>
            </form>
        </div>
    </body>
</html>
