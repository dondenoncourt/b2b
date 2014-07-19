<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Kettler Online Retailers</title>
    <meta name="layout" content="${(params.division.replaceAll(/ /,''))}" />
</head>
<body>
<div id="webDealers">
    <h2>Online Retailers</h2>
    <g:link controller="locate" action="index" params="[division:params.division,itemId:params.itemId]" 
            class="retailer clickme">
     Store Retailers
    </g:link>
    &nbsp; <!-- non-blanking space seems to be required or roundies on link don't work on the right??? -->
    <br/>
    <br/>
    <br/>
    <g:each in="${dealers}" status="i" var="dealer">
        <div class="webDealer">
	        <a href="#" onclick="window.open('http://${dealer.website}')" title="${dealer.website}">
	            <% if (dealer.logo) { %>
	                <img src="<g:createLink action='renderLogo' id='${dealer?.id}'/>" alt="Dealer Logo">
	            <% } else { %>
	                ${dealer.customer?.name}
	            <% } %>
	            <br/>
	        </a>
	        <% if (dealer.logo) { %>
	            <br/>
	            ${dealer.customer?.name}
	        <% } %>
	        <br/>
	        <kettler:formatPhone phone="${dealer.phone}"/><br/>
        </div>
    </g:each>
</div>
<g:javascript>
    $('#dealerList').height(${(dealers.size()/4*100)}+'px');
</g:javascript>
</body>
