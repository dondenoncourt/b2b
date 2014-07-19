<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <gui:resources components="['dataTable']"/>
    <title>Customer Selection</title>
</head>

<body >
	<g:form action="custSearchforDataTable">
		Customer short name:
		<input type="text" name="shortName" id="shortName" />
        <g:submitButton  update="cust_data_table" name="search" value="Search"  />
	</g:form>
    <gui:dataTable
            caption="Click row to select"
            draggableColumns="true"
            id="cust_data_table"
            columnDefs="[
                [key:'custNo', sortable:true, resizeable: true, label:'Number'],
                [key:'shortName', sortable:true, resizeable: true, label:'Short Name'],
                [key:'addr1', sortable:true, resizeable: true, label:'Address Line 1'],
                [key:'state', sortable:true, resizeable: true, label:'State'],
                [key:'zipCode', sortable:true, resizeable: true, label:'Zip'],
			]"
            controller="order" action="custDataTableAsJSON"
            rowClickNavigation="true"
            collapseOnExpansionClick="true"
            rowsPerPage="24"
            sortedBy='shortName'
    />
</body>
</html>
