<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.ShipTo" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.FOBCode" %>
<%@ page import="com.kettler.domain.orderentry.Terms" %>
<%@ page import="com.kettler.domain.orderentry.PackListCode" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesTax" %>
<%@ page import="com.kettler.domain.orderentry.SalesTermsTier" %>
<%@ page import="com.kettler.domain.orderentry.share.ShipVia" %>
<%@ page import="com.kettler.domain.orderentry.share.OrderDiscountAllowance" %>
<%@ page import="com.kettler.domain.orderentry.DiscountAllowanceCode" %>

<%@ page import="com.kettler.domain.item.Warehouse" %>
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>
<%@ page import="com.kettler.domain.item.ProfitCenter"%>

<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.actrcv.share.TableCode" %>

<%@ page import="com.kettler.domain.work.DateUtils" %>

<html>
  <head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<% if (params.pdf) { %>
			<meta name="layout" content="pdf" />
		<% } else { %>
			<meta name="layout" content="main" />
		<% } %>
      <g:javascript library="prototype" />      
      <title>Order Header Information</title>
  </head>
<body>
<% if (!params.pdf) { %>
<% } %>
  <div class="body">
   	<h1>Order Summary </h1>

	<g:render template="orderHeaderInfo"/>
	<h1>&#160;</h1>
		<div style="clear:both;">
			<div class="col1">
				<dl>
					<% if (ordDate) { %>
						<dt>Req Ship Date:</dt>
													<dd class="value"><g:formatDate date="${ordDate?.date}" format="MM/dd/yyyy"/>&#160;</dd>
					<% } else { %>
						<dt>Ship:</dt>	 			<dd class="value">As Soon As Possible</dd>
					<% } %>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Warehouse:</dt> 		<dd class="value">${(Warehouse.findByCompCodeAndCode(ord.compCode, ord.warehouse)?.name?:'&#160;')}</dd>
					</jsec:hasRole>
					<dt>PO No:</dt> 				<dd class="value"> ${ord.poNo}&#160;</dd>      		
					<jsec:lacksRole name="${Role.KETTLER}">
						<dt>Ship Via:</dt> 			<dd class="value">${ShipVia.get(ord.shipViaSCACShipIns)?.id}&#160;</dd>
						<% if (ord.shipViaSCACShipIns?.startsWith('UPS') ||  
							   ord.shipViaSCACShipIns?.startsWith('Fedex')  ) {  %>
							<dt id="sigReqDT">	Signature:</dt>				<dd id="sigReqDD">	${(ord.signatureRequired?'Yes':'No')}&#160;</dd>
							<dt id="insDT">		Insurance:</dt>				<dd id="insDD">		${(ord.insurance?'Yes':'No')}&#160;</dd>
						<% } else if (ord.shipViaSCACShipIns?.startsWith('COMMON CARRIER')  ) {  %>
							<dt id="liftDT">	Lift Gate:</dt>				<dd id="liftDD">	${(ord.liftGate?'Yes':'No')}&#160;</dd>
							<dt id="insDelDT">	Inside Delivery:</dt>		<dd id="insDelDD">	${(ord.insideDelivery?'Yes':'No')}&#160;</dd>
							<% if (ord.shipToNo == 9999) { %>
								<dt id="resiDelDT">	Residential:</dt>		<dd id="resiDelDD">	${(ord.resiDelivery?'Yes':'No')}&#160;</dd>
							<% } %>
						<% } %>
					</jsec:lacksRole>
					<dt>Shipping Terms:</dt> 		<dd class="value">${(ord.fobCode?FOBCode.get(ord.fobCode)?.desc:'&#160;')}&#160;</dd>
					<% if (ord.carrierCode) { %>
						<dt>Carrier:</dt>			<dd class="value" id="scacDD">${(Carrier.get(ord.carrierCode)?.desc?:ord.carrierCode)}&#160;</dd>
					<% } %>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Ship Method:</dt> 		<dd class="value">${ord.shipInstructions}&#160;</dd>
						</dl>
						<dl id="specialChargesDL">
							<% if (ord.specialChrgCd1) { %>
								<dt>Special Charge 1:</dt> 		<dd class="value"> ${ord.specialChrgCd1}</dd>
							<% } %>
							<% if (ord.specialChrgCd2) { %>
								<dt>               2:</dt> 		<dd class="value"> ${ord.specialChrgCd2}</dd>
							<% } %>
 							<% if (ord.specialChrgCd3) { %>
								<dt>               3:</dt> 		<dd class="value"> ${ord.specialChrgCd3}</dd>
							<% } %>
						</dl>
						<dl>
					</jsec:hasRole>
					<dt>Payment Terms:</dt> 		<dd class="value">${(Terms.get(ord.termsCode)?.desc)}&#160;</dd>
					<% if (session.cust.refCode1) { %>						
						<dt>Cust Ref No:</dt> 		<dd class="value"> ${ord.custRef1}		 </dd>
					<% } %>       		
				</dl>
			</div>
			<div class="col2">
				<dl>
					<% if (!DateUtils.isEndOfTime(ord.cancelAfterDate)) { %> 
						<dt>Cancel Date:</dt> 		<dd class="value"><g:formatDate date="${cancelAfterDate}" format="MM/dd/yy"/>&#160;</dd>
					<% } %>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Line Discounts:</dt> 	<dd class="value">${(ord.lineDiscCode?'Yes':'No')} &#160;</dd>
					</jsec:hasRole>
					<dt>eMail Ackn:</dt> <dd class="value"> ${((ord.acknowledgement == 'Y')?'Yes: '+ord.acknEmail:'No')} &#160;</dd>
					<jsec:hasRole name="${Role.KETTLER}">
						<% if (ord.taxCode1) { %>
								<dt>Tax Code 1:</dt> <dd class="value"> <g:select name="taxCode1" from="${SalesTax.list()}" optionKey="id" optionValue="desc"  value="${ord.taxCode1}" noSelection="${['':'Select One...']}"/> </dd>
						<% } %>
						<% if (ord.taxCode2) { %>
								<dt>         2:</dt> <dd class="value"> <g:select name="taxCode2" from="${SalesTax.list()}" optionKey="id" optionValue="desc"  value="${ord.taxCode1}" noSelection="${['':'Select One...']}"/> </dd>
						<% } %>
						<% if (ord.taxCode3) { %>
							<dt>         3:</dt> <dd class="value"> <g:select name="taxCode3" from="${SalesTax.list()}" optionKey="id" optionValue="desc"  value="${ord.taxCode1}" noSelection="${['':'Select One...']}"/> </dd>
						<% } %>
					</jsec:hasRole>
					<dt>Ship Complete:</dt> 		<dd class="value"> ${(ord.shipComplete?'Yes':'No')} &#160;</dd>
					<% if (ord.shipComplete) { %>
						<dt>Back Order:</dt> 		<dd>${(ord.backOrder?'Yes':'No')} &#160;</dd>
					<% } %>
					<% if (ord.hasExtraShipInst) { %>
						<dt>Extra Ship Instr:</dt> 	<dd>${(ord.extraShipInst)} &#160;</dd>
					<% } %> 
					
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Sales Person 1:</dt> 	<dd class="value"> ${SalesPerson.get(salesperson1)?.name?:'&#160;'}</dd>
						<dt>Discount Allow:</dt> 	<dd class="value">
														<g:if test="${ord.discAllowCode}">
															<img src="${createLinkTo(dir:'images/skin',file:'checkmark.gif')}" alt="Yes">
														</g:if>
														<g:else>No</g:else>
														&#160;
													</dd>
						<dt>Pack List:</dt> 		<dd class="value"> ${PackListCode.get(ord.packingListCode)?.desc}&#160;</dd>
						<dt>Override AR Code:</dt><dd class="value">${TableCode.findWhere([compCode:ord.compCode, type:'S', code:ord.overrideARCode])?.desc?:'&#160;'}&#160;</dd> 
						<dt class="name"> Fullfillment Sell-To No: </dt> 
													<dd class="value"> ${ord.sellToNo?:'&#160;'}&#160;</dd>
					</jsec:hasRole>
				</dl>
			</div>
		</div>
	<g:if test="${ord.discAllowCode}">
		<div id="discAllowDiv">
	       <h3>Discount Allowances</h3>
           <table>
             <tbody>
               <tr><th>Disc/Allow Code</th><th>Percent</th></tr>
               <g:each var="discAllow" in="${ordDiscAllowList}">
                 <tr>
	                 <td>${DiscountAllowanceCode.get(discAllow.code)?.desc?:'&#160;'}</td>
	                 <td  class="number"><g:formatNumber number="${discAllow.percent}" format="##0.00" /></td>
                 </tr>
               </g:each>
             </tbody>
           </table>
		</div>
	</g:if>
	<g:if test="${ord.lineDiscCode}">
		<h3>Line Discounts</h3>
		<div id="lineDiscDiv">
            <table>
              <tbody>
                <tr><th>Profit Center</th><th>Percent</th></tr>
           		<g:each var="i" in="${ (1..5) }">
           		   <% if (ord."lineDisc${i}") { %>
	                   <tr>
			                <td><%=  ProfitCenter.get(ord."profitCenter${i}").desc %></td>
			                <td class="number"><%=  ord."lineDisc${i}" %></td>
	                   </tr>
                   <% } %>
                </g:each>
              </tbody>
            </table>
		</div>
	</g:if>
	<div style="clear:both;">
		<h3>Line Items</h3>
        <% def discounts = ordLines.find { it.value.lineType == 'I' && it.value.itemDiscPct } %>
        <div>
	           <g:if test="${ordLines.size() > 0}">
	            <table <% if (params.pdf) { %>class="pdfTable"<% } %>  >
	               <tbody>
	                 <tr>
	                 	<th class="width4">Line</th>
	                 	<th class="width8">Item Number</th>
	                 	<th class="width40">Description</th>
	                 	<% if (ord.statusCode == 'B') { %>
		                 	<th class="width4">B/O</th>
		                 	<th class="width4">B/O Qty</th>
	                 	<% } %>
	                 	<th class="width4">Quantity</th>
	                    <% if (discounts) { %>
	                 		<th class="width4">Net Price</th>
	                    	<th class="width4">Discount</th>
	                    <% } else { %>
	                 		<th class="width6">Price</th>
	                 	<% } %>
	                    <th class="width6">Amount</th>
	                    <th class="width6">Color</th>
	                 </tr>
	                 <g:each var="dtl" status="i" in="${(ordLines.findAll{it.key < '9900'})}">
	                   <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                     <g:if test="${(dtl.value.lineType == 'I' || dtl.value.lineType == 'N')}">
	                       <td class="width4"><g:formatNumber number="${dtl.value.lineNo}" format="0000"/></td>
	                       <td class="width8">${dtl.value.itemNo}</td>
	                       <td class="width40">${fieldValue(bean:dtl.value,field:'desc')}</td>
		                 	<% if (ord.statusCode == 'B') { %>
			                 	<td>${dtl.value.backOrderCode}</td>
			                 	<td class="number">${dtl.value.backOrderQty}</td>
		                 	<% } %>
	                       <td class="number">${dtl.value.orderQty}</td>
		                   <% if (discounts) { %>
		                   		<td class="number width6"> 
		                   			${((dtl.value.itemDiscPct)
		                   			?(dtl.value.unitPrice - (dtl.value.unitPrice * (dtl.value.itemDiscPct / 100))).setScale(2, BigDecimal.ROUND_HALF_UP)
		                   			:dtl.value.unitPrice)}
		                   		</td>
	                	   		<td class="number width6">${((dtl.value.itemDiscPct)?dtl.value.itemDiscPct+' %':'')}</td>
		                   <% } else { %>
	                       		<td class="number width6">${dtl.value.unitPrice}</td>
	                       <% } %>
	                       <td class="number width6">${dtl.value.amount}</td>
	                       <g:if test="${(dtl.value.lineType == 'I')}">
	                         <td>${(ItemMaster.findByItemNo(dtl.value.itemNo).color)}</td>
	                       </g:if>
	                     </g:if>
	                     <g:elseif test="${(dtl.value.lineType == 'C')}">
	                       <td class="width4"><g:formatNumber number="${dtl.value.lineNo}" format="0000"/></td>
	                       <td colspan="${((ord.statusCode == 'B')?8:6)}" class="comment">${dtl.value.text}</td> 
	                     </g:elseif>
	                     <g:elseif test="${(dtl.value.lineType == 'M')}">
	                       <td class="width4"><g:formatNumber number="${dtl.value.lineNo}" format="0000"/></td>
	                       <td class="width20"/><td class="width20">${dtl.value.desc}</td>		                 	
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
	 	</div>
	</div>	
	<br/>
	<div class="full" id="orderTotalDiv">
		<h3>&#160;</h3><!-- if this is not here, the total numeric amount does not show, for some reason -->
        <g:render template="orderTotal" bean="orderTotalInfo"/>
		<g:if test="${((orderTotalInfo.netAmount + totalBalance) > session.cust.creditLimit)}">
			<dl>
				<dt>Note:</dt><dd class="errors">You have exceeded your credit by <g:formatNumber number="${((session.cust.creditLimit - (orderTotalInfo.netAmount + totalBalance)).abs())}" format="\$#,###,##0.00" /></dd>
				<% if (!params.pdf) { %>
					<dt>&#160;</dt><dd>Click  
					<a href="#" onclick="window.open ('${createLinkTo(dir:'customer')}/show?compCode=${ord.compCode}&custNo=${ord.custNo}&popup=true', 'custhist', 'location=1,status=1,scrollbars=1,width=900,height=690');"
						title="Click to display your customer information">here</a>
						if you would like to see your customer information
								</dd>
				<% } %>
			</dl>
			 
		</g:if>
	</div>
	<% if (!params.pdf) { %>
		<div class="buttons" style="clear:left;">
			<g:form action="order" method="post" >
		      <g:if test="${!inquiry}">
				  <g:submitButton class="table" name="lineItemSubfile" value="Edit Line Items" title="Click to display line item maintenance" />
				  <g:submitButton class="table" name="shippingInfo" value="Edit Shipping Info" title="Click to display shipping information maintenance" />
	              <g:submitButton class="house" name="cancel" value="Cancel Order" onclick="return confirm('Are you sure?');" title="Click to cancel this order" />
	              <% if (ord.id) { %>
		              <g:submitButton class="house" name="abort" value="Cancel Update" onclick="return confirm('Are you sure?');" title="Click to abort updates to this order" />
	              <% } %>
				  <g:submitButton class="save" name="complete" value="Complete Order" title="Click to approve your edits to this order and update the order entry database with your modifications" />
			  </g:if>
		      <g:if test="${inquiry}">
				  <g:submitButton class="table" name="lineItemSubfile" value="Review Line Items" title="Click to display the list of line items" />
				  <g:submitButton class="table" name="shippingInfo" value="Review Shipping Info" title="Click to display shipping information" />
	              <g:submitButton class="house" name="abort" value="Exit Inquiry" title="Click to end review of this order" />
			      <span class="menuButton">
				  	  <g:pdf url="/order/pdfOrder?compCode=${ord.compCode}&orderNo=${ord.orderNo}" icon="true"/>
				  </span>
			  </g:if>
			</g:form>
		</div>
	<% } %>
  </div>
</body>
</html>
