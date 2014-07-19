<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="com.kettler.domain.orderentry.OrderDates" %>

<%@ page import="com.kettler.domain.actrcv.share.Customer" %>

<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<% if (params?.popup) { %>
			<meta name="layout" content="popup" />
		<% } else { %>
			<meta name="layout" content="main" />
		<% } %>
        <resource:dateChooser />
		<g:javascript library="prototype" />
		<title>Select Order</title>
    </head>
<body>
	<g:javascript>
	    function onloadHandler() { // called in body of layout gsp
	       openOrInvoicedChanged();
	    }
	    function openOrInvoicedChanged() {
           if ($('orderOpenInvoicedBoth').value == 'I') { 
               $('fromToDT').show();$('fromToDD').show();
           } else { 
               $('fromToDT').hide();$('fromToDD').hide();
               $('fromInvoiceDate_month').value = '';
               $('fromInvoiceDate_day').value = '';
               $('fromInvoiceDate_year').value = '';
               $('toInvoiceDate_month').value = '';
               $('toInvoiceDate_day').value = '';
               $('toInvoiceDate_year').value = '';
           }
	    }
	    // remove optional dates, if blank, so Grails command binding doesn't have an issue
	    function removeEmptyDates() {
	        var ele;
	        if ($('fromInvoiceDate_month').value == '') {
	            ele = $('fromInvoiceDate');       ele.parentNode.removeChild(ele);
	            ele = $('fromInvoiceDate_month'); ele.parentNode.removeChild(ele);
	            ele = $('fromInvoiceDate_day');   ele.parentNode.removeChild(ele);
	            ele = $('fromInvoiceDate_year');  ele.parentNode.removeChild(ele);
	        }
	        if ($('toInvoiceDate_month').value == '') {
	            ele = $('toInvoiceDate');       ele.parentNode.removeChild(ele);
	            ele = $('toInvoiceDate_month'); ele.parentNode.removeChild(ele);
	            ele = $('toInvoiceDate_day');   ele.parentNode.removeChild(ele);
	            ele = $('toInvoiceDate_year');  ele.parentNode.removeChild(ele);
	        }
	    }
	</g:javascript>
    <div class="body">
    	<g:if test="${params.inquiry}">
    		<g:if test="${params.statusCode == ' '}">
    			<h1>Order Inquiry</h1>
    		</g:if>
    		<g:elseif test="${params.statusCode == 'F'}">
				<h1>Future Ship Inquiry</h1>
    		</g:elseif>
    		<g:elseif test="${params.statusCode == 'H'}">
				<h1>Credit Hold Inquiry</h1>
    		</g:elseif>
    		<g:elseif test="${params.statusCode == 'B'}">
				<h1>Back Order Inquiry</h1>
    		</g:elseif>
        </g:if>
        <g:else>
        	<h1>Order Update</h1>
        </g:else>
        
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <g:hasErrors bean="${cmd}"><div class="errors"><g:renderErrors bean="${cmd}" as="list" /></div></g:hasErrors>

		<% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()?:'') %>

        <g:form action="selectOrder" name="selectOrderForm" method="post">
   	        <jsec:lacksRole name="${Role.KETTLER}">
				<g:hiddenField name="compCode" value="${user.compCode}"/>
			</jsec:lacksRole>
        	<g:hiddenField name="statusCode" value="${params.statusCode}"/>
        	<g:hiddenField name="max" value="${params.max}"/>
        	<g:hiddenField name="offset" value="0"/>
        	<g:hiddenField name="sort" value="${params.sort}"/>
            <g:hiddenField name="poNo" value="${params.poNo}"/>
            <g:hiddenField name="freightTrackingNo" value="${params.freightTrackingNo}"/>
            <g:hiddenField name="creditMemo" value="${params.creditMemo}"/>
            <g:hiddenField name="inquiry" value="${params.inquiry}"/>
            <g:hiddenField name="gspRequestNotRedirect" value="true"/>
             <div class="dialog">
    	          <jsec:hasRole name="${Role.KETTLER}">
                  	<span class="prompt">Comp Code:</span>  <input type="text" size="2" maxlength="2" id="compCode" name="compCode"/>
                  </jsec:hasRole>
                  <span class="prompt">Order No:</span>		<input type="text" size="7" maxlength="7" id="orderNo" name="orderNo"/>
				  <span class="buttons"><g:submitButton class="show" name="selectOrder" value="Select" /></span>
             </div>
         </g:form> 

		<h1>Search for an Order</h1>

        <g:form action="listOrders" name="searchOrderForm" method="post" >
        	<input type="hidden" name="statusCode" value="${params.statusCode}"/>
        	<input type="hidden" name="max" value="${params.max}"/>
        	<input type="hidden" name="offset" value="0"/>
        	<input type="hidden" name="sort" value="${params.sort}"/>
        	<input type="hidden" name="inquiry" value="${params.inquiry}"/>
        	<div class="col1">
				<dl>
					<% if (!['N', 'B', 'F', 'H'].find {it == params.statusCode}) { %>
						<dt>Open Or Invoiced:</dt>		<dd>
						                                       <g:select name="orderOpenInvoicedBoth" from="${['O', 'I', 'B']}" value="${params.orderOpenInvoicedBoth}" 
						                                                 valueMessagePrefix="orderOpenInvoicedBoth"  noSelection="${['O':'Select One...']}"
						                                                 onchange="openOrInvoicedChanged();"/>
						                                </dd>
					<% } %>
		            <jsec:hasAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN,Role.KETTLER]}"><!-- prompted below in "full" dl list with the wide customers for rep drop-down -->
						<dt>PO No:</dt>					<dd><input type="text" size="25" maxlength="25" name="poNo" id="poNo" value="${params.poNo}"/></dd>
					</jsec:hasAnyRole>
					<% if (!['N', 'B', 'F', 'H'].find {it == params.statusCode}) { %>
						<dt>Status:</dt>				<dd><g:select name="status" from="${['N', 'B', 'C', 'X', 'F', 'I', 'H', 'O', 'P', 'S']}" value="${params.status}" valueMessagePrefix="orderHeader.status"  noSelection="${['':'Select One...']}"/></dd>
					<% } %>
          <jsec:hasRole name="${Role.KETTLER}">
						<dt>Rep No:</dt>	<dd>
                                    <%-- <input type="text" size="3" maxlength="3" name="salesperson1" id="salesperson1" value="${params.salesperson1}" > --%>
                                    <g:select name="salesperson1" from="${com.kettler.domain.orderentry.share.SalesPerson.list([sort: 'name'])}"
                                                value="${params.salesperson1}"
                                                optionKey="id" optionValue="name"
                                                noSelection="${['':'Pick salesperson...']}" />

                              </dd>
					</jsec:hasRole>
				</dl>
			</div>
        	<div class="col2">
				<dl>
		   	        <jsec:hasRole name="${Role.KETTLER}">
						<dt>Cust No:</dt>				<dd><input type="text" size="7" maxlength="7" name="custNo" id="custNo" value="${params.custNo}" onchange="this.value=this.value.toUpperCase();"/></dd>
					</jsec:hasRole>
					<% if (!['N', 'B', 'F', 'H'].find {it == params.statusCode}) { %>
						<dt>Freight Tracking:</dt>		<dd><input type="text" size="25" maxlength="25" name="freightTrackingNo" id="freightTrackingNo" value="${params.freightTrackingNo}" /></dd>
						<dt>Credit Memo:</dt>			<dd><g:checkBox name="creditMemo"  value="${params.creditMemo}"/></dd>
                        <dt>Invoice No:</dt>            <dd><input type="text" size="7" maxlength="7" name="invoiceNo" id="invoiceNo" value="${params.invoiceNo}" /></dd>
					<% } %>
                <dt id="fromToDT">From/Thru:</dt>       <dd id="fromToDD">  <%-- rebuild dates from structure in params --%>
                                                           <richui:dateChooser class="date" name="fromInvoiceDate" value="${(cmd.metaClass.hasProperty(cmd,'fromInvoiceDate')?cmd?.fromInvoiceDate:null)}" format="MM/dd/yyyy"    /> 
                                                           <richui:dateChooser class="date" name="toInvoiceDate"   value="${(cmd.metaClass.hasProperty(cmd,'toInvoiceDate')  ?cmd?.toInvoiceDate:null)}"   format="MM/dd/yyyy"    />
                                                           mm/dd/yyyy
                                                        </dd>
				</dl> 
			</div>
            <jsec:hasAnyRole in="${[Role.REP_PLUS, Role.REP,Role.REP_ADMIN]}">
	            <div class="full">
	            	<dl>
						<dt>PO No:</dt>					<dd><input type="text" size="25" maxlength="25" name="poNo" id="poNo" value="${params.poNo}"/></dd>
					     <dt>Cust No:</dt>			
							<dd>
								<g:select name="custNo" from="${customers}" onchange="this.form.submit();" optionKey="custNo" 
									value="${params.custNo}" noSelection="${['':'Select a customer...']}"/>
					        	<%--<input type="hidden" name="search" value="Search"/> --%>
							</dd>
					</dl> 
				</div>		  
			</jsec:hasAnyRole>                       
			<div class="buttons" >
				<g:submitButton class="search" name="search" value="Search" onclick="removeEmptyDates();"/> 
			</div>
			<br/>
            <div class="list">
                <table style="width:100%">
                    <thead>
                        <tr>
                   	        <kettler:sortableColumn property="orderNo" params="${params}" title="Order No" />
				            <jsec:lacksAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
	                   	        <kettler:sortableColumn property="custNo" params="${params}" title="Cust No" />
    	               	        <th>Name</th>
    	               	    </jsec:lacksAnyRole>
							<% if (params.statusCode != 'N') {  %>
                   	        	<kettler:sortableColumn property="creditMemoCode" params="${params}" title="CM" linkTitle="Click to sort on Credit Memo" />
                   	        <% } %>
                   	        <% if (params.orderOpenInvoicedBoth != 'I') { %>
                      	        <kettler:sortableColumn property="orderDate" params="${params}" title="Order Date" />
                   	        <% } else { %>
                                <kettler:sortableColumn property="invoiceDate" params="${params}" title="Invoice Date" />
                   	        <% } %>
                   	        <kettler:sortableColumn property="poNo" params="${params}" title="Purchase Order No" />
                   	        <kettler:sortableColumn property="statusCode" params="${params}" title="Status" />
							<% if (params.statusCode != 'N') {  %>
	                   	        <th>Status Date</th>
	                   	        <kettler:sortableColumn property="freightTrackingNo" params="${params}" title="Freight Tracking No" />
	                   	    <% } %>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${orderList}" status="i" var="order">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td style="white-space: nowrap;" >
								<% if ('I' == order.statusCode) { %>
									<a href="${createLink(controller:'customer', action:'invoiceHistDetail', params:[compCode:order.compCode, orderNo:order.orderNo, shipNo:order.shipNo, requestPage:'selectOrder'])}"
									   title="Click to select this invoiced order">${order.orderNo}</a>
                            	<% } else { %>
	                            	<a href="#" onclick="$('compCode').value='${order.compCode}';$('orderNo').value='${order.orderNo}';$('selectOrderForm').submit();" 
    	                        				title="Click to select this order">${order.orderNo}</a>
                               	<% } %>
								<% if (!['I', 'N', 'X'].find {it == order.statusCode} ) { %>
									<a class="printer"  href="#" onclick="window.open ('${createLinkTo(dir:'customer')}/printAckn?compCode=${order.compCode}&orderNo=${order.orderNo}&shipNo=${order.shipNo}', 'acknowledgement', 'location=1,status=1,scrollbars=1,width=900,height=690');"
											title="Click to display the Print Acknowledgement as a PDF" >&nbsp;</a>
                               	<% } %>
                               	
								<% if (['S', 'C'].find {it == order.statusCode}) { %>
									<a class="printer"  href="#" onclick="window.open ('${createLinkTo(dir:'customer')}/printPackList?compCode=${order.compCode}&orderNo=${order.orderNo}&shipNo=${order.shipNo}', 'packlist', 'location=1,status=1,scrollbars=1,width=900,height=690');"
											title="Click to display the Pack List as a PDF" >&nbsp;</a>
                               	<% } %>
                            </td>
				            <jsec:lacksAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
	                            <td>${fieldValue(bean:order, field:'custNo')}</td>
	                            <td>${Customer.findByCompCodeAndCustNo(order.compCode, order.custNo)?.name}</td>
                            </jsec:lacksAnyRole>
							<% if (params.statusCode != 'N') {  %>
	                            <td>
			                    	<g:if test="${order.creditMemoCode}">
										<img src="${createLinkTo(dir:'images/skin',file:'checkmark.gif')}" alt="Yes">
									</g:if>
								</td>
							<% } %>
                            <% if (params.orderOpenInvoicedBoth != 'I') { %>
                                <td><g:formatDate date="${order.orderDate}" format="MM/dd/yy"/></td>
                            <% } else { %>
                                <td><g:formatDate date="${order.invoiceDate}" format="MM/dd/yy"/></td>
                            <% } %>
                            <td>${fieldValue(bean:order, field:'poNo')}</td>
                            <td>
                            	<g:message code="orderStatus.${order.statusCode}"/>
                            	<% if (order.statusCode == 'S') { %>
                            		by ${order.shipVia}
                               	<% } %>
                            </td>
							<% if (params.statusCode != 'N') {  %>
	                            <td>
	                                <% def date %>
	                            	<% 	switch (order.statusCode) {
	                            		case 'S': date= order.dateShipped; break;
	                            		case 'X': date= order.canceledDate; break;
	                            		case 'N': date= order.dateCreated; break;
	                            		case 'P': date= order.pickDateMDY; break;
	                            		case 'B': date= order.backOrderReleaseDate; break;
	                            		case 'C': date= order.dateConfirmed; break;
	                            		case 'F': date= OrderDates.findWhere(compCode:order.compCode, orderNo:order.orderNo, shipNo:order.shipNo)?.date;break;
	                            		/* don't know what date to use:
	                            		H - On credit hold
	                            		N - New status (until verified)
	                            		O - Open 
	                            		*/
	                            		}
	                            	%>
	                            	<% if (date) { %>
	                            		<g:formatDate date="${date}" format="MM/dd/yy"/>
	                            	<% } %>
	                            </td>
	                            <td>${fieldValue(bean:order, field:'freightTrackingNo')}</td>
	                        <% } %>
                        </tr>
                    </g:each>
                    <g:if test="${(!orderList?.size())}">
                    	<tr><td class="comment">No records found</td></tr>
                    </g:if>
                    </tbody>
                </table>
            </div>
        </g:form>
        <div class="paginateButtons">
            <% params.search = 'Search' /* so savedOrderSearchParams doesn't overwrite params */ %>
            <g:paginate total="${count?:0}" params="${params}"/>
			<span class="menuButton">
				<a class="home" href="${createLinkTo(dir:'order')}/home.gsp">Home</a>
				<% if (params.compCode && params.custNo) { %>
					<a class="table" href="${createLinkTo(dir:'customer')}/show?compCode=${params.compCode}&custNo=${params.custNo}&popup=${params.popup}" title="Click to return to Customer Inquiry">Back</a>
				<% } %>
			</span>
        </div>
    </div>
</body>
</html>
