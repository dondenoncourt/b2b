<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderDetailItem" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.SalesDivision" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>

<%@ page import="com.kettler.domain.actrcv.share.Customer" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<% if (params.popup) { %>
		<meta name="layout" content="popup" />
	<% } else if (params.pdf) { %>
		<meta name="layout" content="pdf" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
    <resource:dateChooser />
	<g:javascript library="prototype" />
	<title>Invoiced Order Inquiry</title>
</head>
<body>
<div class="body">
<% if (!params.pdf) { %>
	<g:javascript>
		function submitPdf() {
			var formValues =  
				'compCode='+$('compCode').value+
				'&fromDate='+$('fromDate').value+''+
				'&fromDate_day='+$('fromDate_day').value+''+
				'&fromDate_month='+$('fromDate_month').value+''+
				'&fromDate_year='+$('fromDate_year').value+''+
				'&toDate='+$('toDate').value+''+
				'&toDate_day='+$('toDate_day').value+''+
				'&toDate_month='+$('toDate_month').value+''+
				'&toDate_year='+$('toDate_year').value+''+
				<% if (cmd.fromDate2) { %>
				'&fromDate2='+$('fromDate2').value+''+
				'&fromDate2_day='+$('fromDate2_day').value+''+
				'&fromDate2_month='+$('fromDate2_month').value+''+
				'&fromDate2_year='+$('fromDate2_year').value+''+
				'&toDate2='+$('toDate2').value+''+
				'&toDate2_day='+$('toDate2_day').value+''+
				'&toDate2_month='+$('toDate2_month').value+''+
				'&toDate2_year='+$('toDate2_year').value+''+
				<% } %>
				<% if (cmd.fromDate3) { %>
				'&fromDate3='+$('fromDate3').value+''+
				'&fromDate3_day='+$('fromDate3_day').value+''+
				'&fromDate3_month='+$('fromDate3_month').value+''+
				'&fromDate3_year='+$('fromDate3_year').value+''+
				'&toDate3='+$('toDate3').value+''+
				'&toDate3_day='+$('toDate3_day').value+''+
				'&toDate3_month='+$('toDate3_month').value+''+
				'&toDate3_year='+$('toDate3_year').value+''+
				<% } %>
				'&reportType='+$('reportType').value+''+
				'&rowCount='+$('rowCount').value+''+
				'&salesDivision='+$('salesDivision').value+''+
				'&unitsOrDollars='+$('unitsOrDollars').value+
				'&pdf=true'+
				'&userEmail='+'${user.email}'
			formValues = escape(formValues);
			var url = '/${meta(name:'app.name')}/pdf/show?url=/salesAnalysis/analyze?'+formValues+'&pdf=true';
			window.location=url;
		}
	</g:javascript>
<% } %>
    <div>
    	<h1>Sales Analysis</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
    </div>
   	<div class="list full">
   		<dl>
			<dt>Report:</dt><dd><g:message code="salesAnal.Rpt.Typ.${params.reportType}" /></dd>
			<% if (user.role.role == Role.getNo(Role.KETTLER)) { %>
	   			<dt>Company Code:</dt><dd>${params.compCode}</dd>
	   		<% } %>
			<% if (user.role.role == Role.getNo(Role.CUSTOMER)) { %>
				<dt>Customer:</dt><dd>${user.custNo}: ${Customer.findByCompCodeAndCustNo(user.compCode, user.custNo)?.name}</dd>
			<% } %>
			<% if (user.role.role == Role.getNo(Role.REP)    ||
			       user.role.role == Role.getNo(Role.REP_PLUS)) { %>
				<dt>Rep:</dt><dd>${SalesPerson.get(user?.salesperson.id)?.name}</dd>
			<% } %>
   			<% if (params.salesDivision) { %>
   				<dt>Sales Division:</dt><dd>${(SalesDivision.get(params.salesDivision)?.desc)}</dd>
   			<% } %>
   			<dt>Units/Dollars:</dt><dd>${params.unitsOrDollars == 'U'?'Units':'Dollars'}</dd>
   		</dl>
   		<br/>
       <table>
           <thead>
               <tr>
         	        <th/> 
         	        <th>${headings[0]}</th>
         	        <th>${headings[1]}</th>
         	        <th>
							<g:formatDate date="${cmd.fromDate}" format="MM/dd/yy"/>
							-<br/>
							<g:formatDate date="${cmd.toDate}" format="MM/dd/yy"/>
         	        </th>
					<% if (cmd.fromDate2) { %>
         	        	<th>
							<g:formatDate date="${cmd.fromDate2}" format="MM/dd/yy"/>
							-<br/>
							<g:formatDate date="${cmd.toDate2}" format="MM/dd/yy"/>
         	        	</th>
         	        	<th>% Change</th>
					<% } %>
					<% if (cmd.fromDate3) { %>
         	        	<th>
							<g:formatDate date="${cmd.fromDate3}" format="MM/dd/yy"/>
							-<br/>
							<g:formatDate date="${cmd.toDate3}" format="MM/dd/yy"/>
         	        	</th>
         	        	<th>% Change</th>
					<% } %>
               </tr>
           </thead>
           <tbody>
           
			<%  def i = 0
				sql.eachRow (query) {dtl -> 
				i++
				BigDecimal compare1 = dtl[2].toBigDecimal()
			%>
	            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
						<td class="number">${i}</td>
						<td>${dtl[0]}</td>
						<td>${dtl[1]?.encodeAsHTML()}</td>
						<td class="number">
							<% if (params.unitsOrDollars == 'U') { %>
								<g:formatNumber number="${compare1}" format="###,###,##0.00" />
							<% } else { %>
								<g:formatNumber number="${compare1}" format="\$###,###,##0.00" />
							<% } %>
						</td>
						<% if (dtl[3] != 'N') {%>
							<td class="number">
								<%
									def compare2 = 0g
									def result = sql.firstRow (dtl[3], [params.compCode, dtl[0]]) 
									if (result) { 
										compare2 = result[0]?.toBigDecimal()
									}
								%>
								<% if (params.unitsOrDollars == 'U') { %>
									<g:formatNumber number="${compare2}" format="###,###,##0.00" />
								<% } else { %>
									<g:formatNumber number="${compare2}" format="\$###,###,##0.00" />
								<% } %>
							</td>
							<td class="number">	
								<% if (compare2) { %>
									<% if (compare1 == compare2) { %>
									    <!--  no change -->	
									<% } else { %>
									<%-- =((compare1-compare2)/compare2)*100 --%>
										<g:formatNumber number="${((compare1-compare2).divide(compare2, 3, BigDecimal.ROUND_HALF_UP))*100}" format="###,##0.0" />
									<% } %>
								<% } else { %>
									100.0
								<% } %>
							</td>          
						<% } %>
						<% if (dtl[4] != 'N') {%>
							<td class="number">
								<% 
									def compare3 = 0g
									def result = sql.firstRow (dtl[4], [params.compCode, dtl[0]]) 
									if (result) { 
										compare3 = result[0]?.toBigDecimal()
									}
								%>
								<% if (params.unitsOrDollars == 'U') { %>
									<g:formatNumber number="${compare3}" format="###,###,##0.00" />
								<% } else { %>
									<g:formatNumber number="${compare3}" format="\$###,###,##0.00" />
								<% } %>
							</td>
							<td class="number">	
								<% if (compare3) { %>
									<% if (compare1 == compare3) { %>
										<!--  no change -->
									<% } else { %>
										<g:formatNumber number="${((compare1-compare3).divide(compare3, 3, BigDecimal.ROUND_HALF_UP))*100}" format="###,##0.0" />
									<% } %>
								<% } else { %>
									100.0
								<% } %>
							</td>          
						<% } %>
				</tr>
		
			<% } %>
           </tbody>
       </table>
   </div>
	<% if (!params.pdf) { %>
		<g:form  name="backForm" action="prompt">
			<g:hiddenField name="compCode" value="${cmd.compCode}" />
			<richui:dateChooser class="date" name="fromDate" style="visible: hidden;display: none;" format="MM/dd/yyyy"  value="${cmd.fromDate}" /> 
			<richui:dateChooser class="date" name="toDate"  style="visible: hidden;display: none;" format="MM/dd/yyyy"  value="${cmd.toDate}" />
			<% if (cmd.fromDate2) { %>
				<richui:dateChooser class="date" name="fromDate2" style="visible: hidden;display: none;" format="MM/dd/yyyy"  value="${cmd.fromDate2}" /> 
				<richui:dateChooser class="date" name="toDate2"  style="visible: hidden;display: none;" format="MM/dd/yyyy"  value="${cmd.toDate2}" />
			<% } %>
			<% if (cmd.fromDate3) { %>
				<richui:dateChooser class="date" name="fromDate3" style="visible: hidden;display: none;" format="MM/dd/yyyy"  value="${cmd.fromDate3}" /> 
				<richui:dateChooser class="date" name="toDate3"  style="visible: hidden;display: none;" format="MM/dd/yyyy"  value="${cmd.toDate3}" />
			<% } %>
			<g:hiddenField name="reportType" value="${cmd.reportType}"  />
			<g:hiddenField name="rowCount"   value="${cmd.rowCount}"/>	 
			<g:hiddenField name="salesDivision" value="${cmd.salesDivision}" />
			<g:hiddenField name="unitsOrDollars"  value="${cmd.unitsOrDollars}"/>	 
			<div class="buttons" >
				<g:submitButton class="table" name="Prompt" value="Back" title="Click to return to Sales Analysis prompt"/> 
				<span class="menuButton">
					<a href="#" onClick="submitPdf();" title="Click to display a PDF version of this page"><img src="/kettler/images/skin/pdficon_small.gif" alt="PDF Version"></a>
				</span>
			</div>
		</g:form>
	<% } %>
</div>
</body>
</html>
