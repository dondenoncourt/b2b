<gui:dialog
		id="shipToDataTableDialog"
		title="Select Ship-To Address"
		draggable="true"
		modal="true"
		controller="order"
		triggers="[show:[id:'showShipToDataTableDialog', on:'click']]">
		<div id="shipToDataTableDiv">
		<g:render template="shipToDataTable"/>
		</div>
</gui:dialog>
