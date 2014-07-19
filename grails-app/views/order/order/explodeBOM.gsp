<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <gui:resources components="['dataTable']"/>
      <g:javascript src="application" />
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() {} // called in body of layout gsp
  </script>
    <div class="body">
    	<h1>Order Item Maintenance</h1>
		<br/>
       <h3>Some components for kit ${ordItem.itemNo} are unavailable. Would you like to order the following components separately?</h3>
      <div class="list">
          <table>
              <thead>
                  <tr>
             	        <th>Component</th>
             	        <th>Description</th>
             	        <th>Quantity</th>
             	        <th>Unit Measure</th>
             	        <th>Available</th>
                  </tr>
              </thead>
              <tbody>
              <g:each in="${bom}" var="part">
                  <tr>
					<td>${part.partItemNo}</td>
					<td>${(ItemMaster.findByCompCodeAndItemNo(part.compCode, part.itemNo)?.desc)}</td>
					<td>${part.partQty}</td>
					<td>${part.partUnitMeas}</td>
					<td>
						<g:if test="${(orderService.isBOMPartInventoryAvail(part, ordItem.orderQty, ord.warehouse))}">
							Yes
						</g:if>
						<g:else>
							No
						</g:else>
					</td>
                  </tr>
              </g:each>
              </tbody>
          </table>
        <g:form action="order" name="explodBOMForm" method="post" >
	        <input type="hidden" name="lineNo" value="${g.formatNumber(number:ordItem.lineNo, format:'0000')}" />
            <div class="buttons">
              <g:submitButton class="add"    name="yes" value="Yes" title="Click to generate order items for each part in the Bill of Materials"/>
              <g:submitButton class="delete" name="no"  value="No"  title="Click to opt out of the BOM explosion in to order items"/>
            </div>
        </g:form>
   </div>
     
</body>
</html>
