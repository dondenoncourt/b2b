<%@ page import="com.kettler.domain.item.share.Dealer" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dealer.label', default: 'Dealer')}" />
        <title>Dealer Maintenance - Find Dealer</title>
    </head>
    <body>
		<div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" controller="dealerInventory" action="index">Inventory</g:link></span>
            <span class="menuButton"><g:link class="list" controller="dealerLocation" action="index">Locations</g:link></span>
            <span class="menuButton"><g:link class="list" action="list">List Dealers</g:link></span>
        </div>
        <div class="body">
            <h1>Find Dealer</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:form method="post" >
            <div class="dialog">
                <table>
                    <tbody>
                        <tr class="prop">
                            <td valign="top" class="name">Account No:</td>
                            <td valign="top" class="value">
                              <g:textField name="custid" value="" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
              <div class="buttons">
                    <span class="button"><g:actionSubmit class="edit" action="search" value="Search" /></span>
            </div>
            </g:form>
        </div>
	</div>
    </body>
</html>
