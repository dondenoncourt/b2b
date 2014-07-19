<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.ShipTo" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesTax" %>
<%@ page import="com.kettler.domain.orderentry.StateCode" %>

<%@ page import="com.kettler.domain.varsity.Country" %>
<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
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
	function checkNumeric(e) {   
		var key  
		var shiftKey   
		if (window.event) {     
			key = event.keyCode   
		} else {     
			key = e.which
		}
		// Was key that was pressed a numeric character (0-9) or backspace (8)?   
		if ((key > 47 && key < 58) || key == 8 || key == 9 || key == 18 || key == 0 || key == 13) {     
			return; // if so, do nothing   
		} else {// otherwise, discard character  
			alert('Please key numerics only for this field.'+key);   
			if (window.event) { //IE       
				window.event.returnValue = null;     
			} else {//Firefox       
				e.preventDefault();
			}
		} 
	} 	
	
  </script>
    <div class="body">
	<h1>Create Ship-To</h1>
	<g:if test="${message}"><div class="message">${message}</div></g:if>
    <g:hasErrors bean="${shipTo}"><div class="errors"><g:renderErrors bean="${shipTo}" as="list" /></div></g:hasErrors>
	<g:form action="order" name="shipToForm" method="post" >
		<input type="hidden"text" name="compCode" value="${fieldValue(bean:shipTo,field:'compCode')}"/>
		<input type="hidden"" name="custNo" value="${fieldValue(bean:shipTo,field:'custNo')}"/>
		<input type="hidden" name="orderNo" value="${fieldValue(bean:shipTo,field:'orderNo')}"/>
    	<input type="hidden" name="countryName" id="countryName" readonly="readonly" value="${shipTo?.countryName}" /> 
		<div > 
			<dl class="full">
          	    <jsec:hasRole name="${Role.KETTLER}">
					<dt>Company Code:</dt>	<dd>${fieldValue(bean:shipTo,field:'compCode')} </dd>
					<g:if test="${shipTo.shipToNo == 9999}">
					  <dt>Order No:</dt><dd><dd>${shipTo.orderNo}</dd>
					</g:if>
				</jsec:hasRole>
				<dt>Customer No:</dt>		<dd>${fieldValue(bean:shipTo,field:'custNo')} </dd>
          	    <jsec:hasRole name="${Role.KETTLER}">
					<dt>Ship-To No:</dt>		
						<g:if test="${shipTo.shipToNo != 9999}">
											<dd><input type="text" id="shipToNo" name="shipToNo" size="4" maxLength="4" value="${fieldValue(bean:shipTo,field:'shipToNo')}" /> </dd>
						</g:if>
						<g:else>
											<dd>
											    ${shipTo.shipToNo}
												<input type="hidden" id="shipToNo" name="shipToNo" value="${fieldValue(bean:shipTo,field:'shipToNo')}" />
												<input type="hidden" name="dropShip" value="true"/>
											</dd>
						</g:else>
				</jsec:hasRole>
				<dt>Country Code:</dt>		<dd><g:select name="countryCode" from="${Country.listUsaCanFirst()}" optionKey="isoCode" optionValue="desc"  value="${shipTo?.countryCode}"  onchange="selectCountry();" style="display:inline;"/></dd>
			</dl>	
				<div class="full" id="addressDiv">
					<g:render template="/common/address" model="['objWithAddr':shipTo]"/>
				</div>
			<dl class="full">
				<dt>Phone No:</dt>			<dd><input type="text" size="10" maxlength="10" id="phoneNo" name="phoneNo" onkeypress="checkNumeric(event);" value="${fieldValue(bean:shipTo,field:'phoneNo')}"/> </dd>
				<dt>Fax No:</dt>			<dd><input type="text" size="10" maxlength="10" id="faxNo" name="faxNo"     onkeypress="checkNumeric(event);" value="${fieldValue(bean:shipTo,field:'faxNo')}"/> </dd>
				<dt>Contact Person:</dt>	<dd><input type="text" maxlength="20" id="contactPerson" name="contactPerson" value="${fieldValue(bean:shipTo,field:'contactPerson')}"/> </dd>
				<% if (ord.shipInstructions) { %>
												<input type="hidden" name="residentialCommercial" value="${ord.shipInstructions[0]}"/>
				<% } else { %>
					<dt>Location:</dt>		<dd><g:select name="residentialCommercial" from="${shipTo.constraints.residentialCommercial.inList}" valueMessagePrefix="shipTo.resi.comm" value="${shipTo.residentialCommercial}" ></g:select></dd>
				<% } %>
			</dl>
		</div>
		<div class="buttons">
              <g:submitButton class="add" name="create" value="Create" title="Click to add this Ship-To" />
              <g:submitButton class="table" name="back" value="Back" title="Click to return to the shipping information page" />
		</div>
	</g:form>
 </div>
</body>
</html>