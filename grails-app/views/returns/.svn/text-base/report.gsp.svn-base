<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.actrcv.share.Return" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnItem" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnReason" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnStatus" %>

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
	                href += '&url=/returns/report/?pdf=true-AMPERSAND-filename-EQUALS-ra_report.pdf-AMPERSAND-'+formValues;
	                window.open(href);
	            }
	        </g:javascript>
	    <% } %>
        <div class="body full">

            <g:if test="${session.message}"><div class="message">${session.message}</div><% session.message = null %></g:if>

            <h1>Return Authorization Report</h1>
            
            <% if (params.pdf) { %>
	            <div class="col1">
	               <h2>Selection Criterion:</h2>
                    <dl>
                        <% if (params.returnNo) { %>
    	                    <dt>Return No:</dt>              <dd>${params.returnNo}</dd>
	                    <% } %>
                        <% if (params.orderNo) { %>
		                    <dt>Order No:</dt>               <dd>${params.orderNo}</dd>
                        <% } %>
                        <% if (params.custNo) { %>
		                    <dt>Cust No:</dt>                <dd>${params.custNo}</dd>
                        <% } %>
                        <% if (params.itemNo) { %>
		                    <dt>Item Number:</dt>            <dd>${params.itemNo}</dd>
                        <% } %>
                        <% if (params.freightClaimsOnly) { %>
	                        <dt>Freight Claims:</dt>         <dd>${params.freightClaimsOnly}</dd>
                        <% } %>
                        <% if (params.shipToName) { %>
	                        <dt>Pick-Up Name:</dt>           <dd>${params.shipToName}</dd>
                        <% } %>
                        <% if (params.shipToZip) { %>
	                        <dt>Pick-Up Zip:</dt>            <dd>${params.shipToZip}</dd>
                        <% } %>
                        <% if (params.status) { %>
	                        <dt>Status:</dt>                 <dd>${params.status}</dd>
                        <% } %>
                   </dl>
               </div>
            <% } else { %>
	            <g:form action="report" name="searchForm" method="post" >
	                <input type="hidden" name="max" value="${params.max}"/>
	                <input type="hidden" name="offset" value="0"/>
	                <input type="hidden" name="sort" value="${params.sort}"/>
	                <div class="full">
	                    <dl class="search">
	                            <dt>Return No:</dt>              <dd><g:textField size="6" maxlength="7" name="returnNo"  value="${params.returnNo}"/></dd>
	                            <dt>Order No:</dt>               <dd><g:textField size="6" maxlength="6" name="orderNo"  value="${params.orderNo}"/></dd>
	                            <dt>Cust No:</dt>                <dd><g:textField  size="7"  maxlength="7"  name="custNo"     value="${params.custNo}" onchange="this.value=this.value.toUpperCase();"/></dd>
	                            <dt>Item Number:</dt>            <dd><g:textField  size="12" maxlength="15" name="itemNo" value="${params.itemNo}" /></dd>
	                    </dl>
	                </div>
	                <div class="full">
	                    <dl class="search">
	                            <dt>Freight Claims:</dt>         <dd><g:checkBox name="freightClaimsOnly" value="${params.freightClaimsOnly}" /></dd>
	                            <dt>Pick-Up Name:</dt>           <dd><g:textField  size="30" maxlength="30" name="shipToName" value="${params.shipToName}" /></dd>
	                            <dt>Pick-Up Zip:</dt>            <dd><g:textField  size="10" maxlength="10" name="shipToZip"  value="${params.shipToZip}" /></dd>
	                    </dl>
	                </div>
	                <div class="full">
	                    <dl class="search">
	                            <dt>Status:</dt>                <dd><g:select name="status" from="${ReturnStatus.list()}" optionKey="code" value="${params.status}" noSelection="['':'- Any Status -']"/> </dd>
	                    </dl>
	                </div>
	                <% if (!params.pdf) { %>
		                <div class="buttons" >
		                    <g:submitButton class="search" name="search" value="Search" /> 
		                    <span class="menuButton">
		                        <a href="#" id="showItemMasterDataTableDialog" class="search" title="Click to search for an item." 
		                              onclick="$('itemMasterDataTableDialog').setStyle({left: '0em'});$('itemMasterDataTableDiv').show();"
		                        >Item Search</a>
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
		                               <th>Item No</th>
		                               <th>Description</th>
		                               <th>Reason</th>
		                               <th>Order No</th>
		                               <th>Cust No</th>
		                               <th>Return No</th>
		                               <th>Status</th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                        <g:each in="${raList}" status="i" var="item">
		                            <tr class="odd">
		                                <td>${item.itemNo}</td>
		                                <td>${item.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
		                                <td>${ReturnReason.get(item.reason?.id)}</td>
		                                <td>${item.orderNo}</td>
		                                <td>${item.ra.customer.custNo}</td>
		                                <td>${item.ra.id}</td>
		                                <td>${item.ra.status.id}</td>
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
