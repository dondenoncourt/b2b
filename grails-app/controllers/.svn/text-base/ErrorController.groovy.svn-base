import com.kettler.domain.orderentry.share.WebUser
import org.jsecurity.SecurityUtils

public class ErrorController{

	def error = {
			if (SecurityUtils.getSubject()) {
			   	WebUser user 
	            try {
	            	if (SecurityUtils.getSubject()?.getPrincipal()) {
	            		user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	            	}
					sendMail {
						to grailsApplication.config.app.error.email.to.addresses.toArray()
						subject "KETTLER Web app error occurred."
						body( view:"/error/internalError", 
			                              plugin:"email-confirmation",
			                              model:[fromAddress:'dondenoncourt@gmail.com', user:user])
						from grailsApplication.config.app.error.email.from.address
					}
	            } catch (Exception e) {
	                log.error "Problem emailing $e.message", e
	            }
	            render (view:'error',model:[user:user])
			}
	}
	
	def failure = { 
		throw new RuntimeException('Error email test. Please ignore.')
	}
	def download = {
		def file = new File(params.fileDir)    
		response.setContentType("application/octet-stream")
		response.setHeader("Content-disposition", "attachment;filename=${file.getName()}")

		response.outputStream << file.newInputStream() // Performing a binary stream copy	
	}
}
