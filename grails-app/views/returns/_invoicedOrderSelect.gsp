<%-- ajax support in pagination from http://dahernan.net/2008/02/grails-hacking-paginate-tag-to-make.html --%>
<g:javascript>
	function clickPaginate(event){
		event.stop();
		var link = event.element();
		if(link.href == null){
    		return;
		}
		new Ajax.Updater({ success: $('invoicedOrderSelectDiv') },link.href, {evalScripts: true} );
	}
</g:javascript>
<g:form action="returns" method="post" >
    <dl>
        <dt>PO No:</dt><dd><g:textField name="poNo"/></dd>
        <dt>Freight Tracking No:</dt><dd><g:textField name="fghtTrkNo"/></dd>
    </dl>
    <div class="buttons">
        <input type="button" class="show" onclick="ajaxInvoicedOrderSelect($('poNo').value, $('fghtTrkNo').value);" value="Search" />
    </div>
    <g:if test="${list?.size() > 0}">
    	<table style="width:100%;">
    		<tbody>
				<tr><th>Order No</th><th>Order Date</th><th>PO No</th><th>Freight Tracking No</th></tr>
           		<g:each var="order" status="i" in="${list}">
	           		<tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="selectRow${i}">
						<td>
							<a href='#' onclick="$('orderNo').value='${order.orderNo}';$('invoicedOrderSelectDiv').hide();ajaxInvoicedItemLookup();return false;">
							${order.orderNo} 
						    </a>
						 </td>
						<td><g:formatDate date="${order.orderDate}" format="MM/dd/yy"/></td>
                        <td>${order.poNo}</td>
                        <td>${order.freightTrackingNo}</td>
					</tr>
				</g:each>
			</tbody>
		</table>
	</g:if>
</g:form>
<div class="paginateButtons">
    <g:paginate total="${count?:0}" params="${params}"/>
    <kettler:observe classes="${['step','prevLink','nextLink']}" event="click" function="clickPaginate"/>   
</div>
