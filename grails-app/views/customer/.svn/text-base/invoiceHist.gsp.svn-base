<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.actrcv.BalanceForward" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<% if (params?.popup) { %>
		<meta name="layout" content="popup" />
	<% } else { %>
		<meta name="layout" content="main" />
	<% } %>
    <resource:dateChooser />
	<title>Customer Invoice History</title>
</head>
    
<body>
    <div class="body">
    	<h1>Customer Invoice History</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <div class="dialog">
        	<dl>
             <dt class="name">Customer:</dt>   <dd>${cust.compCode}:${cust.custNo} - ${cust.shortName}</dd>
            </dl>
        </div>
		<h1>Subset Search</h1>

        <g:form action="invoiceHist" name="invoiceHistForm" method="post" >
        	<input type="hidden" name="max" value="${params.max}"/>
        	<input type="hidden" name="offset" value="0"/>
        	<input type="hidden" name="sort" value="${params.sort}"/>
        	<input type="hidden" name="compCode" value="${params.compCode}"/>
        	<input type="hidden" name="custNo" value="${params.custNo}"/>
        	<div class="col1">
				<dl>
					<dt>PO No:</dt>					<dd><input type="text" size="25" maxlength="25" name="poNo" id="poNo" value="${params.poNo}"/></dd>
					<dt>Order No >=</dt>			<dd><input type="text" size="7"  maxlength="7"  name="orderNo" id="orderNo" value="${params.orderNo}" onkeypress="checkNumeric(event);"/></dd>
				</dl>
			</div>
        	<div class="col2">
				<dl>
					<dt>Invoice No >=</dt>			<dd><input type="text" size="7" maxlength="7" name="invoiceNo" id="invoiceNo" value="${params.invoiceNo}"/></dd>
					<dt>Invoice Date:</dt>			<dd><richui:dateChooser class="date" name="invoiceDate" value="${params.invoiceDate}" format="MM/dd/yyyy" /> mm/dd/yyyy</dd>
				</dl>
			</div>
			<div class="buttons" >
				<g:submitButton class="search" name="search" value="Search" /> 
			</div>
		</g:form>
		<br/>
    	<div class="list">
            <table style="width:100%">
                <thead>
                    <tr>
              	        <kettler:sortableColumn property="invoiceNo" params="${params}" title="Invoice No" />
              	        <kettler:sortableColumn property="invoiceDate" params="${params}" title="Invoice Date" />
              	        <kettler:sortableColumn property="orderNo" params="${params}" title="Order No" />
              	        <kettler:sortableColumn property="shipToNo" params="${params}" title="Ship-To No" />
              	        <kettler:sortableColumn property="poNo" params="${params}" title="Purchase Order" />
              	        <kettler:sortableColumn property="creditMemoCode" params="${params}" title="CM" />
              	        <kettler:sortableColumn property="orderTotal" params="${params}" title="Amount" />
                    </tr>
                </thead>
                <tbody>
                <g:each in="${invoices}" status="i" var="inv">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}"> 
						<td><a href="${createLinkTo(dir:'customer')}/invoiceHistDetail?compCode=${inv.compCode}&orderNo=${inv.orderNo}&shipNo=${inv.shipNo}&popup=${params.popup}" title="Click to display invoice history detial">${inv.invoiceNo}</a></td>
              	        <td><g:formatDate date="${inv.invoiceDate}" format="MM/dd/yy"/></td>
              	        <td>${inv.orderNo}-${inv.shipNo}</td>
              	        <td>${inv.shipToNo}</td> 
              	        <td>${inv.poNo}</td>
              	        <td class="number">
              	        	<g:if test="${inv.creditMemoCode}">
								<img src="${createLinkTo(dir:'images/skin',file:'checkmark.gif')}" alt="Yes">
							</g:if>
						</td>
              	        <td class="number">${inv.orderTotal}</td>
                    </tr>
                </g:each>
                <g:if test="${(!invoices?.size())}">
                	<tr><td class="comment">No records found</td></tr>
                </g:if>
                </tbody>
            </table>
        </div>
        <div class="paginateButtons">
            <g:paginate total="${count?:0}" params="${params}"/>
        </div>
   </div>
	<div class="buttons">
		<span class="menuButton">
			<a class="table" href="${createLinkTo(dir:'customer')}/show?compCode=${cust.compCode}&custNo=${cust.custNo}&popup=${params.popup}" title="Click to return to Customer Inquiry">Back</a>
		</span>
	</div>
</body>
</html>