

<%@ page import="com.kettler.domain.item.share.DealerLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerLocation.label', default: 'DealerLocation')}" />
        <g:javascript src="jquery/jquery-1.4.2.min.js"/>
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
	<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" controller="dealer" action="index"><g:message code="default.home.label"/></g:link></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${dealerLocationInstance}">
            <div class="errors">
                <g:renderErrors bean="${dealerLocationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" enctype="multipart/form-data" >
                <g:hiddenField name="id" value="${dealerLocationInstance?.id}" />
                <g:hiddenField name="version" value="${dealerLocationInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>

                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name">Name</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${dealerLocationInstance?.name}" size="50"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="street"><g:message code="dealerLocation.street.label" default="Street" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'street', 'errors')}">
                                    <g:textField name="street" value="${dealerLocationInstance?.street}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="phone"><g:message code="dealerLocation.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${dealerLocationInstance?.phone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="city"><g:message code="dealerLocation.city.label" default="City" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'city', 'errors')}">
                                    <g:textField name="city" value="${dealerLocationInstance?.city}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="state"><g:message code="dealerLocation.state.label" default="State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'state', 'errors')}">
                                    <g:textField name="state" maxlength="2" value="${dealerLocationInstance?.state}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="zip"><g:message code="dealerLocation.zip.label" default="Zip" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'zip', 'errors')}">
                                    <g:textField name="zip" maxlength="10" value="${dealerLocationInstance?.zip}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label>Current Store Photo</label>
                                </td>
                                <td valign="top" class="value">
                                  <g:if test="${dealerLocationInstance.storePhoto}">
                                    <img src="<g:createLink action='renderStorePhoto' id='${dealerLocationInstance?.id}'/>" alt="Dealer Store Photo">
                                  </g:if>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label><g:message code="dealerLocation.storePhoto.label" default="Store Photo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'storePhoto', 'errors')}">
                                    <input type="file" name="storePhoto"  />
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="lat"><g:message code="dealerLocation.lat.label" default="Lat" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'lat', 'errors')}">
                                    <g:textField name="lat" value="${fieldValue(bean: dealerLocationInstance, field: 'lat')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="lng"><g:message code="dealerLocation.lng.label" default="Lng" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'lng', 'errors')}">
                                    <g:textField name="lng" value="${fieldValue(bean: dealerLocationInstance, field: 'lng')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dealer"><g:message code="dealerLocation.dealer.label" default="Dealer" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'dealer', 'errors')}">
                                    <g:select name="dealer.id" from="${com.kettler.domain.item.share.Dealer.list()}" optionKey="id" value="${dealerLocationInstance?.dealer?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="inventories"><g:message code="dealerLocation.inventories.label" default="Inventories" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'inventories', 'errors')}">
                                    
<ul>
<g:each in="${dealerLocationInstance?.inventories?}" var="i">
    <li><g:link controller="dealerInventory" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="dealerInventory" action="create" params="['dealerLocation.id': dealerLocationInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'dealerInventory.label', default: 'DealerInventory')])}</g:link>

                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
	</div>
    </body>
</html>
