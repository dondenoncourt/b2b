
<%@ page import="com.kettler.domain.item.share.ItemMasterExt" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<%@ page import="com.kettler.domain.item.share.WebCategory" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="Item Master Extension List" />
        <title>"Item Master Extension List"</title>
    </head>
    <body>
        <div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="itemMasterList">CRS Items</g:link></span>
        </div>
        <div class="body">
            <h1>Item Master Extension List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

		<h2>Search Criterion</h2>

        <g:form action="list" method="post" >
        	<div class="col1">
				<dl>
					<dt>Item:</dt>		<dd><input type="text" size="15" maxlength="15" name="itemNumber" value="${params.itemNumber}"/></dd>
				</dl>
            </div>
            <div class="col2">
				<dl>
					<dt>Item Description:</dt>		<dd><input type="text" size="30" maxlength="30" name="itemDesc" value="${params.itemDesc}"/></dd>
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
                            <g:sortableColumn property="itemNo" params="${params}" title="${message(code: 'itemMasterExt.itemNo.label', default: 'Item No')}" />
                            <g:sortableColumn property="compCode" params="${params}" title="${message(code: 'itemMasterExt.compCode.label', default: 'Comp')}" />
                            <g:sortableColumn align="left" property="desc" params="${params}" title="${message(code: 'itemMasterExt.desc.label', default: 'Desc')}" />
                            <g:sortableColumn property="retailPrice" params="${params}" title="Price" />
                            <g:sortableColumn property="youTube" params="${params}" title="You Tube" />
                            <g:sortableColumn property="division" params="${params}" title="Division" />
                            <g:sortableColumn property="category" params="${params}" title="Category" />
                            <g:sortableColumn property="collection" params="${params}" title="Collection" />
                            <g:sortableColumn property="activeCode" params="${params}" title="${message(code: 'itemMasterExt.activeCode.label', default: 'Active Code')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${itemMasterExtInstanceList}" status="i" var="itemMasterExtInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:link action="edit" id="${itemMasterExtInstance.id}">${fieldValue(bean: itemMasterExtInstance, field: "itemNo")}</g:link></td>
                            <td>${fieldValue(bean: itemMasterExtInstance, field: "compCode")}</td>
                            <td>${fieldValue(bean: itemMasterExtInstance, field: "desc")}</td>
                            <td class="number">${itemMasterExtInstance.retailPrice}</td>
                            <td><a href="${itemMasterExtInstance.youTube}">${(itemMasterExtInstance.youTube?'View':'')}</td>
                            <td>${WebDivision.get(itemMasterExtInstance.division?.id)?.name }</td>
                            <td>${WebCategory.get(itemMasterExtInstance.category?.id)?.name }</td>
                            <td>${itemMasterExtInstance.collection}</td>
                            <td>${fieldValue(bean: itemMasterExtInstance, field: "activeCode")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <br></br>
            <div class="paginateButtons">
                <g:paginate total="${itemMasterExtInstanceTotal}" params="${params }"/>
            </div>
        </div>
    </div>
    </body>
</html>
