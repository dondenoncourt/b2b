<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <resource:autoComplete skin="default" />
      <gui:resources components="['dataTable']"/>
      <g:javascript src="application" />
  </head>
<body>
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
  <script>
	function onloadHandler() { // called in body of layout gsp
		$('itemMasterDataTableDiv').hide();
		$('ieWants2inputsSoThisIsFake').hide();
		<% if (inquiry) { %>
			disableFormFields('itemForm') ;
		<% } else { %>
			$('itemNo').focus();
		<% } %>
	}
	function itemSelect() {
        var formValues = $('itemForm').serialize();
        // strip off any g:submitButton event names as one is explicitly set   
        formValues = formValues.substr(0, formValues.lastIndexOf('&_eventId'));
        window.location='/${meta(name:'app.name')}/order/order?execution='+$('execution').value+'&_eventId_add=Add&'+formValues;
	}
	
  </script>
    <div class="body">
    	<h1>Order Item Selection</h1>
    	<br/>
        <div id="custDiv">
          <dl>
            <dt>Order No:</dt><dd>${ord.orderNo}</dd>
          </dl>
        </div>
        <g:if test="${error}"><div class="errors">${error}</div></g:if>
        <g:hasErrors bean="${ordItem}"><div class="errors"><g:renderErrors bean="${ordItem}" as="list" /></div></g:hasErrors>
		<g:form action="order" name="itemForm" method="post">
        
          <dl>
            <dt>Item Number:</dt>
            <dd>
            	<richui:autoComplete name="itemNo" action="${createLinkTo('dir': 'itemMaster/searchAJAX')}" 
					            	   size="15" maxLength="15" value="${ordItem?.itemNo}"
					            	   shadow="true" typeAhead="true" maxResultsDisplayed="25"
					            	   onItemSelect="itemSelect();"   
            	/>
            	<input type="text" id="ieWants2inputsSoThisIsFake" name="bogus"/>
            </dd>
            <dt>&nbsp;</dt>
            <dd id="itemDesc"></dd>
          </dl>
           <div class="buttons">
              <g:submitButton class="add" name="add" value="Add" title="Click to proceed to the item detail update panel"/>
			  <span class="menuButton">
	   			  <a href="#" id="showItemMasterDataTableDialog" class="search" title="Click to search for an item." 
	   			     onclick="$('itemMasterDataTableDialog').setStyle({left: '0em'});$('itemMasterDataTableDiv').show();"
	   			  >Search</a>
	   	      </span> 
              <g:submitButton class="table" name="back" value="Back" title="Click to return to the list of line items"/>
            </div>
        </g:form>
              <g:render template="itemMasterDataTableDialog"/>
     </div>
</body>
</html>
