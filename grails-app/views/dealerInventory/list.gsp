
<%@ page import="com.kettler.domain.item.share.DealerInventory" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerInventory.label', default: 'DealerInventory')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
	<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" controller="dealer" action="index"><g:message code="default.home.label"/></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'dealerInventory.id.label', default: 'Id')}" />
                        
                            <th><g:message code="dealerInventory.dealerLocation.label" default="Dealer Location" /></th>
                        
                            <th><g:message code="dealerInventory.item.label" default="Item" /></th>
                        
                            <g:sortableColumn property="quantity" title="${message(code: 'dealerInventory.quantity.label', default: 'Quantity')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${dealerInventoryInstanceList}" status="i" var="dealerInventoryInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${dealerInventoryInstance.id}">${fieldValue(bean: dealerInventoryInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: dealerInventoryInstance, field: "dealerLocation")}</td>
                        
                            <td>${fieldValue(bean: dealerInventoryInstance, field: "item")}</td>
                        
                            <td>${fieldValue(bean: dealerInventoryInstance, field: "quantity")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${dealerInventoryInstanceTotal}" />
            </div>
        </div>
	</div>
    </body>
</html>
