<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="org.jsecurity.SecurityUtils" %>


<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <% if (params?.pdf) { %>
        <meta name="layout" content="pdf" />
    <% } else { %>
        <meta name="layout" content="main" />
    <% } %>
    <resource:dateChooser />
    <g:javascript library="prototype" />
    <title>Commission Statements</title>
</head> 
<body>
    <% if (!params.pdf) { %>
        <g:javascript>
            function displayAsCsv() {
               var href = '${createLink(controller:'customer', action:'commStmts')}';
               var formValues = $('commStmtsForm').serialize()
               window.open(href+'?'+formValues+'&csv=true');
            }
            function displayAsPdf() {
               <% def args = [popup:'true'] %>
               var href = '${createLink(controller:'pdf', action:'show', params:args)}';
               var formValues = $('commStmtsForm').serialize()
               // pdf controller will reset & and =, the params get lost otherwise
               formValues = formValues.replace(/&/g, "-AMPERSAND-");
               formValues = formValues.replace(/=/g, "-EQUALS-");
               href += '&url=/customer/commStmts?pdf=true-AMPERSAND-filename-EQUALS-commstmts.pdf-AMPERSAND-popup-EQUALS-true-AMPERSAND-'+formValues;
               window.open(href);
            }
        </g:javascript>
    <% } %>
    <div class="logo">
        <img alt="KETTLER, Inc." src="${createLinkTo(dir:'images',file:'kettler_logo.gif')}"/>
        <h2>KETTLER Int'l., Inc.</h2>
        <ul>
            <li>1355 London Bridge Road,</li>
            <li>Virginia Beach, VA 23453 USA</li>
            <li>Phone: (757) 427-2400</li>
            <li>Fax:   (757) 427-0183</li>
            <li>www.KETTLERUSA.com</li>
            <li>eMail: info@.KETTLERUSA.com</li>
        </ul>
    </div>
    
    <div class="body">
        <h1 class="title">Sales Commission ${totalRow?'for '+totalRow.name.encodeAsHTML().replaceAll(/&amp;/,'&#38;'):''} </h1>
        <g:hasErrors bean="${cmd}"><div class="errors"><g:renderErrors bean="${cmd}" as="list" /></div></g:hasErrors>
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <% if (params.pdf) { %>
           <dl>
                  <dt>Rep:</dt> <dd class="value"> ${params.rep}:${SalesPerson.get(params.rep)?.name.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</dd>
                  <dt>Month:</dt>    <dd class="value"> <g:formatDate format="MMMMMMMMMM yyyy" date="${cmd.fromDate}"/> </dd>
           </dl>
           <br/>
        <% } else { %>
            <g:form action="commStmts" name="commStmtsForm" method="post" >
                <div>
                    <dl class='wide'>
                        <jsec:hasRole name="${Role.KETTLER}">
                            <dt>Sales Person:</dt>    <dd class="value"> <g:select name="rep" from="${SalesPerson.list([sort:'id'])}" optionKey="id" value="${params.rep}" noSelection="${['':'Select One...']}"/> </dd>
                        </jsec:hasRole>
                            <% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()) %>
                        <jsec:hasRole name="${Role.REP_ADMIN}">
                            <dt>Sales Person:</dt>
                            <dd>
                                <g:select name="rep" from="${SalesPerson.findAllByVendorNo(user.salesperson.vendorNo)}" 
                                   optionKey="id" optionVlue="name" value="${user.salesperson.id}" noSelection="${['':'Select a Rep...']}"/>
                             </dd>
                        </jsec:hasRole>                         
                        <jsec:hasAnyRole in="${[Role.REP_PLUS, Role.REP]}">
                            <g:hiddenField name="rep" value="${user.salesperson.id}"/>
                        </jsec:hasAnyRole>                         
                        <dt>From Date:</dt>    <dd class="value"> 
                                                 <g:datePicker name="fromDate" value="${cmd?.fromDate}" precision="month" years="${2009..2020}" noSelection="['':'-Choose-']"/>
                                               </dd>
                    </dl>
                </div>
                    <div class="buttons" >
                        <g:submitButton class="table" name="run" value="Run" /> 
                         <span class="menuButton">
                            <a class="pdfAnchor" href="#" onclick="displayAsPdf();" 
                               title='Click to display the commission report as a PDF'>PDF</a>
                        </span>
                         <span class="menuButton">
                            <a class="csvAnchor" href="#" onclick="displayAsCsv();" 
                               title='Click to display the commission report as a CSV/Excel'>CSV</a>
                        </span>
                    </div>
            </g:form>
        <% } %>
   </div>
    <g:render template="commStmtsBody" model="${[list:list, count:count, totalRow:totalRow, cmd:cmd, params:params]}"/>
</body>
</html>
