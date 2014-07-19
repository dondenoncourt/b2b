
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main" />
    <title>Customer Stock Status</title>
</head>
<body>
    <div class="body">
        <h1>Stock Status for ${customer.name}
        </h1>
        <table>
            <thead>
                <tr>
                    <th>Item No</th><th>Description</th><th>Available</th>
                </tr>
            </thead>
            <g:each in="${stockStatus}" status="i" var="item">
                <tr>
                    <td> ${item.key.itemNo} </td>
                    <td> ${item.key?.desc} </td>
                    <td style="text-align:center;"> ${item.value?.qtyOnHand?'Y':'N'} </td>
                </tr>
            </g:each>
        </table>
    </div>
</body>
</html>
