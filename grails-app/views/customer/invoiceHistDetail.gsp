<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderDetailItem" %>
<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>
<%@ page import="com.kettler.domain.orderentry.FOBCode" %>
<%@ page import="com.kettler.domain.orderentry.Terms" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<% if (params?.popup) { %>
		<meta name="layout" content="popup" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
	<g:javascript library="prototype" />
	<title>Invoiced Order Inquiry</title>
</head>
<body>
<div class="body">
    <div>
    	<h1>Invoiced Order Inquiry</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <dl class="wide"><dt>Order No: </dt><dd>${invoice.orderNo} - ${invoice.shipNo}</dd></dl>
    </div>
	<div class="col1">
		<dl>
			<dt class="name">Customer:</dt>   <dd>${invoice.compCode}:${invoice.custNo}</dd>
		</dl>
		${cust.name}<br/>
        ${cust.addr1}<br/>
        <g:if test="${cust.addr2.trim()}">
            ${cust.addr2}<br/>
        </g:if>
        <g:if test="${cust.addr3.trim()}">
            ${cust.addr3}<br/>
        </g:if>
        ${cust.city}, ${cust.state} ${cust.zipCode}
    </div>
	<div class="col2">
    	<g:if test="${invoice.shipToNo}">
	        <dl>
	          <dt>Ship-To No:</dt>		<dd>${(invoice.shipToNo?:'&nbsp;')} ${(shipTo?.countryCode)?:'&nbsp;'}</dd>
	        </dl>
		</g:if>
		<g:else>
			<br/><br/><br/><br/><h3>Ship-To Address</h3><br/>
		</g:else>
		<g:if test="${shipTo}">
	        ${shipTo?.name}<br/>
	        ${shipTo?.addr1}<br/>
	        <g:if test="${shipTo?.addr2?.trim()}">
	            ${shipTo?.addr2}<br/>
	        </g:if>
	        <g:if test="${shipTo?.addr3?.trim()}">
	            ${shipTo?.addr3}<br/>
	        </g:if>
	        ${shipTo?.city}, ${shipTo?.state} ${shipTo?.zipCode}<br/>
        </g:if>
        <g:else>
        	Same<br/><br/><br/><br/><br/>
        </g:else>
	</div>
	<div class="col1">
		<dl>
			<dt class="name">Order Date:</dt>   <dd><g:formatDate date="${invoice.invoiceDate}" format="MM/dd/yy"/></dd>
			<dt class="name">Pick Date:</dt>   <dd><g:formatDate date="${invoice.pickDateMDY}" format="MM/dd/yy"/></dd>
			<dt class="name">Due Date:</dt>   <dd><g:formatDate date="${invoice.dueDate}" format="MM/dd/yy"/></dd>
			<dt class="name">Invoice Date & No:</dt>   <dd><g:formatDate date="${invoice.invoiceDate}" format="MM/dd/yy"/> ${invoice.invoiceNo}</dd>
			<dt class="name">Payment Terms:</dt>   <dd>${(Terms.get(invoice.termsCode)?.desc?:'&nbsp;')}</dd>
		</dl>
	</div>
	<div class="col2">
		<dl>
			<dt class="name">Carrier:</dt>   <dd>${(Carrier.get(invoice.carrierCode)?.desc)?:'&nbsp;'}</dd>
			<dt class="name">Freight Tracking:</dt>   <dd>${invoice.freightTrackingNo?:'&nbsp;'}</dd>
			<dt class="name">Shipping Terms:</dt>   <dd>${(FOBCode.get(invoice.fobCode)?.desc?:'&nbsp;')}</dd>
			<dt class="name">PO No:</dt>   <dd>${invoice.poNo?:'&nbsp;'}</dd>
			<dt class="name">Salesperson</dt>   <dd>${invoice.salesperson1}:${(SalesPerson.get(invoice.salesperson1)?.name)}</dd>
		</dl>
	</div>
   	<div class="list full">
       <table style="width:100%;">
           <thead>
               <tr>
         	        <kettler:sortableColumn property="itemNo" params="${params}" title="Item No" />
         	        <th>Description</th>
         	        <th style="width:6em;">Order Qty</th>
         	        <th style="width:6em;">Ship Qty</th>
         	        <th style="width:6em;">B/O Qty</th>
         	        <th>Price</th>
         	        <th>Amount</th>
               </tr>
           </thead>
           <tbody>
			<g:each in="${detailMap}" status="i" var="dtl">
	            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}"> 
                    <% if (dtl.value.lineType == 'I' || dtl.value.lineType == 'N') { %>
						<td>${dtl.value.itemNo}</td>
						<td>${dtl.value.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
						<td class="number">${dtl.value.orderQty}</td>
						<td class="number">${dtl.value.shipQty}</td>
						<td class="number">${dtl.value.backOrderQty}</td>
						<td class="number">${dtl.value.unitPrice}</td>
						<td class="number">${dtl.value.amount}</td>
					<% } else if (dtl.value.lineType == 'M') { %>
						<td/>
						<td>${dtl.value.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td class="number">${dtl.value.amount}</td>
					<% } else if (dtl.value.lineType == 'C') { %>
						<td/>
						<td class="comment">${dtl.value.desc}</td>
						<td colspan="5"/> 
					<% } else  { %>
						<td colspan="7">Invalid line type</td>
					<% } %>
				</tr>
			</g:each>
           </tbody>
       </table>
   </div>
	<div class="buttons">
		<span class="menuButton">
			<% if (params.requestPage == 'selectOrder') { %>
				<a class="table" href="${createLinkTo(dir:'order')}/listOrders" title="Click to return to the order search panel">Back</a>
			<% } else { %>
			<a class="table" href="${createLinkTo(dir:'customer')}/invoiceHist?compCode=${invoice.compCode}&custNo=${invoice.custNo}&popup=${params.popup}" 
				title="Click to return to Customer Invoice History">Back</a>
			<% } %>
		</span>
	</div>
</div>
</body>
</html>