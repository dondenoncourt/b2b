<gui:dialog
        id="itemMasterDataTableDialog"
        title="Select Item"
        draggable="true"
        modal="true"
        controller="order"
        triggers="[show:[id:'showItemMasterDataTableDialog', on:'click']]">

		<dl>
			<dt>Item Short Name:</dt>
			<dd><input type="text" size="10" maxlength="10" name="shortName" id="shortName" /></dd>
			<dt>Item Description</dt>
			<dd><input type="text" size="15" maxlength="15" name="desc" id="desc" /></dd>
			<dt>UPC:</dt>
			<dd><input type="text" size="12" maxlength="12" name="upc" id="upc" /></dd>
			<dt>European Article No:</dt>
			<dd><input type="text" size="13" maxlength="13" name="euroArticleNo" id="euroArticleNo" /></dd>
			<dt>Query Type:</dt>
			<dd>And <input name="andor" checked="checked" value="and" id="andorand" type="radio">Or<input name="andor" value="or" id="andoror" type="radio"> </dd>
			<dt>&nbsp;</dt><dd>&nbsp;</dd>
			<dt><a href="#" class="button" onclick="ajaxItemMasterLookup();">Search</a></dt><dd>&nbsp;</dd>
			
		</dl>
<g:javascript>
   function showSpinner(visible) { $('spinner').style.display = visible ? "inline" : "none"; }
	function ajaxItemMasterLookup() {
		var andor = 'and';
		if ($('andoror').checked) {
			andor = 'or';
		}
		new Ajax.Updater('itemMasterDataTableDiv','order/itemMasterSearchforDataTable',
				{asynchronous:true,evalScripts:true,
					parameters:'shortName='+$('shortName').value+
								'&desc='+$('desc').value+
								'&upc='+$('upc').value+
								'&euroArticleNo='+$('euroArticleNo').value+
								'&andor='+andor
				}
		);
		return false;
	}
</g:javascript>

	<div class="yui-skin-sam" id="itemMasterDataTableDiv">
		<g:render template="itemMasterDataTable"/>
	</div>
</gui:dialog>