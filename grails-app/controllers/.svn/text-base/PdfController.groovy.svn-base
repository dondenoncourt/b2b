import grails.util.Environment
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH


class PdfController {

    PdfService pdfService
    def mailService
	
	def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
    def afterInterceptor = {model ->
        log.debug("action: $actionName model: $model")
    }

    def index = {
        redirect(action: show)
    }

    def show = {
    	def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort +  grailsAttributes.getApplicationUri(request)
    	if (Environment.current == Environment.PRODUCTION) {
    		baseUri = "http://localhost" +  grailsAttributes.getApplicationUri(request)
    	}
        log.debug "BaseUri is $baseUri"

        params.url = params.url.replaceAll("-AMPERSAND-", '&')
        params.url = params.url.replaceAll("-EQUALS-", '=')
        def url = baseUri + params.url
        log.debug "Fetching url $url"

        byte[] bytes = pdfService.buildPdf(url)

        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + (params.filename ?: "document.pdf"))
        response.setContentLength(bytes.length)
        response.getOutputStream().write(bytes)

        if (params.emails) {
	        try {
	            mailService.sendMail {
	            	multipart true
	                to params.emails.tokenize(',')
	                subject "KETTLER International, Inc. Return Authorization"
	                body "Attached is your return authorization"
	                from "info@kettlerusa.com"
	                attachBytes "return_authorization.pdf", "application/pdf", bytes  
	            }
	        } catch (Exception e) {
	            log.error "Problem emailing $e.message", e
	        }
        }

    }
}

