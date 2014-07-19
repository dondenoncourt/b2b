<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<div id="staticOrdDiv">
    <div id="custDiv" class="col1">
      <dl>
		<jsec:hasRole name="${Role.KETTLER}">
	        <dt>Company Code:</dt>	<dd>${ord.compCode}</dd>
	    </jsec:hasRole>
        <dt>Customer No:</dt>		<dd>${ord.custNo}</dd>
        <dt>Order No:</dt>			<dd>${ord.orderNo}</dd>
      </dl>
		<h3>Customer Address</h3>
        ${session.cust.name.encodeAsHTML()}<br/>
        ${session.cust.addr1.encodeAsHTML()}<br/>
        <g:if test="${session.cust.addr2}">
            ${session.cust.addr2.encodeAsHTML()}<br/>
        </g:if>
        <g:if test="${session.cust.addr3}">
            ${session.cust.addr3.encodeAsHTML()}<br/>
        </g:if>
        ${session.cust.city}, ${session.cust.state} ${session.cust.zipCode}
    </div>
    <div id="shipToDiv" class="col2">
    	<g:if test="${ord.shipToNo}">
	        <dl>
	          <dt>Ship-To No:</dt>		<dd>${(ord.shipToNo?:'&#160;')}</dd>
	          <dt>Country:</dt>			<dd>${(shipTo?.countryCode)?:'&#160;'}</dd>
	          <dt>Phone No:</dt>			<dd>${(shipTo?.phoneNo)?:'&#160;'}&#160;</dd>
	        </dl>
			<span class="resicomm"><kettler:message prefix="shipTo.resi.comm" key="${shipTo?.residentialCommercial}"/></span><br/>
		</g:if>
		<g:else>
			<br/><br/><br/><br/><h3>Ship-To Address</h3><br/>
		</g:else>
		<g:if test="${shipTo}">
	        ${shipTo?.name.encodeAsHTML()}<br/>
	        ${shipTo?.addr1.encodeAsHTML()}<br/>
	        <g:if test="${shipTo?.addr2?.trim().encodeAsHTML()}">
	            ${shipTo?.addr2}<br/>
	        </g:if>
	        <g:if test="${shipTo?.addr3?.trim().encodeAsHTML()}">
	            ${shipTo?.addr3}<br/>
	        </g:if>
	        ${shipTo?.city}, ${shipTo?.state} ${shipTo?.zipCode}<br/>
        </g:if>
        <g:else>
        	Same<br/><br/><br/><br/><br/>
        </g:else>
    </div>
</div>
