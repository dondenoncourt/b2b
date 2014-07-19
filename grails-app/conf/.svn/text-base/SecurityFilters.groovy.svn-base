import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class SecurityFilters {
	def httpRequest

    def filters = {
        all(controller:'*', action:'*') {
            before = {
            	httpRequest = request 
				if (actionName != 'error' && actionName != 'login' && actionName != 'requestLogin' && actionName != 'loginRedirect'  && actionName != 'emailPassword'
					&& actionName != 'createCreditMemo' && actionName != 'total'
					&& !params.pdf) {
	                accessControl {
	            		role("Customer") | role("Rep Plus") | role("Rep") | role("Kettler") | role("Customer Admin") | role("Rep Admin") | role("Super Admin") 
	            	}
            	}
            }
            after = {}
            afterView = {}
        }
        order(controller:'order', action:'*') {
            before = {
            	if (!params.pdf) {
	                accessControl {
	            		role("Customer") | role("Rep Plus") | role("Rep") | role("Customer Admin") | role("Rep Admin") | role("Kettler") | role("Admin") | role("Super Admin") 
	            	}
            	}
            }
            after = {}
            afterView = {}
        }
        salesAnalysis(controller:'salesAnalysis', action:'*') {
            before = {
            	if (!params.pdf) {
	                accessControl {
	            		role("Customer") | role("Rep Plus") | role("Rep") | role("Customer Admin") | role("Rep Admin") | role("Rep") | role("Kettler")   
	            	}
            	}
            }
            after = {}
            afterView = {}
        }
        returns(controller:'returns', action:'*') {
            before = {
            	if (!params.pdf && actionName != 'createCreditMemo' && actionName != 'total') {
	                accessControl {
	            		role("Customer") | role("Rep Plus") | role("Rep") | role("Customer Admin") | role("Rep Admin") | role("Rep") | role("Kettler") | role("Super Admin")
	            	}
            	}
            }
            after = {}
            afterView = {}
        }
        webUser(controller:'webUser', action:'create') {
            before = {
            	println "SecurityFilters webUser actionName: ${actionName}"
                accessControl {
            		role("Cust Admin") | role("Rep Admin") | role("Super Admin")
            	}
            }
            after = {}
            afterView = {}
        }
    }
    def onNotAuthenticated(subject, d) {
		log.debug "onNotAuthenticated onNotAuthenticated onNotAuthenticated request URI: ${httpRequest.forwardURI}"
		httpRequest.request.session.preLoginURI = httpRequest.forwardURI
		if (httpRequest.queryString?.size()) {
			httpRequest.request.session.preLoginURI += '?'+httpRequest.queryString 
		}
        d.redirect(url:"${CH.config.grails.serverURL}/kettler/login/loginRedirect")
    }

}
