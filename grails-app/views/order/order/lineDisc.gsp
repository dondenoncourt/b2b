<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.CustDiscAllow" %>
<%@ page import="com.kettler.domain.orderentry.DiscountAllowanceCode" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>

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
			disableFormFields('lineDiscForm') ;
		<% } %>
		<jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP_ADMIN,Role.REP,Role.CUSTOMER,Role.CUST_ADMIN]}">
			disableFormFields('lineDiscForm') ;
		</jsec:hasAnyRole>
	}
  </script>
    <div class="body">
        <div id="custDiv">
          <dl>
            <dt>Company Code:</dt><dd>${ord.compCode}</dd>
            <dt>Customer No:</dt><dd>${ord.custNo}</dd>
            <dt>Order No:</dt><dd>${ord.orderNo}</dd>
          </dl>
	            ${session.cust.addr1?.encodeAsHTML()}<br/>
            <g:if test="${session.cust.addr2}">
                ${session.cust.addr2?.encodeAsHTML()}<br/>
            </g:if>
            <g:if test="${session.cust.addr3}">
                ${session.cust.addr3?.encodeAsHTML()}<br/>
            </g:if>
            ${session.cust.city}, ${session.cust.state} ${session.cust.zipCode}
        </div>
		<br/>
		<h3>Line Discounts</h3>
        <g:if test="${message}"><div class="message">${message}</div></g:if>
        <g:hasErrors bean="${ord}"><div class="errors"><g:renderErrors bean="${ord}" as="list" /></div></g:hasErrors>
	
        <div id="lineDiscDiv">
	        <g:form action="order" name="lineDiscForm" method="post" >
	        
	            <table>
	              <tbody>
	                <tr><th>Profit Center</th><th>Percent</th></tr>
	                    <jsec:hasRole name="${Role.KETTLER}">       
		                  <tr>
		                  	<td><g:select name="profitCenter1" from="${ProfitCenter.list()}" optionKey="id" optionValue="desc" value="${ord.profitCenter1}" noSelection="${['':'Select one: ...']}" /></td>
		                  	<td class="number"><g:textField name="lineDisc1" value="${ord.lineDisc1}" size="5" class="number"/></td>
		                  </tr>
		                  <tr>
		                  	<td><g:select name="profitCenter2" from="${ProfitCenter.list()}" optionKey="id" optionValue="desc" value="${ord.profitCenter2}" noSelection="${['':'Select one: ...']}" /></td>
		                  	<td class="number"><g:textField name="lineDisc2" value="${ord.lineDisc2}" size="5" class="number"/></td>
		                  </tr>
		                  <tr>
		                  	<td><g:select name="profitCenter3" from="${ProfitCenter.list()}" optionKey="id" optionValue="desc" value="${ord.profitCenter3}" noSelection="${['':'Select one: ...']}" /></td>
		                  	<td class="number"><g:textField name="lineDisc3" value="${ord.lineDisc3}" size="5" class="number"/></td>
		                  </tr>
		                  <tr>
		                  	<td><g:select name="profitCenter4" from="${ProfitCenter.list()}" optionKey="id" optionValue="desc" value="${ord.profitCenter4}" noSelection="${['':'Select one: ...']}" /></td>
		                  	<td class="number"><g:textField name="lineDisc4" value="${ord.lineDisc4}" size="5" class="number"/></td>
		                  </tr>
		                  <tr>
		                  	<td><g:select name="profitCenter5" from="${ProfitCenter.list()}" optionKey="id" optionValue="desc" value="${ord.profitCenter5}" noSelection="${['':'Select one: ...']}" /></td>
		                  	<td class="number"><g:textField name="lineDisc5" value="${ord.lineDisc5}" size="5" class="number"/></td>
		                  </tr>
		                </jsec:hasRole>
        	        	<jsec:hasAnyRole in="${[Role.CUSTOMER, Role.REP_PLUS, Role.REP, Role.CUST_ADMIN, Role.REP_ADMIN]}">          
 				            <g:each var="i" in="${ (1..5) }">
			           		   <% if (ord."lineDisc${i}") { %>
				                   <tr>
						                <td><%=  ProfitCenter.get(ord."profitCenter${i}").desc %></td>
						                <td class="number"><%=  ord."lineDisc${i}" %></td>
				                   </tr>
			                   <% } %>
				             </g:each>
		                </jsec:hasAnyRole>
	              </tbody>
	            </table>
	            
		        <div class="buttons">
			      <g:if test="${!inquiry}">
			          <g:submitButton class="save" name="next" value="Next"  title="Click to update this Line Discount and proceed to the next input panel"/>
			      </g:if>
			      <g:else>
			          <g:submitButton class="show" name="next" value="Next"  title="Click to proceed to the next panel"/>
			      </g:else>
		          <g:submitButton class="table" name="back" value="Back"  title="Click to return to the list of line items"/>
		        </div>
	        </g:form>
        </div>
     </div>
</body>
</html>
