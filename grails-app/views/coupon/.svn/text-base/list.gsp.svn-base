
<!-- fake change -->
<%@ page import="com.kettler.domain.orderentry.share.Coupon" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'coupon.label', default: 'Coupon')}" />
        <title>List Coupons</title>
    </head>
    <body>
        <div class="body">
            <h1>Coupon List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'coupon.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="no" title="${message(code: 'coupon.no.label', default: 'No')}" />
                        
                            <th><g:message code="coupon.item.label" default="Item" /></th>
                            <th>Division</th>
                            <th>Category</th>
                        
                            <g:sortableColumn property="percent" title="${message(code: 'coupon.percent.label', default: 'Percent')}" />
                        
                            <g:sortableColumn property="amount" title="${message(code: 'coupon.amount.label', default: 'Amount')}" />
                        
                            <g:sortableColumn property="start" title="${message(code: 'coupon.start.label', default: 'Start')}" />

                            <g:sortableColumn property="approved" title="Approved" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${couponInstanceList}" status="i" var="couponInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${couponInstance.id}">${fieldValue(bean: couponInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: couponInstance, field: "no")}</td>
                        
                            <td>${fieldValue(bean: couponInstance, field: "item")}</td>
                            <td>${fieldValue(bean: couponInstance, field: "division")}</td>
                            <td>${fieldValue(bean: couponInstance, field: "category")}</td>
                        
                            <td>${fieldValue(bean: couponInstance, field: "percent")}</td>
                        
                            <td>${fieldValue(bean: couponInstance, field: "amount")}</td>
                        
                            <td><g:formatDate date="${couponInstance.start}" /></td>

                            <td>${fieldValue(bean: couponInstance, field: "approved")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${couponInstanceTotal}" />
            </div>
	        <jsec:hasRole name="${Role.SUPER_ADMIN}">
	            <div class="nav">
	                <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
	            </div>
	        </jsec:hasRole>
        </div>
    </body>
</html>
