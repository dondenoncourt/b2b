import com.kettler.domain.orderentry.ContractPrice
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role

import com.kettler.domain.actrcv.share.Customer

import com.kettler.domain.work.DateUtils

import org.jsecurity.SecurityUtils

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class ContractPriceController {
    
    def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = '20'
        if(!params.offset) params.offset = '0'
        if(!params.sort) params.sort = 'itemNo'
        if(!params.order) params.order = 'asc'
        if (!params.dateType) params.dateType = "C"
        def cpList
        def cpCount = 0

        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
       	def customers
       	if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
       		customers = user.customers
       		log.debug "Rep: $user.salesperson.id with ${customers.size()}"
       	}

        boolean sortable = true
        
		int nowYMD = DateUtils.getNowYMD()
       	// note: All, Future, and Expired filters turned off until John merges future and expired that are in oefprc and oexprc to the standard contract price file
        if (params.itemNo || params.custNo              || 
        	(params.dateType && params.dateType != "A") ||
        	user.role.name == Role.REP_ADMIN            ||
        	user.role.name == Role.CUST_ADMIN           ||
        	user.role.name == Role.REP                  ||
        	user.role.name == Role.REP_PLUS             ||
        	user.role.name == Role.CUSTOMER               ) {
        	sortable = false
            def queryParams = []
            def query = "from ContractPrice cp where "
    		if (params.itemNo) {
    			params.itemNo = params.itemNo.toUpperCase() 
    			if (queryParams.size()) query += ' AND '
    			query += 'cp.itemNo = ? ' 
    			queryParams << params.itemNo
    		}
    		if (params.custNo || user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
    			if (params.custNo) {
    				params.custNo = params.custNo.toUpperCase()
    			}
    			if (queryParams.size()) query += ' AND '
    			query += 'cp.custNo = ? ' 
    		    if ( user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
    		    	queryParams << user.custNo
    		    } else {
    		    	queryParams << params.custNo 
    		    }
    		}
    		if (!params.custNo && (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN)) {
    			if (!customers.size()) {
    				flash.message = 'Contract pricing inquiry aborted as you have no customers'
    		        redirect controller:'itemMaster', action:'item'
    			}
    			if (queryParams.size()) query += ' AND '
        		query += " cp.custNo in ("
        		customers.each {cust ->
        			query += "\'${cust.custNo}\', "
        		}
        		query = query.replaceAll(/, $/, '') //	remove trailling comma
    			query += ") "
    			if (!queryParams.size() && params.dateType && params.dateType != "A" ) query += ' AND ' 
    		}
    		if (params.dateType && params.dateType != "A") {
    			if (queryParams.size()) query += ' AND '
    			queryParams << nowYMD
    			switch (params.dateType) {
    			case 'C': // current
    				query += ' ? BETWEEN mod((cp.beginDate * 10000.01), 1000000) AND mod((cp.expireDate * 10000.01), 1000000) '
        			break
    			case 'F': // future 
    				query += ' mod((cp.beginDate * 10000.01), 1000000) > ? '
        			break
    			case 'X': // expired  
    				query += ' mod((cp.expireDate * 10000.01), 1000000) < ? '
        			break
    			}
    		}
    		log.debug "ContractPrice list query: $query queryParams $queryParams, [max:${params.max.toInteger()}, offset:${params.offset.toInteger()}])"			
			cpList = ContractPrice.executeQuery(query, queryParams, [max:params.max.toInteger(), offset:params.offset.toInteger()]) 
			cpCount = ContractPrice.executeQuery("select count(*) " + query, queryParams)[0]
    		log.debug "ContractPrice list query returned $cpCount rows"			
        } else {
        	cpList = ContractPrice.list(params)
        	cpCount = ContractPrice.count()
        }
        [ cpList: cpList, cpCount:cpCount, customers:customers, sortable:sortable, params:params ]
    }

    def show = {
        return [ contractPriceInstance : getContractPrice(params) ]
    }

    def delete = {
    	def contractPrice = getContractPrice(params)

        if(contractPrice) {
            ContractPrice.delete()
            flash.message =  "contractPrice "+getKey(contractPrice) + " deleted"
        }  else {
           	flash.message  = "ContractPrice not found with key:"+getKey(contractPrice)
        }
        redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}contractPrice/list")
    }

    def edit = {
       	def contractPrice = getContractPrice(params)

        if(!contractPrice) {
           	flash.message  = "ContractPrice not found with key:"+getKey(contractPrice)
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}contractPrice/list")
        }
        else {
            return [ contractPriceInstance : contractPrice ]
        }
    }

    def update = {
    	def contractPrice = getContractPrice(params)

        if(contractPrice) {
            contractPrice.properties = params
            if(!contractPrice.hasErrors() && contractPrice.save()) {
               	flash.message  = "contractPrice with key:"+getKey(contractPrice)+" updated"
               	def url = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}contractPrice/show?"
               	params.each {name, value -> url += name+'='+value+'&' } 
               	redirect(url:url)
            }  else {
                render(view:'edit',model:[contractPriceInstance:contractPrice])
            }
        }  else {
            flash.message = "contractPrice not found with key:"+getKey(contractPrice)
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}contractPrice/edit/$params.id")
        }
    }

    def create = {
        def contractPrice = new ContractPrice(newEntity:true)
        contractPrice.properties = params
        return ['contractPriceInstance':contractPrice]
    }

    def save = {
        def contractPrice = new ContractPrice(params)

       	

        if(!contractPrice.hasErrors() && contractPrice.save(insert:contractPrice.newEntity) ) {
            flash.message = "ContractPrice created"  
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}contractPrice/list")
            return 
        }
        render(view:'create',model:[contractPriceInstance:contractPrice])        
    }

    
    /*
     * the following private methods were coded to handle legacy assigned keys
     * The code intermixes the use of generated unique id columns
     * It should not be necessary to understand or modify the internals of these methods
     * Note that gen'd code depends on if the id is composite 
     */
     
    // Return a String representation of the key
    private String getKey(def contractPrice) {
        
        	def key = ""
    	    // get legacy composite key as was mapped to the domain
	    	contractPrice.mapping.getDelegate()?.mapping?.identity?.propertyNames.each { keyField ->
			    key += " ${keyField}:"
				key += contractPrice."$keyField"
	    	}
	    	return key
    	
	}

    private ContractPrice getContractPrice(params) {
       	
    		return ContractPrice.get( new ContractPrice(params) )
        	
    }
}
