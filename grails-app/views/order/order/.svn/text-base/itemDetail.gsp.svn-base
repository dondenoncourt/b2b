<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesTax" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>
<%@ page import="com.kettler.domain.item.share.NatlMotorFreightClass" %>
<%@ page import="com.kettler.domain.actrcv.share.TableCode" %>

<%@ page import="com.kettler.domain.work.InventoryInfo" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <g:javascript src="application" />
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		<% if (inquiry) { %>
			disableFormFields('itemDetailForm') ;
		<% } else { %>
		$('orderQty').focus();
		<% } %>
	}
	function qtyChanged(qty) {
        <% if (ordItem.lineType == 'I') { %>
			var params = "compCode=${ordItem.compCode}&itemNo=${ordItem.itemNo}&warehouse=1&orderQty="+qty;
	        new Ajax.Request('${resource(dir:'order')}/inventoryAvail', {
	          method: 'get',
	          parameters: params,
	          onSuccess: function(transport) {
	            $('availableDD').innerHTML = transport.responseText;
	          }
	        });		
	     <% } %>
	}
  </script>
    <div class="body">
    	<h1>Order Item <%= inquiry?'Inquiry':'Maintenance' %></h1>
        <br/>
        <div>
          <dl>
	       	  <jsec:lacksAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
            	<dt>Company Code:</dt>	<dd>${ord.compCode}</dd>
              </jsec:lacksAnyRole>
            <dt>Order No:</dt>			<dd>${ord.orderNo}</dd>
            <dt>Line no:</dt>			<dd>${ordItem.lineNo}</dd>
          </dl>
	      <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
	      <g:hasErrors bean="${ordItem}"><div class="errors"><g:renderErrors bean="${ordItem}" as="list" /></div></g:hasErrors>
	      <g:form action="order" name="itemDetailForm" method="post">   
	          <input type="hidden" name="lineNo" value="${g.formatNumber(number:ordItem?.lineNo, format:'0000')}" />
          <dl >
            <dt>Item Number:</dt>
            <g:if test="${ordItem.lineType == 'I'}">
                                        <dd>${ordItem.itemNo}</dd>
            </g:if>
            <g:else>
                                        <dd><g:textField name="itemNo"        value="${ordItem?.itemNo}" tabindex="1"/></dd>
            </g:else>
	        <g:if test="${ordItem.lineType == 'I' && ItemMaster.findByItemNo(ordItem.itemNo).shortName != 'KIT'}">
		          <dt>Available:</dt>	<dd id="availableDD">
	            								<g:if test="${invInfo?.isAvailable(ordItem.orderQty)}">
	            									Yes
	            								</g:if>
	            								<g:else>
	            									No
	            								</g:else>
		            					</dd>
            	<g:if test="${(item.color.trim())}">
 					<dt>Color:</dt>     <dd>${item.color.trim()}</dd>
            	</g:if>
	        </g:if>
            <g:if test="${ordItem.lineType == 'N'}">
	            <dt>Natl Motor Freight:</dt>
	                                    <dd><g:select    name="nmfcNo"        value="${ordItem.nmfcNo}" from="${NatlMotorFreightClass.list()}" optionKey="id" optionValue="desc"  noSelection="${['':'Select One...']}" tabindex="2"/></dd>
            </g:if>
            <dt>Order Quantity:</dt>	<dd><g:textField name="orderQty"      value="${(ordItem?.orderQty?:'1')}" class="number"  size="5" maxlength="5" tabindex="3" onchange="qtyChanged(this.value);"/></dd>
            <dt>Description:</dt>       
			            <g:if test="${ordItem.lineType == 'I'}">
	                                    <dd>${ordItem.desc}</dd>
			            </g:if>
			            <g:else>
							            <dd><g:textField name="desc"          value="${ordItem?.desc}" size="30" maxlength="30" tabindex="4"/></dd>
	                   </g:else>
            <% if (ordItem.itemDiscPct) { %>
	   	        <dt>Net Price:</dt>
	   	    <% } else { %>
	   	        <dt>Unit Price:</dt>
	   	    <% } %>      
		    	<jsec:hasRole name="${Role.KETTLER}">
	              						<dd><g:textField name="unitPrice"     value="${ordItem?.unitPrice}"  class="number" tabindex="6"/></dd>
	            </jsec:hasRole>
	       	    <jsec:lacksRole name="${Role.KETTLER}">
	              						<dd>
	              						${((ordItem.itemDiscPct)
		                   			       ?(ordItem.unitPrice - (ordItem.unitPrice * (ordItem.itemDiscPct / 100))).setScale(2, BigDecimal.ROUND_HALF_UP)
		                   			       :ordItem.unitPrice)}
	              						</dd>
	       	    </jsec:lacksRole>
			<g:if test="${ordItem?.itemDiscPct}">
				<dt>Discount:</dt>		<dd>${ordItem?.itemDiscPct}%</dd>
			</g:if>            
            <dt>Unit Measure</dt>       
   	        	  <jsec:hasRole name="${Role.KETTLER}">
            							<dd><g:textField name="qtyUnitMeas"   value="${ordItem?.qtyUnitMeas}" size="3" maxlength="3" tabindex="5"/></dd>
            	  </jsec:hasRole>
   	        	  <jsec:lacksRole name="${Role.KETTLER}">
            							<dd>${ordItem?.qtyUnitMeas}</dd>
   	        	  </jsec:lacksRole>
            <dt>Price Unit Measure:</dt> 
   	        	  <jsec:hasRole name="${Role.KETTLER}">
                                        <dd><g:textField name="priceUnitMeas" value="${ordItem?.priceUnitMeas}" size="3" maxlength="3" tabindex="6"/></dd>
            	  </jsec:hasRole>
   	        	  <jsec:lacksRole name="${Role.KETTLER}">
            							<dd>${ordItem?.priceUnitMeas}</dd>
   	        	  </jsec:lacksRole>
		
       	    <jsec:hasRole name="${Role.KETTLER}">
	            <g:if test="${(ord.taxCode1)}">
		            <dt>${(SalesTax.get(ord.taxCode1)?.desc)}:</dt>  
                                        <dd><g:checkBox  name="subjToTax1"    value="${ordItem.subjToTax1}" checked="${ordItem.subjToTax1}"  tabindex="8"/></dd>
	            </g:if>
	            <g:if test="${(ord.taxCode2)}">
		            <dt>${(SalesTax.get(ord.taxCode2)?.desc)}:</dt>  
                                        <dd><g:checkBox  name="subjToTax2"    value="${ordItem.subjToTax2}" checked="${ordItem.subjToTax2}" tabindex="9"/></dd>
	            </g:if>
	            <g:if test="${(ord.taxCode3)}">
	            	<dt>${(SalesTax.get(ord.taxCode3)?.desc)}:</dt>  
                                        <dd><g:checkBox  name="subjToTax3"    value="${ordItem.subjToTax3}" checked="${ordItem.subjToTax3}" tabindex="10"/></dd>
	            </g:if>
            </jsec:hasRole>
          </dl>
          <div class="buttons">
		      <g:if test="${!inquiry}">
	              <g:submitButton class="save" name="update" value="${(ordItem.orderQty?'Update':'Add')}"  tabindex="11"  title="Click to update this line item"/>
	              <g:submitButton class="delete" name="delete" value="Delete" title="Click to delete this line item" />
	          </g:if>
              <g:submitButton class="table" name="back" value="Back" title="Click to return to the list of line items" />
            </div>
        </g:form>
     --</div>
</body>
</html>

