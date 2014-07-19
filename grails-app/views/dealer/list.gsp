<%@ page import="com.kettler.domain.item.share.Dealer" %>
<%@ page import="com.kettler.domain.item.share.DealerLocation" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealer.label', default: 'Dealer')}" />
        <title>List Dealers</title>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
        <g:javascript>
            function trackInventory(id, yesNo) {
	             $.ajax({
	                url: "${createLink(controller:'dealer', action:'trackInventory')}/"+id,
	                data: 'yesNo='+yesNo.checked,
	                type: 'POST',
	                success: function(data, textStatus) {$('div.message').html(data);$('div.message').show();},
	                error: function(xhr,textStatus, errorThrown) { alert(textStatus) }
	             });
            }
        </g:javascript>
        
    </head>
    <body>
        <div class="body">
	        <jsec:hasRole name="${Role.SUPER_ADMIN}">
	            <div class="nav">
	                <span class="menuButton"><g:link class="create" action="index">Create Dealer</g:link></span>
	            </div>
	        </jsec:hasRole>
            <h1>List Dealers</h1>
            <div class="message">${flash.message}</div>
            <g:form action="list" name="searchDealers" method="get" >
                <dl>
                     <dt>Acct No:</dt>      <dd><input type="text" name="custNo" value="${params.custNo}"/></dd>
                     <dt>Acct Name:</dt>    <dd><input type="text" name="custName" value="${params.custName}"/></dd>
                     <dt>Division:</dt>     <dd>
                            <g:select name="divisionId" from="${WebDivision.list()}" 
                                noSelection="['0':'All']"
                                value="${params.divisionId}"
                                optionKey="id" optionValue="name"/>
                            </dd>
                </dl>
	            <div class="buttons" >
	                <g:submitButton class="search" name="search" value="Search" onclick="removeEmptyDates();"/> 
	            </div>
            </g:form>
            <br/>  
            <div class="list">
                <table>
                    <thead>
                        <tr>
                            <th>Acct No</th>
                            <th>Name</th>
                            <th>Divisions</th>
                            <th>Phone</th>
                            <g:sortableColumn property="website" title="${message(code: 'dealer.website.label', default: 'Website')}" params="${params}" />
                            <g:sortableColumn property="trackInventory" title="${message(code: 'dealer.trackInventory.label', default: 'Track Inv')}"  params="${params}"/>
                            <th>Web Dealer</th>
                            <th>Last Login</th>
                            <th>Logo</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${dealerInstanceList}" status="i" var="dealerInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td>
                                <jsec:hasRole name="${Role.KETTLER}">
                                    ${dealerInstance.customer.custNo}
                                </jsec:hasRole>
                                <jsec:hasRole name="${Role.SUPER_ADMIN}">
                                    <g:link action="show" id="${dealerInstance.id}">${dealerInstance.customer.custNo}</g:link>
                                </jsec:hasRole>
                            </td>
                            <td>${dealerInstance.customer?.name}</td>
                            <td>
                                <g:each var="division" in="${dealerInstance.divisions}">
                                    ${division?.name}&nbsp;
                                </g:each>
                            </td>
                            <td><kettler:formatPhone phone="${dealerInstance.phone}"/></td>
                            <td>${fieldValue(bean: dealerInstance, field: "website")}</td>
                            <td>
                                <% if (DealerLocation.findByDealer(dealerInstance)) { %>
	                                <g:checkBox name="trackInventory" value="${dealerInstance.trackInventory}" 
	                                    onclick="trackInventory(${dealerInstance.id}, this)"
	                                    title="Click to toggle inventory tracking" 
	                                />
	                            <% } else { %>
	                               <g:formatBoolean boolean="${dealerInstance.trackInventory}" true="yes" false="no" />
	                            <% } %>
                            </td>
                            <td><g:formatBoolean boolean="${dealerInstance.web}" true="yes" false="no" /></td>
                            <td style="width:6em;"><g:formatDate format="MM-dd-yy" date="${WebUser.findByCustNo(dealerInstance.customer.custNo)?.lastLogin}"/></td>
                           <td valign="top" class="value">
                             <g:if test="${dealerInstance.logo}">
                               <img src="<g:createLink action='renderLogo' id='${dealerInstance?.id}'/>" alt="Dealer Logo">
                             </g:if>
                           </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${dealerInstanceTotal}" params="${params}"/>
            </div>
        </div>
	</div>
	<g:javascript>
	    $('div.message').hide();
	    <g:if test="${flash.message}">
	       $('.message').show();
	    </g:if>
	</g:javascript>    
    </body>
</html>
