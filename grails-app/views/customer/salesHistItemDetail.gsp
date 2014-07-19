<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderDetailItem" %>
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<% if (params?.popup) { %>
		<meta name="layout" content="popup" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
	<g:javascript library="prototype" />
	<title>Customer Sales History Item Detail</title>
</head>
    
<body>
    <div class="body">
    	<h1>Customer Sales History for ${params.year.toInteger()+2000} Item ${params.itemNo} Detail</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <div class="dialog">
        	<dl>
             <dt class="name">Customer:</dt>   <dd>${cust.compCode}:${cust.custNo} - ${cust.shortName}</dd>
             <dt class="name">Item No:</dt>     <dd>${params.itemNo}</dd>
             <dt class="name"> Desc:</dt> 	   <dd>${(ItemMaster.findByCompCodeAndItemNo(cust.compCode, params.itemNo)?.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;'))}</dd>
            </dl>
        </div>
       	<div style="float:left;width:40%;">
        	<h3> History for ${params.year.toInteger()+2000} by Month:</h3>
           <table>
               <thead>
                   <tr>
              	        <th>Month</th>
              	        <th>No of Orders</th>
              	        <th>Qty Sold</th>
              	        <th>Sales Amount</th>
                   </tr>
               </thead>
               <tbody>
               <%
               	def totalOrders = 0
               	def totalQtys = 0
               	def totalAmount = 0.0g
               %>
               <g:each in="${amounts}" status="i" var="amount">
                   <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                       <td ><g:message code="month.${i+1}"/></td>
                       <td class="number">${orders[i]}</td>
                       <td  class="number">${qtys[i]}</td>
                       <td  class="number">${amount}</td>
                   </tr>
                <%
                	totalOrders += orders[i]
                	totalQtys += qtys[i] 
                	totalAmount += amounts[i]
                %>
               </g:each>
               <g:if test="${(!amounts?.size())}">
               	<tr><td class="comment">No records found</td></tr>
               </g:if>
               <g:else>
                   <tr>
                       <td class="total">Totals:</td>
                       <td class="number">${totalOrders}</td>
                       <td class="number">${totalQtys}</td>
                       <td class="number"><g:formatNumber number="${totalAmount}" format="\$#,###,##0.00" /></td>
                   </tr>
               </g:else>
               </tbody>
           </table>
			<div class="buttons">
				<span class="menuButton">
					<a class="table" href="${createLinkTo(dir:'customer')}/salesHist?compCode=${cust.compCode}&custNo=${cust.custNo}&year=${params.year}&popup=${params.popup}" title="Click to return to Customer Inquiry">Back</a>
				</span>
			</div>
       </div>
</body>
</html>