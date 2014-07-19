<%@ page import="com.kettler.domain.orderentry.QuoteHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.Terms" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>

<%@ page import="com.kettler.domain.actrcv.share.Customer" %>

<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="layout" content="main" />
		<g:javascript library="prototype" />
		<title>Select Quote</title>
    </head>
    
<body>
    <div class="body">
		<h1>Quote Inquiry</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <g:hasErrors bean="${cmd}"><div class="errors"><g:renderErrors bean="${cmd}" as="list" /></div></g:hasErrors>

		<% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()?:'') %>

        <g:form action="view" name="viewQuoteForm" method="post" >
   	        <jsec:lacksRole name="${Role.KETTLER}">
				<g:hiddenField name="compCode" value="${user.compCode}"/>
			</jsec:lacksRole>
        	<g:hiddenField name="max" value="${params.max}"/>
        	<g:hiddenField name="offset" value="0"/>
        	<g:hiddenField name="sort" value="${params.sort}"/>
             <div class="dialog">
    	          <jsec:hasRole name="${Role.KETTLER}">
                  	<span class="prompt">Comp Code:</span>  <input type="text" size="2" maxlength="2" id="compCode" name="compCode"/>
                  </jsec:hasRole>
                  <span class="prompt">Order No:</span>		<input type="text" size="7" maxlength="7" id="orderNo" name="orderNo"/>
				  <span class="buttons"><g:submitButton class="show" name="selectOrder" value="Select" /></span>
             </div>
         </g:form> 

		<h1>Search for a Quote</h1>

        <g:form action="select" name="selectQuoteForm" method="post" >
        	<input type="hidden" name="max" value="${params.max}"/>
        	<input type="hidden" name="offset" value="0"/>
        	<input type="hidden" name="sort" value="${params.sort}"/>
        	<div class="col1">
				<dl>
		            <jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}"> 
					     <dt>Cust No:</dt>			
							<dd>
								<g:select name="custNo" from="${customers}" onchange="this.form.submit();" optionKey="custNo" 
									value="${params.custNo}" noSelection="${['':'Select a customer...']}"/>
							</dd>
					</jsec:hasAnyRole>
		            <jsec:hasRole name="${Role.KETTLER}"> 
						<dt>Cust No:</dt>				<dd><input type="text" size="7" maxlength="7" name="custNo" id="custNo" value="${params.custNo}" onchange="this.value=this.value.toUpperCase();"/></dd>
					</jsec:hasRole>
					<dt>Status:</dt>					<dd><g:select name="statusCode" from="${['P', 'E', 'R', 'D']}" value="${params.statusCode}" valueMessagePrefix="quoteHeader.status"  noSelection="${[' ':'New Quotes']}"/></dd>
				</dl>
			</div>
        	<div class="col2">
				<dl>
		   	        <jsec:hasRole name="${Role.KETTLER}">
						<dt>Sales Person:</dt> 	<dd class="value"> <g:select name="salesperson1" from="${SalesPerson.list([sort:'id'])}" optionKey="id" noSelection="${['':'Select One...']}"/> </dd>
					</jsec:hasRole>
				</dl> 
			</div>
			<div class="buttons" >
				<g:submitButton class="search" name="search" value="Search" /> 
			</div>
			<br/>
            <div class="list">
                <table style="width:100%">
                    <thead>
                        <tr>
                   	        <kettler:sortableColumn property="orderNo" params="${params}" title="Quote No" />
                   	        <kettler:sortableColumn property="shipNo" params="${params}" title="Ship No" />
                   	        <kettler:sortableColumn property="statusCode" params="${params}" title="Status Code" />
				   	        <jsec:lacksAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
    	               	        <kettler:sortableColumn property="custNo" params="${params}" title="Cust No" />
				   	        </jsec:lacksAnyRole>
				   	        <jsec:hasRole name="${Role.KETTLER}">
    	               	        <kettler:sortableColumn property="salesperson1" params="${params}" title="Rep" />
				   	        </jsec:hasRole>
                   	        <th>Pick Date</th>
                   	        <kettler:sortableColumn property="termsCode" params="${params}" title="Payment Terms" />
                   	        <kettler:sortableColumn property="orderTotal" params="${params}" title="Total" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${quoteList}" status="i" var="quote">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}  ">
                            <td style="white-space: nowrap;" >
                            	<a href="#" onclick="$('compCode').value='${quote.compCode}';$('orderNo').value='${quote.orderNo}';$('viewQuoteForm').submit();" 
                            				title="Click to select this quote">${quote.orderNo}</a>
                            </td>
				   	        <td>${quote.shipNo}</td>
				   	        <td><g:message code="quoteHeader.status.${quote.statusCode}"/></td>
				   	        <jsec:lacksAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
				   	        	<td>${quote.custNo}</td>
				   	        </jsec:lacksAnyRole>
				   	        <jsec:hasRole name="${Role.KETTLER}">
				   	        	<td>${quote.salesperson1}</td>
				   	        </jsec:hasRole>
				   	        <td><g:formatDate date="${quote.pickDateMDY}" format="MM/dd/yy"/></td>
				   	        <td>${(Terms.get(quote.termsCode)?.desc)}</td>
				   	        <td class="number"><g:formatNumber number="${quote.orderTotal}" format="\$#,###,##0.00" /></td>
                        </tr>
                    </g:each>
                    <g:if test="${(!quoteList?.size())}">
                    	<tr><td class="comment">No records found</td></tr>
                    </g:if>
                    </tbody>
                </table>
            </div>
        </g:form>
        <div class="paginateButtons">
            <g:paginate total="${count?:0}" params="${params}"/>
        </div>
    </div>
</body>
</html>
