<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.actrcv.BalanceForward" %>
<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderHeader" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<% if (params?.popup) { %>
		<meta name="layout" content="popup" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
    <resource:dateChooser />
	<g:javascript library="prototype" />
	<title>Customer Open Invoices</title>
</head>
    
<body>
    <div class="body">
    	<h1>Customer Open Invoices</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <div class="dialog">
        	<dl>
             <dt class="name">Customer:</dt>   <dd>${cust.compCode}:${cust.custNo} - ${cust.shortName}</dd>
            </dl>
        </div>
        <g:form action="openInvoices" name="openInvoicesForm" method="post" >
        	<input type="hidden" name="max" value="${params.max}"/>
        	<input type="hidden" name="offset" value="0"/>
        	<input type="hidden" name="sort" value="${params.sort}"/>
        	<input type="hidden" name="compCode" value="${params.compCode}"/>
        	<input type="hidden" name="custNo" value="${params.custNo}"/>
        	<div class="col1">
				<dl>
					<dt>Ref No Prefix:</dt>				<dd><input type="text" size="7" maxlength="7" name="refNo" id="refNo" value="${params.refNo}"/></dd>
				</dl>
			</div>
        	<div class="col2">
				<dl>
					<dt>Trans Date:</dt>			<dd><richui:dateChooser class="date" name="transDate" value="${params.transDate}" format="MM/dd/yyyy" />mm/dd/yyyy</dd>
				</dl>
			</div>
			<div class="buttons" >
				<g:submitButton class="search" name="search" value="Search" /> 
			</div>
		</g:form>
		<br/>
    	<div class="list">
            <table style="width:100%;">
                <thead>
                    <tr>
              	        <kettler:sortableColumn property="refNo" params="${params}" title="Ref No" />
              	        <kettler:sortableColumn property="transDate" params="${params}" title="Tran Date" />
              	        <kettler:sortableColumn property="charges" params="${params}" title="Charges" />
              	        <kettler:sortableColumn property="payments" params="${params}" title="Payments" />
              	        <kettler:sortableColumn property="adjustments" params="${params}" title="Adjusts/Credits" />
              	        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <g:each in="${balSummaries}" status="i" var="balSum">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>
                        	<g:if test="${(BalanceForward.findByRefNoLike(balSum.refNo+'%'))}">
								<a href="${createLinkTo(dir:'customer')}/openInvoiceDetail?compCode=${cust.compCode}&custNo=${cust.custNo}&refNo=${balSum.refNo}&popup=${params.popup}" title="Click to display invoice payment detial">${balSum.refNo}</a>
	                            <%  if (balSum.refNo.trim().isInteger() && InvoicedOrderHeader.findByInvoiceNo(balSum.refNo.trim().toInteger())) {  %> 
									<a class="printer"  href="#" onclick="window.open ('${createLinkTo(dir:'customer')}/printInvoice?compCode=${cust.compCode}&invNo=${balSum.refNo}', 'invoice', 'location=1,status=1,scrollbars=1,width=900,height=690');"
											title="Click to display the Invoice as a PDF" >&nbsp;</a>
								<% } %>
							</g:if>
							<g:else>
								${balSum.refNo}
							</g:else>
                        </td>
                        <td class="number"><g:formatDate date="${balSum.transDate}" format="MM/dd/yy"/></td> 
                        <td class="number">${balSum.charges}</td>
                        <td class="number">${balSum.payments}</td>
                        <td class="number">${balSum.credits}</td>
                        <td class="number">${balSum.charges + balSum.payments + balSum.credits}</td>
                    </tr>
                </g:each>
                <g:if test="${(!balSummaries?.size())}">
                	<tr><td class="comment">No records found</td></tr>
                </g:if>
                </tbody>
            </table>
        </div>
        <div class="paginateButtons">
            <g:paginate total="${count?:0}" params="${params}"/>
        </div>
   </div>
	<div class="buttons">
		<span class="menuButton">
			<a class="table" href="${createLinkTo(dir:'customer')}/show?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}" title="Click to return to Customer Inquiry">Back</a>
		</span>
	</div>
</body>
</html>