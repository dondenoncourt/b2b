<%@ page import="com.kettler.domain.item.share.DealerLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerLocation.label', default: 'DealerLocation')}" />
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
                            <td valign="top" class="name"><g:message code="dealerLocation.id.label" default="Id" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "id")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.name.label" default="name" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "name")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.street.label" default="Street" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "street")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Phone</td>
                            <td valign="top" class="value"><kettler:formatPhone phone="${dealerLocationInstance.phone}"/></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.city.label" default="City" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "city")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.state.label" default="State" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "state")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.zip.label" default="Zip" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "zip")}</td>
                        </tr>
                        <tr class="prop">
                           <td valign="top" class="name">Store Photo</td>
                           <td valign="top" class="value">
                             <g:if test="${dealerLocationInstance.storePhoto}">
                               <img src="<g:createLink action='renderStorePhoto' id='${dealerLocationInstance?.id}'/>" alt="Store Photo">
                             </g:if>
                           </td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.lat.label" default="Lat" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "lat")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.lng.label" default="Lng" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerLocationInstance, field: "lng")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.dealer.label" default="Dealer" /></td>
                            <td valign="top" class="value"><g:link controller="dealer" action="show" id="${dealerLocationInstance?.dealer?.id}">${dealerLocationInstance?.dealer?.encodeAsHTML()}</g:link></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealerLocation.inventories.label" default="Inventories" /></td>
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${dealerLocationInstance.inventories}" var="i">
                                    <li><g:link controller="dealerInventory" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${dealerLocationInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
	</div>
    </body>
</html>
