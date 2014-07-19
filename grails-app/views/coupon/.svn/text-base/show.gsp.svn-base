
<%@ page import="com.kettler.domain.orderentry.share.Role; com.kettler.domain.orderentry.share.Coupon" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<%@ page import="com.kettler.domain.item.share.WebCategory" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'coupon.label', default: 'Coupon')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
            <h1>Show Coupon</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: couponInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.no.label" default="No" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: couponInstance, field: "no")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.item.label" default="Item" /></td>
                            
                            <td valign="top" class="value"><g:link controller="itemMasterExt" action="show" id="${couponInstance?.item?.id}">${couponInstance?.item?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name"> <g:message code="coupon.division.label" default="Division" /> </td>
                            <td valign="top" class="value"> ${couponInstance?.division?.id} </td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"> <g:message code="coupon.category.label" default="Category" /> </td>
                            <td valign="top" class="value"> ${couponInstance?.category?.id} </td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.percent.label" default="Percent" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: couponInstance, field: "percent")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.amount.label" default="Amount" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: couponInstance, field: "amount")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.start.label" default="Start" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${couponInstance?.start}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.expire.label" default="Expire" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${couponInstance?.expire}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.createdBy.label" default="Created By" /></td>
                            
                            <td valign="top" class="value"><g:link controller="webUser" action="show" id="${couponInstance?.createdBy?.id}">${couponInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.approvedBy.label" default="Approved By" /></td>
                            
                            <td valign="top" class="value"><g:link controller="webUser" action="show" id="${couponInstance?.approvedBy?.id}">${couponInstance?.approvedBy?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="coupon.singleUse.label" default="Single Use" /></td>
                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${couponInstance?.singleUse}" /></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${couponInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                    <jsec:hasRole name="${Role.SUPER_ADMIN}">
                        <% if (!couponInstance.approvedBy) { %>
                          <span class="button"><g:actionSubmit class="edit" action="approve" value="Approve" /></span>
                        <% } %>
                    </jsec:hasRole>
		            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
