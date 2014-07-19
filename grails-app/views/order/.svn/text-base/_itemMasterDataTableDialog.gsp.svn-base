<gui:dialog
        id="itemMasterDataTableDialog"
        title="Select Item"
        draggable="true"
        modal="true"
        controller="order"
        triggers="[show:[id:'showItemMasterDataTableDialog', on:'click']]">

		<dl>
			<dt>Item Name or Desc:</dt>
			<dd><input type="text" size="15" maxlength="15" name="desc" id="desc" /></dd>
			<dt>UPC:</dt>
			<dd><input type="text" size="12" maxlength="12" name="upc" id="upc" onkeypress="checkNumeric(event);" /></dd>
			<dt>European Article No:</dt>
			<dd><input type="text" size="13" maxlength="13" name="euroArticleNo" id="euroArticleNo" onkeypress="checkNumeric(event);"/></dd>
			<%-- 
			<dt>Query Type:</dt>
			<dd>And <input name="andor" checked="checked" value="and" id="andorand" type="radio">Or<input name="andor" value="or" id="andoror" type="radio"> </dd>
			--%>
			<dt>&nbsp;</dt><dd><input type="button" class="buttons" onclick="ajaxItemMasterLookup();return false;" value="Search"/></dd>
			
		</dl>

<g:javascript>
   function showSpinner(visible) { $('spinner').style.display = visible ? "inline" : "none"; }
	function ajaxItemMasterLookup() {
		new Ajax.Updater('itemMasterDataTableDiv','${createLink(controller:'order',action:'itemMasterSearchforDataTable')}',
				{asynchronous:true,evalScripts:true,
					parameters:'&desc='+$('desc').value+
								'&upc='+$('upc').value+
								'&euroArticleNo='+$('euroArticleNo').value
				}
		);
		return false;
	}
</g:javascript>

	<div class="yui-skin-sam" id="itemMasterDataTableDiv">
		<g:render template="/order/itemMasterDataTable"/>
	</div>
</gui:dialog>