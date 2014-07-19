import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.UserControl
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.share.SalesPerson 
import com.kettler.domain.actrcv.share.Customer


import org.jsecurity.crypto.hash.Sha1Hash
import org.jsecurity.SecurityUtils

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class WebUserController {
    def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
    def afterInterceptor = {model ->
        log.debug("action after: $actionName model: $model")
    }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']
	def imageDownload = {
		def webUser = WebUser.get(params.id)
		assert webUser
		webUser.imageDownload = params.yesNo == 'true'?true:false
		webUser.save()
		println webUser.dump()
		render "${webUser.firstname} ${webUser.lastname} image download ${webUser.imageDownload?'en':'dis'}abled."	
	}
    def list = {
        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal());
		params.max = params.max?:'20'
		params.offset = params.offset?:'0'
		if (params.email || params.lastname || params.custNo || params.salespersonCode) {
        	def webUserList = WebUser.withCriteria {
        		if (params.email)    ilike('email', "${params.email}%")
        		if (params.lastname) ilike('lastname', "${params.lastname}%")
        		if (params.custNo) ilike('custNo', "${params.custNo}%")
        		if (params.salespersonCode) eq('salesperson', SalesPerson.get(params.salespersonCode))
        		if (user.role.name == Role.CUST_ADMIN) {
        			eq('compCode', user.compCode)
        			eq('custNo',   user.custNo)
        		} 
				if (params.sort) order (params.sort, params.order)
                maxResults(Integer.parseInt(params.max))
                firstResult(Integer.parseInt(params.offset))
        	}
            def countArray = WebUser.withCriteria(unique:true) {
        		if (params.email)    ilike('email', "${params.email}%")
        		if (params.lastname) ilike('lastname', "${params.lastname}%")
        		if (params.custNo) ilike('custNo', "${params.custNo}%")
        		if (params.salespersonCode) eq('salesperson', SalesPerson.get(params.salespersonCode))
        		if (user.role.name == Role.REP_ADMIN) eq('salesperson.id', user.salesperson.id)
        		if (user.role.name == Role.CUST_ADMIN) {
        			eq('compCode', user.compCode)
        			eq('custNo',   user.custNo)
        		}
                projections {rowCount()}
            }	
			println "webUserTotal count:"+countArray[0]
			
        	[ webUserList: webUserList, webUserTotal:countArray[0]]
			
		} else {
	        if (user.role.name == Role.SUPER_ADMIN) {
	        	[ webUserList: WebUser.list( params ), webUserTotal: WebUser.count() ]
	        } else if (user.role.name == Role.REP_ADMIN) {
	        	def webUserList = WebUser.withCriteria {
	        		eq('salesperson.id', user.salesperson.id)
					if (params.sort) order (params.sort, params.order)
	                maxResults(Integer.parseInt(params.max))
	                firstResult(Integer.parseInt(params.offset))
	        	}
	            def countArray = WebUser.withCriteria(unique:true) {
	                projections {rowCount()}
	           		eq('salesperson.id', user.salesperson.id)
	            }	
	        	[ webUserList: webUserList, webUserTotal:countArray[0]]
	        } else if (user.role.name == Role.CUST_ADMIN) {
	        	[ webUserList: WebUser.findAllByCompCodeAndCustNo(user.compCode, user.custNo, params ), 
	        	  webUserTotal: WebUser.countByCompCodeAndCustNo(user.compCode, user.custNo) ]
	        } else if (user.role.name == Role.KETTLER) {
	        	def webUserList = WebUser.withCriteria {
	        		'in'('role', [Role.getNo(Role.CUST_ADMIN), Role.getNo(Role.CUSTOMER)])
					if (params.sort) order (params.sort, params.order)
	                maxResults(Integer.parseInt(params.max))
	                firstResult(Integer.parseInt(params.offset))
	        	}
	            def countArray = WebUser.withCriteria(unique:true) {
	                projections {rowCount()}
	        		'in'('role', [Role.getNo(Role.CUST_ADMIN), Role.getNo(Role.CUSTOMER)])
	            }	
	        	[ webUserList: webUserList, webUserTotal:countArray[0]]
	        }
		}
    }

    def show = {
        def webUser = WebUser.get( params.id )

        if(!webUser) {
            flash.message = "WebUser not found with id ${params.id}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/list")
        }
        else { return [ webUser : webUser ] }
    }

    def delete = {
        def webUser = WebUser.get( params.id )
        if(webUser) {
            try {
                webUser.delete()
                flash.message = "WebUser ${params.id} deleted"
                redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/list")
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "WebUser ${params.id} could not be deleted"
                redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/show/${params.id}")
            }
        }
        else {
            flash.message = "WebUser not found with id ${params.id}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/list")
        }
    }

    def edit = {
        def webUser = WebUser.get( params.id )

        if(!webUser) {
            flash.message = "WebUser not found with id ${params.id}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/list")
        }
        else {
            return [ webUser : webUser ]
        }
    }

    def update = {
        def webUser = WebUser.get( params.id )
        log.debug "updating: $webUser.email custNo:$webUser.custNo salesperson:$webUser.salesperson firstname:$webUser.firstname lastname:$webUser.lastname" 
        if(webUser) {
            if(params.version) {
                def version = params.version.toLong()
                if(webUser.version > version) {
                    webUser.errors.rejectValue("version", "webUser.optimistic.locking.failure", "Another user has updated this WebUser while you were editing.")
                    render(view:'edit',model:[webUser:webUser])
                    return
                }
            }
            if (!params.password.size()) {
            	params.remove('password')
            }
            webUser.properties = params
            WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal());
            if (user.role.name != Role.SUPER_ADMIN) {
            	webUser.compCode = user.compCode
            	webUser.custNo = user.custNo
            } else { // set from cust/rep 
//            	webUser.compCode  = 
            }
            
            if (params.password && !(params.password ==~  /^.*(?=\w*[A-Z])(?=\w*[0-9])\w*$/) ) {
            	webUser.errors.rejectValue('password', 'webUser.password.matches.invalid')
            }
    		if (!webUser.hasErrors() && webUser.validate() && params.password) {
    			webUser.password = new Sha1Hash(webUser.password).toHex()
    		}
    		webUser.loginFail = 0
            if(!webUser.hasErrors() && webUser.save()) {
                flash.message = "WebUser ${params.id} updated"
                redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/show/$webUser.id")
            } else {
                render(view:'edit',model:[webUser:webUser])
            }
        }
        else {
            flash.message = "WebUser not found with id ${params.id}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/edit/$params.id")
        }
    }

    def create = {
        def webUser = new WebUser()
        webUser.properties = params
   		def customers 
        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal());
        if (user.role.name == Role.REP_ADMIN) {
        	customers = user.customers
        }
        return [webUser:webUser, customers:customers]
    }

    def save = {
    	params.custNo = params.custNo?.toUpperCase()
    	int role = params.role.toInteger()
    	params.remove('role')
        def webUser = new WebUser(params)
        webUser.role = new Role(role:role)
        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal());
    	if (user.role.name != Role.SUPER_ADMIN && 
        	(user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN || user.role.name == Role.CUST_ADMIN) ) {
        	webUser.custNo = user.custNo
        }
        if (user.role.name == Role.REP_ADMIN) {
        	webUser.salesperson = SalesPerson.get(user.salesperson.id)
        }
        if (!(params.password ==~  /^.*(?=\w*[A-Z])(?=\w*[0-9])\w*$/) ) {
        	webUser.errors.rejectValue('password', 'webUser.password.matches.invalid')
        }
		if (!webUser.hasErrors() && webUser.validate()) {
			webUser.password = new Sha1Hash(webUser.password).toHex()
		}
        if(!webUser.hasErrors() && webUser.save()) {
            flash.message = "WebUser ${webUser.email} created"
            redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}webUser/list");//show/$webUser.id")
	    return
        } else {
        	def customers
            if (user.role.name == Role.REP_ADMIN) {
            	customers = user.customers
            }
            render(view:'create',model:[webUser:webUser,customers:customers])
        }
    }
}
