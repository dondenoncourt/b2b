import org.jsecurity.authc.credential.*
import org.jsecurity.authc.*
import org.jsecurity.SecurityUtils
import org.jsecurity.crypto.hash.Sha1Hash

import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class LoginController {
    def beforeInterceptor = {
            log.debug "action: $actionName params: $params flash: $flash"
        }
        def afterInterceptor = {
            log.debug "after action: $actionName params: $params"
        }

	def loginRedirect = {
    	render(view:'login')
    }
        
	def login = {LoginCommand cmd ->
		WebUser user
	    if (!cmd.hasErrors()) {
	        user = WebUser.findByEmailIlike(cmd.email)//SecurityUtils.getSubject()?.getPrincipal());
	    }
		log.debug " login session.preLoginURL ${session.preLoginURI} before check"
		if (user) {
			log.info "log on: ${user?.firstname} ${user?.lastname} ${user?.email}"
			user.lastLogin = new Date()
			user.save(flush:true)
	        if (user.role.name == Role.REP_ADMIN) {
	        	user.metaClass.getCustomers = {
	        			return Customer.findAllBySalespersonCode(delegate.user.salesperson.id)
	        	}
	        }
	        if (user.role.name == Role.KETTLER) {
	        	session.maxInactiveInterval = (120 * 60) // 2 hours
	        }
			session.userinfo = "${user?.firstname} ${user?.lastname} ${user?.email}"
		}
		if (session.preLoginURI != null && !session.preLoginURI.contains('login') && !session.preLoginURI.contains('null') ) {
			log.debug " login session.preLoginURL ${session.preLoginURI} after check" 
			redirect(url:"${CH.config.grails.serverURL}${session.preLoginURI}")
			return
		}
		[cmd:cmd,user:user]
	}
	def logoff = { 
   	    SecurityUtils.subject?.logout()
   	    render view:'login'
    }
	def requestLogin = {
		if (params.email && (params.custRepNo || params.storeRepName)) {
			params.custRepNo = params.custRepNo.toUpperCase() 
            try {
				sendMail {
					to (['webmaster@kettlerusa.com'])
					subject "KETTLER Web app login request."
					body "$params.email with Cust/Rep No: $params.custRepNo and Store/Rep name: $params.storeRepName requests access"
					from grailsApplication.config.app.error.email.from.address
				}
            } catch (Exception e) {
                log.error "Problem emailing $e.message", e
            }
			flash.message = "Your KETTLER login request has been received, you will receive an email when it is completed."
		} else {
			flash.message = "Please enter the email address on file with KETTLER, your Customer or Rep number, and your Store or Rep name"
		}
	}
    def emailPassword = {
    	WebUser user = WebUser.findByEmail(params.email)
    	if (user) {
    		def tempPassword = "KettlerUSA"+Math.abs(new Random().nextInt()) 
    		user.password = new Sha1Hash(tempPassword).toHex()
			assert user.save()
			sendMail {
				to (params.email)
				subject "KETTLER Web application information."
				body "$user.firstname, your case-sensitive temporary password is $tempPassword. Please change it as soon as you log in."
				from grailsApplication.config.app.error.email.from.address
			}
			render "Your temporary password has been emailed to you."
    	} else {
    		render "The email you entered is not on file."
    	}
    }
    def changePassword = {ChangePasswordCommand cmd ->
    	if (cmd.password && !cmd.hasErrors()) {
        	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
        	user.password = cmd.password
			user.password = new Sha1Hash(cmd.password).toHex()
        	if (user.save()) {
        		render view:'login', model:[cmd:null,user:user]
        		return
        	} else {
                user.errors.allErrors.each { log.error it }
        		flash.message = "error on save of user"
        	}
    	}
        [cmd:cmd]
    }
}
class LoginCommand {
	String email
    String password
    String custNo
    def jsecSecurityManager
    boolean authenticate() {
        try {
            def authToken = new UsernamePasswordToken(email?.trim()?:'', password)
        	this.jsecSecurityManager.login(authToken)
            return true
        } catch (e) {
            return false
        }
    }
    static constraints = {
    	email blank:false, validator:{ val, cmd ->
    		def user = WebUser.findByEmailIlike(cmd.email?.trim()?:'')
			if(cmd.authenticate()) {
				if (user.loginFail) {
					user.loginFail = 0
					user.save(flush:true)
				}
				return true
			} else {
				if (user) {
					user.loginFail++
					if (user.loginFail >= 5) {
						user.password = 'disabled, and, as it is not SHAed, will not work'
					}
					user.save(flush:true)
					if (user.loginFail >= 5) {
						return "loginCommand.login.attempts.exceeded"
					} 
				}
				return "loginCommand.login.failed"
			}
        }
    }
}
class ChangePasswordCommand {
    String password
    String password2
    static constraints = {
    	password (minSize:8,maxSize:100,blank:false, validator:{ password, cmd ->
             if(password != cmd.password2) {
                 return 'repeat.no.match'
             }
             if (!(password ==~  /^.*(?=\w*[A-Z])(?=\w*[0-9])\w*$/) ) {
            	return 'regex.invalid'
           	}
    	})
    }
}

