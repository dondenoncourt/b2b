<%@ page import="com.kettler.domain.orderentry.CustBillToAddr" %>
<%@ page import="com.kettler.domain.orderentry.StateCode" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Customer Bill-To Address</title>
      <g:javascript src="application" />
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		<% if (inquiry) { %>
			disableFormFields('custBillToAddrForm') ;
		<% } %>
	}
  </script>
    <div class="body">
	<h1>Customer Bill-To Address</h1>
	<g:if test="${message}"><div class="message">${message}</div></g:if>
    <g:hasErrors bean="${custBillToAddr}"><div class="errors"><g:renderErrors bean="${custBillToAddr}" as="list" /></div></g:hasErrors>
	<g:form action="order" name="custBillToAddrForm" method="post" >
		<input type="hidden"  name="compCode" value="${fieldValue(bean:custBillToAddr,field:'compCode')}"/>
		<input type="hidden"  name="orderNo"  value="${fieldValue(bean:custBillToAddr,field:'orderNo')}"/>
		<input type="hidden"  name="shipNo"   value="${fieldValue(bean:custBillToAddr,field:'shipNo')}"/>
		<div > 
			<dl class="wide">
				<dt>Bill-To Name:</dt>		<dd><input type="text" size="30" maxlength="30" id="name" name="name" value="${custBillToAddr.name?.encodeAsHTML()}"/></dd>
				<dt>Address Line 1:</dt>	<dd><input type="text" size="30" maxlength="30" id="addr1" name="addr1" value="${custBillToAddr.addr1?.encodeAsHTML()}"/> </dd>
				<dt>             2:</dt>	<dd><input type="text" size="30" maxlength="30" id="addr2" name="addr2" value="${custBillToAddr.addr2?.encodeAsHTML()}"/> </dd>
				<dt>City/State/Zip:</dt> 	<dd>
												<input type="text" maxlength="15" id="city" name="city" value="${custBillToAddr.city}"/> 
				                                <g:select name="state" from="${StateCode.list()}" optionKey="id" optionValue="name" value="${custBillToAddr.state}" noSelection="${['':'Select One...']}"/> 
   		                                    	<input type="text" size="9" maxlength="9" id="zipCode" name="zipCode" value="${(custBillToAddr.zipCode?.trim())}"/> 
   		                                    </dd>
			</dl>
		</div>
		<div class="buttons">
	      <g:if test="${!inquiry}">
            <g:submitButton class="save" name="update" value="Update"  title="Click to update this Customer Bill-To Address"/> 
           	<g:submitButton class="delete" name="delete" value="Delete"  title="Click to delete this Customer Bill-To Address"/>
          </g:if>
          <g:submitButton class="table" name="back" value="Back"  title="Click to return to the list of line items"/>
		</div>
	</g:form>
 </div>
 <pre style="color:green;">
 O99KBT                DROP SHIP BILL TO MAINTENANCE                  7/26/09
                                                                            
   Company:  01                                                             
   Order#:   326529  00                                                     
                                                                            
   Customer Number:                                                         
                                                                            
   Ship-to Name:                                                            
   Address Line 1:                                                          
   Address Line 2:                                                          
   City/State/Zip:                                                          
                                                                            
                                                                            
   Bill To Name:                                                            
   Address Line 1:                                                          
   Address Line 2:                                                          
   City/State/Zip:                                                          
                                                                            
   Delete (D):                                                              
                                                                            
Press Enter to Continue,  F12-Previous  
 </pre>
</body>
</html>