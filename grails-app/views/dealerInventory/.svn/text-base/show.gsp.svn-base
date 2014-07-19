
<%@ page import="com.kettler.domain.item.share.DealerInventory" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerInventory.label', default: 'DealerInventory')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
	<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" controller="dealer" action="index"><g:message code="default.home.label"/></g:link></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerInventory.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: dealerInventoryInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerInventory.dealerLocation.label" default="Dealer Location" /></td>
                            
                            <td valign="top" class="value"><g:link controller="dealerLocation" action="show" id="${dealerInventoryInstance?.dealerLocation?.id}">${dealerInventoryInstance?.dealerLocation?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerInventory.item.label" default="Item" /></td>
                            
                            <td valign="top" class="value">${dealerInventoryInstance?.item?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerInventory.quantity.label" default="Quantity" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: dealerInventoryInstance, field: "quantity")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${dealerInventoryInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
	</div>
    </body>
</html>
