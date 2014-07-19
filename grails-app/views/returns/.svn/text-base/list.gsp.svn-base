<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.actrcv.share.Return" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnItem" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnReason" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnStatus" %>

<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderDetailItem" %>


<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
    <style>
        
        /* position auto-complete */
        .yui-skin-sam  .yui-ac-container {
            left:350px;
        }
        .searchcontainer  {
            position: relative; 
            top:10px;
        }
        /* auto-complete overrides of autocomplete.css */
        .searchcontainer li.yui-ac-highlight {background:#b2d1ff;}
        .searchcontainer li.yui-ac-prehighlight {background:#f7f7f7;}
    </style>
    <g:javascript library="prototype" />
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Return Authorizations Search ${params.inquiry=='true'?' for Inquiry':' for Maintenance'}</title>
        <resource:autoComplete skin="default" />
        <gui:resources components="['dataTable']"/>
    </head>
    <body>
        <div class="body">

            <g:if test="${session.message}"><div class="message">${session.message}</div><% session.message = null %></g:if>

            <h1>Return Authorization Search ${(user?.user400?.returnWarehouse)?' for Receiving ':''}${params.inquiry=='true'?' for Inquiry':' for Maintenance'} ${params.inquiry=='true'?'true':'false'} </h1>
          
            <g:form action="list" name="searchForm" method="post" >
                <input type="hidden" name="max" value="${params.max}"/>
                <input type="hidden" name="offset" value="0"/>
                <input type="hidden" name="sort" value="${params.sort}"/>
                 <dl class="search">
                         <dt>Return No:</dt>              <dd><g:textField size="6" maxlength="7" name="returnNo"  value="${params.returnNo}"  onkeypress="checkNumeric(event);"/></dd>
                         <dt>Order No:</dt>               <dd><g:textField size="6" maxlength="6" name="orderNo"  value="${params.orderNo}" onkeypress="checkNumeric(event);"/></dd>
                         <jsec:hasRole name="${Role.KETTLER}">
                             <dt>Cust No:</dt>            <dd><g:textField  size="7"  maxlength="7"  name="custNo"     value="${params.custNo}" onchange="this.value=this.value.toUpperCase();"/></dd>
                         </jsec:hasRole>
                         <dt>Item Number:</dt>            <dd><g:textField  size="12" maxlength="15" name="itemNo" value="${params.itemNo}" /></dd>
                                                         <%-- <richui:autoComplete name="itemNo" action="${createLinkTo('dir': 'itemMaster/searchAJAX')}" 
                                                         TODO use but stop wrap                           size="15" maxLength="15" value="${params.itemNo}"
                                                                                    shadow="true" typeAhead="true" maxResultsDisplayed="25"/>--%>
                 </dl>
                 <dl class="search">
                         <dt>Freight Claims:</dt>         <dd><g:checkBox name="freightClaimsOnly" value="${params.freightClaimsOnly}" /></dd>
                         <dt>Pick-Up Name:</dt>           <dd><g:textField  size="30" maxlength="30" name="shipToName" value="${params.shipToName}" /></dd>
                         <dt>Pick-Up Zip:</dt>            <dd><g:textField  size="10" maxlength="10" name="shipToZip"  value="${params.shipToZip}" /></dd>
                 </dl>
                <jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
	                <div class="full">
	                    <dl class="search">
	                            <dt>Cust No:</dt>            <dd>            
	                                                                <g:select name="custNo" from="${Customer.findAllBySalespersonCode(user?.salesperson?.id)}" 
	                                                                      optionKey="custNo" noSelection="${['':'Select a customer...']}"/>
	                                                         </dd>
	                    </dl>
	                </div>
                </jsec:hasAnyRole>                
                <div class="full">
                    <dl class="search">
                            <dt>Status:</dt>                <dd><g:select name="status" from="${ReturnStatus.list()}" optionKey="code" value="${params.status}" noSelection="['':'- Any Status -']"/> </dd>
                    </dl>
                </div>
                <div class="buttons" >
                    <g:submitButton class="search" name="search" value="Search" /> 
                    <span class="menuButton">
                           <a href="#" id="showItemMasterDataTableDialog" class="search" title="Click to search for an item." 
                                   onclick="$('itemMasterDataTableDialog').setStyle({left: '0em'});$('itemMasterDataTableDiv').show();">
                                   Item Search
                           </a>
	                       <% if (!params.inquiry) { %>
                               <g:link action="return" controller="returns"  class="create" title="Click to create a Return Authorization">Create</g:link></li>
	                       <% } %>
                    </span> 
                    <input type="hidden" name="inquiry" value="${params.inquiry}"/>                
                </div>
            </g:form>
            <g:render template="/order/itemMasterDataTableDialog"/>
            <br/>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table class="wide">
                    <thead>
                        <tr>
                           <g:sortableColumn property="id" title="RA No" />
                           <th>Cust No</th>
                           <th>Status</th>
                           <th class="width8">Order No</th>
                           <th class="width15">Item No</th>
                           <th class="width40">Description</th>
                           <th class="width8">Auth Qty</th>
                           <th class="width8">Return Qty</th>
                           <th class="width8">Unit Price</th>
                           <th class="width25">Reason</th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:each in="${raList}" status="i" var="ra">
                            <tr id="raListRow${i}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                <td class="${ra.hold?'hold':''}">
                                    <g:link action="return" id="${ra.id}" 
                                           title="${ra.hold?'On hold. ':''}Click to ${params.inquiry=='true'?' display ':' edit '} this Return" params="[inquiry:params.inquiry]">
                                           <g:formatNumber number="${ra.id}" format="#######0" />
                                    </g:link>
                                </td>
                                <td>${ra.customer.custNo}</td>
                                <td>${ra.status.id}</td>
                                <g:each in="${ra.items}" status="j" var="item">
	                                 <% // if quanties or unit prices deviate, highlight
	                                    def itemErrorDesc
	                                    if (ra.status.colLockLevel >= ReturnStatus.get('CMDIF').colLockLevel && !ra.fieldDestroy && item.receivedQty != item.authQty) {
	                                 	   itemErrorDesc = "Received quantity of ${item.receivedQty} not equal to authorized quantity of ${item.authQty}"
	                                    } 
	                                    if (item.orderNo) { 
	                                 	   def invoicedPrice = InvoicedOrderDetailItem.findWhere(compCode:ra.customer.compCode, orderNo:item.orderNo, itemNo:item.itemNo)?.amount
	                                 	   if (invoicedPrice && item.unitPrice > invoicedPrice) {
	                                            itemErrorDesc = "RA price of ${item.unitPrice} greater than invoiced price of ${invoicedPrice}"
	                                 	   }
	                                    }
	                                 %>
		                            <% if (j) { /* if not first item for RA, new row and check for error condition */ %>
		                                <tr
		                                   <%  if (itemErrorDesc) { /* if quanties or unit prices deviate, highlight */ %>
		                                          class="errors"
		                                          title="${itemErrorDesc}"
		                                   <% } %>
		                                >
		                                <td/><td/><td/>
		                            <% } else if (itemErrorDesc) { /* must be first row, if error condition use javascript to set */ %>
		                              <script type="text/javascript">
		                              <%-- Note, IE can't get at the tr at this point --%>
		                               $('raListRow${i}').className = 'errors';
		                               $('raListRow${i}').title = '${itemErrorDesc}';
		                              </script>
		                            <% } %>
	                                <td>${item.orderNo}</td>
	                                <td>${item.itemNo}</td>
	                                <td class="width50">${item.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
	                                <td class="number">${item.authQty}</td>
	                                <td class="number">${item.receivedQty}</td>
	                                <td class="number">${item.unitPrice}</td>
	                                <td>${(item.reason?.id?ReturnReason.get(item.reason?.id):'&#160;')}</td>
                                </g:each>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${raTotal}" params="${params}" />
            </div>
        </div>
    </body>
</html>
