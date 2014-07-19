<%@ page import="com.kettler.domain.item.share.ItemMasterExt" %>
<%@ page import="com.kettler.domain.item.share.Dealer" %>
<%@ page import="com.kettler.domain.item.share.WebDivision" %>
<%@ page import="com.kettler.domain.item.share.WebCategory" %>
<%@ page import="com.kettler.domain.item.share.WebDivision %>
<%@ page import="com.kettler.domain.warranty.share.WarrantyPeriod" %>
<%@ page import="com.kettler.domain.comparator.DealerComparator" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="Item Master Extension Edit" />
        <title>Item Master Extension Edit</title>
        <g:javascript src="jquery/jquery-1.4.2.min.js" />
   
		<g:javascript>
			$(document).ready(function() {
				$('#division').change(function() {
				    var params = '&divisionId='+$('#division').val()
			        $.ajax({
			           url: "${createLink(action:'catsByDiv')}",
			           data: params,
			           type: 'POST',
			           success: function(data) { $('#categoryBox').html(data) },
			           error: function(xhr,textStatus, errorThrown) { alert("categoryBox") }
			        });
			    });
			    $('#itemForm').submit(function () {
			    	if (itemForm['category.id'].value == '') {
			    		alert("Please select a category" + itemForm['category.id'].value);
			    		return false;
			    	}
			    	return true;	
			    });
			});
            $('#accessories').click(function() {
                alert(this.val());
                $.map($('#accessories :selected'), function(e) { alert( $(e).text()); })
            });
		</g:javascript>
    </head>
    <body>
        <div class="body">
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">Item Master Extension List</g:link></span>
            <span class="menuButton"><g:link class="list" action="itemMasterList">Item Master List</g:link></span>
        </div>
        <div class="body">
            <h1>Item Master Extension Edit</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${item}">
            <div class="errors">
                <g:renderErrors bean="${item}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="itemForm" method="post" >
                <g:hiddenField name="id" value="${item?.id}" />
                <g:hiddenField name="version" value="${item?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                       
                            <tr class="prop">
                                <td valign="top" class="name" >
                                  <label for="itemNo">ItemNo:Desc</label>
                                </td>
                                <td valign="top" class="value" align="left">
                                    ${fieldValue(bean: item, field: "itemNo")}:
                                    ${fieldValue(bean: item, field: "desc")}
                                </td>
                                <td valign="top" class="name" >
                                  <label for="inactive">Show Code (archive)</label>
                                </td>
                                <td valign="top" class="value" align="left">
                                    <select name="inactive"> 
                                   		<option value="N" ${(item.inactive=='N')?'selected="selected"':''} >Don't show in retail</option>
                                   		<option value="S" ${(item.inactive=='S')?'selected="selected"':''} >Show in retail</option>
                                   		<option value="R" ${(item.inactive=='R')?'selected="selected"':''} >Archive</option>
                                    </select>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="division"><g:message code="itemMasterExt.division.label" default="Division" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'division', 'errors')}">
                                    <g:select name="division.id" id="division"
                                    		from="${WebDivision.list()}" value="${item?.division?.id}"
                                    		optionValue="name"
                                    		optionKey="id"  noSelection="['':'Please Select...']" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="category"><g:message code="itemMasterExt.category.label" default="Category" /></label>
                                </td>
                                <td id="categoryBox" valign="top" class="value ${hasErrors(bean: item, field: 'category', 'errors')}">
                                     <g:select name="category.id" id="category"
			                            	from="${item?.division?.categories}" value="${item?.category?.id}" 
			                            	optionValue="name"
			                            	optionKey="id" noSelection="['':'Please Select...']"/>
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="collection"><g:message code="itemMasterExt.collection.label" default="Collection" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'collection', 'errors')}" align="left">
                                    <g:textField name="collection" value="${item?.collection}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="retailPrice">MSRP / Special Price</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'specialPrice', 'errors')} ${hasErrors(bean: item, field: 'msrp', 'errors')}">
                                    <g:textField name="msrp" value="${fieldValue(bean: item, field: 'msrp')}" size="9" />
                                    <g:textField name="specialPrice" value="${fieldValue(bean: item, field: 'specialPrice')}"  size="9" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="retail"><g:message code="itemMasterExt.retail.label" default="Retail" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'retail', 'errors')}">
                                    <g:checkBox name="retail" value="${item?.retail}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="retailPrice"><g:message code="itemMasterExt.retailPrice.label" default="Web Price" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'retailPrice', 'errors')}">
                                    <g:textField name="retailPrice" value="${fieldValue(bean: item, field: 'retailPrice')}"  size="9"/>
                                </td>
                            </tr>
                            <tr class="prop">
                                <td/>
                                <td/>
                                <td valign="top" class="name">
                                  <label for="storeprice"><g:message code="itemMasterExt.storeprice.label" default="Store Price" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'storeprice', 'errors')}">
                                    <g:textField name="storeprice" value="${fieldValue(bean: item, field: 'storeprice')}"  size="9"/>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name" >
                                  <label for="onlyCanada">Canada</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'onlyCanada', 'errors')} ${hasErrors(bean: item, field: 'alsoCanada', 'errors')}">
                                    Only: <g:checkBox name="onlyCanada" value="${item?.onlyCanada}" />
                                    Also: <g:checkBox name="alsoCanada" value="${item?.alsoCanada}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="alsoCanada">Canadian MSRP</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'msrpCanada', 'errors')}">
                                    <g:textField name="msrpCanada" value="${fieldValue(bean: item, field: 'msrpCanada')}"  size="9"/>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="onlyLatino">Latino</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'onlyLatino', 'errors')} ${hasErrors(bean: item, field: 'alsoLatino', 'errors')} " >
                                    Only: <g:checkBox name="onlyLatino" value="${item?.onlyLatino}" />
                                    Also: <g:checkBox name="alsoLatino" value="${item?.alsoLatino}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="commercial"><g:message code="itemMasterExt.commercial.label" default="Commercial" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'commercial', 'errors')}">
                                    <g:checkBox name="commercial" value="${item?.commercial}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="kettlerStoreOnly"><g:message code="itemMasterExt.kettlerStoreOnly.label" default="Kettler Store Only" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'kettlerStoreOnly', 'errors')}">
                                    <g:checkBox name="kettlerStoreOnly" value="${item?.kettlerStoreOnly}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="parts"><g:message code="itemMasterExt.parts.label" default="Parts" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'parts', 'errors')}">
                                    <g:checkBox name="parts" value="${item?.parts}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="assemblyRequired"><g:message code="itemMasterExt.assemblyRequired.label" default="Assembly Required" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'assemblyRequired', 'errors')}">
                                    <g:checkBox name="assemblyRequired" value="${item?.assemblyRequired}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="shipToStore"><g:message code="itemMasterExt.shipToStore.label" default="ShipTo Store" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'shipToStore', 'errors')}">
                                    <g:checkBox name="shipToStore" value="${item?.shipToStore}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="storeInventory"><g:message code="itemMasterExt.storeInventory.label" default="Store Inventory" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'storeInventory', 'errors')}">
                                    <g:checkBox name="storeInventory" value="${item?.storeInventory}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="truck"><g:message code="itemMasterExt.truck.label" default="Truck" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'truck', 'errors')}">
                                    <g:checkBox name="truck" value="${item?.truck}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="closeout">Closeout</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'closeoutCode', 'errors')}">
                                    <g:checkBox name="closeoutCode" value="${item?.closeoutCode}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="specialOrder">Special Order:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'specialOrder', 'errors')} ">
                                    <g:checkBox name="specialOrder" value="${item?.specialOrder}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="specialOrder">Lead Time From/To:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'leadTimeFrom', 'errors')} ${hasErrors(bean: item, field: 'leadTimeTo', 'errors')}">
                                    <g:textField name="leadTimeFrom" value="${item?.leadTimeFrom}" class="number" size="4" /> - 
                                    <g:textField name="leadTimeTo" value="${item?.leadTimeTo}" class="number" size="4" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="warranty">Residential Warranty Period</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'residentialWarrantyCode', 'errors')}">
                                    <g:select name="residentialWarrantyCode" value="${item?.residentialWarrantyCode}" 
                                        from="${WarrantyPeriod.list()}" optionKey="id" optionValue="desc"
                                        noSelection="['':'-- none --']"
                                    />
                                </td>
                                <td valign="top" class="name">
                                  <label for="warranty">Commercial Warranty Period</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'commercialWarrantyCode', 'errors')}">
                                    <g:select name="commercialWarrantyCode" value="${item?.commercialWarrantyCode}" 
                                        from="${WarrantyPeriod.list()}" optionKey="id"  optionKey="id" optionValue="desc"
                                        noSelection="['':'-- none --']"
                                    />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="ageFrom">Age From/To</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'ageFrom', 'errors')}">
                                    <g:textField name="ageFrom" value="${fieldValue(bean: item, field: 'ageFrom')}" size="3"/>
                                    <g:textField name="ageTo" value="${fieldValue(bean: item, field: 'ageTo')}"  size="3"/>
                                </td>
                                <td valign="top" class="name">
                                  <label for="weightLimit"><g:message code="itemMasterExt.weightLimit.label" default="Weight Limit (lbs)" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'weightLimit', 'errors')}">
                                    <g:textField name="weightLimit" value="${fieldValue(bean: item, field: 'weightLimit')}" />
                                </td>
                            </tr>
                        
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="setUpWeight">Set Up Weight</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'setUpWeight', 'errors')}">
                                    <g:textField name="setUpWeight" value="${fieldValue(bean: item, field: 'setUpWeight')}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="setupHeight">Setup Length/Width/Height</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'setupHeight', 'errors')}">
                                    <g:textField name="setupLength" value="${fieldValue(bean: item, field: 'setupLength')}"  size="3"/>
                                    <g:textField name="setupWidth" value="${fieldValue(bean: item, field: 'setupWidth')}"  size="3"/>
                                    <g:textField name="setupHeight" value="${fieldValue(bean: item, field: 'setupHeight')}"  size="3"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="youTube">YouTube</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'youTube', 'errors')}">
                                    <g:textField name="youTube" value="${fieldValue(bean: item, field: 'youTube')}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="youTubeAssembly">YouTube Assembly</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'youTubeAssembly', 'errors')}">
                                    <g:textField name="youTubeAssembly" value="${fieldValue(bean: item, field: 'youTubeAssembly')}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="keywords">Keywords</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'keywords', 'errors')}">
                                    <g:textField name="keywords" value="${fieldValue(bean: item, field: 'keywords')}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="metaDesc">Meta Desc</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'metaDesc', 'errors')}">
                                    <g:textField name="metaDesc" value="${fieldValue(bean: item, field: 'metaDesc')}" />
                                </td>
                            </tr>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="imageAlt">Image Alt</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'imageAlt', 'errors')}">
                                    <g:textField name="imageAlt" value="${fieldValue(bean: item, field: 'imageAlt')}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="imageTitle">Image Title</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'imageTitle', 'errors')}">
                                    <g:textField name="imageTitle" value="${fieldValue(bean: item, field: 'imageTitle')}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="ignoreBufferStock">Ignore Buffer Stock</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'ignoreBufferStock', 'errors')}">
                                    <g:checkBox name="ignoreBufferStock" value="${item?.ignoreBufferStock}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="minQty">Min Ord Qty</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'minQty', 'errors')}">
                                    <g:textField name="minQty" value="${fieldValue(bean: item, field: 'minQty')}" />
                                </td>
                                <td valign="top" class="name">
                                  <label for="comparable">Comparable</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: item, field: 'comparable', 'errors')}">
                                    <g:checkBox name="comparable" value="${item?.comparable}" />
                                </td>
                            </tr>
                         
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="accessories">Accessories</label>
                                </td>
                                <td valign="top">
                                    <select id="accessories" name="accessories" multiple="multiple"> 
                                        <option value="0">-- none --</option>
	                                    <g:each in="${accessoryItems}" var="accessoryItem">
	                                        <option value="${accessoryItem.id}"
	                                           <% if (item.accessories.find {it.accessory.id == accessoryItem.id}) { %>selected="selected"<% } %> 
	                                        >
	                                           ${accessoryItem.desc}
	                                        </option> 
	                                    </g:each>
                                    </select>
                                </td>
                                <td valign="top" class="name">
                                  <label for="dealerId">Exclusive Dealer</label>
                                </td>
                                <td valign="top">
                                    <select id="dealerId" name="dealerId"> 
                                        <option value="0">-- none --</option>
                                        <g:each in="${Dealer.findAllByLogoIsNotNullAndWebsiteIsNotNull().sort{it.customer.name}}" var="dealer">
                                            <option value="${dealer.id}"
                                               <% if (item.dealerId == dealer.id) { %>selected="selected"<% } %> 
                                            >
                                               ${dealer.customer.name}
                                            </option> 
                                        </g:each>
                                    </select>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('Are you sure?');"  /></span>
                </div>
            </g:form>
        </div>
    </div>
    </body>
</html>
