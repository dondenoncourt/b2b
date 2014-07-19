<%@ page import="com.kettler.domain.orderentry.ContractPrice" %>
<%@ page import="com.kettler.domain.item.share.ItemMaster" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<%@ page import="com.kettler.domain.actrcv.share.Customer" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	    <% if (params?.popup) { %>
			<meta name="layout" content="popup" />
		<% } else { %>
			<meta name="layout" content="main" />
		<% } %>
        <title>Contract Price List</title>
    </head>
    <body>
        <div class="body">
            <h1>Contract Price List</h1>
            <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
			<g:form action="list" method="post" >
	             <div>
	             	<span class="prompt">Item No: </span><g:textField name="itemNo" value="${params.itemNo}"/>
			        <jsec:hasRole name="${Role.KETTLER}">
						<span class="prompt">Cust No:</span><g:textField name="custNo" size="7" value="${params.custNo}"/>                                           
			        </jsec:hasRole>        
			        <%-- turn off until John merges future and expired that are in oefprc and oexprc to the standard contract price file
			        <span class="prompt">Dates: </span>
			        		<g:select name="dateType" from="${['A', 'C', 'F', 'X']}" onchange="this.form.submit();" valueMessagePrefix="contractPrice.dateType" value="${params.dateType}"/>
			        --%>
			        <input type="hidden" name="dateType" value="C"/>
			        <jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
			        	<br/>
						<span class="prompt">Cust No: </span><g:select name="custNo" from="${customers}" optionKey="custNo" value="${params.custNo}" noSelection="${['':'All']}"/>
						<br/>
					</jsec:hasAnyRole>                    
	              </div>
                  <g:if test="${params.rootLink}">
                    <g:hiddenField name="rootLink" value="true" />
                  </g:if>
				<div class="buttons" >
	      			<g:submitButton class="search" name="search" value="Search" title="Click to search for prices"/>
				</div>
			</g:form>
			<br/>
            <div class="list">
                <table style="width:100%;">
                    <thead>
                        <tr>
                        	<jsec:hasRole name="${Role.KETTLER}">
	                            <g:if test="${sortable}">
		                   	        <kettler:sortableColumn property="custNo" title="Cust No"/>
		                   	        <th>Name</th>
		                   	        <kettler:sortableColumn property="itemNo" title="Item No" />
		                   	        <th>Desc</th>
		                   	        <kettler:sortableColumn property="unitPrice1" title="Price" />
		                   	        <th>Begins</th>
		                   	        <th>Expires</th>
								</g:if>
								<g:else>
		                   	        <th>Cust No</th>
		                   	        <th>Name</th>
		                   	        <th>Item No</th>
		                   	        <th>Desc</th>
		                   	        <th>Price</th>
		                   	        <th>Begins</th>
		                   	        <th>Expires</th>
								</g:else>              	
							</jsec:hasRole>          
                        	<jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">  
	                   	        <th>Cust No</th>
	                   	        <th>Name</th>
							</jsec:hasAnyRole>                 	
   					        <jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP_ADMIN,Role.REP,Role.CUSTOMER,Role.CUST_ADMIN]}">  
	                   	        <th>Item No</th>
	                   	        <th>Desc</th>
	                   	        <th>Price</th>
	                   	        <th>Begins</th>
	                   	        <th>Expires</th>
							</jsec:hasAnyRole>                      	
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${cpList}" status="i" var="contractPrice">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
   					        <jsec:hasAnyRole in="${[Role.KETTLER, Role.REP_PLUS, Role.REP, Role.REP_ADMIN]}">  
	                   	        <td>${contractPrice.custNo}</td> 
	                   	        <td>${(Customer.findByCompCodeAndCustNo(contractPrice.compCode, contractPrice.custNo)?.name)}</td> 
   					        </jsec:hasAnyRole>        
							<td>${contractPrice.itemNo}</td>
							<td>${(ItemMaster.findByItemNo(contractPrice.itemNo)?.desc.encodeAsHTML().replaceAll(/&amp;/,'&#38;'))}</td>
                            <td class="number">${contractPrice.unitPrice1}</td>
                            <td><g:formatDate date="${contractPrice.beginDate}" format="MM/dd/yy"/></td>
                            <td><g:formatDate date="${contractPrice.expireDate}" format="MM/dd/yy"/></td>
                        </tr>
                    </g:each>
	                    <g:if test="${!cpList}">
                    	<tr><td colspan="4" class="comment">No records found</td></tr>
                    </g:if>
                    </tbody>
                </table>
            </div>
            <g:if test="${cpList}">
	            <div class="paginateButtons">
                	<g:paginate total="${cpCount}" params="${params}" />
    	        </div>
					<div class="buttons">
						<span class="menuButton">
							<g:if test="${params.popup}">
									<a class="home" href="#" onclick="window.close();" title="Click to close">Close</a>
							</g:if>
                            <g:if test="${!params.rootLink}">
     						    <a class="table" href="${createLinkTo(dir:'customer')}/show?compCode=${params.compCode}&custNo=${params.custNo}&popup=${params.popup}" title="Click to return to Customer Inquiry">Back</a>
                            </g:if>
						</span>
					</div>
            </g:if>
        </div>
    </body>
</html>
