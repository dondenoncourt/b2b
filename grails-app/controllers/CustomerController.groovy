import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.actrcv.CustControl
import com.kettler.domain.actrcv.BalanceForward
import com.kettler.domain.actrcv.BalanceForwardSummary

import com.kettler.domain.orderentry.Commission 
import com.kettler.domain.orderentry.Company 
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.InvoicedOrderHeader
import com.kettler.domain.orderentry.share.InvoicedOrderDetailItem
import com.kettler.domain.orderentry.share.InvoicedOrderDetailComment
import com.kettler.domain.orderentry.share.InvoicedOrderDetailMisc
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.share.SalesPerson
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.ShipTo
import com.kettler.domain.orderentry.share.Cart

import com.kettler.domain.work.DateUtils

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import org.jsecurity.SecurityUtils

import java.math.BigDecimal;
import java.text.DecimalFormat

import groovy.sql.*

public class CustomerController {
    def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
	def cal = new GregorianCalendar()
	def orderService
	def customerService
	def rpgService
	def sessionFactory
    def zeroPad7 = new java.text.DecimalFormat('0000000')
    def zeroPad6 = new java.text.DecimalFormat('000000')
    def zeroPad2 = new java.text.DecimalFormat('00')
	
	/* don't forget to use oecanp for canadian province check
	 * as well as oestac for usa
	 * TODO oeuctl used for setupNewCust (column:'UCSUNC') check
	 */

    def reportPrompt = {
		[params:params]
	}

	def listRetailShiptoBillto = {
   		params.max = params.max?:'100'
   		if (params.pdf || params.csv) params.max='10000' // disable pagination for report
   	   	params.offset = params.offset?:'1' // first row is the total so start at 2nd 
   	   	params.rep = params.rep?.toUpperCase()
   	   	if (params.offset == '0') {
   	   		params.offset = '1'
   	   	}
		[carts : Cart.findAllByOrderPlacedAndShipToIdGreaterThan(true, 0, [max: params.max, offset: params.offset, sort:'dateCreated', order:'desc']),
		 kount : Cart.countByOrderPlacedAndShipToIdGreaterThan(true, 0)]
			
	}
	def printAckn = {
	    def order = OrderHeader.findWhere(compCode:params.compCode, orderNo:params.orderNo.toInteger(), shipNo:params.shipNo.toInteger())
	    if (!order) {
			render text:"Order no: $params.orderNo Ship No: $params.shipNo not found"
			return
		}
	    if (['N', 'X'].find {it == order.statusCode} ) {
			render text:"Order no: $params.orderNo:$params.shipNo at status $order.statusCode and is not available for acknowledgement printing"
			return
	    }
	   	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	   	if (((user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN)       && order.salesperson1 != user.salesperson.id) || 
		   	((user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) && order.custNo       != user.custNo)           ) {
			render text:"You are not authorized to order no: $params.orderNo:$params.shipNo"
			return
	   	}

		def file = rpgService.printAcknowledgement(params.compCode, params.orderNo, params.shipNo) 
		if (file) {
			ifsPdfFileToStream(file, response)
		} else {
			render text: "PDF for order is not found"
		}
	}
    private ifsPdfFileToStream(File file, def response) {
		response.contentType = "application/pdf"
		response.contentLength = file.size()
		file.readBytes().each {bite -> response.outputStream.write(bite)}
		response.outputStream.flush() 
	}
    
    def printPackList = {
	    def order = OrderHeader.findWhere(compCode:params.compCode, 
	                               orderNo:params.orderNo?params.orderNo.toInteger():0, 
	                               shipNo:params.shipNo?params.shipNo?.toInteger():0)
	    if (!order) {
            render text:"Invalid order no: $params.compCode:$params.orderNo:$params.shipNo"
            return
		}
	    if (!['S', 'C'].find {it == order.statusCode} ) {
			render text:"Order no: $params.orderNo:$params.shipNo at status $order.statusCode and is not available for pack list printing"
			return
	    }
	   	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	   	if (((user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN)       && order.salesperson1 != user.salesperson.id) || 
		   	((user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) && order.custNo       != user.custNo)           ) {
			render text:"You are not authorized to order no: $params.orderNo:$params.shipNo"
			return
	   	}
		def file = rpgService.printPackList(params.compCode, zeroPad6.format(params.orderNo.toInteger()), zeroPad2.format(params.shipNo.toInteger())) 
		if (file) {
			ifsPdfFileToStream(file, response)
		} else {
			render text: "PDF for order is not found"
		}
	}
    
    def invoicePrompt = {}

    def printInvoice = {
        def invoice
        try {
        	invoice = InvoicedOrderHeader.findByCompCodeAndInvoiceNo(params.compCode, params.invNo.toInteger())
        } catch (java.lang.NumberFormatException e) {
        	invoice = null
        }
        if (!invoice) {
			render text:"Invalid invoice no: $params.invNo"
			return
		}
	   	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	   	if (((user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN)       && invoice.salesperson1 != user.salesperson.id) || 
		   	((user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) && invoice.custNo       != user.custNo)           ) {
			render text:"You are not authorized to invoice no: $params.invNo"
			return
	   	}
		def file = rpgService.printInvoice(params.compCode, zeroPad7.format(params.invNo.toInteger())) 
		if (file) {
			ifsPdfFileToStream(file, response)
		} else {
			render text: "PDF for invoice is not found"
		}
	}
    def arStmtsPrompt = {
	   	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	   	def customers = []
	   	if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
	   		customers = user.getCustomers()
	   	}
	   	[customers:customers, params:params]
	}
    
    private String commStmtAsCsv (String html, Date fromDate, String rep) {
		def xml = new XmlSlurper().parseText(html)
		def csv = ''
		xml.table.thead.tr.th.each {csv += "'${it.text().trim()}', "}
		csv += '\n'
		xml.table.tbody.tr.each {tr ->
			tr.td.each{td ->
				if (td.@colspan != '') {
					def colspan = td.@colspan.toInteger()
					(1..colspan).each{col ->
						if (col == colspan && td.text()) {
							csv += td.text()?.trim().replaceAll(/,/,' ')
						}
						csv += ','
					}
				} else {
					csv += td.text()?.trim().replaceAll(/,/,' ')?:''
					csv += ','
				}
			}
			csv += '\n'
		}
		// set header 
		SalesPerson slsp = SalesPerson.get(params.rep) 
		def header = ",${slsp.name}\n"
		header += ',Commission Statement\n'
   	    header += ",'${(g.formatDate(date:fromDate,format:'MMMMMMMMMM yyyy'))}'\n"
    	return header+csv
    }
    def commStmts = {CommStmtsCommand cmd ->
	    if (cmd.hasErrors()) {
	        render (view:'commStmts', model:[cmd:cmd])
	        return
	    }
   		params.max = params.max?:'15'
   		if (params.pdf || params.csv) params.max='10000' // disable pagination for report
   	   	params.offset = params.offset?:'1' // first row is the total so start at 2nd 
   	   	params.rep = params.rep?.toUpperCase()
   	   	if (params.offset == '0') {
   	   		params.offset = '1'
   	   	}
   	   	def totalRow
    	def list = []
    	def count = 0

		if (cmd?.fromDate > Company.get('01').lastCommissionFinal) {
			list = null
			count = 0
			flash.message = "Report pending preparation"
			return [list:list, count:count, totalRow:totalRow, cmd:cmd, params:params]
		}
		if (cmd.fromDate) {
			Date toDate = cmd.fromDate
			// get the last day of the month
			while (cmd.fromDate.month == toDate.month) {
				toDate++
			}
			toDate--
			
			log.debug "search commission table for rep: $params.rep $cmd.fromDate to $toDate"
			SalesPerson slsp = SalesPerson.get(params.rep) 
			if (params.offset.toInteger() == 1) { // rebuild oespcm rows for rep
				rpgService.commStmts(g.formatDate(format:"MMddyy", date: cmd.fromDate), 
						             g.formatDate(format:"MMddyy", date: toDate), 
						             slsp.compCode, slsp.id) 
			}
	    	def query = 'FROM Commission c WHERE c.rep = ? ORDER BY c.invoiceNo asc, itemNo desc '
           	list = Commission.executeQuery(query, [params.rep], 
           				[max:params.max.toInteger(), offset:params.offset.toInteger()]) 
			count = Commission.countByRep(params.rep)
			totalRow = Commission.findByRep(params.rep, [sort:'invoiceNo'])
		}
   	   	if (!totalRow?.commAmt && cmd?.fromDate) {
   	   		list = null
   	   		count = 0
   	   		flash.message = "Report pending preparation"
   	   	} 
   	   	if (params.csv && count) {
   	   		def html = g.render(template:'commStmtsBody', model:[list:list, count:count, totalRow:totalRow, cmd:cmd, params:params]).readAsString()
			def bytes = commStmtAsCsv (html, params.fromDate, params.rep).bytes
			response.setContentType("text/csv")
			response.setHeader("Content-disposition", "attachment; filename=commstmt.csv")
			response.setContentLength(bytes.length)
			response.getOutputStream().write(bytes)
   	   	} else {
   	   		[list:list, count:count, totalRow:totalRow, cmd:cmd, params:params]
   	   	}
    }

	def arStmts = {
		params.custNo = params.custNo.toUpperCase()
		def cust = Customer.findByCompCodeAndCustNo(params.compCode, params.custNo)
		if (!cust) {
			render text:"Invalid customer: $params.custNo"
			return
		}
		def file = rpgService.arStatements(cust) 
		if (file) {
			ifsPdfFileToStream(file, response)
		} else {
			render text:"PDF for AR Statements is not found";return;
		}
	}
	 
    def invoiceHist = {
		params.max = params.max?:'15'
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'invoiceDate'
		params.order = params.order?:'desc'

		def invoices 
		def count 
		
	
		if (params.invoiceDate_year && params.invoiceDate_year.size() == 4) {
			params.invoiceDate = DateUtils.buildDate(params.invoiceDate_year[2..3], params.invoiceDate_month, params.invoiceDate_day)
		} else {
			params.invoiceDate = null
		}
	
		if (params.orderNo || params.invoiceNo || params.poNo || params.invoiceDate) {
			invoices = InvoicedOrderHeader.withCriteria {
                if (params.orderNo)			ge("orderNo",       	params.orderNo.toInteger())
                if (params.invoiceNo)		ge("invoiceNo",       	params.invoiceNo.toInteger())
                if (params.poNo)			like("poNo",  	   		"${params.poNo}%".toUpperCase())
                if (params.invoiceDate)		ge("invoiceDate",	   	params.invoiceDate)
                eq('compCode', params.compCode)
                eq('custNo', params.custNo)
                maxResults(Integer.parseInt(params.max))
                firstResult(Integer.parseInt(params.offset))
                if (params.orderNo)			order('orderNo',   'asc')
                if (params.invoiceNo)		order('invoiceNo', 'asc')
                if (params.poNo)			order('poNo', 	   'asc')
                if (params.invoiceDate)		order('invoiceDate', 	   'asc')
            }
            def countArray = InvoicedOrderHeader.withCriteria(unique:true) {
                projections {rowCount()}
            	and {
                    if (params.orderNo)			ge("orderNo",       	params.orderNo.toInteger())
                    if (params.invoiceNo)		ge("invoiceNo",       	params.invoiceNo.toInteger())
                    if (params.poNo)			like("poNo",  	   		"${params.poNo}%".toUpperCase())
                    if (params.invoiceDate)		ge("invoiceDate",	   	params.invoiceDate)
                    eq('compCode', params.compCode)
                    eq('custNo', params.custNo)
            	}
            }	
            count = countArray[0]
     		log.debug "$count = InvoicedOrderHeader.withCriteria"  
		} else {
			invoices = InvoicedOrderHeader.findAllByCompCodeAndCustNo(params.compCode, params.custNo, params)
			count = InvoicedOrderHeader.countByCompCodeAndCustNo(params.compCode, params.custNo)
		}
		[invoices:invoices, count:count, cust:Customer.findByCompCodeAndCustNo(params.compCode, params.custNo), popup:params.popup, params:params]
	}
    
    def invoiceHistDetail = {	
		def invoice = InvoicedOrderHeader.findWhere([compCode:params.compCode, orderNo:params.orderNo.toInteger(), shipNo:params.shipNo.toInteger()])

		def detailMap = new TreeMap()

		InvoicedOrderDetailItem.findAllWhere([compCode:params.compCode, orderNo:params.orderNo.toInteger(), shipNo:params.shipNo.toInteger()])
			.each {detailMap.put(it.lineNo, it) }
		InvoicedOrderDetailMisc.findAllWhere([compCode:params.compCode, orderNo:params.orderNo.toInteger(), shipNo:params.shipNo.toInteger()])
			.each {detailMap.put(it.lineNo, it) }
		InvoicedOrderDetailComment.findAllWhere([compCode:params.compCode, orderNo:params.orderNo.toInteger(), shipNo:params.shipNo.toInteger()])
			.each {detailMap.put(it.lineNo, it) }

		def shipTo = ShipTo.retreiveShipTo(invoice.compCode, invoice.custNo, invoice.shipToNo.toInteger(), invoice.orderNo, invoice.shipNo)
		[invoice:invoice, detailMap:detailMap, shipTo:shipTo, cust:Customer.findByCompCodeAndCustNo(params.compCode, invoice.custNo), popup:params.popup]
	}

	def create = {
        def cust = new Customer(countryCode:'USA')
		GregorianCalendar cal = new GregorianCalendar ()
		cal.time = new Date()
        cust.monthYearOpened = ((cal.get(Calendar.MONTH)+1) * 100) + (cal.get(Calendar.YEAR) % 100) 
        render view:'edit', model:[cust:cust]
	}

    def save = {
		
	    def cust = Customer.get(params.id)
	    if (!cust) {
	    	cust = new Customer(params)
	    } else {
	    	cust.properties = params
	    }
	    boolean newCust = false
        if (!cust.id && !cust.custNo.size() && cust.shortName.size() > 1) {
        	newCust = true
        	cust.shortName = cust.shortName.toUpperCase()
        	def custCtrl = CustControl.get(cust.shortName[0..1])
        	if (!custCtrl) {
        		custCtrl = new CustControl(alphaChars:cust.shortName[0..1]).save(flush:true)
        	}
        	cust.custNo = cust.shortName[0..1] + new DecimalFormat('0000').format(custCtrl.nextSeqNo) 
        	custCtrl.nextSeqNo++
        	custCtrl.save(flush:true)
        }
        cust.validate()
        if(cust.custNo.size() && cust.save()) {
        	if (newCust)
        		flash.message = 'Customer added'
        	else
        		flash.message = 'Customer updated'
        } 
        render view:'edit', model:[cust:cust]
	}
    def show = {
   		params.custNo = params.custNo.toUpperCase()
		Customer cust = Customer.findByCompCodeAndCustNo(params.compCode, params.custNo)
		if (!cust) {	
			flash.message = "Customer $params.custNo not found"
			render view:'list'
			return
		}
    	
    	WebUser user
    	if (!params.pdf) {
	    	user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	        if ((user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) &&
	        	cust.salespersonCode != user.salesperson.id                        ) {
				flash.message = "Not authorized to view information on customer ${params.custNo}"
				render view:'list'
				return
	        }
    	}
    	
		List aging = customerService.getAgingBuckets(params.compCode, params.custNo)

		[cust:cust, orderTotal:orderService.getTotalBalance(params.compCode, params.custNo, 0), 
		 ageCurrent:aging[0], age1to30:aging[1], age31to60:aging[2], age61to90:aging[3], age90Plus:aging[4],
		 custDiscAllowList:orderService.getCustDiscAllow(params.compCode, params.custNo, new Date()) ]
	}
    
    def openInvoices = {
		params.max = params.max?:'15'
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'transDate'
		params.order = params.order?:'desc'

		def balSummaries 
		def count 
		
	
		if (params.transDate_year && params.transDate_year.size() == 4) {
			params.transDate = DateUtils.buildDate(params.transDate_year[2..3], params.transDate_month, params.transDate_day)
		} else {
			params.transDate = null
		}
	
		if (params.refNo || params.transDate) {
			balSummaries = BalanceForwardSummary.withCriteria {
                if (params.refNo)			ilike("refNo",      params.refNo+'%')
                if (params.transDate)		ge("transDate",	   	params.transDate)
                eq('compCode', params.compCode)
                eq('custNo', params.custNo)
                maxResults(Integer.parseInt(params.max))
                firstResult(Integer.parseInt(params.offset))
                if (params.refNo)			order("refNo", 'asc')
                if (params.transDate)		order("transDate", 'asc')
            }
            def countArray = BalanceForwardSummary.withCriteria(unique:true) {
                projections {rowCount()}
            	and {
                    if (params.refNo)			ilike("refNo",      params.refNo+'%')
                    if (params.transDate)		ge("transDate",	   	params.transDate)
                    eq('compCode', params.compCode)
                    eq('custNo', params.custNo)
            	}
            }	
            count = countArray[0]
     		log.debug "$count = BalanceForwardSummary.withCriteria"  
		} else {
			balSummaries = BalanceForwardSummary.findAllByCompCodeAndCustNo(params.compCode, params.custNo, params)
			count = BalanceForwardSummary.countByCompCodeAndCustNo(params.compCode, params.custNo)
			
		}
		[balSummaries:balSummaries, count:count, cust:Customer.findByCompCodeAndCustNo(params.compCode, params.custNo), popup:params.popup, params:params]
	}
    
    def openInvoiceDetail = {	
		def balForwards = BalanceForward.findAllByCustNoAndRefNo(params.custNo, params.refNo)
		// invoice get does not work
		/*
		def comment = balForwards[0].comment.replace(/P\/O# /, '')
		println "comment: $comment was ${(balForwards[0].comment)}" 
		def invoice = 
			InvoicedOrderHeader.findWhere([compCode:params.compCode, custNo:params.custNo, poNo:comment] )
			*/
		[balForwards:balForwards, invoice:null, cust:Customer.findByCompCodeAndCustNo(params.compCode, params.custNo), popup:params.popup]
	}
    
    def salesHist = {
		GregorianCalendar cal = new GregorianCalendar ()
		cal.time = new Date()
		int curYear = cal.get(Calendar.YEAR) % 100
   		params.year = params.year?:curYear
   				
   		def cust = Customer.findByCompCodeAndCustNo(params.compCode, params.custNo)
		int minYear = ((cust.monthYearOpened > 2003)?cust.monthYearOpened:2004) % 100
		
    	def query = "from InvoicedOrderDetailItem i where i.compCode = ? and i.custNo = ? "
        	query += " AND i.invoiceDate >= ${params.year}0101 and i.invoiceDate <= ${params.year}1231 and lineType = 'I'" 
           	query += " ORDER BY i.invoiceDate asc, orderNo asc " 
        def salesList = InvoicedOrderDetailItem.executeQuery(
        		query, [params.compCode, params.custNo], 
        		[sort:'invoiceDate']) 
        def orders = []
        def amounts = []
        def qtys = []
        (0..11).each {month -> 
        	amounts[month] = 0.00g
        	qtys[month] = 0
        	orders[month] = 0
        }
        def lastOrderNo = 0
        salesList.each {item ->
			cal.setTime(item.invoiceDate)
			def month = cal.get(Calendar.MONTH)
 			qtys[month] = qtys[month] + (item.orderQty - item.backOrderQty)
 			amounts[month] = amounts[month] + item.amount
 			if (item.orderNo != lastOrderNo) {
 				orders[month]++
 				lastOrderNo = item.orderNo
 			}  
        }
		def sql = new Sql(sessionFactory.getCurrentSession().connection())
		def itemQry = "SELECT  oitem, sum(oexamt) as total FROM ${CH.config.orderEntryLib}.oeinv1 i WHERE i.ocomp = ? AND i.ocustr = ? "
        itemQry += " AND i.oinymd >= ${params.year}0101 AND i.oinymd <= ${params.year}1231 and i.otype = 'I'" 
    	itemQry += " GROUP BY oitem  ORDER BY total desc" 
    	def itemNos = []
        def itemAmounts = []
 		sql.eachRow (itemQry.toString(), [params.compCode, params.custNo]) {row ->
			itemNos << row[0]
			itemAmounts << new BigDecimal(row[1])
        }

		[amounts:amounts, minYear:minYear, curYear:curYear, qtys:qtys, orders:orders, cust:cust, itemNos:itemNos, itemAmounts:itemAmounts, popup:params.popup]
	}

    /* if CUSTOMER put their own rec in the list
     * if REP, menu doesn't let you get in here
     * if KETTLER get all cusomters
     */
    def list = {
		/*if request did not come from the search panel or a main.gsp menu option 
		 * reset params to saved search criterion
		 */ 
    	if (params.search != 'Search' && session.savedCustomerSearchParams) {
    		log.debug "session.savedCustomerSearchParams from order flow: $session.savedCustomerSearchParams"
    		session.savedCustomerSearchParams.each {params.put(it.key, it.value)}
    		session.savedCustomerSearchParams = null
    	}
		params.max = params.max?:'10'
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'custNo'
		params.order = params.order?:'asc'
		params.state = params.state?params.state.toUpperCase():null
	    params.city = params.state?params.city.toUpperCase():null
				
		WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())

       	def custList 
		def count
        if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN || 
        	params.compCode || params.name || params.city || 
        	params.state || params.zipCode || params.salespersonCode) {
        	custList = Customer.withCriteria {
            	and {
	                if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) { 
	                	                        eq('salespersonCode', user.salesperson.id)
	                	                        ne('activeCode', 'I')
	                }
	                if (params.compCode)  		eq("compCode",          params.compCode)
	                if (params.name)			ilike("name",         	params.name+'%')
	                if (params.city) 			eq("city",    			params.city)
	                if (params.state) 			eq("state", 			params.state)
	                if (params.zipCode) 		eq("zipCode", 			params.zipCode)
	                if (params.salespersonCode) eq("salespersonCode",	params.salespersonCode)
            	}
                maxResults(Integer.parseInt(params.max))
                firstResult(Integer.parseInt(params.offset))
                order(params.sort, params.order)
            }
            def countArray = Customer.withCriteria(unique:true) {
                projections {rowCount()}
            	and {
	                if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) 
	                	                        eq('salespersonCode', user.salesperson.id)
	                if (params.compCode)  		eq("compCode",          params.compCode)
	                if (params.name)			ilike("name",         	params.name+'%')
	                if (params.city) 			eq("city",    			params.city)
	                if (params.state) 			eq("state", 			params.state)
	                if (params.zipCode) 		eq("zipCode", 			params.zipCode)
	                if (params.salespersonCode) eq("salespersonCode",	params.salespersonCode)
            	}
            }
            count = countArray[0]
     		log.debug "$count = Customer.withCriteria"  
        } else {
        	custList = Customer.list(params)
        	count = Customer.count()
     		log.debug "$count = Customer.cpunt()"  
        }
		
		session.savedCustomerSearchParams = params

		[custList:custList,count:count]
	}
    def salesHistItemDetail = {
			GregorianCalendar cal = new GregorianCalendar ()
		cal.time = new Date()
		int curYear = cal.get(Calendar.YEAR) % 100
   		params.year = params.year?:curYear
   				
   		def cust = Customer.findByCompCodeAndCustNo(params.compCode, params.custNo)
		int minYear = cust.monthYearOpened % 100
		
    	def query = "from InvoicedOrderDetailItem i where i.compCode = ? and i.custNo = ? and i.itemNo = ? "
        	query += " AND i.invoiceDate >= ${params.year}0101 and i.invoiceDate <= ${params.year}1231 and lineType = 'I' " 
           	query += " ORDER BY i.invoiceDate asc, orderNo asc " 
        def salesList = InvoicedOrderDetailItem.executeQuery(
        		query, [params.compCode, params.custNo, params.itemNo], 
        		[sort:'invoiceDate']) 
        def orders = []
        def amounts = []
        def qtys = []
        (0..11).each {month -> 
        	amounts[month] = 0.00g
        	qtys[month] = 0
        	orders[month] = 0
        }
        def lastOrderNo = 0
        salesList.each {item ->
			cal.setTime(item.invoiceDate)
			def month = cal.get(Calendar.MONTH)
 			qtys[month] = qtys[month] + (item.orderQty - item.backOrderQty)
 			amounts[month] = amounts[month] + item.amount
 			if (item.orderNo != lastOrderNo) {
 				orders[month]++
 				lastOrderNo = item.orderNo
 			}  
        }
		[amounts:amounts, minYear:minYear, curYear:curYear, qtys:qtys, orders:orders, cust:cust, popup:params.popup]
    }
    
}
class CommStmtsCommand {
	Date fromDate 
	String rep
	static constraints = {
		rep blank:false
	}
}
