<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.actrcv.share.Return" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnItem" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnReason" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnStatus" %>

<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="com.kettler.domain.orderentry.share.InvoicedOrderDetailItem" %>


<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
    <% if (!params.pdf) { %>
	    <style>
	        /* position auto-complete */
	        .yui-skin-sam  .yui-ac-container {
	            left:350px;
	        }
	        .searchcontainer  {
	            position: relative; 
	            top:10px;
	        }
	        /* auto-complete overrides of autocomplete.css */
	        .searchcontainer li.yui-ac-highlight {background:#b2d1ff;}
	        .searchcontainer li.yui-ac-prehighlight {background:#f7f7f7;}
	    </style>
    <% } %>
    <head>
	    <% if (params.pdf) { %>
	        <meta name="layout" content="pdf" />
	    <% } else { %>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	        <meta name="layout" content="main" />
	        <resource:autoComplete skin="default" />
	        <gui:resources components="['dataTable']"/>
            <resource:dateChooser />
	        <g:javascript library="prototype" />
        <% } %>
        <title>Return Authorizations Search</title>
    </head>
    <body>
        <% if (!params.pdf) { %>
	        <g:javascript>
	            function requestPDF() {
                    <% def args = [popup:'true'] %>
	                var href = '${createLink(controller:'pdf', action:'show', params:args)}';
	                var formValues = $('searchForm').serialize()
	                // pdf controller will reset & and =, the params get lost otherwise
	                formValues = formValues.replace(/&/g, "-AMPERSAND-");
                    formValues = formValues.replace(/=/g, "-EQUALS-");
	                href += '&url=/returns/freightClaimReport/?pdf=true-AMPERSAND-filename-EQUALS-ra_report.pdf-AMPERSAND-'+formValues;
	                window.open(href);
	            }
	        </g:javascript>
	    <% } %>
        <div class="body full">

            <g:if test="${session.message}"><div class="message">${session.message}</div><% session.message = null %></g:if>

            <h1>Freight Claim Report</h1>
            
            <% if (params.pdf) { %>
	            <div class="col1">
	               <h2>Selection Criterion:</h2>
                    <dl>
                        <% if (params.carrierId) { %>
                            <dt>Carrier:</dt><dd>    ${Carrier.get(params.carrierId).desc} </dd>
                        <% } %>
                        <% if (params.fromDate) { %>
                            <dt>Submit From/To</dt>
                            <dd>
                                <g:formatDate date="${params.fromDate}" format="MM/dd/yy"/> to:
                                <g:formatDate date="${params.toDate}" format="MM/dd/yy"/>
                            </dd>
                        <% } %>
                        <% if (params.claimStatus) { 
                            out.print('<dt>Status</dt>')
                            out.print('<dd>')
                                switch (params.claimStatus) { 
                                    case 'unpaid':          out.print('Unpaid');          break
                                    case 'paid':            out.print('Paid');            break
                                    case 'balance':         out.print('Partial Balance'); break
                                    case 'denied':          out.print('Denied');          break
                                }
                            out.print('</dd>')
                        } %>
                   </dl>
               </div>
            <% } else { %>
	            <g:form action="freightClaimReport" name="searchForm" method="post" >
	                <input type="hidden" name="max" value="${params.max}"/>
	                <input type="hidden" name="offset" value="0"/>
	                <input type="hidden" name="sort" value="${params.sort}"/>
	                    <dl>
	                            <dt>Carrier:</dt>           <dd><g:select name="carrierId" from="${Carrier.list(sort:'desc')}" optionKey="id" optionValue="desc" value="${params.carrierId}" noSelection="${['':'Select One...']}" /></dd>
	                            <dt>Status:</dt>            <dd>
                                                                Unpaid          <g:radio name="claimStatus" value="unpaid" checked="${params.claimStatus=='unpaid'}"/>
                                                                Paid            <g:radio name="claimStatus" value="paid" checked="${params.claimStatus=='paid'}"/>
                                                                Partial Balance <g:radio name="claimStatus" value="balance" checked="${params.claimStatus=='balance'}"/>
                                                                Denied          <g:radio name="claimStatus" value="denied" checked="${params.claimStatus=='denied'}"/>
                                                            </dd>
                                <dt>Submit From/Thru:</dt>	<dd>
                                                                <richui:dateChooser class="date" name="fromDate" format="MM/dd/yyyy"  value="${params.fromDate}"   tabindex="4"/> 
                                                                <richui:dateChooser class="date" name="toDate" format="MM/dd/yyyy"  value="${params.toDate}"    tabindex="5"/>mm/dd/yyyy
                                                            </dd>
	                    </dl>
	                <% if (!params.pdf) { %>
		                <div class="buttons" >
		                    <g:submitButton class="search" name="search" value="Search" /> 
		                    <span class="menuButton">
		                        <a class="pdfAnchor" href="#" onclick="requestPDF();" 
		                              title='Click to eMail and display a PDF version of this page, you will be prompted for email addresses' >Display as PDF</a>
		                        
		                    </span> 
		                </div>
	                <% } %>
	            </g:form>
	            <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
                <g:render template="/order/itemMasterDataTableDialog"/>
            <% } %>
            <div class="full">
	            <g:if test="${raList}">
	                <br/>
		            <div class="list">
		                <table class="${!params.pdf?'wide':''}">
		                    <thead>
		                        <tr>
                                    <th>Carrier</th>
                                    <th>Submit Date</th>
                                    <th>Claim Amount</th>
                                    <th>Claim No.</th>
                                    <th>Paid Amount</th>
                                    <th>Balance</th>
                                    <th>RA#</th>
                                    <th>Status</th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                        <g:each in="${raList}" status="i" var="ra">
		                            <tr class="odd">
		                                <td>${ra.carrier?.desc}</td>
                                        <td class="number"><g:formatDate date="${ra.freightClaimSubmit}" format="MM/dd/yy"/></td> 
                                        <td class="number"><g:formatNumber number="${ra.freightClaimAmount}" format="\$#,###,##0.00" /></td>
                                        <td>${ra.freightClaimNo}</td>
                                        <td class="number"><g:formatNumber number="${ra.freightClaimAmountPaid?:0}" format="\$#,###,##0.00" /></td>
                                        <td class="number"><g:formatNumber number="${ra.freightClaimAmount - (ra.freightClaimAmountPaid?:0)}" format="\$#,###,##0.00" /></td>
		                                <td>${ra.id}</td>
		                                <td>${ra.status.id}</td>
		                            </tr>
		                        </g:each>
		                    </tbody>
		                </table>
		            </div>
	            </g:if>
            </div>
        </div>
    </body>
</html>
