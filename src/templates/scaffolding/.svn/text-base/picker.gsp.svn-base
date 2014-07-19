<!-- Suggested use of modalbox plugin:
grails install-plugin modalbox
To use, in the top of the calling GSP place:
<modalbox:modalIncludes />
put the following beside/below the input field:
<modalbox:createLink url="${(propertyName)}Picker.gsp?offset=1&max=10" title="Any instructions" width="600" linkname="Select link text" />
then replace, in this GSP, inputFieldIdToBeSet with the id of input field to be set from the calling GSP
-->

<table>
    <thead>
	<tr>
	<%
	    excludedProps = ['version']
	    props = domainClass.properties.findAll { !excludedProps.contains(it.name) && it.type != Set.class }
	    props.eachWithIndex { p,i ->
	       if(i < 8) { %> 
	  		     <th>${p.naturalName}</th> 
	       <% }  } %>
	</tr>
    </thead>
    <tbody>
    <g:each in="\${${(domainClass.name)}.list([offset:params.offset, max:params.max])}" status="i" var="${propertyName}">
	<tr class="\${(i % 2) == 0 ? 'odd' : 'even'}">
	<%  props.eachWithIndex { p,i ->
		if(i == 0) { %>
	    <td><a href="javascript:\$('inputFieldIdToBeSet').value='\${${propertyName}.id}';Modalbox.hide();">\${${propertyName}.${p.name}}</a></td>
	<%      } else if(i < 6) { %>
	    <td>\${${propertyName}.${p.name}?.encodeAsHTML()}</td>
	<%  }   } %>
	</tr>
    </g:each>
    
     <g:if test="\${(Integer.parseInt(params.offset) > 1 )}">
		<modalbox:createLink url="${propertyName}Picker.gsp?offset=\${(Integer.parseInt(params.offset) - Integer.parseInt(params.max))}&max=\${params.max}" title="Any instructions" width="600" linkname="Prior" />                                    
	</g:if>
	<modalbox:createLink url="${propertyName}Picker.gsp?offset=\${(Integer.parseInt(params.offset) +Integer.parseInt(params.max))}&max=\${params.max}" title="Any instructions" width="600" linkname="Next" />                                    
    
    </tbody>
</table>

