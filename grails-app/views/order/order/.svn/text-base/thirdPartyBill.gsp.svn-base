<%@ page import="com.kettler.domain.orderentry.Order3rdPartyBill" %>
<%@ page import="com.kettler.domain.orderentry.StateCode" %>
<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>

<%@ page import="com.kettler.domain.varsity.Country" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>3rd Party Bill-To Address</title>
      <g:javascript library="prototype" />
      <g:javascript src="application" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		<% if (inquiry) { %>
			disableFormFields('thirdPartyBillForm') ;
		<% } %>
	}
	function selectCountry() {
		var idx = $('countryCode').selectedIndex;
		var options = $('countryCode').options;
		$('countryName').value = options[idx].text;
		// reformat address input 
        var params =   'countryCode='+options[idx].value+
		               '&name='+$('name').value+
		               '&addr1='+$('addr1').value+
		               '&addr2='+$('addr2').value+
		               '&addr3='+$('addr3').value+
		               '&city='+$('city').value+
		               '&state='+$('state').value+
		               '&zipCode='+$('zipCode').value;
        new Ajax.Request('${resource(dir:'order')}/address', {
          method: 'get',
          parameters: params,
          onSuccess: function(transport) {
            $('addressDiv').innerHTML = transport.responseText;
          }
        });		
	}
  </script>
    <div class="body">
	<h1>3rd Party Bill-To Address <%= inquiry?'Inquiry':'Maintenance' %></h1>
	<g:if test="${message}"><div class="errors">${message}</div></g:if>
    <g:hasErrors bean="${thirdPartyBill}"><div class="errors"><g:renderErrors bean="${thirdPartyBill}" as="list" /></div></g:hasErrors>
	<g:form action="order" name="thirdPartyBillForm" method="post" >
		<input type="hidden"  name="compCode" value="${fieldValue(bean:thirdPartyBill,field:'compCode')}"/>
		<% if (thirdPartyBill.class.name == Order3rdPartyBill.name) { %>
			<input type="hidden"  name="orderNo"  value="${(thirdPartyBill?.orderNo)}"/>
			<input type="hidden"  name="shipNo"   value="${fieldValue(bean:thirdPartyBill,field:'shipNo')}"/>
		<% } %>
		<input type="hidden"  name="countryName" id="countryName" value="${thirdPartyBill?.countryName}" /> 
		<div > 
			<dl>
			<dt>Country Code:</dt>		<dd>
			                                <g:select name="countryCode" from="${Country.listUsaCanFirst()}" optionKey="isoCode" optionValue="desc"  value="${thirdPartyBill.countryCode}"
			                                	 noSelection="${['':'Select One...']}"
			                                    onchange="selectCountry();"/>
			                            </dd>
			</dl>
			<div id="addressDiv">
				<g:render template="/common/address" model="['objWithAddr':thirdPartyBill]"/>
			</div>
			<dl>
				<dt>Account No:</dt>				<dd><input type="text" size="30" maxlength="30" id="acctNo" name="acctNo" value="${thirdPartyBill.acctNo}"/> </dd>
				<% if (thirdPartyBill.class.name == Order3rdPartyBill.name) { %>
					<dt>Set as default:</dt>		<dd><g:checkBox name="makeCust3rdPartyBill" value="${thirdPartyBill.makeCust3rdPartyBill}"/></dd>
				<% } else { %>
					<dt>This order only:</dt>		<dd><g:checkBox name="makeOrder3rdPartyBill" value="${thirdPartyBill.makeOrder3rdPartyBill}"/></dd>
				<% } %>
			</dl>
			
		<dl>
			</dl>
		</div>
		<div class="buttons">
 	      <g:if test="${inquiry}">
   	        <g:submitButton class="save" name="next" value="Next" title="Click to proceed to the next input panel"/>
   	      </g:if>
   	      <g:else> 
    	     <g:submitButton class="save" name="next" value="Next"  
        	    	title="Click to update this 3rd Party Bill-To Address and process to the next input panel"/>
             <g:submitButton class="table" name="back" value="Back"  
                  title="Click to return to the Shipping Informaton page. Note, however, that this page will continue to display if Shipping Terms is set to THIRD PARTY"/>
          </g:else> 
		</div>
	</g:form>
 </div>
</body>
</html>
