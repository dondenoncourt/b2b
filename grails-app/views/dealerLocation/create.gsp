

<%@ page import="com.kettler.domain.item.share.DealerLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerLocation.label', default: 'DealerLocation')}" />
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
            <g:hasErrors bean="${dealerLocationInstance}">
            <div class="errors">
                <g:renderErrors bean="${dealerLocationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
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
                                    <label for="phone"><g:message code="dealerLocation.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${dealerLocationInstance?.phone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="street"><g:message code="dealerLocation.street.label" default="Street" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'street', 'errors')}">
                                    <g:textField name="street" value="${dealerLocationInstance?.street}" size="50" />
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
                                    <label for="dealer"><g:message code="dealerLocation.dealer.label" default="Dealer" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerLocationInstance, field: 'dealer', 'errors')}">
                                    <g:select name="dealer.id" from="${com.kettler.domain.item.share.Dealer.list()}" optionKey="id" value="${dealerLocationInstance?.dealer?.id}"  />
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
