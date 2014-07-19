<%@ page import="com.kettler.domain.orderentry.share.Role" %>
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
	<title>Customer Inquiry</title>
</head>
    
<body>
    <div class="body">
    	<h1>Customer Sales History</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <div class="dialog">
        	<dl>
             <dt class="name">Customer:</dt>   <dd>${cust.compCode}:${cust.custNo} - ${cust.shortName}</dd>
            </dl>
        </div>
        <div class="linkButtons">
			<g:each var="year" in="${ (curYear..minYear) }">
				<g:link class="button" action="salesHist" params="[compCode:params.compCode,custNo:params.custNo,year:year,popup:params.popup]">${year+2000}</g:link>
			</g:each>
		</div>


       	<div style="float:left;width:40%;">
        	<h3>History for ${params.year.toInteger()+2000} by Month:</h3>
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
					<a class="table" href="${createLinkTo(dir:'customer')}/show?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}" title="Click to return to Customer Inquiry">Back</a>
				</span>
			</div>
       </div>
       <div style="float:right;width:50%;">
        	<h3>History for ${params.year.toInteger()+2000} by Item Rank:</h3>
           <table>
               <thead><tr><th>Rank</th><th>Item No</th><th>Description</th><th>Amount</th></tr></thead>
               <tbody>
               <g:each in="${itemNos}" status="i" var="itemNo">
                   <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                       <td class="number">${i+1}</td>
                       <td><a href="${createLinkTo(dir:'customer')}/salesHistItemDetail?compCode=${cust.compCode}&custNo=${cust.custNo}&year=${params.year}&itemNo=${itemNo}&popup=${params.popup}" title="Click to display sales history item detail">${itemNo}</a></td>
						<td>${(ItemMaster.findByItemNo(itemNo)?.desc?.encodeAsHTML()?.replaceAll(/&amp;/,'&#38;'))}</td>
	                   <td class="number"><g:formatNumber number="${itemAmounts[i]}" format="\$#,###,##0.00" /></td>
                   </tr>
               </g:each>
       </div>
   </div>
</body>
</html>