<dl>
	<g:if test="${(orderTotalInfo.salesAmount != orderTotalInfo.netAmount)}">
		<dt>Total Sales: </dt>		<dd class="number"><g:formatNumber number="${orderTotalInfo.salesAmount}" format="\$#,###,##0.00" /></dd>
	</g:if>
	<g:else>
		<dt>&#160;</dt>				<dd>&#160;</dd>
	</g:else>
	<g:if test="${orderTotalInfo.miscAmount}">
		<dt>Total Misc:  </dt>		<dd class="number"><g:formatNumber number="${orderTotalInfo.miscAmount}" format="\$#,###,##0.00" /></dd>
	</g:if>
	<g:if test="${orderTotalInfo.discAllowAmount}">
		<dt>Total Disc/Allow:</dt>	<dd class="number"><g:formatNumber number="${orderTotalInfo.discAllowAmount}" format="\$#,###,##0.00" /></dd>
	</g:if>
	<g:if test="${orderTotalInfo.tax}">
		<dt>Total Tax:   </dt>		<dd class="number"><g:formatNumber number="${orderTotalInfo.tax}" format="\$#,###,##0.00" /></dd>
	</g:if>
	<dt>Total Order: </dt>			<dd class="number"><g:formatNumber number="${orderTotalInfo.netAmount}" format="\$#,###,##0.00" /></dd>
</dl>
