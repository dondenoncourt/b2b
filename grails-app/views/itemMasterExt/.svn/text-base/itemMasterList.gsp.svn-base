
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>
<%@ page import="com.kettler.domain.item.share.ItemMasterExt" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="Item Master Extension List" />
        <title>"Item Master List"</title>
    </head>
    <body>
        <div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">Retail Items</g:link></span>
        </div>
        <div class="body">
            <h1>Item Master List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

		<h1>Search Criterion</h1>

        <g:form action="itemMasterList" method="post" >
        	<div class="col1">
				<dl>
					<dt>Item:</dt>		<dd><input type="text" size="15" maxlength="15" name="itemNumber" value="${params.itemNumber}"/></dd>
					<dt>Item Description:</dt>		<dd><input type="text" size="30" maxlength="30" name="itemDesc" value="${params.itemDesc}"/></dd>
				</dl>
			</div>
        	<div class="col2">
				<dl>
					<dt>Profit Center:</dt>		<dd><input type="text" size="15" maxlength="15" name="profCenter" value="${params.profCenter}"/></dd>
					<dt>Product Group:</dt>		<dd><input type="text" size="30" maxlength="30" name="prodGroup" value="${params.prodGroup}"/></dd>
					<dt>Article Group:</dt>		<dd><input type="text" size="30" maxlength="30" name="artGroup" value="${params.artGroup}"/></dd>
				</dl>
			</div>
			<div class="buttons" >
				<g:submitButton class="search" name="search" value="Search" /> 
			</div>
		</g:form>      
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        	<td>Edit/Add</td>
                            <g:sortableColumn property="compCode" params="${params}" title="${message(code: 'itemMasterExt.compCode.label', default: 'Comp')}" />
                            <g:sortableColumn property="itemNo" params="${params}" title="${message(code: 'itemMaster.itemNo.label', default: 'Item No')}" />
                            <g:sortableColumn align="left" property="desc" params="${params}" title="${message(code: 'itemMaster.desc.label', default: 'Desc')}" />
                            <g:sortableColumn property="profitCenterClass" params="${params}" title="${message(code: 'itemMaster.profitCenterClass.label', default: 'Profit Center')}" />
                            <g:sortableColumn property="productGroupClass" params="${params}" title="${message(code: 'itemMaster.productGroupClass.label', default: 'Product Group')}" />
                            <g:sortableColumn property="articleGroupClass" params="${params}" title="${message(code: 'itemMaster.articleGroupClass.label', default: 'Article Group')}" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${itemMasterInstanceList}" status="i" var="itemMasterInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	<% if (ItemMasterExt.get(itemMasterInstance.id) ) { %>
                            	<td><g:link action="edit" id="${itemMasterInstance.id}">Edit</g:link></td>
                        	<% } else { %>
                            	<td><g:link action="add" id="${itemMasterInstance.id}">Add</g:link></td>
                        	<% } %>
                        
                            <td>${fieldValue(bean: itemMasterInstance, field: "compCode")}</td>
                            <td>${fieldValue(bean: itemMasterInstance, field: "itemNo")}</td>
                            <td>${fieldValue(bean: itemMasterInstance, field: "desc")}</td>
                            <td>${fieldValue(bean: itemMasterInstance, field: "profitCenterClass")}</td>
                            <td>${fieldValue(bean: itemMasterInstance, field: "productGroupClass")}</td>
                            <td>${fieldValue(bean: itemMasterInstance, field: "articleGroupClass")}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <br></br>
            <div class="paginateButtons">
                <g:paginate total="${itemMasterInstanceTotal}" params="${params }"/>
            </div>
        </div>
    </div>
    </body>
</html>
