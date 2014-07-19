

<%@ page import="com.kettler.domain.item.share.Dealer" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealer.label', default: 'Dealer')}" />
        <g:javascript src="jquery/jquery-1.4.2.min.js"/>     
        <title>Edit Dealer</title>
    </head>
    <body>
		<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">List Dealers</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">Create Dealer</g:link></span>
        </div>
        <div class="body">
            <h1>Edit Dealer</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${dealerInstance}">
            <div class="errors">
                <g:renderErrors bean="${dealerInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="dealerForm" enctype="multipart/form-data" >
                <g:hiddenField name="id" value="${dealerInstance?.id}" />
                <g:hiddenField name="version" value="${dealerInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="website"><g:message code="dealer.website.label" default="Website" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'website', 'errors')}">
                                    <g:textField name="website" value="${dealerInstance?.website}" size="50"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="phone">Phone</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${dealerInstance?.phone}" size="10"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label><g:message code="dealer.customer.label" default="Customer" /></label>
                                </td>
                                <td valign="top" class="value">
                                    ${dealerInstance?.customer?.name?.encodeAsHTML()}
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="division">Division</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'division', 'errors')}">
                                    <select id="divisions" name="divisions" multiple="multiple"> 
                                        <option value="0">-- none --</option>
                                        <g:each in="${WebDivision.list()}" var="division">
                                            <option value="${division.id}"
                                               <% if (dealerInstance.divisions.find {it.id == division.id}) { %>selected="selected"<% } %> 
                                            >
                                               ${division.name}
                                            </option> 
                                        </g:each>
                                    </select>
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label>Current Logo</label>
                                </td>
                                <td valign="top" class="value">
                                  <g:if test="${dealerInstance.logo}">
                                    <img src="<g:createLink action='renderLogo' id='${dealerInstance?.id}'/>" alt="Dealer Logo">
                                  </g:if>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label><g:message code="dealer.logo.label" default="Logo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'logo', 'errors')}">
                                    <input type="file" name="logo"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="locations"><g:message code="dealer.locations.label" default="Locations" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'locations', 'errors')}">
									<ul>
										<g:each in="${dealerInstance?.locations}" var="l">
										    <li><g:link controller="dealerLocation" action="show" id="${l.id}">${l?.encodeAsHTML()}</g:link></li>
										</g:each>
									</ul>
									<g:link controller="dealerLocation" action="create" params="['dealer.id': dealerInstance?.id]">Dealer Location</g:link>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="trackInventory"><g:message code="dealer.trackInventory.label" default="Track Inventory" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'trackInventory', 'errors')}">
                                    <g:checkBox name="trackInventory" value="${dealerInstance?.trackInventory}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="web">Web Dealer</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: dealerInstance, field: 'web', 'errors')}">
                                    <g:checkBox name="web" value="${dealerInstance?.web}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('Are you sure?');" /></span>
                </div>
            </g:form>
        </div>
	</div>
	<g:javascript>
        $('#dealerForm').submit(function () {
           if ($('#divisions').val() == null) {
                alert('Please select a division');
                return false;
           }
           return true;
        });
	</g:javascript>
    </body>
</html>
