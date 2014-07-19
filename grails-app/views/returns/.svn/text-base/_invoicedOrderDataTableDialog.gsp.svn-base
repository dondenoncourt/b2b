<gui:dialog
        id="invoicedOrderDataTableDialog"
        title="Select Invoiced Order"
        draggable="true"
        modal="true"
        controller="returns"
        triggers="[show:[id:'showInvoicedOrderDataTableDialog', on:'click']]">
	Cust No:
	<g:textField name="custNo"/>
	<input type="button" class="buttons" 
		onclick="new Ajax.Updater('invoicedOrderDataTableDiv','invoicedOrderSearchforDataTable',{asynchronous:true,evalScripts:true,parameters:'custNo='+$('custNo').value});return false;" 
		value="Search"/>
	<div id="invoicedOrderDataTableDiv">
		<g:render template="invoicedOrderDataTable"/>
	</div>
</gui:dialog>
