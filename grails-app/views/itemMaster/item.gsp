<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<%@ page import="com.kettler.domain.work.InventoryInfo" %>

<%@ page import="com.kettler.domain.item.share.ItemMaster" %>
<%@ page import="com.kettler.domain.item.ItemSalesHist" %>

<%@ page import="com.kettler.domain.varsity.Country" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Item Master Information</title>
      <resource:autoComplete skin="default" />
      <gui:resources components="['dataTable']"/>
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		$('itemMasterDataTableDiv').hide();
	}
  </script>
    <div class="body">
    	<br/>
        <h1>Item Master Inquiry</h1>
        <g:if test="${flash.message}"><div class="errors">${flash.message}</div></g:if>
        <g:form action="item" name="itemSelectForm" method="post" >
          <dl>
            <dt>Item Number:</dt>
            <dd>
            	<richui:autoComplete name="itemNo" action="${createLinkTo('dir': 'itemMaster/searchAJAX')}" 
            	   size="15" maxLength="15"
            	   shadow="true" typeAhead="true" maxResultsDisplayed="25"   
            	   onItemSelect="\$('itemDetail').innerHTML='';\$('itemSelectForm').submit();"
            	/>
                <g:render template="/order/itemMasterDataTableDialog"/>
            </dd>
            <dt>&nbsp;</dt> 		<dd id="itemDesc"></dd>
			<dt>&nbsp;</dt> 		<dd>
										<span class="menuButton">
											<g:submitButton class="show" name="item" value="Show Item" title="Click to display detail on the entered item number"/>
											<input type="button" class="search" id="showItemMasterDataTableDialog"  value="Search" 
												title="Click to search for an item" 
												onclick="$('itemDetail').innerHTML='';$('itemMasterDataTableDialog').setStyle({left: '0em'});$('itemMasterDataTableDiv').show();return false;"/>
										</span>
									</dd>
          </dl>
		  <div id="itemDetail">
	        <g:if test="${item}">
		  		<div class="col1">
		          <dl>
		          	<dt>Item No:</dt>			<dd>${item.itemNo}</dd>
		          	<dt>Description:</dt>		<dd>${item.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</dd>
					<dt>Available:</dt>			<dd>
		   	        	        <jsec:hasAnyRole in="${[Role.ASSISTANT_CONTROLLER,Role.KETTLER,Role.REP_PLUS,Role.SUPER_ADMIN,Role.STORE, Role.STORE_MANAGER, Role.INV_MANAGER]}">
													  ${(item.qtyOnHand - item.qtyAlloc)}
												  </jsec:hasAnyRole>
		   	        	        <jsec:hasAnyRole in="${[Role.CUST_ADMIN, Role.CUSTOMER, Role.REP, Role.REP_ADMIN]}">
                            ${((item.qtyOnHand - item.qtyAlloc) - InventoryInfo.INV_AVAIL_FUDGE_FACTOR > 0)?'Yes':'No'}
								   	      </jsec:hasAnyRole>
												</dd>
                    <g:if test="${pod}">
                        <dt>Next shipment due:</dt>    <dd><g:formatDate type="date" date="${pod?.header?.etaDate+7}" style="LONG"/></dd>
                    </g:if>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Price:</dt>			<dd>${item.basePrice}</dd>
						<dt>Price Unit Meas:</dt>
												<dd>${(item.priceUnitMeas?:'&nbsp;')}</dd>
					</jsec:hasRole>
					<dt>Std Unit Meas:</dt>		<dd>${(item.stdUnitMeas?:'&nbsp;')}</dd>
					<dt>Unit Weight:</dt>		<dd><g:formatNumber number="${item.unitWeight}" format="####0.0##"/></dd>
					<dt>Cubic Feet:</dt>		<dd><g:formatNumber number="${item.cubicFeet}" format="###0.0"/></dd>
		          </dl>
	            </div>
		  		<div class="col2">
		          <dl>
					<dt>UPC:</dt>				<dd><g:formatNumber number="${item.upc}" format="###########0"/></dd>
					<dt>Euro Article No:</dt>	<dd><g:formatNumber number="${item.euroArticleNo}" format="###########0"/></dd>
					<dt>GTIN:</dt>				<dd><g:formatNumber number="${item.gtin}" format="00000000000000"/></dd>
					<dt>Customs Tariff No:</dt>	<dd>${(item.customsTariffNo.trim()?:'&nbsp;')}</dd>
					<dt>Class:</dt>				<dd>${item.profitCenterClass}-${item.productGroupClass}-${item.articleGroupClass}</dd>
					<dt>Color:</dt>				<dd style="color:${(item.color.trim() != 'WHITE')?item.color.trim():black}">
													<font color="">
													${(item.color.trim()?:'&nbsp;')}
                                                    </font>
												</dd>
			        <g:if test="${item.dimLength}">
						<dt>Dimensions:</dt>	<dd>${item.dimLength} X ${item.dimWidth} X ${item.dimHeight}</dd>
					</g:if>
                    <jsec:hasRole name="${Role.KETTLER}">
                        <dt>Active:</dt> <dd>
                            <% if (item.activeCode == 'I') { %>
                                No
                            <% } else { %>
                                <img src="${createLinkTo(dir:'images/skin',file:'checkmark.gif')}" alt="Yes">
                            <% } %>
                        </dd>
                    </jsec:hasRole>
		          </dl>
	            </div>
            </g:if>
            <g:if test="${bom}">
	            <div class="list" style="clear:both;">
	               <h3>Bill of Materials:</h3s>
	                <table>
	                    <thead>
	                        <tr>
	                   	        <th>Component</th>
	                   	        <th>Description</th>
	                   	        <th>Quantity</th>
	                   	        <th>Unit Measure</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <g:each in="${bom}" status="i" var="part">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
								<td>
									<g:link action="item" params="[itemNo:part.partItemNo]">${part.partItemNo}</g:link>
								</td>
								<td>${(ItemMaster.findByCompCodeAndItemNo(part.compCode, part.itemNo)?.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;'))}</td>
								<td>${part.partQty}</td>
								<td>${part.partUnitMeas}</td>
	                        </tr>
	                    </g:each>
	                    </tbody>
	                </table>
		        </div>
            </g:if>
          </div>
          <div class="buttons">
          	<%-- this seems practically useless but it is on the SOW
          	   although, it would be handy if the new order had this item automatically added... 
  			<span class="menuButton">
				<g:link action="order" controller="order" class="linkButton" title="Click to add a new order">New Order</g:link>
			</span>
			--%>
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}/order/home.gsp">Home</a></span>
			<jsec:hasRole name="${Role.KETTLER}">
		        <g:if test="${item && ItemSalesHist.findByCompCodeAndItemNo(item.compCode, item.itemNo)}">
		        	<input type="hidden" name="compCode" value="${item.compCode}">
		        	<input type="hidden" name="itemNoForHist" value="${item.itemNo}">
		            <g:actionSubmit class="show" action="salesHist" name="salesHist" value="Sales History" title="Click to display item sales history"/>
		        </g:if>
		    </jsec:hasRole>
          </div>
        </g:form>
     </div>
   
</body>
</html>
