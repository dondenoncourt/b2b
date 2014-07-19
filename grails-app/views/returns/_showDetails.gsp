<%@ page import="com.kettler.domain.actrcv.share.Return" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnItem" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnReason" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnNote" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnFreightDesc" %>

<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>

<g:if test="${flash.message}">
<div class="message">${flash.message}</div>
</g:if>
<div class="logo">
    <img alt="KETTLER, Inc." src="${createLinkTo(dir:'images',file:'kettler_logo.gif')}"/>
    <h2>KETTLER Int'l., Inc.</h2>
    <ul>
        <li>1355 London Bridge Road,</li>
        <li>Virginia Beach, VA 23453 USA</li>
        <li>Phone: (757) 427-2400</li>
        <li>Fax:   (757) 427-0183</li>
        <li>www.KETTLERUSA.com</li>
        <li>eMail: info@.KETTLERUSA.com</li>
    </ul>
</div>
<h1 class="raReport">Return Authorization</h1>
<dl class="pdf" id="raId">
    <dt>RA Number:</dt>           <dd>${ra.id}</dd>
</dl>
<div class="col1">
    <dl class="notPdf">
        <dt>RA Number:</dt>           <dd>${ra.id}</dd>
        <dt>Status:</dt>              <dd>${ra.status?.id}</dd>
        <dt>Tracking No:</dt>         <dd>${ra.freightTrackingNo}&#160;</dd>
        <dt>Create User:</dt>         <dd>${ra.createUser?.encodeAsHTML()}&#160;</dd>
    </dl>
    <dl>
        <dt>Customer No:</dt>         <dd>${ra.customer.compCode}:${ra.customer.custNo}&#160;</dd>
        <dt>     Name:</dt>           <dd>${ra.customer.name?.encodeAsHTML()?.replaceAll(/&amp;/,'&#38;')}&#160;</dd>
        <dt>  Address:</dt>           <dd>${ra.customer.addr1?.encodeAsHTML()}&#160;</dd>
        <dt>     &#160;</dt>          <dd>${ra.customer.addr2?.encodeAsHTML()}&#160;</dd>
        <% if (ra.customer.addr3) { %>
            <dt>     &#160;</dt>      <dd>${ra.customer.addr3?.encodeAsHTML()}&#160;</dd>
        <% } %>
        <dt>     &#160;</dt>          <dd>${ra.customer.city}, ${ra.customer.state} ${ra.customer.zipCode}</dd>
    </dl>
</div>
<div class="col2">
    <dl class="notPdf">
        <dt>Ship/Hand Cr:</dt>        <dd><g:formatNumber number="${ra.shipHandCustCr}" format="\$#,###,##0.00" />&#160;${ReturnFreightDesc.get(ra.shipHandDesc?.id).descr}</dd> 
        <dt>Freight:</dt>             <dd><g:formatNumber number="${ra.freightCustCr}" format="\$#,###,##0.00" />&#160;${ReturnFreightDesc.get(ra.freightDesc?.id).descr}</dd>
        <dt>Refurb/Restock:</dt>      <dd>${ra.refurbRestockCustDb}%&#160;</dd>
        <dt>Freight In:</dt>          <dd><g:formatNumber number="${ra.freightInCustDb}" format="\$#,###,##0.00" />&#160;</dd>
        <dt>Debit Mfg:</dt>           <dd>${(ra.manufacturerDb?'Yes':'No')}&#160;</dd>
        <dt>Return Date:</dt>         <dd><g:formatDate date="${ra.returnDate}" format="MM/dd/yyyy"/>&#160;</dd>             
        <dt>Last Change:</dt>         <dd><g:formatDate date="${ra.changeDate}" format="MM/dd/yyyy"/>&#160;${ra.changeUser}</dd>
    </dl>
    <dl>
        <dt>Date:</dt>                <dd><g:formatDate date="${ra.createDate}" format="MM/dd/yyyy"/> </dd>             
        <dt>Carrier:</dt>             <dd>${Carrier.get(ra.carrier?.id)?.desc}&#160; </dd>
        <dt>Shipping Method:</dt>     <dd>${ra.shipVia?.id}&#160; </dd> 
        <dt>Shipping Terms:</dt>      <dd>${Return.SHIPPING_TERMS_MAP[ra.shippingTerms]}&#160;</dd>
        <dt>Field Destroy:</dt>       <dd>${(ra.fieldDestroy?'Yes':'No')}&#160; </dd>
    </dl>
</div>
<% if (ra.freightClaim) { %>
    <div class="full">
    <h3>Freight Claim:</h3>
    <div class="col1">
        <dl>
            <dt>Freight Claim No:</dt><dd>${ra.freightClaimNo}</dd>
            <dt>Submit Date:</dt>     <dd><g:formatDate date="${ra.freightClaimSubmit}" format="MM/dd/yyyy"/>&#160;</dd>
            <dt>Claim Amount:</dt>    <dd><g:formatNumber number="${ra.freightClaimAmount}" format="\$#,###,##0.00" /></dd>
        </dl>
    </div>
    <div class="col2">
        <dl>
            <dt>Paid:</dt>	          <dd><g:formatDate date="${ra.freightClaimPaid}" format="MM/dd/yyyy"/>&#160;</dd>
            <dt>Check No:</dt>        <dd>${ra.freightClaimCheckNo}&#160;</dd>
            <dt>GL Code:</dt>         <dd>${ra.freightClaimGLCode}&#160;</dd>
        </dl>
    </div>
     </div>
<% } %>

<% if (ra.notes?.find{it.showOnPdf}) { %>
    <div class="full">
        <h3>Notes:</h3>
        <table class="wide">
           <tbody id="returnNotes">
                <tr>
                   <th>Note</th>
                   <th class="width15">Creator</th>
                </tr>
                <g:each var="note" status="i" in="${ra.notes?.findAll{it.showOnPdf}.sort {it.id} }">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" >
                        <td class="comment ">${note.note?.encodeAsHTML()}</td>
                        <td>${note.user}</td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </div>
<% } %>
<br/>
<div class="full">
    <h3>Return Items:</h3>
    <table class="wide">
       <tbody id="returnItems">
            <tr>
               <th>Item</th>
               <th>Description</th>
               <th class="width8">Unit Price</th>
               <th>Return Reason</th>
               <th class="width8">Authorized Qty</th>
            </tr>
            <g:each var="item" status="i" in="${ra.items}">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" >
                    <td>${item.itemNo}</td>
                    <td>${item.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
                    <td class="number">${item.unitPrice}</td>
                    <td>${(item.reason?.id?ReturnReason.get(item.reason?.id):'&#160;')}</td>
                    <td class="number">${item.authQty}</td>
                </tr>
            </g:each>
       </tbody>
    </table>
</div>
<div id="legal" class="pdf full">
	<h5>${"TERMS & CONDITIONS".encodeAsHTML()}:</h5>
	<ul>
		<li>There is a 20% restocking fee for all returns unless return is due to a un-repairable defect or KETTLER error.</li>
		<li>Call Tags and KETTLER approved freight will only be issued for shipping damage by a KETTLER (prepaid) carrier or defective items. UPS makes 3 Pick-up attempts for Call Tags. If the item is not given to UPS after the third attempt; the Call Tag is cancelled and a $25.00 cancellation fee will apply.</li>
		<li>Keep a record of the tracking for all shippments.</li>
		<li>Item must be returned in new, re-sellable condition in order to receive credit. Customer is responsible to adequately repack the items for return shipment. Any damage on the return shipment may result in no credit being given.</li>
		<li>Any item that has obvious signs of use will result in a reduced credit or no credit. If the item is determined upon inspectioin not to be damaged by a KETTLER (prepaid) carrier or defective, a reduced credit or no credit will result. </li>
		<li>RA numbers expire if not returned within 30 days of issue day. The RA number must be listed on the packing slip and packaging.</li>
	</ul>
</div>