<%@ page import="com.kettler.domain.actrcv.share.Customer" %>

<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.SalesDivision" %>
<%@ page import="com.kettler.domain.orderentry.SalesGroup" %>
<%@ page import="com.kettler.domain.orderentry.Company" %>
<%@ page import="com.kettler.domain.orderentry.StateCode" %>
<%@ page import="com.kettler.domain.orderentry.Terms" %>

<%@ page import="com.kettler.domain.varsity.Country" %>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="layout" content="main" />
	<gui:resources components="['dataTable']"/>
	<g:javascript library="prototype" />
	<title>Customer Maintenance</title>
</head>
  
<body>
<script>
</script>
<div class="body">
	<h1>Setup New Customer</h1>
	<g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
	<g:hasErrors bean="${cust}"><div class="errors"><g:renderErrors bean="${cust}" as="list" /></div></g:hasErrors>
	<div>
      <g:form action="save" method="post" >
        <g:hiddenField name="id" value="${cust?.id}"/>
        <g:hiddenField name="monthYearOpened" value="${cust?.monthYearOpened}"/>
        <g:hiddenField name="custNo" value="${cust?.custNo}"/>
		<dl>
			<dt>Company Code:</dt>		<dd><g:select name="compCode" from="${Company.list()}" optionKey="id" optionValue="name"  value="${cust?.compCode}" noSelection="${['':'Select One...']}"/></dd>
			<g:if test="${cust?.custNo}">
			  <dt>Customer Number:</dt>	<dd>${cust?.custNo}</dd>
			</g:if>                                               
			<dt>Country Code:</dt>		<dd>
			                                <g:select name="countryCode" from="${Country.listUsaCanFirst()}" optionKey="isoCode" optionValue="desc"  value="${cust?.countryCode}"
			                                	 noSelection="${['':'Select One...']}"
			                                    onchange="this.form.submit();"/>
			                            </dd>
		</dl>
		<g:render template="/common/address" model="['objWithAddr':cust]"/>
		<dl>
			<dt>Short Name:</dt>		<dd>
										  <g:if test="${!cust.custNo}">
											<g:textField name="shortName" size="10" maxLength="10" value="${cust?.shortName}" />
											&nbsp;(1st 2 chars will be used as customer number prefix)
										  </g:if>
										  <g:else>
									        <g:hiddenField name="shortName" value="${cust?.shortName}"/>
										  	${cust?.shortName}
										  </g:else>
										</dd>  
			<dt>Phone Number:</dt>		<dd><g:textField name="phoneNo" size="10" maxLength="10" value="${cust?.phoneNo}" /></dd>          
			<dt>Fax Number:</dt>		<dd><g:textField name="faxNo"   size="10" maxLength="10" value="${cust?.faxNo}" /></dd>                                         
			<dt>Contact:</dt>			<dd><g:textField name="contact" size="20" maxLength="20" value="${cust?.contact}" /></dd>                                                                  
			                                                                             
			<dt>Date Opened:</dt>		<dd><g:message code="month.${cust.monthYearOpened.intdiv(100)}"/> ${cust.monthYearOpened%100+2000}</dd>
			
			<dt>Salesperson Code:</dt>	<dd><g:select name="salespersonCode" from="${SalesPerson.list([sort:'id'])}" optionKey="id" optionValue="name"  value="${cust?.salespersonCode}" noSelection="${['':'Select One...']}"/></dd>                       
			<dt>Tax Exempt:</dt>		<dd><g:checkBox name="taxExempt" value="${cust?.taxExempt}" /></dd>                  
			                                                                              
			<dt>Terms Code:</dt>		<dd><g:select name="termsCode" from="${Terms.list()}" optionKey="id" optionValue="desc" value="${cust?.termsCode}"  noSelection="${['':'Select One...']}"/></dd>                   
			<dt>Sales Division:</dt>	<dd><g:select name="salesDivision" from="${SalesDivision.list()}" optionKey="id" optionValue="desc" value="${cust?.salesDivision}"  noSelection="${['':'Select One...']}"/></dd>                                                   
			<dt>Sales Group:</dt>		<dd><g:select name="salesGroup" from="${SalesGroup.list()}" optionKey="id" optionValue="desc" value="${cust?.salesGroup}"  noSelection="${['':'Select One...']}"/></dd>                                                           
			<dt>Email Invoices:</dt>	<dd><g:checkBox name="emailInvoiceCode" value="${cust?.emailInvoiceCode}" /></dd>                                                   
			<dt>Email Address:</dt>		<dd><g:textField name="email" size="50" maxlength="50" value="${cust?.email}" /></dd>                                    
			                                                                              
			<dt>Back Order Code:</dt>	<dd><g:checkBox name="backOrderCode" value="${cust?.backOrderCode}" /></dd>                               
			<dt>Ship Complete:</dt>		<dd><g:checkBox name="shipComplete" value="${cust?.shipComplete}" /></dd> 
		
		</dl>                                                
        <div class="buttons">
          <g:if test="${!cust.custNo}">
            <input class="add" type="submit" name="save" value="Add" />
          </g:if>
          <g:else>
            <input class="save" type="submit" name="save"  value="Update" />
          </g:else>
           <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}/order/home.gsp">Home</a></span>
        </div>
      </g:form> 

	</div>
</div>
</body>
</html>