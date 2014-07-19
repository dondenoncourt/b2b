<%@ page import="com.kettler.domain.item.share.Dealer" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealer.label', default: 'Dealer')}" />
        <title>Show Dealer</title>
    </head>
    <body>
		<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">List Dealers</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Dealer</g:link></span>
        </div>
        <div class="body">
            <h1>Show Dealer</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealer.id.label" default="Id" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerInstance, field: "id")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealer.website.label" default="Website" /></td>
                            <td valign="top" class="value">${fieldValue(bean: dealerInstance, field: "website")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealer.customer.label" default="Customer" /></td>
                            <td valign="top" class="value">${dealerInstance?.customer?.name?.encodeAsHTML()}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Division</td>
                            <td valign="top" class="value">                            
	                            <g:each var="division" in="${dealerInstance.divisions}">
	                                ${division.name}&nbsp;
	                            </g:each>
                            </td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Phone</td>
                            <td valign="top" class="value"><kettler:formatPhone phone="${dealerInstance.phone}"/></td>
                        </tr>
                        <tr class="prop">
                           <td valign="top" class="name">Logo</td>
                           <td valign="top" class="value">
                             <g:if test="${dealerInstance.logo}">
                               <img src="<g:createLink action='renderLogo' id='${dealerInstance?.id}'/>" alt="Dealer Logo">
                             </g:if>
                           </td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealer.locations.label" default="Locations" /></td>
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${dealerInstance.locations}" var="l">
                                    <li><g:link controller="dealerLocation" action="show" id="${l.id}">${l?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="dealer.trackInventory.label" default="Track Inventory" /></td>
                            <td valign="top" class="value"><g:formatBoolean boolean="${dealerInstance?.trackInventory}" true="yes" false="no" /></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Web Dealer</td>
                            <td valign="top" class="value"><g:formatBoolean boolean="${dealerInstance.web}" true="yes" false="no" /></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${dealerInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('Are you sure?');" /></span>
                </g:form>
            </div>
        </div>
	</div>
    </body>
</html>
