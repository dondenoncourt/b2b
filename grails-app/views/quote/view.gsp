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
      <title>KETTLER Order Quote</title>
      <g:javascript library="prototype" />      
  </head>
<body>
<% if (!params.pdf) { %>
	<g:javascript>
	    function checkDupPo(compNo, custNo, poNo, orderNo) {
	        var params = 'compNo='+compNo+'&custNo='+custNo+'&poNo='+poNo+'&orderNo='+orderNo;
	        new Ajax.Request('${resource(dir:'order')}/checkDupPo', {
	          method: 'get',
	          parameters: params,
	          onSuccess: function(transport) {
	            if (transport.responseText == 'true') {
	                alert("Purchase order "+poNo+" already exists");
	                $('poNo').focus();
	            } else {
	            	$('poNoForm').submit();
	            }
	          }
	        });
	    }
		function onloadHandler() { // called in body of layout gsp
			$('poNoDialog').hide();
			$('commentDialog').hide();
		}    
	</g:javascript>
  <% } %>
  <div class="body">
   	<h1>Order Quote</h1>

	<div id="staticOrdDiv">
	    <div id="custDiv" class="col1">
	      <dl>
	        <dt>Quote No:</dt>			<dd>${ord.orderNo}</dd>
	      </dl>
			<h3>Customer Address</h3>
	        ${session.cust.addr1.encodeAsHTML()}<br/>
	        <g:if test="${session.cust.addr2}">
	            ${session.cust.addr2.encodeAsHTML()}<br/>
	        </g:if>
	        <g:if test="${session.cust.addr3}">
	            ${session.cust.addr3.encodeAsHTML()}<br/>
	        </g:if>
	        ${session.cust.city}, ${session.cust.state} ${session.cust.zipCode}
	    </div>
	    <div id="shipToDiv" class="col2">
	    	<g:if test="${ord.shipToNo}">
		        <dl>
		          <dt>Ship-To No:</dt>		<dd>${(ord.shipToNo?:'&#160;')}</dd>
		          <dt>Country:</dt>			<dd>${(shipTo?.countryCode)?:'&#160;'}</dd>
		          <dt>Phone No:</dt>			<dd>${(shipTo?.phoneNo)?:'&#160;'}&#160;</dd>
		        </dl>
				<span class="resicomm"><kettler:message prefix="shipTo.resi.comm" key="${shipTo?.residentialCommercial}"/></span><br/>
			</g:if>
			<g:else>
				<dl>
			        <dt>Customer No:</dt>		<dd><jsec:hasRole name="${Role.KETTLER}">${ord.compCode}:</jsec:hasRole>${ord.custNo}</dd>
				</dl>
				<h3>Ship-To Address</h3><br/>
			</g:else>
			<g:if test="${shipTo}">
		        ${shipTo?.name}<br/>
		        ${shipTo?.addr1.encodeAsHTML()}<br/>
		        <g:if test="${shipTo?.addr2}">
		            ${shipTo?.addr2.encodeAsHTML()}<br/>
		        </g:if>
		        <g:if test="${shipTo?.addr3}">
		            ${shipTo?.addr3.encodeAsHTML()}<br/>
		        </g:if>
		        ${shipTo?.city}, ${shipTo?.state} ${shipTo?.zipCode}<br/>
	        </g:if>
	        <g:else>
	        	Same<br/><br/><br/><br/>
	        </g:else>
	    </div>
	</div>

	<h1>&#160;</h1>
		<div style="clear:both;">
			<div class="col1">
				<dl>
					<% if (ordDate) { %>
						<dt>Requested Ship Date:</dt>
													<dd class="value"><g:formatDate date="${ordDate?.date}" format="MM/dd/yyyy"/>&#160;</dd>
					<% } else { %>
						<dt>Ship:</dt>	 			<dd class="value">As Soon As Possible</dd>
					<% } %>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Warehouse:</dt> 		<dd class="value">${(Warehouse.findByCompCodeAndCode(ord.compCode, ord.warehouse)?.name?:'&#160;')}</dd>
					</jsec:hasRole>
					<dt>Shipping Terms:</dt> 		<dd class="value">${(ord.fobCode?FOBCode.get(ord.fobCode)?.desc:'&#160;')}&#160;</dd>
					<% if (ord.carrierCode) { %>
						<dt>Carrier:</dt>			<dd class="value" id="scacDD">${(ord.carrierCode?Carrier.get(ord.carrierCode)?.desc:'&#160;')}&#160;</dd>
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
				</dl>
			</div>
			<div class="col2">
				<dl>
					<%-- if (!DateUtils.isEndOfTime(ord.cancelAfterDate)) { %>  not in quote
						<dt>Cancel Date:</dt> 		<dd class="value"><g:formatDate date="${cancelAfterDate}" format="MM/dd/yy"/>&#160;</dd>
					<% } --%>
					<% if (ord.lineDiscCode) { %>
						<dt>Line Discounts:</dt> 	<dd class="value">Yes</dd>
					<% } %>
					<dt>eMail Ackn:</dt> <dd class="value"> ${((ord.acknowledgement == 'Y')?'Yes':'No')} &#160;</dd>
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
					<%-- if (ord.shipComplete) { %> backOrder not in quote
						<dt>Back Order:</dt> 		<dd>${(ord.backOrder?'Yes':'No')} &#160;</dd>
					<% } --%>
					<%-- if (ord.hasExtraShipInst) { %> not in quote
						<dt>Extra Ship Instr:</dt> 	<dd>${(ord.extraShipInst)} &#160;</dd>
					<% } --%> 
					<% if (ord.discAllowCode) { %>
						<dt>Discount Allow:</dt> 	<dd class="value">Yes</dd>
					<% } %>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Sales Person 1:</dt> 	<dd class="value"> ${SalesPerson.get(salesperson1)?.name?:'&#160;'}</dd>
						<dt>Pack List:</dt> 		<dd class="value"> ${PackListCode.get(ord.packingListCode)?.desc}&#160;</dd>
					</jsec:hasRole>
					<dt>Pick Date:</dt> 			<dd class="value"><g:formatDate date="${ord.pickDateMDY}" format="MM/dd/yy"/>&#160;</dd>
					<% if (ord.dueDate != DateUtils.yearOne) {%>
						<dt>Due Date:</dt> 			<dd class="value"><g:formatDate date="${ord.dueDate}" format="MM/dd/yy"/>&#160;</dd>
					<% } %>
					<% if (ord.releaseDate != DateUtils.yearOne) {%>
						<dt>Release Date:</dt>		<dd class="value"><g:formatDate date="${ord.releaseDate}" format="MM/dd/yy"/>&#160;</dd>
					<% } %>
					<dt>Create Date:</dt>			<dd class="value"><g:formatDate date="${ord.dateCreated}" format="MM/dd/yy"/>&#160;</dd>
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
	                 	<th class="width12">Item Number</th>
	                 	<th class="width40">Description</th>
	                 	<% if (ord.statusCode == 'B') { %>
		                 	<th style="width:3em;">B/O</th>
		                 	<th style="width:5em;">B/O Qty</th>
	                 	<% } %>
	                 	<th class="width6">Quantity</th>
	                    <% if (discounts) { %>
	                 		<th class="width6">Net Price</th>
	                    	<th class="width6">Discount</th>
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
	                       <td class="width12">${dtl.value.itemNo}</td>
	                       <td class="width40">${dtl.value.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
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
	                         <td>${(ItemMaster.findByItemNo(dtl.value.itemNo)?.color)}</td>
	                       </g:if>
	                     </g:if>
	                     <g:elseif test="${(dtl.value.lineType == 'C')}">
	                       <td><g:formatNumber number="${dtl.value.lineNo}" format="0000"/></td>
	                       <td colspan="${((ord.statusCode == 'B')?8:6)}" class="comment">${dtl.value.text}</td> 
	                     </g:elseif>
	                     <g:elseif test="${(dtl.value.lineType == 'M')}">
	                       <td><g:formatNumber number="${dtl.value.lineNo}" format="0000"/></td>
	                       <td/><td>${dtl.value.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>		                 	
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
	<div id="orderTotalDiv">
		<h3>&#160;</h3><!-- if this is not here, the total numeric amount does not show, for some reason -->
        <g:render template="/order/orderTotal" bean="orderTotalInfo"/>
	</div>
	<% if (!params.pdf) { %>
		<div id="poNoDialog" class="popup" style="left:250px;top:250px;width:400px;">
			<h1>Enter Purchase Order</h1>
			<g:form name="poNoForm" action="approve" method="post">
				<g:hiddenField name="compCode" value="${ord.compCode}"/> 
				<g:hiddenField name="orderNo" value="${ord.orderNo}"/> 
				<dl><dt>PO No:</dt> 	<dd class="value"> <input type="text" maxlength="25" id="poNo" name="poNo" />  </dd></dl>      		
				<div class="buttons" style="clear:left;">
				  <span class="menuButton">
	     			 <a class="table" href="#" onClick="checkDupPo('${ord.compCode}', '${ord.custNo}', $('poNo').value, '${ord.compCode}');" 
					   title="Click to approve quote and turn it into an order">Approve</a>
				</div>
			</g:form>
		</div>
		<div id="commentDialog" class="popup" style="left:250px;top:250px;width:400px;">
			<h1>Please describe why you disapproved this quote</h1>
			<g:form name="disapproveCommentForm" action="disapprove" method="post">
				<g:hiddenField name="compCode" value="${ord.compCode}"/> 
				<g:hiddenField name="orderNo" value="${ord.orderNo}"/> 
				<dl><dt>Comment:</dt> 	<dd class="value"> <input type="text" size="30" maxlength="30" id="comment" name="comment" />  </dd></dl>      		
				<div class="buttons" style="clear:left;">
				  <span class="menuButton">
				  <g:submitButton class="table" name="disapprove" value="Disapprove" title="Click to disapprove the quote" />
				</div>
			</g:form>
		</div>
		<div id="buttonPanel" class="buttons" style="clear:left;">
			<g:form action="approveDisapprove" method="post" >
			  <span class="menuButton">
			  	<% if (!ord.statusCode) { %>
	    			<a class="table" href="#" onclick="$('commentDialog').show();$('buttonPanel').hide();" title="Click to disapprove the quote">Disapprove</a>
	    			<a class="table" href="#" onclick="$('poNoDialog').show();$('buttonPanel').hide();"    title="Click to approve quote and turn it into an order">Approve</a>
    			<% } %>
	          	<a class="table" href="${createLinkTo(dir:'quote')}/select" title="Click to return to the quote list">List</a>
	    	  	<g:pdf url="/quote/view?compCode=${ord.compCode}&orderNo=${ord.orderNo}" icon="true"/>
	          </span>
			</g:form>
		</div>
	<% } %>
  </div>
</body>
</html>
