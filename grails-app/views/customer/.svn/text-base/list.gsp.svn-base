<%@ page import="com.kettler.domain.orderentry.Company" %>
<%@ page import="com.kettler.domain.orderentry.StateCode" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
		<g:javascript library="prototype" />
		<title>Customer Inquiry</title>
    </head>
    
<body>
    <div class="body">
    	<h1>Customer Inquiry</h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <g:form action="show" name="selectCustForm" method="post" >
             <div class="dialog">
                <jsec:hasRole name="${Role.KETTLER}">
             	      <span class="prompt">Comp Code:</span><input type="text" size="2" maxlength="2" id="compCode" name="compCode"/>
             	</jsec:hasRole>
                <jsec:lacksRole name="${Role.KETTLER}">
                    <% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()) %>
                    <g:hiddenField name="compCode" value="${user.compCode}"/>
             	</jsec:lacksRole>
             	
                <span class="prompt">Cust No:</span><input type="text" size="7" maxlength="7" id="custNo" name="custNo"/>
				<span class="buttons"><g:submitButton class="show" name="show" vwalue="Select" /></span>
             </div>
         </g:form>

		<h1>Search for a Customer</h1>

        <g:form action="list" name="searchCustForm" method="post" >
        	<div class="col1">
				<dl>
					<dt>Name:</dt>				<dd><input type="text" size="20" maxlength="30" name="name" value="${params.name}"/></dd>
	        	    <jsec:hasRole name="${Role.KETTLER}">
                        <dt>Comp Code:</dt>         <dd><g:select name="compCode" from="${Company.list()}" optionKey="id" optionValue="name" noSelection="${['':'Select One...']}"/></dd>
						<dt>Sales Rep:</dt>			<dd><g:select optionKey="id" from="${SalesPerson.list([sort:'id'])}" name="salespersonCode" value="${params?.salespersonCode}" noSelection="['':'Select One']"></g:select></dd>
					</jsec:hasRole>
				</dl>
			</div>
        	<div class="col2">
				<dl>
					<dt>City:</dt>				<dd><input type="text" size="15" maxlength="15" name="city"  value="${params.city}"/></dd>
					<dt>State:</dt>				<dd><input type="text" size="2"  maxlength="2"  name="state"  value="${params.state}"/></dd>
					<dt>Zip Code:</dt>			<dd><input type="text" size="10" maxlength="10" name="zipCode" value="${params.zipCode}" /></dd>
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
                   	        <kettler:sortableColumn property="custNo" params="${params}" title="Cust No" />
                   	        <kettler:sortableColumn property="name" params="${params}" title="Name" />
                   	        <kettler:sortableColumn property="city" params="${params}" title="City" />
                   	        <kettler:sortableColumn property="state" params="${params}" title="State" />
                   	        <kettler:sortableColumn property="zipCode" params="${params}" title="Zip Code" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${custList}" status="i" var="cust">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><a href="#" onclick="$('custNo').value='${cust.custNo}';$('compCode').value='${cust.compCode}';$('selectCustForm').submit();" 
                            		title="Click to select this customer">${cust.custNo}</a>
                            </td>
                            <td>${fieldValue(bean:cust, field:'name')}</td>
                            <td>${fieldValue(bean:cust, field:'city')}</td>
                            <td>${fieldValue(bean:cust, field:'state')}</td>
                            <td>${fieldValue(bean:cust, field:'zipCode')}</td>
                        </tr>
                    </g:each>
                    <g:if test="${(!custList?.size())}">
                    	<tr><td class="comment">No records found</td></tr>
                    </g:if>
                    </tbody>
                </table>
            </div>
        </g:form>
        <div class="paginateButtons">
            <% params.search = 'Search' /* so savedCustomerSearchParams doesn't overwrite params */%>
            <g:paginate total="${count?:0}" params="${params}"/>
			<span class="menuButton">
				<a class="home" href="${createLinkTo(dir:'order')}/home.gsp">Home</a>
			</span>
        </div>
    </div>

</body>
</html>
