import java.io.Serializable;
import java.util.Date;
import java.util.GregorianCalendar;

import com.kettler.domain.orderentry.share.Carrier
import com.kettler.domain.orderentry.CustBillToAddr
import com.kettler.domain.orderentry.Cust3rdPartyBill
import com.kettler.domain.orderentry.ContractPrice
import com.kettler.domain.orderentry.CustomerContact
import com.kettler.domain.orderentry.share.Control
import com.kettler.domain.orderentry.share.InvoicedOrderHeader
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.OrderDates
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.Order3rdPartyBill
import com.kettler.domain.orderentry.share.OrderDiscountAllowance
import com.kettler.domain.orderentry.OrderInvoiceMerge
import com.kettler.domain.orderentry.PrintCode
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.SalesTermsTier
import com.kettler.domain.orderentry.share.ShipTo
import com.kettler.domain.orderentry.share.ShipVia
import com.kettler.domain.orderentry.Terms
import com.kettler.domain.orderentry.share.WebUser

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemWarehouse
import com.kettler.domain.item.share.BillOfMaterials as BOM

import com.kettler.domain.actrcv.share.Customer

import com.kettler.domain.varsity.ShippingInstructions
import com.kettler.domain.varsity.SpecialCharges

import com.kettler.domain.work.Komment
import com.kettler.domain.work.InventoryInfo
import com.kettler.domain.work.OrderTotalInfo
import com.kettler.domain.work.DateUtils

import org.jsecurity.SecurityUtils

import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class OrderController {
 
	def orderService
	def rpgService
	def sessionFactory

	def ZERO_PAD2 = new java.text.DecimalFormat('00')

        def testNextOrd = {
		int nextOrdNo = rpgService.getNextOrderNo('01')
		render nextOrdNo.toString()
	}	
	
    def index = { 
		render view:'home'
	}

	def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
    //def afterInterceptor = {model ->log.debug("action: $actionName model: $model") }

	def selectCustRedirect = {
       	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
       	def customers = []
       	if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
       		customers = user.customers
       	}
		render view:'customer', model:[customers:customers]
	}
    def selectCustomer = {SelectCustomerCommand cmd -> 
       if (cmd.hasErrors()) {
            render (view:'customer', model:[cmd:cmd])
            return
        }
        session.cust = Customer.findByCustNo(cmd.custNo)
        redirect(url:"${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/order?inquiry=false")
    }
	def orderFlow = {
        begin {
            action {
	           	log.debug params
	        	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
            	if (user.role.name != Role.KETTLER ) { 
            		flow.shipViaCustViewable = [] //Grails 1.3.3 hack
            		ShipVia.findAllByCustView(true).each {flow.shipViaCustViewable << it.id}
            	}
                if (user.role.name == Role.CUSTOMER && 
                    Customer.findByCompCodeAndCustNo('01', user.custNo)?.activeCode != '') {
                		redirect action:"home", params:[webFlowMessage:
                			"Your account is not active. Please contact the credit manager at creditmanager@kettlerusa.com or 757-301-2629."]
						return endOrderFlow()
                }
	        	flow.user = user
				flow.inquiry = params.inquiry == 'true'?true:false
				if (params.orderNo) { // update or inquiry mode
					flow.ord = OrderHeader.findByCompCodeAndOrderNo(params.compCode, params.orderNo)
					flow.ord.discard()
					params.remove('action')
					params.remove('controller')
					params.remove('orderNo')
					orderService.setOrderTransientsOnInqUpd(flow.ord)
					session.cust = Customer.findByCompCodeAndCustNo(flow.ord.compCode, flow.ord.custNo)
					flow.ordLines = orderService.getOrderLines (flow.ord.compCode, flow.ord.orderNo)
					flow.shipTo = ShipTo.retreiveShipTo(flow.ord.compCode, flow.ord.custNo, flow.ord.shipToNo, flow.ord.orderNo, flow.ord.shipNo)
					flow.shipTo?.discard()
					flow.ordDate = OrderDates.findWhere(compCode:flow.ord.compCode, orderNo:flow.ord.orderNo, shipNo:flow.ord.shipNo)
					flow.ordDate?.discard()
	                flow.ordDiscAllowList = []
					flow.orderService = orderService
	                OrderDiscountAllowance.findAllByCompCodeAndOrderNo(flow.ord.compCode, flow.ord.orderNo).each {discAllow ->
	                	discAllow.discard()
	                	flow.ordDiscAllowList << discAllow
	                }
	                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
	                if (user.role.name != Role.KETTLER ) flow.custRepSetShipTo = true
					review()
 				} else { // add mode
					if (!session.cust) {
						if (user.role.name == Role.KETTLER || user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
				        	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/selectCustRedirect"
							return endOrderFlow()
						} // else must be  Role.CUSTOMER
						session.cust = Customer.findByCompCodeAndCustNo(user.compCode, user.custNo)
					}
					if (user.role.name != Role.KETTLER ) flow.custRepSetShipTo = false
					flow.ord = new OrderHeader(compCode:session.cust.compCode, custNo:session.cust.custNo, orderNo:rpgService.getNextOrderNo(session.cust.compCode), 
		            		                   salesperson1:session.cust.salespersonCode, packingListCode:session.cust.packingListCode?:'01',
		            		                   acknEmail:CustomerContact.findWhere(compCode:session.cust.compCode, custNo:session.cust.custNo,type:'ACK')?.emailAddress)
					
					switch (user.role.name) {
						case Role.KETTLER:  
											flow.ord.enteredBy = user.user400.id
											flow.ord.approvedBy = user.user400.id
											flow.ord.approvedDate = new Date()
											flow.ord.approvedTime = new java.sql.Time(new Date().time)
											break
						case Role.REP_ADMIN:
						case Role.REP_PLUS:
						case Role.REP:      
											flow.ord.enteredBy = "${user.salesperson.id}:${user.id}";break;
						case Role.CUSTOMER: 
						case Role.CUST_ADMIN: 
							                flow.ord.enteredBy = "${user.id}";break;
					}
		            flow.ord.discard()
					flow.ordDiscAllowList = orderService.fleshOutOrderHeaderOnAdd(flow.ord, session.cust)
					session.orderNo = flow.ord.orderNo
					flow.ordLines = new TreeMap()
					flow.orderService = orderService
					def comments = orderService.createCustCommentList(flow.ord.compCode, flow.ord.custNo)
					comments.each {cmt -> flow.ordLines.put(g.formatNumber(number:cmt.lineNo, format:'0000'), cmt) }
	                flow.orderTotalInfo = new OrderTotalInfo()
		            flow.shipTo = ShipTo.retreiveShipTo(flow.ord.compCode, flow.ord.custNo, flow.ord.shipToNo, flow.ord.orderNo, flow.ord.shipNo)
					lineItemSubfile()
				}
            }
            on('review') {
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            	[totalBalance: orderService.getTotalBalance(flow.ord.compCode, flow.ord.custNo, flow.ord.orderNo)]
            }.to('review')
            on('lineItemSubfile').to('lineItemSubfile')
            on('selectCust').to("selectCust")
            on('endOrderFlow').to("endOrderFlow")
        }
        shippingInfo {
            on ("back").to("lineItemSubfile")
            on("next") {
            	if (!flow.inquiry) {
            		if (params.reqShipDate == 'struct') { params.reqShipDate = null }
            		if (params.dueDate == 'struct') { params.dueDate = null }
            		if (params.cancelAfterDate == 'struct') { params.cancelAfterDate = null }
	                flow.ord.properties = params
	                if (hasPOBox(flow.shipTo?:session.cust)) {
	                	flash.message = "Ship To address cannot contain a Post Office Box number."
	                	return error()
	                }
	                if (!flow.ord.validate()) {
	                    return error()
	                }
	                if (params.reqShip == 'date') {
	                	if (!params.reqShipDate_year) {
	                		flash.message = 'When prompted for Requested Ship Date, please enter a date'
		                    return error()
	                	}
	                	Date date = DateUtils.buildDate(params.reqShipDate_year, params.reqShipDate_month, params.reqShipDate_day)
	                	if (!flow.ordDate) {
	                		flow.ordDate = new OrderDates(compCode:flow.ord.compCode, orderNo:flow.ord.orderNo, shipNo:flow.ord.shipNo, date:date)
	                	} else {
	                		flow.ordDate.date = date
	                	}
	                	/* If Customers and Reps input the order, the Pick Date could be 2 (two) days prior to the requested ship date 
	                	  (or today's date if req ship date was not selected.) */
	                	if (flow.user.role.name == Role.KETTLER) {
	                		if (!params.pickDate_year) {
		                		flash.message = 'When prompted for Requested Ship Date, please enter a Pick Date'
			                    return error()
	                		}
	                		flow.ord.pickDateMDY =  flow.ord.pickDate
	                	} else {
	                		flow.ord.pickDate = flow.ord.pickDateMDY =  date - 2
	                	}
	                } else {
	                	flow.ordDate = null
	                }
	                if (!flow.ord.poNo) {
	                	flash.message = "Purchase Order No requires an entry"
	                   	return error()
	                } else if (rpgService.isDuplicatePO(flow.ord.compCode, flow.ord.custNo, flow.ord.poNo, flow.ord.orderNo as String)) {
	                	flash.message = "Purchase order ${flow.ord.poNo} already exists"
	                	return error()
	                }
	                if (params.callBeforeShipping) orderService.addCallBeforeShipping(flow.ordLines)
	                else orderService.removeCallBeforeShipping(flow.ordLines)

	                orderService.fleshOutOrderHeaderOnUpdate(flow.ord)
            	}
            }.to("shippingInfoAction") 
            on ("setShipTo") {
				if (params.backOrder == 'o') params.backOrder = 'on'        // circumvent squirrelly behavior for some booleans
				if (params.hasExtraShipInst) params.hasExtraShipInst = 'on' // this one too
           		if (params.cancelAfterDate == 'struct') { params.cancelAfterDate = null }
				flow.ord.properties = params
            	flow.ord.shipToNo = params?.shipToNoPick.toInteger()
            	flow.shipTo = ShipTo.retreiveShipTo(flow.ord.compCode, flow.ord.custNo, flow.ord.shipToNo, flow.ord.orderNo, flow.ord.shipNo)
				if (flow.shipTo?.phoneNo?.trim()?.size() > 0) {
					flow.ord.shippingPhoneNo = flow.shipTo?.phoneNo.toLong() 
				}
                if (hasPOBox(flow.shipTo?:session.cust)) {
                	flash.message = "Ship To address cannot contain a Post Office Box number."
                	return error()
                }
				if (flow.user.role.name != Role.KETTLER ) flow.custRepSetShipTo = true
            }.to("shippingInfo")
            on ("createShipTo") {
           		if (params.cancelAfterDate == 'struct') { params.cancelAfterDate = null }
                flow.ord.properties = params
                flow.shipTo = new ShipTo(compCode:flow.ord.compCode,custNo:flow.ord.custNo,shipNo:flow.ord.shipNo)
				if (flow.user.role.name != Role.KETTLER ) flow.custRepSetShipTo = true
            }.to("createShipTo")
            on ("createDropShip") {
           		if (params.cancelAfterDate == 'struct') { params.cancelAfterDate = null }
                flow.ord.properties = params
                flow.shipTo = new ShipTo(compCode:flow.ord.compCode, custNo:flow.ord.custNo,shipNo:flow.ord.shipNo)
            	flow.shipTo.orderNo = flow.ord.orderNo
            	flow.shipTo.shipToNo = 9999
            	flow.shipTo.shipNo = ZERO_PAD2.format(flow.ord.shipNo)
				if (flow.user.role.name != Role.KETTLER ) flow.custRepSetShipTo = true
            }.to("createShipTo")
            on("custBillToAddr") { 
            	flow.custBillToAddr = flow.custBillToAddr ?: CustBillToAddr.get(flow.ord.compCode, flow.ord.orderNo, flow.ord.shipNo)
            	if (!flow.custBillToAddr) {
            		flow.custBillToAddr = new CustBillToAddr(compCode:flow.ord.compCode, orderNo:flow.ord.orderNo, shipNo:flow.ord.shipNo, newEntity:true)
            	}
            }.to("custBillToAddr")
            on("abort") {
            	session?.cust = null 
            	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/listOrders"
            }.to('endOrderFlow') 
            on("cancel") {
            	if (flow.ord.id) {
                	flow.ord.statusCode = 'X'
                   	if (!flow.ord.save(flush:true)) flow.ord.errors.each { log.error it.inspect()}
            	}
            	session?.cust = null 
            	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/listOrders"
            }.to('endOrderFlow') 
        }
        createShipTo {
            on ("create") {
                flow.shipTo.properties = params
                if (hasPOBox(flow.shipTo)) {
                	flash.message = "Ship To address cannot contain a Post Office Box number."
                	return error()
                }
                log.debug "flow.shipTo.save() id: $flow.shipTo.id, compCode: $flow.shipTo.compCode, custNo: $flow.shipTo.custNo, orderNo: $flow.shipTo.orderNo, shipToNo: $flow.shipTo.shipToNo"
                def checkDup = ShipTo.findWhere(compCode:flow.shipTo.compCode, custNo:flow.shipTo.custNo, orderNo:flow.shipTo.orderNo, shipToNo:flow.shipTo.shipToNo)
                if (checkDup) {
                	ShipTo.withTransaction{ status ->
                		checkDup.delete(flush:true)
                	}
                }
                if(!flow.shipTo.save()) {  
                    return error()
                }
				if (flow.shipTo?.phoneNo?.trim()?.size() > 0) {
					flow.ord.shippingPhoneNo = flow.shipTo?.phoneNo.toLong() 
				}
            	flow.ord.shipToNo = flow.shipTo.shipToNo 
            }.to("shippingInfo")
            on ("back") {
           		flow.shipTo = null
            }.to('shippingInfo') 
        }
        custBillToAddr {
            on ("update") {
                flow.custBillToAddr.properties = params
            	if (!flow.custBillToAddr.validate()) {
            		return error()
            	}
            }.to("shippingInfo")
            on ("delete") {
            	if (!flow.custBillToAddr.newEntity) {
            		flow.custBillToAddr.delete()
            	}
            	flow.custBillToAddr = null
            }.to("shippingInfo")
            on("back") {
            	flow.custBillToAddr = null
        	}.to('shippingInfo')
        }
        
        /* bubble thru optional panels thirdPartyBill, discAllow, lineDisc otherwise go to lineItemSubfile
         * each Action implementation forwards to the next Action 
         * one or all three pages could be displayed so we need predicates after each page is complete
         * to see if the next page should be displayed
         * We can't simply reuse shippingInfoAction because it could redisplay pages 
         */
        
        shippingInfoAction {
        	action {
	            if      (flow.ord.fobCode == 'TP')                               thirdPartyBill() 
	            else if (flow.ord.discAllowCode && flow.user.role.name == Role.KETTLER) discAllow()
	            else if (flow.ord.lineDiscCode && flow.user.role.name == Role.KETTLER ) lineDisc()
	            else review()
        	}
            on("thirdPartyBill") {
            	// try to get existing, if none, try oebill and pre-fill new Order3rdPartyBill
            	if (!flow.thirdPartyBill) { // one may already have been set in flow but not in DB
	            	flow.thirdPartyBill = Order3rdPartyBill.findWhere([compCode:flow.ord.compCode, orderNo:flow.ord.orderNo, shipNo:flow.ord.shipNo])
	            	if (!flow.thirdPartyBill) {
	            		flow.thirdPartyBill = Cust3rdPartyBill.findWhere([compCode:flow.ord.compCode, custNo:flow.ord.custNo, carrierCode:flow.ord.carrierCode])
	            		if (!flow.thirdPartyBill) {
	            			flow.thirdPartyBill = new Order3rdPartyBill(compCode:flow.ord.compCode, orderNo:flow.ord.orderNo, shipNo:flow.ord.shipNo, countryCode:'USA')
	            		}
	            	}
            	}
            }.to("thirdPartyBill")
            on("discAllow").to("discAllow")
            on("lineDisc").to("lineDisc")
            on("review") {
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            	[totalBalance: orderService.getTotalBalance(flow.ord.compCode, flow.ord.custNo, flow.ord.orderNo)]
            }.to("review")
        }
        thirdPartyBill {
        	on("next") {
        		if (!flow.inquiry) {
	        		flow.thirdPartyBill.properties = params
        			if (!flow.thirdPartyBill.validate()) {
        				return error()
        			}
					if (flow.thirdPartyBill.class.name == Order3rdPartyBill.name && 
						flow.thirdPartyBill.makeCust3rdPartyBill && !flow.ord.carrierCode) {
	        			flash.message = "To set this as a default, a Ship Via must be selected on the Shipping Info page, click Back to set."
	        			return error()
	        		}
        		}
        	}.to("discAllowAction")
            on("back") {
        		flow.thirdPartyBill = null 
        	}.to('shippingInfo')
        }
        discAllowAction {
        	action {
	            if (flow.ord.discAllowCode) discAllow()
	            else if (flow.ord.lineDiscCode) lineDisc()
	            else review()
        	}
            on ("discAllow").to('discAllow')
            on ("lineDisc").to('lineDisc')
            on("review") {
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            	[totalBalance: orderService.getTotalBalance(flow.ord.compCode, flow.ord.custNo, flow.ord.orderNo)]
            }.to("review")
        }
        discAllow {
            on("next").to("lineDiscAction") // note: no update
            on("back").to('shippingInfo')
        }
        lineDiscAction {
        	action {
        		if (flow.ord.lineDiscCode) lineDisc()
        		else                       review()
        	}
            on ("lineDisc").to('lineDisc')
            on("review") {
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            	[totalBalance: orderService.getTotalBalance(flow.ord.compCode, flow.ord.custNo, flow.ord.orderNo)]
            }.to("review")
        }
        lineDisc {
            on("next") {
            	if (!flow.inquiry) {
					flow.ord.properties = params
					if (!flow.ord.validate()) {
					    return error()
					}
            	}
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            	[totalBalance: orderService.getTotalBalance(flow.ord.compCode, flow.ord.custNo, flow.ord.orderNo)]
            }.to("review")  
            on("back").to('shippingInfo')
        }
        
        lineItemSubfile {
            on("next").to('shippingInfo')
            on("item").to("item")
            on("noninvitem") {
                int max = flow.ordLines.keySet().findAll {it < '9900'}.max() as Integer
                def ordItem = new OrderDetailItem(compCode:flow.ord.compCode,
                    orderNo:flow.ord.orderNo, lineNo:max ? max-(max%10) + 10 : 10,
                    lineType:'N')
                ordItem.discard()
                flow.ordLines.put (g.formatNumber(number:ordItem.lineNo, format:'0000'), ordItem)
                [ordItem:ordItem] 
            }.to("itemDetail")
            on("misc") {
                if (params.id) {
                    flow.misc =flow.ordLines.get(params.id)
                } else {
                    flow.misc = null
                }
            }.to("misc")
            on("comment") {
                [komment:params.id ?flow.ordLines.get(params.id):null]
            }.to("comment")
            on("itemdetail") {
                def ordItem = flow.ordLines.get(params.id) 
                assert ordItem
                [ordItem:ordItem, 
                 item:ItemMaster.findByCompCodeAndItemNo(ordItem.compCode, ordItem.itemNo), 
                 invInfo:orderService.getInvInfo(flow.ord.compCode, ordItem.itemNo, flow.ord.warehouse)
                ]
            }.to("itemDetail")
            on("abort") {
            	session?.cust = null 
            	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/listOrders"
            }.to('endOrderFlow') 
            on("cancel") {
            	if (flow.ord.id) {
                	flow.ord.statusCode = 'X'
					flow.ord.cancelAfterDate = DateUtils.getBeginningOfTime()
                   	if (!flow.ord.save(flush:true)) flow.ord.errors.each { log.error it.inspect()}
            	}
            	session?.cust = null 
            	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/listOrders"
            }.to('endOrderFlow') 
            on("review") {
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            	[totalBalance: orderService.getTotalBalance(flow.ord.compCode, flow.ord.custNo, flow.ord.orderNo)]
            }.to("review")
        }
        item {
            on("add") {
                int max = flow.ordLines.keySet().findAll {it < '9900'}.max() as Integer
                def ordItem = new OrderDetailItem(compCode:flow.ord.compCode,
                    orderNo:flow.ord.orderNo, lineNo:max ? max-(max%10) + 10 : 10,
                    lineType:'I', itemNo:params.itemNo, orderQty:1) // qty to fake out validate
                if (!ordItem.validate()) {
                	flow.ordItem = ordItem
				    return error()
                }
                ordItem.discard()
                orderService.fleshOutOrderItemOnAdd(ordItem, flow.ord, flow.ordLines, flow.ordDiscAllowList)
                ordItem.orderQty = 0 // reset with validation complete so user can set
                flow.ordLines.put (g.formatNumber(number:ordItem.lineNo, format:'0000'), ordItem)
                log.debug "flow.inquiry"+flow.inquiry
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
                [
                 ordItem:ordItem, 
                 item:ItemMaster.findByCompCodeAndItemNo(flow.ord.compCode, ordItem.itemNo), 
                 invInfo:orderService.getInvInfo(flow.ord.compCode, ordItem.itemNo, flow.ord.warehouse)
                ]
            }.to("itemDetail")
            on("delete") {
                flow.ordLines.remove(params.lineNo)
            }.to('lineItemSubfile')
            on("back") {
            	flow.ordItem = null 
            }.to('lineItemSubfile')
        }
        misc {
            on("add") {
                int max = flow.ordLines.keySet().findAll {it < '9900'}.max() as Integer
                def misc = new OrderDetailMisc(compCode:flow.ord.compCode,
                    orderNo:flow.ord.orderNo, lineNo:max ? max-(max%10) + 10 : 10,
                    lineType:'M', printCode:'I')
                misc.discard()
                misc.properties = params
                flow.ordLines.put(g.formatNumber(number:misc.lineNo, format:'0000'), misc)
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
                if (!misc.validate()) {
                    flow.misc = misc
                    return error()
                }
                flow.misc = null
            }.to("lineItemSubfile")
            on("update") { // note, duplicate logic but for new 
                def misc = flow.ordLines.get(params.lineNo.toString())
                assert misc.lineType == 'M'
                misc.properties = params
                if (!misc.validate()) {
                    flow.misc = misc
                    return error()
                }
                flow.misc = null
                flow.ordLines.put(g.formatNumber(number:params.lineNo, format:'0000'), misc)
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            }.to("lineItemSubfile")
            on("delete") {
                flow.ordLines.remove(params.lineNo)
            }.to('lineItemSubfile')
            on("back").to('lineItemSubfile')
        }
        comment {
            on("add") {
				def printCodes = []
            	PrintCode.list().each {pc ->  if (params."printCode${pc.id}") {printCodes << pc.id }}
	            if (!params.komment) flash.message = 'Please enter a comment'
	            if (!printCodes) flash.message = 'Please select one or more print codes'
	            def lineNo = params.lineNo?params.lineNo.toInteger():0
	            if (!lineNo) {
		            int max = flow.ordLines.keySet().findAll {it < '9900'}.max() as Integer
	            	lineNo = max ? max-(max%10) + 10 : 10
	            }
                def komment = new Komment(lineNo:lineNo, text:params.komment, printCodes:printCodes)
	            if (!params.komment || !printCodes) {
	            	flash.komment = komment
	            	return error()
	            }
                flow.ordLines.put(g.formatNumber(number:komment.lineNo, format:'0000'), komment)
            }.to("lineItemSubfile")
            on("update") {
				def printCodes = []
				PrintCode.list().each {pc ->  if (params."printCode${pc.id}") {printCodes << pc.id }}
	            if (!params.komment) flash.message = 'Please enter a comment'
	            if (!printCodes) flash.message = 'Please select one or more print codes'
                def komment = new Komment(lineNo:params.lineNo.toInteger(), text:params.komment, printCodes:printCodes)
	            if (!params.komment || !printCodes) {
	            	flash.komment = komment
	            	return error()
	            }
                flow.ordLines.put(g.formatNumber(number:params.lineNo, format:'0000'), komment)
            }.to("lineItemSubfile")
            on("delete") {
                flow.ordLines.remove(params.lineNo)
            }.to("lineItemSubfile")
            on("back").to('lineItemSubfile')
        }
        itemDetail {
            on("update") {  
                OrderDetailItem ordItem = flow.ordLines.get(params.lineNo.toString())
                flow.ordItem = ordItem
                ordItem.properties = params
                if (!ordItem.validate()) {
                    return error()
                }
                flow.orderTotalInfo = orderService.fleshOutOrderItemOnUpdate(ordItem, flow.ord, flow.ordLines, flow.ordDiscAllowList)
                if (!ContractPrice.inEffectForCust(flow.ord.compCode, flow.ord.custNo) && flow.ord.termsCode.trim() != Terms.CREDIT_CARD) {
                	SalesTermsTier curTier = SalesTermsTier.getTier(flow.ord.compCode, session.cust.salesDivision, session.cust.salesGroup, flow.orderTotalInfo.netAmount)
                	SalesTermsTier nextTier = SalesTermsTier.getNextTier(flow.ord.compCode, session.cust.salesDivision, session.cust.salesGroup, flow.orderTotalInfo.netAmount)
                	if (nextTier?.tier) flash.message = "Increase your order by "+ g.formatNumber(number:(curTier.amount - flow.orderTotalInfo.netAmount), format:'\$###,##0') + " to receive payment terms of "+ Terms.get(nextTier.termsCode).desc
                }
            }.to('checkBOMInvAction')
            on("delete") {
                flow.ordLines.remove(params.lineNo)
                flow.ordItem = null
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
            }.to('lineItemSubfile')
            on("back"){
            	if (flow.ordItem && !flow.ordItem.orderQty) {
                    flow.ordLines.remove(params.lineNo)
            	}
                flow.ordItem = null
            }.to('lineItemSubfile')
        }
        checkBOMInvAction {
        	action {
                if (!orderService.isBOMInventoryAvail(flow.ord.compCode, flow.ordItem.itemNo, flow.ord.warehouse, flow.ordItem.orderQty)) 
                	explodeBOM()
                else lineItemSubfile()
        	}
            on ("explodeBOM") { 
            	[bom:BOM.findAllByCompCodeAndItemNo(flow.ord.compCode, flow.ordItem.itemNo), orderService:orderService] 
            }.to('explodeBOM')
            on ("lineItemSubfile") { 
            	flow.ordItem = null 
            }.to('lineItemSubfile')
        }
        explodeBOM {
        	on("yes") {
        		log.debug "params: $params"
                OrderDetailItem ordItem = flow.ordLines.get(params.lineNo.toString())
                flow.ordLines.remove(params.lineNo)
                flow.ordItem = null
                flow.ordLines.put(params.lineNo, new Komment(lineNo:ordItem.lineNo, text:ordItem.desc, printCodes:['I']))
        		def bom = BOM.findAllByCompCodeAndItemNo(flow.ord.compCode, ordItem.itemNo)
       			def lineNo = params.lineNo.toInteger() + 1
        		bom.each {part ->
	                def partItem = new OrderDetailItem(compCode:flow.ord.compCode, orderNo:flow.ord.orderNo, 
	                		itemNo:part.partItemNo, lineNo:lineNo++, lineType:'I', 
	                		orderQty:part.partQty * ordItem.orderQty)
	                partItem.discard()
	                assert partItem.validate() 
	                flow.ordLines.put(g.formatNumber(number:partItem.lineNo, format:'0000'), partItem)
	                orderService.fleshOutOrderItemOnAdd(partItem, flow.ord, flow.ordLines, flow.ordDiscAllowList)
	            	orderService.fleshOutOrderItemOnUpdate(partItem, flow.ord, flow.ordLines, flow.ordDiscAllowList)
        		}
                flow.orderTotalInfo = orderService.calcTotal(flow.ordLines, flow.ord, flow.ordDiscAllowList, flow.inquiry)
        	}.to('lineItemSubfile')
            on("no") {
        		flow.ordItem = null
        	}.to('lineItemSubfile')
        }
        review {
            on("shippingInfo").to('shippingInfo')
            on("lineItemSubfile").to('lineItemSubfile')
            on("abort") {
            	session?.cust = null 
            	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/listOrders"
            }.to('endOrderFlow') 
            on("cancel") {
            	if (flow.ord.id) {
                	flow.ord.statusCode = 'X'
					flow.ord.cancelAfterDate = DateUtils.getBeginningOfTime()
                   	if (!flow.ord.save(flush:true)) flow.ord.errors.each { log.error it.inspect()}
            	}
            	session?.cust = null 
            	flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/listOrders"
            }.to('endOrderFlow') 
            on("complete") {
                /* see note in OrderFlowTests on unit test setup for these session objects 
                 * and why the non-flow completeOrder is used */
                session.ord = flow.ord
                session.ordLines = flow.ordLines
                session.custBillToAddr = flow.custBillToAddr
                session.ordDiscAllowList = flow.ordDiscAllowList
                session.thirdPartyBill = flow.thirdPartyBill
                session.ordDate = flow.ordDate
                flow.sendRedirect = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/completeOrder"
            }.to('endOrderFlow') 
        }
        endOrderFlow()
    }

    // re-direct from orderFlow to circumvent: java.io.NotSerializableException: org.hibernate.util.MarkerObject
    def completeOrder = {
    	boolean addMode = (session.ord.id == null)
		session.ordLines.keySet().findAll {it > '9990'}.each {key -> 
			session.ordLines.remove(key)
		}
		OrderTotalInfo orderTotalInfo = orderService.calcTotal(session.ordLines, session.ord, session.ordDiscAllowList, false)
		session.ord.orderTotal = orderTotalInfo.netAmount
		if (!session.ord.cancelAfterDate) {
			session.ord.cancelAfterDate = DateUtils.getBeginningOfTime()
		}
		log.debug "Order $session.ord.orderNo id: $session.ord.id saved with fobCode: $session.ord.fobCode"
		if (!session.ord.save(flush:true)) {
            session.ord.errors.each { log.error it.inspect()}
        }
		if (session.ord.hasExtraShipInst) {
	        int max = session.ordLines.keySet().findAll {it < '9900'}.max() as Integer
	    	def lineNo = max ? max-(max%10) + 10 : 10
            def komment = new Komment(lineNo:lineNo, text:session.ord.extraShipInst, printCodes:['P'])
            session.ordLines.put(g.formatNumber(number:komment.lineNo, format:'0000'), komment)
		}
		orderService.writeOrderLines(session.ordLines, session.ord.compCode, session.ord.orderNo, session.ord.shipNo)
		if (session.custBillToAddr) {
        	assert session.custBillToAddr.save(flush:true)
        }
        session.ordDiscAllowList.each { discAllow ->
	    	if (!discAllow.save(flush:true)) {
	    		 discAllow.errors.each { log.error it.inspect()}
	    	}
	    }
        List nonInvDiscAllowList = orderService.buildNonInvForOrdDiscAllow(session.ord.custNo, session.ordDiscAllowList, orderTotalInfo.netAmount) // TODO discriminate between netamt and totamt
        nonInvDiscAllowList.each {nonInvDiscAllow -> 
        	if (!nonInvDiscAllow.save(insert:true,flush:true)) {
        		nonInvDiscAllow.errors.allErrors.each { log.error it.inspect() }
        	}
        }
		if (session.ord.fobCode == 'TP') {
			if (session.thirdPartyBill?.class.name == Order3rdPartyBill.name) {
				if (session.thirdPartyBill?.makeCust3rdPartyBill) {
					def order3rdPartyBill = session.thirdPartyBill
					session.thirdPartyBill = new Cust3rdPartyBill(custNo:session.ord.custNo, carrierCode: session.ord.carrierCode)
					session.thirdPartyBill.properties = order3rdPartyBill.properties
					if (!order3rdPartyBill.save()) { // because this is still attached to the order
						order3rdPartyBill.errors.each {log.error it.inspect()}
					}
				}
			} else { // must be a Cust3rdPartyBill
				if (session.thirdPartyBill?.makeOrder3rdPartyBill) {
					def cust3rdPartyBill = session.thirdPartyBill
					session.thirdPartyBill = new Order3rdPartyBill(orderNo:session.ord.orderNo, shipNo: session.ord.shipNo)
					session.thirdPartyBill.properties = cust3rdPartyBill.properties
				}
			}
			if (!session.thirdPartyBill.save()) {
	    		session.thirdPartyBill.errors.each { log.error it.inspect()}
			}
		}
        if (session.ordDate) {
        	session.ordDate.save()
        } else {
			OrderDates.findWhere(compCode:session.ord.compCode, orderNo:session.ord.orderNo, shipNo:session.ord.shipNo)?.delete()
        }
        
        def orderNo = session.ord.orderNo
		session.orderNo = null
        session.cust = null
        session.ord = null
        session.ordLines = null
        session.custBillToAdd = null
        session.ordDiscAllowList = null
        session.thirdPartyBill = null
        session.ordDate = null
        [orderNo:orderNo, addMode:addMode]
    }
	
	private boolean hasPOBox(def objWithAddr123) {
		List boxes = [objWithAddr123.addr1, objWithAddr123.addr2, objWithAddr123.addr3]
		boolean foundPOBox = false            
    	boxes.each {
    		if  ( it ==~ /(?i)P[\. ]?O[\. ]?\s*BOX.*/ ) {
				foundPOBox = true
    		}
    	}
		return foundPOBox
	}
	
	def home = {
		if (params.webFlowMessage) {
			flash.message = params.webFlowMessage
			redirect action:'home' // to ste the message state to clear
		}
	}

	def pdfOrder = {
		def ord = OrderHeader.findByCompCodeAndOrderNo(params.compCode, params.orderNo)
		session.cust = Customer.findByCompCodeAndCustNo(params.compCode, ord.custNo)
		def ordLines = orderService.getOrderLines (ord.compCode, ord.orderNo)
		def shipTo = ShipTo.retreiveShipTo(ord.compCode, ord.custNo, ord.shipToNo, ord.orderNo, ord.shipNo)
		def ordDate = OrderDates.findWhere(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo)
	    def ordDiscAllowList = []
	    OrderDiscountAllowance.findAllByCompCodeAndOrderNo(ord.compCode, ord.orderNo).each {discAllow ->
	    	ordDiscAllowList << discAllow
	    }
	    def orderTotalInfo = orderService.calcTotal(ordLines, ord, ordDiscAllowList, true)
		render view:'/order/order/review', 
		       model:[ord:ord,ordLines:ordLines, shipTo:shipTo, ordDate:ordDate, 
		              ordDiscAllowList:ordDiscAllowList, orderTotalInfo:orderTotalInfo,
		              totalBalance: orderService.getTotalBalance(ord.compCode, ord.custNo, ord.orderNo)]
	}

	/* JSON DataTable actions */

	def selectOrder = {SelectOrderCommand cmd ->
	    if (cmd.hasErrors()) {
	        render (view:'selectOrder', model:[cmd:cmd])
	        return
	    }
       	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
       	def customers = []
       	if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
       		customers = user.customers
       	}
       	def url = "${CH.config.grails.serverURL}${g.createLinkTo(dir: '/')}order/order?"
       	params.each {name, value -> url += name+'='+value+'&' } 
       	redirect(url:url)
	}

    /* 
     *  Get all orders with statusCode determined by menu option 
     *  
     *  If no search criterion passed:
     *  	if role is customer, custNo = user.custNo
     *  	if role is rep orders for cust.salespersonCode = user.salesperson.id
     *  	if role is kettler, get all orders of statusCode = params.statusCode
     */
    def listOrders = {ListOrdersCommand cmd ->
	    if (cmd.hasErrors()) {
	        render (view:'selectOrder', model:[cmd:cmd, params:params])
	        return
	    }
		/*if request did not come from the search panel or a main.gsp menu option 
		 * (it probably came from Order Flow)
		 * reset params to saved search criterion
		 */ 
		if (params.search != 'Search' && !params.gspRequestNotRedirect && session.savedOrderSearchParams) {
    		log.debug "session.savedOrderSearchParams from order flow: $session.savedOrderSearchParams"
    		params.remove('Search')
    		session.savedOrderSearchParams.each {params.put(it.key, it.value)}
    		session.savedOrderSearchParams = null
    	}		
		
		def orderList 
		def count = 0
		params.invoiceNo = params?.invoiceNo?.replaceAll(/[^0-9]/, '')
		params.max = params.max?:'10'
		params.offset = params.offset?:'0'
	    params.sort = params.sort?:'orderNo'
		params.order = params.order?:'desc'
       	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
       	if (params.invoiceNo == '0') {
       		params.invoiceNo = null
       	}

		Class ordInvClass = OrderHeader.class
		if (params.orderOpenInvoicedBoth == 'B') {
			ordInvClass = OrderInvoiceMerge.class
		} else if (params.orderOpenInvoicedBoth == 'I') {
			ordInvClass = InvoicedOrderHeader.class
		}

		log.debug "status:$params.status orderOpenInvoicedBoth:$params.orderOpenInvoicedBoth statusCode:$params.statusCode poNo:$params.poNo invoiceNo:$params.invoiceNo creditMemo: $params.creditMemo, freightTrackingNo: $params.freightTrackingNo offset: $params.offset user.custNo $user.custNo user.salesperson.id: ${(user.salesperson?.id)}"
        if (params.poNo || params.invoiceNo || params.freightTrackingNo || params.creditMemo || params.status || params.custNo || params.fromInvoiceDate_year || params.salesperson1) {
        	def critList = {
                	and {
                		if (params.statusCode != ' ') 	  eq("statusCode", params.statusCode) // set by menu for update or inquiry all, BO, future etc.
                		if (params.statusCode == 'N')	  eq("webOrder", true) // 'N'ew show only web entered orders
    	                if (params.status)                eq("statusCode", params.orderOpenInvoicedBoth)
                        if (params.poNo)  				  ilike("poNo",                      params.poNo+'%')
    	                if (params.freightTrackingNo)	  ilike("freightTrackingNo",         params.freightTrackingNo+'%')
    	                if (params.invoiceNo) 			  eq("invoiceNo",   Integer.parseInt(params.invoiceNo))
    	                if (params.salesperson1?.trim() != '')    eq("salesperson1",                 params.salesperson1)
    	                if (params.creditMemo) 			  eq("creditMemoCode", true)
    	                if (params.custNo)	 			  eq("custNo", params.custNo.toUpperCase())
    	                if (params.fromInvoiceDate_year)  between("invoiceDate", cmd.fromInvoiceDate, cmd.toInvoiceDate)
println user.role.name
println user.custNo
println user.salesperson?.id
                        if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
                            eq("salesperson1", user.salesperson.id)
                            ne ('custNo', 'KE1108')
println "REP role, search on salesperson id and not ke1108"
                        } else if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
                            eq("custNo", user.custNo)
println "CUSTOMER role, search on custNo:"+user.custNo
                        } else {
                            ne ('custNo', 'KE1108')
                        }
                        //sqlRestriction " NOT EXISTS (SELECT * from ${CH.config.orderEntryLib}.pscusord ps where ps.ordernumber = this_.OORDN)"
                	}
                    maxResults(Integer.parseInt(params.max))
                    firstResult(Integer.parseInt(params.offset))
                    order(params.sort, params.order)
                }
        	def critCount = {
                    projections {rowCount()}
                	and {
                		if (params.statusCode != ' ') 	  eq("statusCode", params.statusCode)
                		if (params.statusCode == 'N')	  eq("webOrder", true) // 'N'ew show only web entered orders
    	                if (params.status)                eq("statusCode", params.orderOpenInvoicedBoth)
    	                if (params.poNo)  				  ilike("poNo",                      params.poNo+'%')
    	                if (params.freightTrackingNo)	  eq("creditMemoCode", true)
    	                if (params.invoiceNo) 			  eq("invoiceNo",   Integer.parseInt(params.invoiceNo))
    	                if (params.salesperson1?.trim() != '')    eq("salesperson1",                 params.salesperson1)
    	                if (params.creditMemo) 			  eq("creditMemoCode", true)
    	                if (params.custNo)	 			  eq("custNo", params.custNo.toUpperCase())
    	                if (params.fromInvoiceDate_year)  between("invoiceDate", cmd.fromInvoiceDate, cmd.toInvoiceDate)
    	                if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
    	                	eq("salesperson1", user.salesperson.id)
                            ne ('custNo', 'KE1108')
    	                } else if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
    	                	eq("custNo", user.custNo)
    	                } else {
                            ne ('custNo', 'KE1108')
                        }
                        //sqlRestriction " NOT EXISTS (SELECT * from ${CH.config.orderEntryLib}.pscusord ps where ps.ordernumber = this_.OORDN)"
                	}
                }
            orderList = ordInvClass.withCriteria(critList)
            def countArray = ordInvClass.withCriteria(unique:true, critCount) 
            count = countArray[0]
     		log.debug "count: $count = ordInvClass.withCriteria"  
        } else {
           	switch (user.role.name) {
           	case Role.CUSTOMER:
           	case Role.CUST_ADMIN:
        		if (params.statusCode != ' ') 	{ 
	           		orderList = ordInvClass.findAllByStatusCodeAndCustNo(params.statusCode, user.custNo, params)
	           		count = ordInvClass.countByStatusCodeAndCustNo(params.statusCode, user.custNo)  
	           		log.debug "count: $count = ordInvClass.countByStatusCodeAndCustNo($params.statusCode, $user.custNo)"
        		} else {
	           		orderList = ordInvClass.findAllByCustNo(user.custNo, params)
	           		count = ordInvClass.countByCustNo(user.custNo)  
	           		log.debug "count: $count = ordInvClass.countByCustNo($user.custNo)"
        		}
           		break
           	case Role.REP_ADMIN:
           	case Role.REP_PLUS:
           	case Role.REP:
        		if (params.statusCode != ' ') 	{ 
	           		orderList = ordInvClass.findAllByStatusCodeAndSalesperson1(params.statusCode, user.salesperson?.id, params)
	           		count = ordInvClass.countByStatusCodeAndSalesperson1(params.statusCode, user.salesperson?.id)  
	           		log.debug "count: $count = ordInvClass.countByStatusCodeAndSalesperson1($params.statusCode, $user.salesperson?.id)"
        		} else {
	           		orderList = ordInvClass.findAllBySalesperson1AndCustNoNotEqual(user.salesperson?.id, 'KE1108', params)
	           		count = ordInvClass.countBySalesperson1AndCustNoNotEqual(user.salesperson?.id, 'KE1108')  
	           		log.debug "count: $count = ordInvClass.countBySalesperson1($user.salesperson?.id)"
        		}
           		break
           	case Role.KETTLER:
        		if (params.statusCode && params.statusCode != ' ') 	{ 
	           		orderList = ordInvClass.findAllByStatusCodeAndCustNoNotEqual(params.statusCode, 'KE1108', params)
	           		count = ordInvClass.countByStatusCodeAndCustNoNotEqual(params.statusCode, 'KE1108')  
	         		log.debug "count: $count = ordInvClass.countByStatusCode($params.statusCode)"  
        		} else {
	           		orderList = ordInvClass.findAllByCustNoNotEqual('KE1108', params)
	           		count = ordInvClass.countByCustNoNotEqual('KE1108')  
	         		log.debug "count: $count = ordInvClass.count()"  
        		}
           		break
           	}
        }
        def customers = []
       	if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
       		customers = user.customers
       	}

        params.remove('gspRequestNotRedirect')
		session.savedOrderSearchParams = params
		params.gspRequestNotRedirect = true

		if (params.fromInvoiceDate_year) {
		   	GregorianCalendar cal = new GregorianCalendar ()
		   	cal.time = cmd.fromInvoiceDate
		   	params["fromInvoiceDate_year"] = cal.get(Calendar.YEAR).toString()
		   	params["fromInvoiceDate_month"] = (cal.get(Calendar.MONTH)+1).toString()
		   	params["fromInvoiceDate_day"] = cal.get(Calendar.DAY_OF_MONTH).toString()
		   	cal.time = cmd.toInvoiceDate
		   	params["toInvoiceDate_year"] = cal.get(Calendar.YEAR).toString()
		   	params["toInvoiceDate_month"] = (cal.get(Calendar.MONTH)+1).toString()
		   	params["toInvoiceDate_day"] = cal.get(Calendar.DAY_OF_MONTH).toString()
		}
		render view:'selectOrder', model:[customers:customers, orderList:orderList, count:count, cmd:cmd, params:params] 
    }

    def custDataTableAsJSON = {
        def custList
        def custCount 
        if (flash.name) {
        	custList = Customer.findAllByNameIlike("%${flash.name}%", params)
            custCount = Customer.countByNameIlike("%${flash.name}%")
        	flash.name = flash.name
        } else {
        	custList = Customer.list(params)
            custCount = Customer.count()
        }
        response.setHeader("Cache-Control", "no-store")
		def list = []
        custList.each {
            list << [ custNo:
                      "<a href='#' onclick=\"\$('custNo').value=\'${it.custNo}\';GRAILSUI.custDataTableDialog.cancel();\$('custDataTableDiv').hide();\">${it.custNo}</a>",
                      shortName:it.shortName, name:it.name,
                      addr1:it.addr1, state:it.state, zipCode:it.zipCode
                    ]
        }
        def data = [ totalRecords: custCount, results: list ]  
        render data as JSON
    }

	def custSearchforDataTable = {
		flash.name = params.nameSearch
		render template:"custDataTable"
	}

    def itemMasterDataTableAsJSON = {
       	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
        log.debug "$flash.desc $flash.upc  "
        
		def contractPriceItemNosForCustomer
		if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN || user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
			contractPriceItemNosForCustomer = ContractPrice.getItemNosForCust(session?.cust?.compCode?:user.compCode, session?.cust?.custNo?:user.custNo)
			log.debug "custNo: ${(session?.cust?.custNo?:user.custNo)} has ${contractPriceItemNosForCustomer?.size()} current contract price items"   
		}
		
        def itemMasterList = ItemMaster.withCriteria {
        	and {
                eq ('compCode', user.compCode?:'01')  
                eq ('activeCode', ' ')
                ne ('profitCenterClass', '6')
                or {
        			ne("profitCenterClass",	' ')
        			eq('shortName', 'KIT')
        		}
                if (contractPriceItemNosForCustomer) {
                	'in'('itemNo', contractPriceItemNosForCustomer)
                }
                if (flash.desc || flash.upc || flash.euroArticleNo) {
	                and {
	                    if (flash.desc)       ilike("desc", '%'+flash.desc+'%')
	                    if (flash.upc)           eq("upc",  		 Long.parseLong(flash.upc))
	                    if (flash.euroArticleNo) eq("euroArticleNo",  Long.parseLong(flash.euroArticleNo))
	                }
                }
                maxResults(Integer.parseInt(params.max))
                firstResult(Integer.parseInt(params.offset))
                order(params.sort, params.order)
        	}
        }
        def count = ItemMaster.withCriteria {
            projections {rowCount()}
        	and {
                eq ('compCode', session?.cust?.compCode ?: '01')
                eq ('activeCode', ' ')
                ne ('profitCenterClass', '6')
                or {
        			ne("profitCenterClass",	' ')
        			eq('shortName', 'KIT')
        		}
                if (contractPriceItemNosForCustomer) {
                	'in'('itemNo', contractPriceItemNosForCustomer)
                }
                if (flash.desc || flash.upc || flash.euroArticleNo) {
	                and {
	                    if (flash.desc)       ilike("desc", '%'+flash.desc+'%')
	                    if (flash.upc)           eq("upc",  		 Long.parseLong(flash.upc))
	                    if (flash.euroArticleNo) eq("euroArticleNo",  Long.parseLong(flash.euroArticleNo))
	                }
                }
        	}
        }
        flash.desc = flash.desc ?: null
        flash.upc = flash.upc ?: null
        response.setHeader("Cache-Control", "no-store")
		def list = []
        itemMasterList.each {
        	def desc = it.desc.replace("'", '')
            list << [ itemNo:"<a href='#' onclick=\"\$('itemNo').value=\'${it.itemNo}\';GRAILSUI.itemMasterDataTableDialog.cancel();\$('itemMasterDataTableDiv').hide();\$('itemDesc').innerHTML='${desc}';\">${it.itemNo}</a>",
                      desc:it.desc,color:it.color,stdUnitMeas:it.stdUnitMeas,upc:it.upc, compCode:it.compCode,euroArticleNo:it.euroArticleNo
                    ]
        }
        log.debug "itemMasterDataTableAsJSON returning ${list.size()} rows"
        def data = [ totalRecords: count, results: list ]
        render data as JSON
    }

	def itemMasterSearchforDataTable = {
		flash.desc = params.desc ?: null
        flash.euroArticleNo = params.euroArticleNo ?: null
        flash.upc = params.upc ?: null
		render template:"itemMasterDataTable"
	}

    def shipInstrDataTableAsJSON = {
        def shipInstrList = ShippingInstructions.list(params)
        response.setHeader("Cache-Control", "no-store")
        def anchor = "<a href='#' onclick=\"\$('shipInstructions').value='ROUTINGS'; refreshSpecialChargesSelects();  GRAILSUI.shipInstrDataTableDialog.cancel(); \$('shipInstrDataTableDialog').setStyle({left: '-999em'});\">"
		def list = [[id:"${anchor}ROUTINGS</a>", carrierCode:'', servType:'']]
        shipInstrList.each {
            list << [ id: "<a href='#' onclick=\"\$('shipInstructions').value='${it.id}'; refreshSpecialChargesSelects();  GRAILSUI.shipInstrDataTableDialog.cancel(); \$('shipInstrDataTableDialog').setStyle({left: '-999em'});\">${it.id}</a>",
                      carrierCode:it.carrierCode,servType:it.servType]
        }
        def data = [ totalRecords: ShippingInstructions.count(), results: list ]
        render data as JSON
    }
    def getShippingInstructionsForCarrier = {
        response.setHeader("Cache-Control", "no-store")
        def list = ShippingInstructions.findAllByCarrierCode(params.carrierCode)
        if (!list.size()) {
        	list = ShippingInstructions.findAllByCarrierCode(Carrier.get(params.carrierCode)?.shortDesc)
        }
        if (list.size()) {
        	render g.select(name:"shipInstructions", optionKey:'id', optionValue:'id',from:list)
        } else {
        	render "<select name='shipInstructions'><option value='C-TRAILER'>C-TRAILER</option><option value='R-TRAILER'>R-TRAILER</option></select>"
        }
     }
    		 
    /* get special charges by carrier code and service type */
    def specialChargesSelectAsJSON = {
        def shipInstr = ShippingInstructions.get(params.shipInstructions)
    	if (!shipInstr) {
    		return
    	}
        def spList = SpecialCharges.findAllByCarrierCodeAndServiceType(shipInstr.carrierCode, shipInstr.servType)
        def spCount =  SpecialCharges.countByCarrierCodeAndServiceType(shipInstr.carrierCode, shipInstr.servType)
		def list = []
        spList.each {
            list << [ chargeCode:it.chargeCode,chargeDescr:it.chargeDescr]
        }
        render list as JSON
    }

    def shipToDataTableAsJSON = {
        def shipToList = ShipTo.findAllByCompCodeAndCustNo(session.cust.compCode, session.cust.custNo, params)
        def shipToCount = ShipTo.countByCompCodeAndCustNo(session.cust.compCode, session.cust.custNo)
        response.setHeader("Cache-Control", "no-store")
		def list = []
        shipToList.each {
            list << [ name:
            	"""<a href='#' onclick=\"\$('shipToNo').value=${it.shipToNo};
                   GRAILSUI.shipToDataTableDialog.cancel();
                   \$('shipToDataTableDiv').hide();\">
                   ${it.name}</a>""",
                      city:it.city, state:it.state, zipCode:it.zipCode
                     ]
        }
        def data = [ totalRecords: shipToCount, results: list ]
        render data as JSON
    }

	def terms1DataTableAsJSON = {render termsDataTableAsJSON(1) as JSON}
	def terms2DataTableAsJSON = {render termsDataTableAsJSON(2) as JSON}
	def terms3DataTableAsJSON = {render termsDataTableAsJSON(3) as JSON}

	def checkDupPo = {
		render rpgService.isDuplicatePO(params.compNo, params.custNo, params.poNo, params.orderNo)
	}
	
	def address = {
        def shipTo = new ShipTo(params)
    	render template:'/common/address', model:[objWithAddr:shipTo]
     }
	
	/* internal methods */

    private Map termsDataTableAsJSON(int termIndex) {
        def list = []
        def termsList = Terms.list(params)
        response.setHeader("Cache-Control", "no-store")
        termsList.each {
            list << [ id: "<a href='#' onclick=\"javascript:\$('termsCode${termIndex}').value=${it.id};\$('pickTermsDialog${termIndex}').hide();\">${it.id}</a>", desc:it.desc ]
        }
        [ totalRecords: Terms.count(), results: list ]
    }
       	
    def inventoryAvail = {
    	InventoryInfo invInfo = orderService.getInvInfo(params.compCode, params.itemNo, params.warehouse)
		def orderQty = params.orderQty.isInteger()?params.orderQty.toInteger():1
    	if (invInfo.isAvailable(orderQty)) {
    		render 'Yes'
    	} else {
    		render 'No'
    	}
    }

}



