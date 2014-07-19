<%@ page import="com.kettler.domain.orderentry.share.ConsumerShipTo" %>
<%@ page import="com.kettler.domain.orderentry.share.ConsumerBillTo" %>
<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderHeader" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
		<g:javascript library="prototype" />
		<title>Customer Inquiry</title>
		<style type="text/css">
		table {
			border-width: 1px;
			border-spacing: 2px;
			border-style: outset;
			border-color: gray;
			border-collapse: separate;
			background-color: white;
		}
		table th {
			border-width: 1px;
			padding: 1px;
			border-style: inset;
			border-color: gray;
			background-color: white;
			-moz-border-radius: ;
		}
		table td {
			border-width: 1px;
			padding: 1px;
			border-style: inset;
			border-color: gray;
			background-color: white;
			-moz-border-radius: ;
		}
		</style>
    </head>
    
<body>
    <div class="body">
<h1>List Cart Order Ship-to and Bill-to in descending order</h1>
<table style="border-style: solid; border-width: 1px;">
<tr><th>Order No</th><th>Date Created</th><th>Order Total</th><th>Ship-To Address</th><th>Bill-To Address</th></tr>
<g:each in="${carts}" var="cart">
<tr>
	<td>${cart.orderNo}</td>
	<% 
		def shipto = ConsumerShipTo.get(cart.shipToId) 
		def billto = ConsumerBillTo.get(cart.billToId) 
	    def order = OrderHeader.findWhere(compCode:'01', orderNo:cart.orderNo)
	    if (!order) {
		    order = InvoicedOrderHeader.findWhere(compCode:'01', orderNo:cart.orderNo)
	    }
	%>
	<td><g:formatDate date="${cart.dateCreated}" format="MM/dd/yy"/></td>
    <td class="number"><g:formatNumber number="${order?.orderTotal?:0.0g}" format="\$###,###,##0.00" /></td>
	<% if (shipto) { %>
	<td>
		${shipto.name}<br/>
		${shipto.addr1}<br/>
		<% if (shipto.addr2) { %>
			${shipto.addr2}<br/>
		<% } %> 
		${shipto.city}, ${shipto.state}   ${shipto.zipCode}<br/>
	</td>
	<% } else { %>
		<td>no ship to (ship-to: ${cart.shipToId} bill-to: ${cart.billToId})</td>
	<% } %>
	<% if (billto) { %>
	<td>
		${billto.name}<br/>
		${billto.addr1}<br/>
		<% if (billto.addr2) { %>
			${billto.addr2}<br/>
		<% } %> 
		${billto.city}, ${billto.state}   ${billto.zipCode}<br/>
	</td>
	<% } else { %>
		<td>None found (ship-to: ${cart.shipToId} bill-to: ${cart.billToId})</td>
	<% } %>
</tr>
	
</g:each>
</table>
<g:paginate controller="customer" action="listRetailShiptoBillto" total="${kount}" /></div>
</body>