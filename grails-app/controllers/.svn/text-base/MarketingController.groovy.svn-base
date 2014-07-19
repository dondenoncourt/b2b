import com.kettler.domain.orderentry.share.Consumer

class MarketingController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def beforeInterceptor = {
         log.debug "action: $actionName params: $params flash: $flash"
    }

	def promptMassRetailEmail = {
		render view:'massRetailEmail', model: [kount: Consumer.countByMarketing(true), params:params]
	}
	def massRetailEmail = {
		if (!params.subject || !params.from || !params.body) {
			flash.message = "Please fill in all fields"
			redirect action:'promptMassRetailEmail ' 
			return
		}
		Consumer.findAllByMarketing(true).each {consumer ->
			try {
				sendMail {
					to consumer.email 
					subject params.subject
					if (params.html) {
						html params.body
					} else {
						body params.body
					}
					from params.from
				}
			} catch (e) {
				sendMail {
					to grailsApplication.config.app.error.email.to.addresses.toArray()
					subject "KETTLER mass email error occurred, probably bad email address."
					body(e.toString() )
					from grailsApplication.config.app.error.email.from.address
				}
			}
		}
		flash.message = "Mass Retail Marketing email sent"
		redirect action:'promptMassRetailEmail '
	}	

}
