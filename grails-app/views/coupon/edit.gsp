

<%@ page import="com.kettler.domain.orderentry.share.Coupon" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<%@ page import="com.kettler.domain.item.share.WebCategory" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'coupon.label', default: 'Coupon')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${couponInstance}">
            <div class="errors">
                <g:renderErrors bean="${couponInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${couponInstance?.id}" />
                <g:hiddenField name="version" value="${couponInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="no"><g:message code="coupon.no.label" default="No" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'no', 'errors')}">
                                    <g:textField name="no" maxlength="15" value="${couponInstance?.no}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="item"><g:message code="coupon.item.label" default="Item" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'item', 'errors')}">
                                    <g:select name="item.id" from="${com.kettler.domain.item.share.ItemMasterExt.list()}" optionKey="id" value="${couponInstance?.item?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="division"><g:message code="coupon.division.label" default="Division" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'division', 'errors')}">
                                    <g:select name="division.id" from="${WebDivision.list()}" optionKey="id" value="${couponInstance?.division?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="category"><g:message code="coupon.category.label" default="Category" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'category', 'errors')}">
                                    <g:select name="category.id" from="${WebCategory.list()}" optionKey="id" value="${couponInstance?.category?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="percent"><g:message code="coupon.percent.label" default="Percent" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'percent', 'errors')}">
                                    <g:select name="percent" from="${0..100}" value="${fieldValue(bean: couponInstance, field: 'percent')}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="amount"><g:message code="coupon.amount.label" default="Amount" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'amount', 'errors')}">
                                    <g:textField name="amount" value="${fieldValue(bean: couponInstance, field: 'amount')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="start"><g:message code="coupon.start.label" default="Start" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'start', 'errors')}">
                                    <g:datePicker name="start" precision="day" value="${couponInstance?.start}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="expire"><g:message code="coupon.expire.label" default="Expire" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'expire', 'errors')}">
                                    <g:datePicker name="expire" precision="day" value="${couponInstance?.expire}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="createdBy"><g:message code="coupon.createdBy.label" default="Created By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'createdBy', 'errors')}">
                                    ${couponInstance.createdBy}
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="approvedBy"><g:message code="coupon.approvedBy.label" default="Approved By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'approvedBy', 'errors')}">
                                    ${couponInstance.approvedBy}
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="singleUse"><g:message code="coupon.singleUse.label" default="Single Use" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: couponInstance, field: 'singleUse', 'errors')}">
                                    <g:checkBox name="singleUse" value="${couponInstance?.singleUse}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
		            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
