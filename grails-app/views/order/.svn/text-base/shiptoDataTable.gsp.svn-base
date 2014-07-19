<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <gui:resources components="['dataTable']"/>
    <title>Ship-to Selection</title>
</head>

<body >
    <gui:dataTable
            caption="Click row to select"
            draggableColumns="true"
            id="shipto_data_table"
            columnDefs="[
                [key:'shipToNo', sortable:true, resizeable: true, label:'No:'],
                [key:'name', sortable:true, resizeable: true, label:'Ship-to Name'],
                [key:'city', sortable:true, resizeable: true, label:'City'],
                [key:'state', sortable:true, resizeable: true, label:'State'],
                [key:'zipCode', sortable:true, resizeable: true, label:'Zip'],
			]"
            controller="order" action="shiptoDataTableAsJSON"
            rowClickNavigation="true"
            collapseOnExpansionClick="true"
            rowsPerPage="24"
            sortedBy='name'
    />
	<div class="nav">
	    <span class="menuButton">
	    	<g:link class="create" controller="shipTo" action="create" 
	    		params="[compCode:session?.ord?.compCode,custNo:session?.ord?.custNo,orderNo:session?.ord?.orderNo]">
	    		New Ship-To
	    	</g:link>
	    </span>
	</div>
    
</body>
</html>
