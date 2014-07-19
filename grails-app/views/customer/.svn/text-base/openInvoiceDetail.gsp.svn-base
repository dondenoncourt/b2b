<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<% if (params?.popup) { %>
		<meta name="layout" content="popup" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
	<g:javascript library="prototype" />
	<title>Customer Open Invoice Detail</title>
</head>
    
<body>
    <div class="body">
    	<h1>Customer Open Invoice Detail</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <div class="dialog">
        	<dl>
             <dt class="name">Customer:</dt>   <dd>${cust.compCode}:${cust.custNo} - ${cust.shortName}</dd>
            </dl>
        </div>
    	<div class="list">
            <table style="width:100%">
                <thead>
                    <tr>
              	        <th>Ref No</th>
              	        <th>Transaction Type</th>
              	        <th>Trans Date</th>
              	        <th>Due Date</th>
              	        <th>Amount</th>
              	        <th>Balance</th>
              	        <th>Comment</th>
                     </tr>
                </thead>
                <tbody>
                <% def balance = 0.00g %>
                <g:each in="${balForwards}" status="i" var="balFwd">
	                <% balance += balFwd.amount %>
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>${balFwd.refNo}</td>
                        <td><g:message code="paymentType.${balFwd.type}"/></td>
                        <td class="number"><g:formatDate date="${balFwd.transDate}" format="MM/dd/yy"/></td> 
                        <td class="number"><g:formatDate date="${balFwd.agingDate}" format="MM/dd/yy"/></td> 
                        <td class="number">${balFwd.amount}</td>
                        <td class="number">${balance}</td>
                        <td>${balFwd.comment}</td>
                    </tr>
                </g:each>
                <g:if test="${(!balForwards?.size())}">
                	<tr><td class="comment">No records found</td></tr>
                </g:if>
                </tbody>
            </table>
        </div>
   </div>
	<div class="buttons">
		<span class="menuButton">
			<a class="table" href="${createLinkTo(dir:'customer')}/openInvoices?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}" 
				title="Click to return to Customer Open Invoice">Back</a>
			<% if (invoice) { %>
				<a href="${createLinkTo(dir:'customer')}/invoiceHistDetail?compCode=${invoice.compCode}&orderNo=${invoice.orderNo}&shipNo=${invoice.shipNo}&popup=${params.popup}" 
					title="Click to display invoice history detial">${invoice.invoiceNo}</a>
			<% } %>		
		</span>
	</div>
</body>
</html>