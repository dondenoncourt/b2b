<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <gui:resources components="['dataTable']"/>
      <g:javascript library="prototype" />
  </head>
<body>
    <div class="body">
    	<h1>Order <%= inquiry?'Inquiry':'Maintenance' %></h1>
        <g:if test="${message}"><div class="message">${message}</div></g:if>
        <g:hasErrors bean="${ord}"><div class="errors"><g:renderErrors bean="${ord}" as="list" /></div></g:hasErrors>
        <div id="custDiv" class="col1">
          <dl>
            <jsec:lacksAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
            	<dt>Company:</dt>	<dd>${ord.compCode}</dd>
            </jsec:lacksAnyRole>
            <dt>Order No:</dt>		<dd>${ord.orderNo}</dd>
            <dt>Name:</dt>			<dd>${(Customer.findByCompCodeAndCustNo(ord.compCode, ord.custNo)?.name)}</dd>
            <dt>Status:</dt>		<dd><g:message code="orderStatus.${ord.statusCode}"/></dd>
          </dl>
        </div>
        <div id="orderTotalDiv" class="col2">
	        <g:render template="orderTotal" bean="orderTotalInfo"/>
	    </div>
        <% def discounts = ordLines.find { it.value.lineType == 'I' && it.value.itemDiscPct } %>
        <div class="body list">
	       <g:form action="order" method="post" >
	           <g:if test="${ordLines.size() > 0}">
	             <table style="width:100%;">
	               <tbody>
	                 <tr>
	                 	<th style="width:3em;">Line</th>
	                 	<th style="width:12em;">Item Number</th>
	                 	<th>Description</th>
	                 	<% if (ord.statusCode == 'B') { %>
		                 	<th style="width:3em;">B/O</th>
		                 	<th style="width:5em;">B/O Qty</th>
	                 	<% } %>
	                 	<th style="width:5em;">Quantity</th>
	                    <% if (discounts) { %>
	                 		<th style="width:5em;">Net Price</th>
	                    	<th style="width:5em;">Discount</th>
	                    <% } else { %>
	                 		<th style="width:5em;">Price</th>
	                 	<% } %>
	                    <th style="width:5em;">Amount</th>
	                    <th style="width:5em;">Color</th>
	                 </tr>
	                 <g:each var="dtl" status="i" in="${(ordLines.findAll{it.key < '9900'})}">
	                   <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                     <g:if test="${(dtl.value.lineType == 'I' || dtl.value.lineType == 'N')}">
	                       <td>
	                       		<g:link action="order" event="itemdetail" id="${dtl.key}" title="Click to edit item detail">${dtl.key}</g:link>
	                       </td>
	                       <td>${dtl.value.itemNo}</td>
	                       <td>${dtl.value.desc?.encodeAsHTML()}</td>
		                 	<% if (ord.statusCode == 'B') { %>
			                 	<td>${dtl.value.backOrderCode}</td>
			                 	<td class="number">${dtl.value.backOrderQty}</td>
		                 	<% } %>
	                       <td class="number">${dtl.value.orderQty}</td>
		                   <% if (discounts) { %>
		                   		<td class="number"> 
		                   			${((dtl.value.itemDiscPct)
		                   			?(dtl.value.unitPrice - (dtl.value.unitPrice * (dtl.value.itemDiscPct / 100))).setScale(2, BigDecimal.ROUND_HALF_UP)
		                   			:dtl.value.unitPrice)}
		                   		</td>
	                	   		<td class="number">${((dtl.value.itemDiscPct)?dtl.value.itemDiscPct+' %':'')}</td>
		                   <% } else { %>
	                       		<td class="number">${dtl.value.unitPrice}</td>
	                       <% } %>
	                       <td class="number">${dtl.value.amount}</td>
	                       <g:if test="${(dtl.value.lineType == 'I')}">
	                         <td>${(ItemMaster.findByItemNo(dtl.value.itemNo).color)}</td>
	                       </g:if>
	                     </g:if>
	                     <g:elseif test="${(dtl.value.lineType == 'C')}">
	                       <td><g:link action="order" event="comment" id="${dtl.key}" title="Click to edit this comment">${dtl.key}</g:link></td>
	                       <td colspan="${((ord.statusCode == 'B')?8:6)}" class="comment">${dtl.value.text}</td> 
	                     </g:elseif>
	                     <g:elseif test="${(dtl.value.lineType == 'M')}">
	                       <td>
					           <jsec:hasRole name="${Role.KETTLER}">
	            	           		<g:link action="order" event="misc" id="${dtl.key}" title="Click to edit this miscellaneous charge">${dtl.key}</g:link>
	            	           </jsec:hasRole>
					           <jsec:lacksRole name="${Role.KETTLER}">
					           		<g:formatNumber number="${dtl.value.lineNo}" format="0000"/>
	            	           </jsec:lacksRole>
	                       	</td>
	                       <td/><td>${dtl.value.desc}</td>		                 	
	                       <% if (ord.statusCode == 'B') { %>
			                 	<td/><td/>
		                 	<% } %>
	                       <td/><td/><td class="number">${dtl.value.amount}</td><td/>
	                     </g:elseif>
	                   </tr>
	                 </g:each>
	                 <g:if test="${!(ordLines.find{it.key < '9900'})}">
	                    <tr><td colspan="6" class="comment">Click the button labeled "Item" below to add line items</td></tr> 
	                 </g:if>
	               </tbody>
	             </table>
	         </g:if>
	         <div class="buttons full">
	           <g:if test="${!inquiry}">
		           <g:submitButton class="create" name="item" value="Add Item" title="Click to select a item to add to this order" />
		           <jsec:hasRole name="${Role.KETTLER}">
			            <g:submitButton class="add" name="noninvitem" value="Add Non-Inv Item"  title="Click to add a Non-Inventory item to this order"/>
			            <g:submitButton class="add" name="misc"       value="Add Misc"  title="Click to add a Miscellaneous Charge to this order"/>
		           </jsec:hasRole>
		           <g:submitButton class="add" name="comment" value="Add Comment" title="Click to add a comment to this order" />
	               <g:submitButton class="house" name="cancel" value="Cancel Order" onclick="return confirm('Are you sure?');" title="Click to cancel this order" />
	               <% if (ord.id) { %>
		               <g:submitButton class="house" name="abort" value="Cancel Update" onclick="return confirm('Are you sure?');" title="Click to abort updates to this order" />
	               <% } %>
	           </g:if>
			   <g:if test="${inquiry}">
	              <g:submitButton class="house" name="abort" value="Exit Inquiry" title="Click to end review of this order" />
			   </g:if>
	           <g:submitButton class="table" name="next" value="Next" title="Click to proceed to the Shipping Information page" />
	         </div>
	       </g:form>
        </div>
    </div>
</body>
</html>
