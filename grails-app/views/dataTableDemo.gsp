<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <gui:resources components="['dataTable']"/>
    <title>DataTable Demo</title>
</head>

<body class="yui-skin-sam">
<button id="show2">Show Modal Markup Dialog</button>
    Current Term selected:
    ${(term?.desc)}
    <gui:dialog
            id="dialog2"
            title="Fixed Modal Dialog"
            draggable="false"
            modal="true"
	    update="true"
            triggers="[show:[id:'show2', on:'click']]">
    <gui:dataTable
            caption="Click row to select"
            draggableColumns="true"
            id="terms_data_table"
            columnDefs="[
                [key:'id', sortable:true, resizeable: true, label:'ID'],
                [key:'desc', sortable:true, resizeable: true, label:'description'],
		]"
            controller="dataTable" action="dataDataTableAsJSON"
            rowClickNavigation="true"
            collapseOnExpansionClick="true"
            rowsPerPage="8"
    />
    </gui:dialog>

<br/><br/>

        <br/><br/>
</body>
</html>
