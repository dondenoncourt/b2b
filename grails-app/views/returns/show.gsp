<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<% if (params.pdf) { %>
			<meta name="layout" content="pdf" />
		<% } else if (params.popup) { %>
			<meta name="layout" content="popup" />
		<% } %>
        <title>Return Authorization</title>
        <g:javascript library="prototype" />
    </head>
    <body>
        <g:javascript>
            function promptEmail() {
                var emails= prompt('Please enter a comma separated list of email addresses:', '${ra.customer.email}');
                <% def args = [popup:'true'] %>
                var href = '${createLink(controller:'pdf', action:'show', params:args)}';
                href += '&url=/returns/showPdf/${ra.id}?pdf=true&filename=returnauthorization.pdf&emails='+emails
                window.open(href);
            }
        </g:javascript>
    	<div class="body">
    		<g:render template="showDetails" />
			<% if (!params.pdf) { %>
			    <div class="buttons">
			         <span class="menuButton">
			            <% if (!params.popup) { %>
			                <g:link class="pdfAnchor" action="list" title="Click to return to Returns list">List</g:link>
			            <% } %>
			               <a  class='pdfAnchor'href='/kettler/pdf/show?url=/returns/showPdf/${ra.id}?pdf=true&pdf=true&filename=returnauthorization.pdf' 
			                   title='Click to display a PDF version of this page' >Show as PDF</a>
			               <a class="pdfAnchor" href="#" onclick="promptEmail();" 
			                  title='Click to eMail and display a PDF version of this page, you will be prompted for email addresses' >eMail PDF</a>
			        </span>
			    </div>
			<% } %>
    	</div>
    </body>
</html>
