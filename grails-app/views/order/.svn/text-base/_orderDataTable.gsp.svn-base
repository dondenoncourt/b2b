<gui:dataTable
           caption="Click on an Order No to select"
           draggableColumns="true"
           id="order_data_table"
           columnDefs="[
               [key:'orderNo', sortable:true, resizeable: true, label:'Order No'],
               [key:'custNo', sortable:true, resizeable: true, label:'Cust No'],
               [key:'poNo', sortable:true, resizeable: true, label:'Purchase Order No'],
               [key:'invoiceNo', sortable:true, resizeable: true, label:'Invoice No'],
               [key:'freightTrackingNo', sortable:true, resizeable: true, label:'Freight Tracking No'],
               [key:'orderDate', sortable:true, resizeable: true, label:'Order Date'],
		]"
           controller="order" action="orderDataTableAsJSON" params="[statusCode:params.statusCode]"
           rowsPerPage="12"
           sortedBy='orderNo'

/>
