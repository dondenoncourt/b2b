<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.OrderDiscountAllowance" %>
<%@ page import="com.kettler.domain.orderentry.DiscountAllowanceCode" %>
<%@ page import="com.kettler.domain.item.ProfitCenter"%>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <g:javascript src="application" />
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		<% if (inquiry) { %>
			disableFormFields('discAllowForm') ;
		<% } %>
	}
  </script>
    <div class="body">
    	<h1>Discount Allowance</h1>
        <div id="custDiv">
          <dl>
            <dt>Company Code:</dt><dd>${ord.compCode}</dd>
            <dt>Customer No:</dt><dd>${ord.custNo}</dd>
            <dt>Order No:</dt><dd>${ord.orderNo}</dd>
          </dl>
            ${session.cust.addr1?.encodeAsHTML()}<br/>
            <g:if test="${session.cust.addr2?.encodeAsHTML()}">
                ${session.cust.addr2}<br/>
            </g:if>
            <g:if test="${session.cust.addr3?.encodeAsHTML()}">
                ${session.cust.addr3}<br/>
            </g:if>
            ${session.cust.city}, ${session.cust.state} ${session.cust.zipCode}
        </div>
        <br/>
		<h3>Discount Allowances</h3>
        <g:if test="${message}"><div class="message">${message}</div></g:if>
        <div id="discAllowDiv">
	        <g:form action="order" name="discAllowForm" method="post" >
	            <table>
	              <tbody>
	                <tr><th>Disc/Allow Code</th><th>Percent</th></tr>
	                <g:each var="discAllow" in="${ordDiscAllowList}">
	                  <tr>
		                 <td>${DiscountAllowanceCode.get(discAllow.code).desc}</td>
		                 <td class="number">${discAllow.percent}</td>
	                  </tr>
	                </g:each>
	              </tbody>
	            </table>
		        <div class="buttons">
	              <g:submitButton class="show" name="next" value="Next"  title="Click to proceed to the next panel"/>
	              <g:submitButton class="table" name="back" value="Back"  title="Click to return to the list of line items"/>
		        </div>
	        </g:form>
        </div>
     </div>
</body>
</html>
