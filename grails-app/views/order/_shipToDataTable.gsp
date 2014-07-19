<gui:dataTable
         caption="Click Ship-To number to select"
         draggableColumns="true"
         id="shipToDataTable"
         columnDefs="[
             [key:'name', sortable:true, resizeable: true, label:'Ship-to Name'],
             [key:'city', sortable:true, resizeable: true, label:'City'],
             [key:'state', sortable:true, resizeable: true, label:'State'],
             [key:'zipCode', sortable:true, resizeable: true, label:'Zip'],
		]"
         controller="order" action="shipToDataTableAsJSON"
         rowsPerPage="12"
         sortedBy='name'
 />
