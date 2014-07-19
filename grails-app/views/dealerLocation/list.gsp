<%@ page import="com.kettler.domain.item.share.DealerLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealerLocation.label', default: 'DealerLocation')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
	<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" controller="dealer" action="index"><g:message code="default.home.label"/></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1>Dealer Location List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                            <g:sortableColumn property="id" title="${message(code: 'dealerLocation.id.label', default: 'Id')}" />
                            <g:sortableColumn property="phone" title="Phone" />
                            <g:sortableColumn property="dealerName" title="Dealer Name" />
                            <g:sortableColumn property="street" title="${message(code: 'dealerLocation.street.label', default: 'Street')}" />
                            <g:sortableColumn property="city" title="${message(code: 'dealerLocation.city.label', default: 'City')}" />
                            <g:sortableColumn property="state" title="${message(code: 'dealerLocation.state.label', default: 'State')}" />
                            <g:sortableColumn property="zip" title="${message(code: 'dealerLocation.zip.label', default: 'Zip')}" />
                            <g:sortableColumn property="lat" title="${message(code: 'dealerLocation.lat.label', default: 'Lat')}" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${dealerLocationInstanceList}" status="i" var="dealerLocationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:link action="show" id="${dealerLocationInstance.id}">${fieldValue(bean: dealerLocationInstance, field: "id")}</g:link></td>
                            <td><kettler:formatPhone phone="${dealerLocationInstance.phone}"/></td>
                            <td>${dealerLocationInstance.dealer.customer?.name}</td>
                            <td>${fieldValue(bean: dealerLocationInstance, field: "street")}</td>
                            <td>${fieldValue(bean: dealerLocationInstance, field: "city")}</td>
                            <td>${fieldValue(bean: dealerLocationInstance, field: "state")}</td>
                            <td>${fieldValue(bean: dealerLocationInstance, field: "zip")}</td>
                            <td>${fieldValue(bean: dealerLocationInstance, field: "lat")}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${dealerLocationInstanceTotal}" />
            </div>
        </div>
	</div>
    </body>
</html>
