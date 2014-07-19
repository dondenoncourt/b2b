

<%@ page import="com.kettler.domain.item.share.DealerInventory" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerInventory.label', default: 'DealerInventory')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
	<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" controller="dealer" action="index"><g:message code="default.home.label"/></g:link></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${dealerInventoryInstance}">
            <div class="errors">
                <g:renderErrors bean="${dealerInventoryInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dealerLocation"><g:message code="dealerInventory.dealerLocation.label" default="Dealer Location" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInventoryInstance, field: 'dealerLocation', 'errors')}">
                                    <g:select name="dealerLocation.id" from="${com.kettler.domain.item.share.DealerLocation.list()}" optionKey="id" value="${dealerInventoryInstance?.dealerLocation?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="item"><g:message code="dealerInventory.item.label" default="Item" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInventoryInstance, field: 'item', 'errors')}">
                                    <g:select name="item.id" from="${com.kettler.domain.item.share.ItemMasterExt.list()}" optionKey="id" value="${dealerInventoryInstance?.item?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="quantity"><g:message code="dealerInventory.quantity.label" default="Quantity" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInventoryInstance, field: 'quantity', 'errors')}">
                                    <g:textField name="quantity" value="${fieldValue(bean: dealerInventoryInstance, field: 'quantity')}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
	</div>
    </body>
</html>
