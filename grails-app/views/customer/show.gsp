<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.Terms" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.ContractPrice" %>
<%@ page import="com.kettler.domain.item.ProfitCenter" %>
<%@ defaultCodec="html" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <% if (params.popup || params.pdf) { %>
		<meta name="layout" content="popup" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
    <title>Customer Inquiry</title>
</head>
<body>
    <div class="body">
        <h1>Customer Inquiry</h1>
		<dl>
			<dt>&#160;</dt><dd>
								<% if (cust.activeCode == '') { %>Active 
								<% } else if (cust.activeCode == 'I') { %>InActive 
								<% } else { %> activeCode: ${cust.activeCode} <% } %>
						   </dd>
			<dt>Cust No:</dt><dd>${cust.compCode}: ${cust.custNo.replaceAll(/&/, '&#38;')}</dd>
			<dt>Name:</dt><dd>${cust.name.replaceAll(/&/, '&#38;')}</dd>
			<dt>Address:</dt><dd>${(cust.addr1?:'&#160;')}</dd>
			<g:if test="${cust.addr2}">
				<dt>&#160;</dt><dd>${(cust.addr2?:'&#160;')}</dd>
			</g:if>
			<g:if test="${cust.addr3}">
				<dt>&#160;</dt><dd>${(cust.addr3?:'&#160;')}</dd>
			</g:if>
			<dt>&#160;</dt><dd>${cust.city}, ${cust.state}  ${cust.zipCode}</dd>
		</dl>
	</div>
	<br/>
	<div class="col1">
		<dl>
		    <% if (cust.invoiceDiscPct) { %>
			 <dt>Invoice Disc:</dt><dd>${cust.invoiceDiscPct}%</dd>
			<% } %>
			<% (1..5).each {i -> 
			    if (cust."lineDisc${i}")  { %>
			        <dt>Line Disc ${i}</dt><dd><%= cust."lineDisc${1}"%>%</dd>
			    <% } %>
            <% } %>
            <% custDiscAllowList.each {discAllow -> %>
                    <dt>${(ProfitCenter.get(discAllow.profitCenter)?.desc?:discAllow.profitCenter)} Disc Allow:</dt><dd>${discAllow.percent}%</dd>
            <% } %>
			<dt>Phone:</dt><dd>${cust.phoneNo}</dd>
			<dt>Fax No:</dt><dd>${cust.faxNo}</dd>
			<dt>Back Order:</dt><dd>${(cust.backOrderCode?'Yes':'No')}</dd>
			<dt>Sales Rep:</dt><dd>${cust.salespersonCode} - ${(SalesPerson.get(cust.salespersonCode)?.name.encodeAsHTML())}</dd>
       	    <jsec:hasRole name="${Role.KETTLER}">
				<dt>Collection Code:</dt><dd>${cust.collectionCode?:'&#160;'}</dd>
       	    	<dt>Sales Division:</dt><dd>${cust.salesDivision?:'&#160;'}</dd>
				<dt>Credit Rating:</dt><dd>${cust.creditRating}</dd>
				<dt>Price Code:</dt><dd>${cust.itemPriceCode}0</dd>
			</jsec:hasRole>
		</dl>
	</div>
	<div class="col2">
		<dl>
			<dt>Opened:</dt><dd>
								<g:message code="month.${cust.monthYearOpened.intdiv(100)}"/> 
								<%  def century = 2000
									if (cust.monthYearOpened%100 > 50) century = 1900 
								%>
								${cust.monthYearOpened%100+century}
							</dd> 
			<dt>Terms:</dt><dd>${cust.termsCode?.trim()?:'&#160;'} ${(Terms.get(cust.termsCode)?.desc?.encodeAsHTML())}</dd>
			<dt>Contact:</dt><dd>${cust.contact?.encodeAsHTML()}&#160;</dd>
			<dt>Tax Exempt:</dt><dd>${(cust.taxExempt?'Yes':'No')}</dd>
			<dt>Tax Codes:</dt><dd>${cust.taxCode1?:'&#160;'} ${cust.taxCode2?:'&#160;'} ${cust.taxCode3?:'&#160;'}</dd>
			<dt>Email:</dt><dd>${cust.email?:'&#160;'}</dd>
       	    <jsec:hasRole name="${Role.KETTLER}">
				<dt>Cycle Code:</dt><dd>${cust.billingCycle}1</dd>
			</jsec:hasRole>
		</dl>
	</div>
	<div class="col1">
		<dl>
			<dt>Current:</dt><dd class="number"><g:formatNumber number="${ageCurrent}" format="\$#,###,##0.00" /></dd>
			<dt>1-30 DAYS:</dt><dd class="number"><g:formatNumber number="${age1to30}" format="\$#,###,##0.00" /></dd>
 			
			<dt>31-60 DAYS:</dt><dd class="number"><g:formatNumber number="${age31to60}" format="\$#,###,##0.00" /></dd>
			<dt>61-90 DAYS:</dt><dd class="number"><g:formatNumber number="${age61to90}" format="\$#,###,##0.00" /></dd>
			<dt>91 + DAYS:</dt><dd class="number"><g:formatNumber number="${age90Plus}" format="\$#,###,##0.00" /> </dd>
			<dt>Past Due:</dt><dd class="number"><g:formatNumber number="${(age1to30 + age31to60 + age61to90 + age90Plus)}" format="\$#,###,##0.00" /></dd>
       	    <jsec:hasRole name="${Role.KETTLER}">
				<dt>Last Maintained:</dt><dd class="number">${cust.lastMaintUserId} <g:formatDate format="MM/dd/yy" date="${cust.lastMaintDate}"/> </dd>
			</jsec:hasRole>
		</dl>
	</div>
	<div class="col2">
		<dl>
       	    <jsec:hasRole name="${Role.KETTLER}">
				<dt>Previous Balance:</dt><dd class="number"><g:formatNumber number="${cust.prevBalance}" format="\$#,###,##0.00" /></dd>
				<dt>Current Charges:</dt><dd class="number"><g:formatNumber number="${cust.currentChgs}" format="\$#,###,##0.00" /></dd>
				<dt>Current Payments:</dt><dd class="number"><g:formatNumber number="${cust.currentPmts}" format="\$#,###,##0.00" /></dd>
				<dt>Current Adj:</dt><dd class="number"><g:formatNumber number="${cust.currentAdjs}" format="\$#,###,##0.00" /></dd>
				<dt>Current Balance:</dt><dd class="number"><g:formatNumber number="${((cust.prevBalance + cust.currentChgs) - cust.currentPmts.abs() + cust.currentAdjs)}" format="\$#,###,##0.00" /></dd>
				<dt>Future Charges:</dt><dd class="number"><g:formatNumber number="${cust.futureChgs}" format="\$#,###,##0.00" /></dd>
				<dt>Future Payments:</dt><dd class="number"><g:formatNumber number="${cust.futurePmts}" format="\$#,###,##0.00" />${cust.futurePmts}</dd>
				<dt>Future Adj:</dt><dd class="number"><g:formatNumber number="${cust.futureAdjs}" format="\$#,###,##0.00" /></dd>
			</jsec:hasRole>
			<dt>Total Balance:</dt><dd class="number"><g:formatNumber number="${(cust.prevBalance + cust.currentChgs - cust.currentPmts.abs() + cust.currentAdjs + cust.futureChgs + cust.futurePmts.abs() + cust.futureAdjs)}" format="\$#,###,##0.00" /></dd>
			<dt>Credit Limit:</dt><dd class="number"><g:formatNumber number="${cust.creditLimit}" format="\$#,###,##0.00" /></dd>
			<dt>Credit Remaining:</dt><dd class="number"><g:formatNumber number="${(cust.creditLimit - orderTotal)}" format="\$#,###,##0.00" /></dd>
			<dt>High Balance:</dt><dd class="number"><g:formatNumber number="${cust.highBalance}" format="\$#,###,##0.00" /></dd>
			<dt>Last Charges:</dt><dd class="number"><g:formatNumber number="${cust.lastChgAmnt}" format="\$#,###,##0.00" /> <g:formatDate format="MM/dd/yy" date="${cust.lastChgDate}"/></dd>
			<dt>Last Payment:</dt><dd class="number"><g:formatNumber number="${cust.lastPmtAmnt}" format="\$#,###,##0.00" /> <g:formatDate format="MM/dd/yy" date="${cust.lastPmtDate}"/> </dd>
			<dt>Last Adj:</dt><dd class="number"><g:formatNumber number="${cust.lastAdjAmnt}" format="\$#,###,##0.00" /> <g:formatDate format="MM/dd/yy" date="${cust.lastAdjDate}"/> </dd>
		</dl>
	</div>
	<% if (!params.pdf) { %>
	<div class="buttons">
		<span class="menuButton">
			<a class="table" href="${createLinkTo(dir:'order')}/listOrders?inquiry=true&search=Search&statusCode=+&compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}">Open Orders</a>
			<a class="table" href="${createLinkTo(dir:'customer')}/salesHist?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}">Sales History</a>
			<a class="table" href="${createLinkTo(dir:'customer')}/openInvoices?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}">Open Invoices</a>
			<a class="table" href="${createLinkTo(dir:'customer')}/invoiceHist?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}">Invoice History</a>
			<a class="table" href="#" onclick="window.open('${createLinkTo(dir:'customer')}/arStmts?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}', 'ARStmt', 'location=1,status=1,scrollbars=1,width=900,height=690')">AR Statements</a>
			<% if (ContractPrice.inEffectForCust(cust.compCode, cust.custNo)) { %>
				<a class="table" href="${createLinkTo(dir:'contractPrice')}/list?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}" title="Click to see Contract Prices">Contract Prices</a>
			<% } %>
			<g:if test="${params.popup}">
				<a class="home" href="#" onclick="window.close();" title="Click to close">Close</a>
			</g:if>
			<g:else>
       	    	<jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP_ADMIN,Role.REP,Role.KETTLER]}">
					<a class="table" href="${createLinkTo(dir:'customer')}/list" title="Click to return to Customer search">Back</a>
				</jsec:hasAnyRole>
			</g:else>
			<g:pdf url="/customer/show?compCode=${cust.compCode}&custNo=${cust.custNo}" icon="true"/>
		</span>
	</div>
	<% } %>
</body>
</html>
