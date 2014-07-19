import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.QuoteHeader
import com.kettler.domain.orderentry.QuoteDetailItem
import com.kettler.domain.orderentry.QuoteDetailMisc
import com.kettler.domain.orderentry.QuoteDetailComment
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.WebUser

import com.kettler.domain.actrcv.share.Customer

import com.kettler.domain.work.Komment

import org.jsecurity.SecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class QuoteController {
	def orderService
	def rpgService
    def zeroPad4 = new java.text.DecimalFormat('0000')

	def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
    def afterInterceptor = {model ->
        log.debug("action: $actionName model: $model")
    }
	
	def view = {
		def ord = QuoteHeader.findWhere(compCode:params.compCode,orderNo:params.orderNo.toInteger())
		def ordDiscAllowList = null
		def ordLines = orderService.getQuoteLines(ord.compCode,ord.orderNo)
		def orderTotalInfo = orderService.calcTotal(ordLines, ord, ordDiscAllowList, true)
		session.cust = Customer.findByCompCodeAndCustNo(ord.compCode, ord.custNo) // TODO change this BAD BAD BAD
		[ord:ord, ordLines:ordLines, orderTotalInfo:orderTotalInfo]
	}

	def select = {
		params.max = params.max?:'10'
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'orderNo'
		params.order = params.order?:'asc'
       	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
		def customers
		if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
       		customers = user.customers
       	} 
		def quoteList 
		def count 
		quoteList = QuoteHeader.withCriteria {
        	and {
                if (params.custNo)	 	  eq("custNo", params.custNo.toUpperCase())
                if (params.statusCode) 	  eq("statusCode", params.statusCode)
                if (params.salesperson1)  eq("salesperson1", params.salesperson1)
                if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
                	                      eq("salesperson1", user.salesperson.id)
                } else if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
                	                      eq("custNo", user.custNo)
                }
        	}
            maxResults(Integer.parseInt(params.max))
            firstResult(Integer.parseInt(params.offset))
            order(params.sort, params.order)
		}
        def countArray = QuoteHeader.withCriteria(unique:true) {
            projections {rowCount()}
        	and {
                if (params.custNo)	 	  eq("custNo", params.custNo.toUpperCase())
                if (params.statusCode) 	  eq("statusCode", params.statusCode)
                if (params.salesperson1)  eq("salesperson1", params.salesperson1)
                if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
                	                      eq("salesperson1", user.salesperson.id)
                } else if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
                	                      eq("custNo", user.custNo)
                }
        	}
        }
        count = countArray[0]
		[quoteList:quoteList, count:count, customers:customers, params:params]
	}
	
	def disapprove = {
		def ord = QuoteHeader.findWhere(compCode:params.compCode,orderNo:params.orderNo.toInteger())
		ord.statusCode = 'D'
		assert ord.save()
		def ordLines = orderService.getQuoteLines(ord.compCode,ord.orderNo)
        int max = ordLines.keySet().findAll {it < '9900'}.max() as Integer
        def comment = new QuoteDetailComment(
                compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo,
        		lineNo:max ? max-(max%10) + 10 : 10,  
                lineType:'C', text:params.comment,
                printCode:'A', // print on all documents
                printCode2:' ',
                printCode3:' ',
                printCode4:' ',
                printCode5:' ',
                printCode6:' ')
        if (!comment.save(insert:true)) {
        	comment.errors.each { log.error it.inspect()}
        }
		
        redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}quote/select")
	}
	
	def approve = {
		def ord = QuoteHeader.findWhere(compCode:params.compCode,orderNo:params.orderNo.toInteger())
		ord.statusCode = 'D' // flagged as deleted but move to order
		assert ord.save()
		def header = new OrderHeader()
		header.properties = ord.properties
		header.orderNo = rpgService.getNextOrderNo(ord.compCode)
		log.debug "Adding order ${header.orderNo} from quote ${ord.orderNo}"
		header.poNo = params.poNo
		header.statusCode = 'N'
		if (!header.save()) {
			header.errors.each { log.error it.inspect()}
		}
        QuoteDetailItem.findAllByCompCodeAndOrderNo(ord.compCode, ord.orderNo).each {quoteItem ->
			def item = new OrderDetailItem() 
			item.properties =  quoteItem.properties
			item.orderNo = header.orderNo
			if (!item.save()) {
				item.errors.each { log.error it.inspect()}
			}
		}
        QuoteDetailComment.findAllByCompCodeAndOrderNo(ord.compCode, ord.orderNo).each {quoteComment ->
			def comment = new OrderDetailComment() 
			comment.properties =  quoteComment.properties
			comment.orderNo = header.orderNo
			if (!comment.save()) {
				comment.errors.each { log.error it.inspect()}
			}
		}
        QuoteDetailMisc.findAllByCompCodeAndOrderNo(ord.compCode, ord.orderNo).each {quoteMisc ->
			def misc = new OrderDetailMisc() 
			misc.properties =  quoteMisc.properties
			misc.orderNo = header.orderNo
			if (!misc.save()) {
				misc.errors.each { log.error it.inspect()}
			}
		}
        redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}quote/select")
	}
	
}
