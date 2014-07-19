<%@ page import="com.kettler.domain.item.share.DealerInventory" %>
<%@ page import="com.kettler.domain.item.share.DealerLocation" %>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main" />
  <title>Inventory Maintenance</title>
</head>
<body>
<div class="body">
<g:if test="${flash.message}">
  <div class="message">${flash.message}</div>
</g:if>
<g:if test="${purchasedItems?.size()==0}">
    <br/>
    <p>There is no history of items purchased in the last ${months} months.</p>
    <br/>
</g:if>
<g:else>
		<ul class="dealerInv">
			<li>System displays items purchased in the last 18 months.</li>  
			<li>Please review and check only the items you currently have in stock. </li>  
			<li>There is no need to update the quantity.</li>
			<li>Please return at least every 14 days to keep the information accurate for our potential customers.</li>
		</ul>
	  <h2>Inventory for location: ${location}</h2><br/>
	  <g:form name="invAvailForm" action="invAvail" method="post">
	    <g:hiddenField name="division" value="${division}"/>
	    <g:hiddenField name="custno" value="${custno}"/>
	    <g:hiddenField name="locId" value="${location.id}"/>
	    <table>
	      <tr>
	        <th>Invoiced Item</th>
	        <th>Last Update</th>
	        <th>Inventory Available?</th>
	      </tr>
	      <g:each in="${purchasedItems}" var="item">
	        <tr>
	          <td>${item.itemNo} &ndash; ${item?.desc}</td>
	          <td>
	            <% def inv = inventories.find{it.item == item}
	               if (inv) {
	            %>
	                <g:formatDate date="${inv.lastUpdated}" format="MM/dd/yy"/></td>
	            <% } %>
	          </td>
	          <td>
	            <g:checkBox name="cbInvAvail_${item.id}" value="${inv?.available}"/>
	          </td>
	        </tr>
	      </g:each>
	    </table>
	    <div class="buttons">
	      <span class="button">
	        <g:actionSubmit action="invAvail" class="save" value="Update Inventory" 
	            title="click to update inventory of items selected above"
	        />
	      </span>
	    </div>
	  </g:form>
</g:else>
</div>
</body>
</html>