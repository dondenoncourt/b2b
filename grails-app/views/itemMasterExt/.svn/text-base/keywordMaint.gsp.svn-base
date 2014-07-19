
<%@ page import="com.kettler.domain.item.share.ItemMasterExt" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<%@ page import="com.kettler.domain.item.share.WebCategory" %>

<html> 
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="Item Master Extension List" />
        <title>Item Master Extension Keywords Maintenance</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
		<g:javascript>
		    function keywordsChanged(id, val) {    
		      $.ajax({
		          url: "${createLink(controller:'itemMasterExt', action:'keywordsChanged')}/"+id,
		            data: 'keywords='+val,
		            type: 'POST',
		            success: function(data, textStatus) {$('div.message').html(data);$('div.message').show();},
		            error: function(xhr,textStatus, errorThrown) { alert(textStatus) }
		        }); 
		    }    
		    function imageAltChanged(id, val) {    
		      $.ajax({
		          url: "${createLink(controller:'itemMasterExt', action:'imageAltChanged')}/"+id,
		            data: 'imageAlt='+val,
		            type: 'POST',
		            success: function(data, textStatus) {$('div.message').html(data);$('div.message').show();},
		            error: function(xhr,textStatus, errorThrown) { alert(textStatus) }
		        }); 
		    }    
		    function imageTitleChanged(id, val) {    
		      $.ajax({
		          url: "${createLink(controller:'itemMasterExt', action:'imageTitleChanged')}/"+id,
		            data: 'imageTitle='+val,
		            type: 'POST',
		            success: function(data, textStatus) {$('div.message').html(data);$('div.message').show();},
		            error: function(xhr,textStatus, errorThrown) { alert(textStatus) }
		        }); 
		    }    
		    function metaDescChanged(id, val) {    
		      $.ajax({
		          url: "${createLink(controller:'itemMasterExt', action:'metaDescChanged')}/"+id,
		            data: 'metaDesc='+val,
		            type: 'POST',
		            success: function(data, textStatus) {$('div.message').html(data);$('div.message').show();},
		            error: function(xhr,textStatus, errorThrown) { alert(textStatus) }
		        }); 
		    }    
		</g:javascript>    
    </head>
    <body>
        <div class="body">
         <h1>Item Master Extension List</h1>
         <div class="message">${flash.message}</div>
        <g:form action="list" method="post" >
            <g:hiddenField name="keywordMaint" value="true"/>
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
                            <g:sortableColumn property="division" params="${params}" title="Division" />
                            <g:sortableColumn property="category" params="${params}" title="Category" />
                            <g:sortableColumn property="keywords" params="${params}" title="Keywords" />
                            <g:sortableColumn property="imageAlt" params="${params}" title="Image Alt" />
                            <g:sortableColumn property="imageTitle" params="${params}" title="Image Title" />
                            <g:sortableColumn property="metaDesc" params="${params}" title="Meta Desc" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${itemMasterExtInstanceList}" status="i" var="itemMasterExtInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td style="width:15em;">${fieldValue(bean: itemMasterExtInstance, field: "itemNo")}</td>
                            <td>${fieldValue(bean: itemMasterExtInstance, field: "compCode")}</td>
                            <td style="width:50em;">${fieldValue(bean: itemMasterExtInstance, field: "desc")}</td>
                            <td>${WebDivision.get(itemMasterExtInstance.division?.id)?.name }</td>
                            <td>${WebCategory.get(itemMasterExtInstance.category?.id)?.name }</td>
                            <td>
                                <input type="text" name="keywordsForId${itemMasterExtInstance.id}"
                                        onchange="keywordsChanged('${itemMasterExtInstance.id}', this.value)"
                                        size="50" maxlength="255" 
                                        title="Enter keywords delimited by commas"
                                        value="${fieldValue(bean: itemMasterExtInstance, field: "keywords")}"
                                />
                            </td>
                            <td>
                                <input type="text" name="imageAltForId${itemMasterExtInstance.id}"
                                        onchange="imageAltChanged('${itemMasterExtInstance.id}', this.value)"
                                        size="35" maxlength="255" 
                                        title="Enter imageAlt delimited by commas"
                                        value="${fieldValue(bean: itemMasterExtInstance, field: "imageAlt")}"
                                />
                            </td>
                            <td>
                                <input type="text" name="imageTitleForId${itemMasterExtInstance.id}"
                                        onchange="imageTitleChanged('${itemMasterExtInstance.id}', this.value)"
                                        size="35" maxlength="255" 
                                        title="Enter imageTitle delimited by commas"
                                        value="${fieldValue(bean: itemMasterExtInstance, field: "imageTitle")}"
                                />
                            </td>
                            <td>
                                <input type="text" name="metaDescForId${itemMasterExtInstance.id}"
                                        onchange="metaDescChanged('${itemMasterExtInstance.id}', this.value)"
                                        size="35" maxlength="255" 
                                        title="Enter metaDesc delimited by commas"
                                        value="${fieldValue(bean: itemMasterExtInstance, field: "metaDesc")}"
                                />
                            </td>
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
    <g:javascript>
        $('div.message').hide();
        <g:if test="${flash.message}">
           $('.message').show();
        </g:if>
    </g:javascript>    
    </body>
</html>
