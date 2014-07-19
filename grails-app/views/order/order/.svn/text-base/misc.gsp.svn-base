<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.PrintCode" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesTax" %>

<%@ page import="com.kettler.domain.actrcv.share.TableCode" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Misc Information</title>
      <gui:resources components="['dataTable']"/>
      <g:javascript src="application" />
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		<% if (inquiry) { %>
			disableFormFields('miscForm') ;
		<% } %>
	}
  </script>
    <div class="body">
    	<h1>Order Miscellaneous Charges <%= inquiry?'Inquiry':'Maintenance' %></h1>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <g:hasErrors bean="${misc}"><div class="errors"><g:renderErrors bean="${misc}" as="list" /></div></g:hasErrors>
        <g:form action="order" name="miscForm" method="post" >
          <input type="hidden" name="lineNo" value="${g.formatNumber(number:misc?.lineNo, format:'0000')}"/>
          <dl class="wide">
              <dt>Description</dt><dd><g:textField name="desc" value="${misc?.desc?.encodeAsHTML()}"/></dd>
              <dt>Amount</dt><dd><g:textField name="amount" value="${misc?.amount}"/></dd>
              <dt>Distribution Code</dt>
                <dd>
					UPS: <g:radio name="distrCode" value="UPS" checked="true"/>
					FRT: <g:radio name="distrCode" value="FRT"/>
					HDL: <g:radio name="distrCode" value="HDL"/>
                </dd>
              <dt>Print Code</dt>
                <dd>
                  <g:select name="printCode" from="${PrintCode.list()}" optionKey="id" optionValue="desc" value="${(misc?.printCode ?:'I')}" />
                </dd>
             <jsec:hasRole name="${Role.KETTLER}">
                
	            <g:if test="${(ord.taxCode1)}">
		            <dt>${(SalesTax.get(ord.taxCode1)?.desc.trim())}:</dt>  
	                                        <dd><g:checkBox  name="subjToTax1"    value="${misc?.subjToTax1}" checked="${misc?.subjToTax1}" /></dd>
	            </g:if>
	            <g:if test="${(ord.taxCode2)}">
		            <dt>${(SalesTax.get(ord.taxCode2)?.desc.trim())}:</dt>  
	                                        <dd><g:checkBox  name="subjToTax2"    value="${misc?.subjToTax2}" checked="${misc?.subjToTax2}"/></dd>
	            </g:if>
	            <g:if test="${(ord.taxCode3)}">
	            	<dt>${(SalesTax.get(ord.taxCode3)?.desc.trim())}:</dt>  
	                                        <dd><g:checkBox  name="subjToTax3"    value="${misc?.subjToTax3}" checked="${misc?.subjToTax3}"/></dd>
	            </g:if>
	          </jsec:hasRole>
          </dl>
            <div class="buttons">
		      <g:if test="${!inquiry}">
	              <g:if test="${misc?.lineNo}">
	                <g:submitButton class="save" name="update" value="Update"  title="Click to update this miscellaneous charge" />
	                <g:submitButton class="delete" name="delete" value="Delete"  title="Click to delete this miscellaneous charge"/>
	              </g:if>
	              <g:else>
	                <g:submitButton class="add" name="add" value="Add" title="Click to add this miscellaneous charge" />
	              </g:else>
	          </g:if>
              <g:submitButton class="table" name="back" value="Back" title="Click to return to the list of line items" />
            </div>
        </g:form>
    </div>
</body>
</html>
