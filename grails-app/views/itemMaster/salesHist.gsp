<%@ page import="com.kettler.domain.item.share.ItemMaster" %>
<%@ page import="com.kettler.domain.item.ItemSalesHist" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Item Sales History Inquiry</title>
  </head>
<body>
    <div>
    	<br/>
        <h1>Item Sales History</h1>
        <g:if test="${flash.message}"><div class="errors">${flash.message}</div></g:if>
        <g:form action="salesHist" method="post" >
			<g:hiddenField name="compCode"  value="${params.compCode}"/>
			<g:hiddenField name="itemNoForHist"  value="${params.itemNoForHist}"/>
			<dl>
			  <dt>Item:</dt> <dd>${params.itemNoForHist}: ${ItemMaster.findWhere(compCode:params.compCode, itemNo:params.itemNoForHist)?.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</dd>
			</dl>
        </g:form>
        <div class="linkButtons">
			<g:each var="year" in="${ (maxYear..minYear) }">
				<g:link class="button" action="salesHist" params="[compCode:params.compCode,itemNoForHist:params.itemNoForHist,year:year]">${year}</g:link>
			</g:each>
		</div>
		<div id="histDiv">
            <g:if test="${hist}">
	            <div class="list">
	               <h3>History for ${params.year}:</h3>
	                <table>
	                    <thead>
	                        <tr>
	                   	        <th>Month</th>
	                   	        <th>Times Sold</th>
	                   	        <th>Quantity Sold</th>
	                   	        <th>Sales Amount</th>
				   	        	<jsec:hasRole name="${Role.KETTLER}">
	                   	        	<th>Transfers to Stores</th>
	                   	        </jsec:hasRole>
	                        </tr>
	                    </thead>
	                    <tbody>
	                		<g:each var="i" in="${ (1..12) }">
		                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
									<td class="number"><g:message code="month.${i}" /></td>
									<td class="number"><%= (hist."timesSold${i}")[0]?:'' 	 %></td>
									<td class="number"><%= (hist."salesQty${i}")[0]?:''  %></td>
									<td class="number"><%= (hist."salesAmt${i}")[0]?:''  %></td>
				   	        	  <jsec:hasRole name="${Role.KETTLER}">
									<td class="number"><%= (hist."transferToStoreQty${i}")[0]?:'' %></td>
								  </jsec:hasRole>
		                        </tr>
		                    </g:each>
	                        <tr>
								<td class="number total">Total:</td>
								<td class="number total">${hist.totalTimesSold[0]?:''}</td>
								<td class="number total">${hist.totalSalesQty[0]?:''}</td>
								<td class="number total">${hist.totalSalesAmt[0]?:''}</td>
			   	        	  <jsec:hasRole name="${Role.KETTLER}">
								<td class="number total">${hist.totalTransferToStoreQty[0]?:''}</td>
							  </jsec:hasRole>
	                        </tr>
	                    </tbody>
	                </table>
		        </div>
            </g:if>
	        <g:form action="item" method="post" >
				<g:hiddenField name="compCode"  value="${params.compCode}"/>
				<g:hiddenField name="itemNoForHist"  value="${params.itemNoForHist}"/>
				<div class="buttons">
				   <g:submitButton class="show" name="item" value="Back" title="Click to go back to the item master inquiry page"/>
				</div>
			</g:form>
		</div>
     </div>
</body>
</html>
