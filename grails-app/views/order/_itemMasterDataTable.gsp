<gui:dataTable
           caption="Click on an item number to select"
           draggableColumns="true"
           id="itemMasterDataTable"
           columnDefs="[
               [key:'itemNo', sortable:true, resizeable: true, label:'Number'],
               [key:'desc', sortable:true, resizeable: true, label:'Description'],
               [key:'stdUnitMeas', sortable:true, resizeable: true, label:'U/M'],
               [key:'upc', sortable:true, resizeable: true, label:'UPC'],
               [key:'euroArticleNo', sortable:true, resizeable: true, label:'Euro Article No'],
               [key:'color', sortable:true, resizeable: true, label:'Color']
			]"
           controller="order" action="itemMasterDataTableAsJSON"
           rowsPerPage="12"
           sortedBy='itemNo'
/>
