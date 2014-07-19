<g:form action="returns" method="post" >
    <g:if test="${list?.size() > 0}">
    	<table style="width:100%;">
    		<tbody>
				<tr><th>Item No</th><th>Ship No</th><th>Ship Qty</th><th>Unit Price</th><th>Description</th></tr>
           		<g:each var="item" status="i" in="${list}">
	           		<tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="selectRow${i}">
						<td>
						   <a href="javascript:selectItem($('selectRow${i}'), '${item.orderNo}', '${item.shipNo}', '${item.itemNo.encodeAsHTML()}', '${item.desc.encodeAsHTML().replaceAll(/'/, '')}', '${item.shipQty}', '${item.unitPrice}');" 
						       title="Click to add to the return request">
						     ${item.itemNo.encodeAsHTML()}
						    </a>
						 </td>
                        <td class="number">${item.shipNo}</td>
						<td class="number">${item.shipQty}</td>
						<td class="number">${item.unitPrice}</td>
						<td>${item.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
					</tr>
				</g:each>
			</tbody>
		</table>
	</g:if>
	<g:else>
	   <p>Order not found</p>
	</g:else>
</g:form>
						