import com.kettler.domain.orderentry.share.Coupon
import org.jsecurity.SecurityUtils
import com.kettler.domain.orderentry.share.WebUser
import grails.util.Environment

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import com.kettler.domain.orderentry.share.Role

class CouponController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def beforeInterceptor = {
    	log.debug "action: $actionName params: $params flash: $flash $Environment.current"
    }


    def index = {
        redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'list')}")
//        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [couponInstanceList: Coupon.list(params), couponInstanceTotal: Coupon.count()]
    }

    def create = {
        def couponInstance = new Coupon()
        couponInstance.properties = params
        return [couponInstance: couponInstance]
    }

    def save = {
        def couponInstance = new Coupon(params)
        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
        couponInstance.createdBy = user
        if (couponInstance.save(flush: true)) {
            flash.message = "Created coupon: ${couponInstance}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'show', id: couponInstance.id)}")
        }
        else {
            render(view: "create", model: [couponInstance: couponInstance])
        }
    }

    def show = {
        def couponInstance = Coupon.get(params.id)
        if (!couponInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'coupon.label', default: 'Coupon'), params.id])}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'list')}")
        }
        else {
            [couponInstance: couponInstance]
        }
    }

    def edit = {
        def couponInstance = Coupon.get(params.id)
        if (!couponInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'coupon.label', default: 'Coupon'), params.id])}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'list')}")
        }
        else {
            return [couponInstance: couponInstance]
        }
    }

    def update = {
        def couponInstance = Coupon.get(params.id)
        if (couponInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (couponInstance.version > version) {
                    
                    couponInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'coupon.label', default: 'Coupon')] as Object[], "Another user has updated this Coupon while you were editing")
                    render(view: "edit", model: [couponInstance: couponInstance])
                    return
                }
            }
            couponInstance.properties = params
            if (!couponInstance.hasErrors() && couponInstance.save(flush: true)) {
                flash.message = "Updated coupon: ${couponInstance}"
                redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'show', id: couponInstance.id)}")
            }
            else {
                render(view: "edit", model: [couponInstance: couponInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'coupon.label', default: 'Coupon'), params.id])}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'list')}")
        }
    }

    def delete = {
        def couponInstance = Coupon.get(params.id)
        if (couponInstance) {
            try {
                couponInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'coupon.label', default: 'Coupon'), params.id])}"
                redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'list')}")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'coupon.label', default: 'Coupon'), params.id])}"
                redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'show', id: couponInstance.id)}")
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'coupon.label', default: 'Coupon'), params.id])}"
            redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'list')}")
        }
    }

    def approve = {
        def couponInstance = Coupon.get(params.id)
        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
        if (couponInstance.createdBy.equals(user)) {
            flash.message = "You can not approve a coupon you created."
        } else {
            couponInstance.approvedBy = user
            if (couponInstance.save(flush: true)) {
                flash.message = "Coupon has been approved"
            } else {
                flash.message = "Coupon approval was not accepted"
            }
        }
        redirect(url:"${CH.config.grails.serverURL}${g.createLink(action: 'show', id: couponInstance.id)}")
    }
}
