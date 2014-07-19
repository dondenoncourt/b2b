<g:javascript>
   function showSpinner(visible) { $('spinner').style.display = visible ? "inline" : "none"; }
    function ajaxItemMasterLookup() {
        new Ajax.Updater('custDataTableDiv','${createLink(controller:'order',action:'custSearchforDataTable')}',
                {asynchronous:true,evalScripts:true,
                    parameters:'&nameSearch='+$('nameSearch').value
                }
        );
        return false;
    }
</g:javascript>

<gui:dialog
        id="custDataTableDialog"
        title="Select Customer"
        draggable="true"
        modal="true"
        controller="order"
        triggers="[show:[id:'showCustDataTableDialog', on:'click']]">
	Customer short name:
	<input type="text" name="nameSearch" id="nameSearch" />
	<input type="button" class="buttons" 
		onclick="ajaxItemMasterLookup();" 
		value="Search"/>
	<div id="custDataTableDiv">
		<g:render template="/order/custDataTable"/>
	</div>
</gui:dialog>
