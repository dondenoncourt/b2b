<g:each in="${items}" var="item">
	<li class="closed expandable" id="item_${item.id}LI">
		<div class="hitarea closed-hitarea expandable-hitarea"  > </div>
		<span class="folder" > ${item.itemNo} : ${item.desc} </span>
		<div id="item${item.id}" class="itemList"></div>
	</li>
	<g:javascript>
		$('#item_${item.id}LI.expandable > span, #item_${item.id}LI.expandable > div.hitarea').click(function() {
		      getItems(${item.id}); $(this).parent().removeClass('expandable');
		});
	</g:javascript>
</g:each> 