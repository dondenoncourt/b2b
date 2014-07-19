<%=packageName ? "import ${packageName}.${className}" : ''%>            
class ${className}Controller {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ ${propertyName}InstanceList: ${className}.list( params ) ]
    }

    def show = {
        return [ ${propertyName}Instance : get${className}(params) ]
    }

    def delete = {
    	def ${propertyName} = get${className}(params)

        if(${propertyName}) {
            ${propertyName}.delete()

            <% if (domainObject?.COMPOSITE_KEY) {  %>
                flash.message =  "${className} "+getKey(${propertyName}) + " deleted"
           	<% } else { %>
            	flash.message = "${className} \${params.id} deleted"
            <% } %>
            redirect(action:list)
        }  else {
            <% if (domainObject?.COMPOSITE_KEY) {  %>
            	flash.message  = "${className} not found with key:"+getKey(${propertyName})
           	<% } else { %>
                flash.message = "${className} not found with id \${params.id}"
            <% } %>
            redirect(action:list)
        }
    }

    def edit = {
       	def ${propertyName} = get${className}(params)

        if(!${propertyName}) {
           	flash.message  = "${className} not found with key:"+getKey(${propertyName})
            redirect(action:list)
        }
        else {
            return [ ${propertyName}Instance : ${propertyName} ]
        }
    }

    def update = {
    	def ${propertyName} = get${className}(params)

        if(${propertyName}) {
            ${propertyName}.properties = params
            if(!${propertyName}.hasErrors() && ${propertyName}.save()) {
               	flash.message  = "${className} with key:"+getKey(${propertyName})+" updated"
                redirect(action:list)
            }  else {
                render(view:'edit',model:[${propertyName}Instance:${propertyName}])
            }
        }  else {
            flash.message = "${className} not found with key:"+getKey(${propertyName})
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def ${propertyName} = new ${className}(newEntity:true)
        ${propertyName}.properties = params
        return ['${propertyName}Instance':${propertyName}]
    }

    def save = {
        def ${propertyName} = new ${className}(params)

       	<% if (!domainObject.COMPOSITE_KEY) {  %>
        	<% if (domainObject?.properties?.id?.class?.name) {  %>
			        	try {
			        		${propertyName}.id = new ${(domainObject.properties.id.class.name)}(params.id)
			        	} catch (NumberFormatException e) {
			        		flash.message = "Invalid key value: \${params.id}"
			                render(view:'create',model:[${propertyName}:${propertyName}])        
			                return
			        	}
        	<% } else { %>
        		${propertyName}.id = params.id
        	<% } %>
       <% } %>

        if(!${propertyName}.hasErrors() && ${propertyName}.save(insert:${propertyName}.newEntity) ) {
            flash.message = "${className} created"  
            redirect(action:list)
            return 
        }
        render(view:'create',model:[${propertyName}Instance:${propertyName}])        
    }

    
    /*
     * the following private methods were coded to handle legacy assigned keys
     * The code intermixes the use of generated unique id columns
     * It should not be necessary to understand or modify the internals of these methods
     * Note that gen'd code depends on if the id is composite 
     */
     
    // Return a String representation of the key
    private String getKey(def ${propertyName}) {
        <% if (domainObject?.COMPOSITE_KEY) {  %>
        	def key = ""
    	    // get legacy composite key as was mapped to the domain
	    	${className}.mapping.getDelegate()?.mapping?.identity?.propertyNames.each { keyField ->
			    key += " \${keyField}:"
				key += ${propertyName}."\$keyField"
	    	}
	    	return key
    	<% } else { %>
    		return ${propertyName}.id
    	<% } %>
	}

    private ${className} get${className}(params) {
       	<% if (domainObject?.COMPOSITE_KEY) {  %>
    		return ${className}.get( new ${className}(params) )
        	<% } else { %>
    	return ${className}.get( params.id )
    	<% } %>
    }
}
