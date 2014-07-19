import java.util.List;

import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.actrcv.share.Return
import com.kettler.domain.actrcv.share.ReturnCondition
import com.kettler.domain.actrcv.share.ReturnDisposition
import com.kettler.domain.actrcv.share.ReturnItem
import com.kettler.domain.actrcv.share.ReturnItemDetail
import com.kettler.domain.actrcv.share.ReturnNote
import com.kettler.domain.actrcv.share.ReturnReason
import com.kettler.domain.actrcv.share.ReturnStatus
import com.kettler.domain.actrcv.share.ReturnFreightDesc
import com.kettler.domain.actrcv.share.ReturnFreightDenial

import com.kettler.domain.orderentry.share.Cart
import com.kettler.domain.orderentry.share.CartItem
import com.kettler.domain.orderentry.share.Carrier
import com.kettler.domain.orderentry.share.InvoicedOrderHeader
import com.kettler.domain.orderentry.share.InvoicedOrderDetailMisc
import com.kettler.domain.orderentry.share.InvoicedOrderDetailItem as InvoicedItem
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.share.ShipTo
import com.kettler.domain.orderentry.share.ShipVia
import com.kettler.domain.orderentry.share.WebUser

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemMasterExt;
import com.kettler.domain.item.share.BinLocationMaster;
import com.kettler.domain.item.share.ItemLocationMaster;

import com.kettler.domain.work.DateUtils 

import org.jsecurity.SecurityUtils

import grails.converters.JSON

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role

import groovy.sql.*

public class ReturnsController{
	def sessionFactory 
	def returnsService 
	def zeroPad6 = new java.text.DecimalFormat('000000')
	
	def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
	//  def afterInterceptor = {model -> log.debug("action: $actionName model: $model") } too verbose
	
	/* RESTful web-service
	 * pass email and password (as the sha1hash value in the webuser table)
	 * the security filter ignors this action
	 */
	def createCreditMemo = {
		WebUser user = WebUser.findByEmailAndPassword(params.email, params.password)
		if (!user || user.role.name != Role.KETTLER) {
			render "invalid email/password or not authorized"
			return
		}
		Return ra = Return.get(params.id.toInteger())
		if (!ra) {
			render "invalid Return Authorization number: $params.id"
			return
		}
		if (ra.status.id !=  'CMAPP') {
			render "invalid Return Authorization status: $ra.status.id"
			return
		}
		returnsService.updateWarehouseLocation(ra)
		int cmOrderNo = returnsService.convertToCreditMemo (ra, user.user400.id)
		
		render "${zeroPad6.format(cmOrderNo)} generated for RA $ra.id"
	}
	
	def getScac = {
		ShipVia shipVia = ShipVia.get(params.viaText)
		if (shipVia) {
			render shipVia.scacCode
		} else {  
			render "not found"
		}
	}
	/* all freight claims, by carrier, by reason codes for open or finalized freight claims.  
	 *  with optional selection for date range the amount submitted and paid on finalized claims including claims with no recovery.
	 *  TODO disallow Rep/Cust access to this option
	 */
	def claimsReport = {
        List raList = ReturnItem.withCriteria {
        	and {
				ra {
					eq("freightClaim", true)
	    		}
			}
        	order("reason.id", 'asc')
        }
        // TODO: replace with specific page sorted by carrier, etc.
        render view:'report', model:[ raList: raList, params:params ] 
			
	}
	/*  TODO disallow Rep/Cust access to this option*/
	def report = {
        List raList
        if (params.size() > 2) { // params contain more than action and controller
	        raList = ReturnItem.withCriteria {
	        	and {
		    		if (params.orderNo) 	 	eq("orderNo",   Integer.parseInt(params.orderNo)) 
		    		if (params.itemNo)	 	 	eq("itemNo",    params.itemNo) 
					ra {
						if (params.custNo)	 			eq("customer", 	Customer.findByCustNo(params.custNo.toUpperCase()) )
	            		if (params.returnNo)		 	eq("id", 		params.returnNo.toLong()) 
	            		if (params.status)			 	eq("status.id", params.status) 
		                if (params.custNo)	 			eq("customer", 	Customer.findByCustNo(params.custNo.toUpperCase()) )
		                if (params.freightClaimsOnly)   eq("freightClaim", true)
		    		}
				}
	        	order("reason.id", 'asc')
	        }
        }
        [ raList: raList, params:params ] 
	}
    def freightClaimReport = {
        List raList
        if (params.size() > 2) { // params contain more than action and controller
	        raList = Return.withCriteria {
	        	and {
		                                    eq("freightClaim", true)
		    		if (params.carrierId)  	eq("carrier",   Carrier.get(params.carrierId))
		    		if (params.fromDate)  	between("freightClaimSubmit",   params.fromDate, params.toDate)
                    switch (params.claimStatus) {
                    case 'unpaid':          eq('freightClaimAmountPaid', 0.0g);                         break
                    case 'paid':            geProperty('freightClaimAmountPaid', 'freightClaimAmount'); break
                    case 'balance':         ltProperty('freightClaimAmountPaid', 'freightClaimAmount'); break
                    case 'denied':          eq('freightClaimDenied', true);                             break
                    }
				}
	        }
        }
        [ raList: raList, params:params ]
    }
	def list = {
		params.max = params.max?:'8' 
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'id'
		params.order = params.order?:'asc'
		params.custNo = params.custNo?params.custNo.toUpperCase():null
		params.itemNo = params.itemNo?params.itemNo.toUpperCase():null
        def save_inquiry = params.inquiry

		if (params.search != 'Search' && session.savedRAListSearchParams) {
    		log.debug "params reset from session.savedRAListSearchParams: $session.savedRAListSearchParams"
    		session.savedRAListSearchParams.each {params.put(it.key, it.value)}
    		session.savedRAListSearchParams = null
    	}		
				
		List raList 
        int raTotal

        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
        boolean warehouse = user?.user400?.returnWarehouse?true:false
        		
        def customers = []
        if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
       		customers = user.customers
       	} 

        if (params.returnNo || params.orderNo || params.itemNo || params.status || params.custNo || 
        	params.freightClaimsOnly || user.role.name != Role.KETTLER) {
        	raList = Return.withCriteria {
                	and {
                		if (params.returnNo)		 	eq("id", 		params.returnNo.toLong()) 
                		if (params.status)			 	eq("status.id", params.status) 
    	                if (params.custNo)	 			eq("customer", 	Customer.findByCustNo(params.custNo.toUpperCase()) )
    	                if (params.freightClaimsOnly)   eq("freightClaim", true)
    	                if (params.orderNo || params.itemNo) {
    	            							items {
    	            		if (params.orderNo) 	 	eq("orderNo",   Integer.parseInt(params.orderNo)) 
    	            		if (params.itemNo)	 	 	eq("itemNo",    params.itemNo) 
    	            							}
    	                }
                		if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
                			eq("customer", 	Customer.findByCustNo(user.custNo) )
    	                } else if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
    	                	'in'('customer', customers)
    	                } 
                	}
                    maxResults(Integer.parseInt(params.max))
                    firstResult(Integer.parseInt(params.offset))
                    order(params.sort, params.order)
                }
        	def countArray = Return.withCriteria {
                    projections {rowCount()}
            		if (params.returnNo)		 	eq("id", 		params.returnNo.toLong()) 
            		if (params.status)			 	eq("status.id", params.status) 
	                if (params.custNo)	 			eq("customer", 	Customer.findByCustNo(params.custNo.toUpperCase()) )
   	                if (params.freightClaimsOnly)   eq("freightClaim", true)
	                if (params.orderNo || params.itemNo) {
	            							items {
	            		if (params.orderNo) 	 	eq("orderNo",   Integer.parseInt(params.orderNo)) 
	            		if (params.itemNo)	 	 	eq("itemNo",    params.itemNo) 
	            							}
	                }
            		if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) {
            			eq("customer", 	Customer.findByCustNo(user.custNo) )
	                } else if (user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN) {
	                	'in'('customer', customers)
	                } 
                }
        	raTotal = countArray[0]
		} else {
			raList = Return.list( params )
			raTotal = Return.count()
		}

        session.savedRAListSearchParams = params
		params.search='Search' // so it is in pagination
        params.inquiry = save_inquiry
        [ raList: raList.unique(), raTotal: raTotal, user:user, params:params ] 
	}
	def show = {
        def ra = Return.get( params.id )

        if(!ra) {
            flash.message = "Return not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ ra : ra ] }
	}
	def showPdf = {
		[ ra : Return.get( params.id ) ]
	}
	def returnFlow = {
	        begin {
	            action {
	            	flow.user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
                   	flow.warehouse = flow.user?.user400?.returnWarehouse?true:false
					flow.salesUser = flow.user?.user400?.returnSales?true:false
                    flow.inquiry = (params.inquiry == 'true')?true:false
	            	if (params.id) {
	                    flow.ra = Return.get( params.id )
	                    flow.fgtClmAmtTtl = sumFreightClaimAmount(flow.ra)
		        		flow.cust = flow.ra.customer
		        		flow.images = getImages(flow.ra)
		        		if (flow.ra.hold) {
		        			flash.message = "RA is on hold"
		        		}
	                    if (isMultiOrder(flow.ra)) {
		                    if (flow.ra.shipHandCustCr && flow.ra.shipHandDesc.descr != 'GST') {
	                    		def handlingInvoiced = sumInvoicedDistrCode(flow.ra, 'HDL')
	                    		if (!handlingInvoiced || handlingInvoiced > flow.ra.shipHandCustCr) {
	                    			flash.message = "Warning: Total invoiced HDL is ${handlingInvoiced} but the handling cr is $flow.ra.shipHandCustCr, the generated Credit Memo must be adjusted manually "
	                    		}
		                    }
		                    if (flow.ra.freightCustCr) {
	                    		def freightInvoiced = sumInvoicedDistrCode(flow.ra, 'FRT')+sumInvoicedDistrCode(flow.ra, 'UPS')+sumInvoicedDistrCode(flow.ra, 'IHC')
	                    		if (!freightInvoiced || freightInvoiced > flow.ra.freightCustCr) {
	                    			flash.message = "Warning: Total invoiced freight is ${freightInvoiced} but the freight cr is $flow.ra.freightCustCr, the generated Credit Memo must be adjusted manually "
	                    		}
		                    }
	                    }
						if (flow.ra.customer.custNo == 'KE1126' && flow.ra.items.toArray()[0].orderNo ) {
							flow.cart = Cart.findByOrderNo(flow.ra.items.toArray()[0].orderNo)
						}
	                    flow.ra.items.each {raItem ->
	                    	if (!ItemMaster.findByCompCodeAndItemNo(flow.ra.customer.compCode, raItem.itemNo)) {
	                    		flash.message ="Warning: $raItem.itemNo not in item master"
	                    	}
	                    }
                        flow.raTotal = returnsService.calcTotal(flow.ra)
	                    buildReturn()
	            	} else if ([Role.CUSTOMER, Role.CUST_ADMIN].find { it == flow.user.role.name }) {
	            		flow.cust = Customer.findByCompCodeAndCustNo(flow.user.compCode, flow.user.custNo)
		        		flow.ra = new Return(customer:flow.cust, createDate:new Date(), 
		        				             createUser:SecurityUtils.getSubject()?.getPrincipal(),
		        				             noRA:flow.warehouse)
	                    buildReturn()
	            	} else if ([Role.KETTLER, Role.REP_PLUS, Role.REP, Role.REP_ADMIN].find { it == flow.user.role.name }) {
						promptCust()
					}
	            	
	            }
	            on('endReturnFlow').to("endReturnFlow")
	            on('promptCust').to("promptCust")
	            on('buildReturn').to("buildReturn")
	        }
	        promptCust {
	        	on("next") {
	        		def cust = Customer.findByCompCodeAndCustNo(params.compCode, params.custNo.toUpperCase())
	        		if (!cust) {
                		flash.message = 'Invalid Customer Number'
                	    return error()
	                } 
	        		flow.cust = cust
	        		flow.ra = new Return(customer:cust, createDate:new Date(), 
	        				             createUser:SecurityUtils.getSubject()?.getPrincipal(),
	        				             noRA:flow.warehouse)
	        	}.to('buildReturn')
	        }
	        promptCustAction {
	        	action {
	        	}
	        	on('buildReturn').to 'buildReturn'
	        	on('redisplay').to 'promptCust'
	        }
	        buildReturn {
	        	on("cancel"                 ).to('returnList')  
	        	on("complete", 		onUpdate).to('complete')
	        	on("delete"                 ).to('delete')  
	        	on("forceDiff", 	onUpdate).to('complete') // complete will look for params._eventId_forceDiff
	        	on("update",   		onUpdate).to('buildReturn')   
	        	on("approve",  		onUpdate).to('approve')   
	        	on("deny", 	   		onUpdate).to('deny')   
	        	on("queSales", 		onUpdate).to('queSales')   
	        	on("queReceiving", 		onUpdate).to('queReceiving')   
	        	on("pendApproval",  onUpdate).to('pendApproval')   
	        	on("hold",          onUpdate).to('hold')   
	        	on("release"                ).to('release')   
	        	on("reject", 	   	onUpdate).to('reject')   
	        	on("backToPendApp", onUpdate).to('pendApproval')
	        	on("generateCM",    onUpdate).to('complete')  
	        }
	        delete {
	        	action {flow.ra.delete()}
	        	on('success').to('returnList')
	        }
	        approve {
	        	action {flow.ra.status = ReturnStatus.get('CMAPP') }
	        	on('success').to('returnList')
	        }
	        deny {
	        	action {flow.ra.status = ReturnStatus.get('DENYD') }
	        	on('success').to('returnList')
	        }
	        queSales {
	        	action {flow.ra.status = ReturnStatus.get('CMQUE') }
	        	on('success').to('returnList')
	        }
	        queReceiving {
	        	action {flow.ra.status = ReturnStatus.get('CMQWH') }
	        	on('success').to('returnList')
	        }
	        pendApproval {
	        	action {flow.ra.status = ReturnStatus.get('CMPEN') }
	        	on('success').to('returnList')
	        }
	        hold {
	        	action {BuildReturnItemsCommand itemCmd ->
	        		flow.ra.hold = true
	        		if (!flow.ra.id) {
	        			complete()
	        		} else {
	        			returnList()
	        		}
	        	}
	            on('complete').to("complete")
	        	on('returnList').to('returnList')
	        }
	        release {
	        	action {flow.ra.hold = false }
	        	on('success').to('returnList')
	        }
	        reject {
	        	action {flow.ra.status = ReturnStatus.get('RAREJ') }
	        	on('success').to('returnList')
	        }
	        complete {
	        	action {
		    		def beforeSaveStatus = flow.ra.status
		    		if (!flow.ra.id) { // just entered  
		    			if (flow.ra.fieldDestroy) {
		    				if (flow.ra.hold) {
		    					flow.ra.status = ReturnStatus.get('NEWRA')
		    				} else {
		    					flow.ra.status = ReturnStatus.get('CMPEN')
		    				}
		    			} else if (Role.KETTLER == flow.user.role.name ) {
							if (flow.salesUser) flow.ra.status = ReturnStatus.get('NEWRA')
		    				else if (flow.warehouse) flow.ra.status = ReturnStatus.get('NORA')  
		    				else                flow.ra.status = ReturnStatus.get('NEWRA')
		    			} else {
		    				flow.ra.status = ReturnStatus.get('RAREQ')
		    			}
		    		} else if (flow.ra.status.id == 'NEWRA') {  
		    			if (flow.warehouse) {
		    				flow.ra.returnDate = new Date()
		    				flow.ra.receivedBy = flow.user.email
		    				if (params._eventId_forceDiff || 
		    				    (flow.ra.items.find {it.receivedQty != it.authQty} && !flow.ra.fieldDestroy)
		    				    ) {
		    					flow.ra.status = ReturnStatus.get('CMDIF')
								sendMail {
		    		                to flow.ra.createUser
		    		                subject "RA $flow.ra.id received a quantity that does not match the authorized quantity"
		    		                body "RA $flow.ra.id received a quantity that does not match the authorized quantity, see https://www.kettlerusa.com/kettler/returns/return/$flow.ra.id"
		    		                from "webmaster@kettlerusa.com"
		    					}
		    				} else {
		    					flow.ra.status = ReturnStatus.get('CMPEN')
		    				}
		    				/* when refurbish/restock is set, assumption is that all items come back new,
		    			       if any of them are not, set the status to CMDIF */
	    				    if (flow.ra.refurbRestockCustDb) {
	    				    	def notNew = false
	    				    	flow.ra.items.each {item ->
	    				    		if (item.details.find {it.condition != ReturnCondition.findByCode('NEW')}) {
	    				    			notNew = true
	    				    		}
	    				    	}
	    				    	if (notNew) {
			    					flow.ra.status = ReturnStatus.get('CMDIF')
	    				    	}
	    				    }

		    			} else if (flow.ra.fieldDestroy) { 
			    			flow.ra.status = ReturnStatus.get('CMPEN')
		    			}
		    		} else if (flow.ra.status.id == 'CMAPP' && params._eventId_generateCM) {
						returnsService.updateWarehouseLocation(flow.ra)
		    			int cmNo = returnsService.convertToCreditMemo (flow.ra, flow.user.user400.id)
		    			flow.ra.status = ReturnStatus.get('CMFIN')
		    			session.message = "Credit Memo $cmNo generated for RA $flow.ra.id"
		    			log.debug session.message
		    		}
		    		flow.ra.changeDate = new Date()
		    		flow.ra.changeUser = flow.user.email
		    		def preSaveRaId = flow.ra.id
		    		if (!flow.ra.save()) {
                        flow.ra.errors.each{println it}
		    			flow.ra.status = beforeSaveStatus // set back so fields are input capable
		    			session.message = null
		    			return error()
		    		}  
		    		if (!params._eventId_generateCM) {
		    			session.message = session.message?:''+"RA No: $flow.ra.id ${(preSaveRaId?'updated':'created')}"
		    		}
	        	}
	        	on('success').to('returnList') 
	        	on('error').to 'buildReturn'
	        } // complete
	        returnList() {
    			redirect controller:'returns', action:'list', params:[inquiry:flow.inquiry] 
	        }
        	endReturnFlow()
	}
	private BigDecimal sumInvoicedDistrCode(Return ra, String code) {
		def distinctOrders = ReturnItem.withCriteria {
			eq 'ra', ra
			projections {distinct "orderNo"}
		} 
	    def freight = InvoicedOrderDetailMisc.withCriteria {
	        eq 'compCode', ra.customer.compCode
	        'in'('orderNo', distinctOrders)
	        eq 'distrCode', code
	        projections {sum "amount"};
	    }[0]?:0
	    log.debug "sumInvoicedDistrCode(ra, $code) on distinctOrders: $distinctOrders returned: $freight"
	    return freight
	}
   	private int getNextImageNo(Return ra) {
		int lastNo = 0
		new File(CH.config.returns.image.directory).eachFileMatch(~/RA${ra.id}.*/){file ->
			  def matcher = file =~ /RA${ra.id}_(\d*).*/
			  lastNo = matcher[0][1].toInteger()
		}
		return ++lastNo
   	}
   	private List putImage(Return ra, def request, def session) {
		def image = request.getFile('image');
		if (image?.size) {
			if (image.size < CH.config.returns.image.max.size) {
    			int nextNo = getNextImageNo(ra)
    			image.transferTo(new File("${CH.config.returns.image.directory}RA${ra.id}_${nextNo}.jpg"))
			} else {
    			session.message = "Image exceeds max size of ${(CH.config.returns.image.max.size / 1024 / 1024)} MB. "
			}
		}
		return getImages(ra)
   	}
	private List getImages(Return ra) {
		def images = []
		new File(CH.config.returns.image.directory).eachFileMatch(~/RA${ra.id}.*/){file ->
			images << file.name
		}
		return images
	}
    def renderImage = {
    	def image = new File(CH.config.returns.image.directory+params.name) 
    	println image.dump()
        response.setContentLength(image.size().toInteger())
        response.outputStream.write(image.bytes)
    }
    def showImage = {
    	render template:'showImage', model:[name:params.id]
    }
	private onUpdate = { BuildReturnItemsCommand itemCmd ->
		log.debug "params: $params"
		if (!itemCmd.validate()) { 
			return error()
		}
        // hack set of null date to end of time to pass auto-validate in flow.ra.properties = params
        params.carrierNotifiedDate = params.carrierNotifiedDate?:DateUtils.endOfTime
		params.freightClaimPaid = params.freightClaimPaid?:DateUtils.endOfTime
		params.freightClaimSubmit = params.freightClaimSubmit?:DateUtils.endOfTime
				
        flow.ra.properties = params // does a validate that ignore nullable:true on dates
        
        // undo hack set of null date to end of time  
        flow.ra.carrierNotifiedDate = DateUtils.isEndOfTime(flow.ra.carrierNotifiedDate)?null:flow.ra.carrierNotifiedDate
		flow.ra.freightClaimPaid    = DateUtils.isEndOfTime(flow.ra.freightClaimPaid)?null:flow.ra.freightClaimPaid
		flow.ra.freightClaimSubmit  = DateUtils.isEndOfTime(flow.ra.freightClaimSubmit)?null:flow.ra.freightClaimSubmit
				
		if (params.shipHandCustCr && params.shipHandDescX) {
            flow.ra.shipHandDesc = null
            flow.ra.shipHandDesc = ReturnFreightDesc.get(params.shipHandDescX.toInteger())
		} 
		if (params.freightCustCr && params.freightDescX) {
            flow.ra.freightDesc = null
            flow.ra.freightDesc = ReturnFreightDesc.get(params.freightDescX.toInteger())
		}
		// add/update ReturnItem(s)
        if (flow.ra.status == null || null == ['DENYD'].find {it == flow.ra.status?.id}) {
	        itemCmd.itemNo.eachWithIndex {itemNo, i ->
				if (itemCmd.newYorN[i] == 'Y' && itemCmd.qty) { // add new return items
					def args = [orderNo:itemCmd.orderNo[i], shipNo:itemCmd.shipNo[i], itemNo:itemCmd.itemNo[i], unitPrice:itemCmd.unitPrice[i], 
							    desc:itemCmd.desc[i], reason:ReturnReason.get(itemCmd.reasonId[i].toInteger()), noRA:flow.warehouse] 
			        if (flow.warehouse) {
			        	args.receivedQty = itemCmd.qty[i]
			        } else {
			        	args.authQty = itemCmd.qty[i];
			        }
                    // set freight distribution code from the first invoiced order
					if (i == 0 && itemCmd.orderNo[0]) {  
					    flow.ra.freightCustCrDistrCode = 'FRT'
						InvoicedOrderDetailMisc.findAllWhere(compCode:flow.ra.customer?.compCode, orderNo:itemCmd.orderNo[i]).each {misc ->
						    if ('UPS' == misc?.distrCode) {
                                flow.ra.freightCustCrDistrCode = 'UPS'
						    }
						}
   					}                                      
					flow.ra.addToItems(new ReturnItem(args))
				} else { // update or delete return items  
					def item = flow.ra.items.find { it.itemNo == itemCmd.itemNo[i] && it.orderNo == itemCmd.orderNo[i]}
					if (itemCmd.delete[i] == 'Y') { // delete it
						flow.ra.items -= item
						item.delete()
					} else { // update it
	                    if (itemCmd.qty) {
					        if (flow.warehouse) {
					        	item.receivedQty = itemCmd.qty[i]
					        } else {
					        	item.authQty = itemCmd.qty[i];
					        }
	                    }

	                    if (itemCmd.reasonId) { //reasonId/unitPrice not passed if disabled
	                    	item.reason = ReturnReason.get(itemCmd.reasonId[i].toInteger())
							item.unitPrice = itemCmd.unitPrice[i]
	                    }
						if (item.details) { // ReturnItemDetail exists so update them
							if (flow.warehouse && 'CMQUE' != flow.ra.status?.id ) {
								item.details.eachWithIndex {detail, j ->
	                                if (itemCmd.qty && 'CMQWH' != flow.ra.status?.id) {
	                                	boolean numberFormatException = false
										detail.dtlWarehouse = getParamString("itemNo${item.itemNo}dtlWar${j}", params)
										detail.dtlLocation = getParamString("itemNo${item.itemNo}dtlLoc${j}", params)
	                                    try {
		                                    detail.condition = ReturnCondition.get(getParam("itemNo${item.itemNo}cond_idx${j}", params))  
			    							detail.disposition = ReturnDisposition.get(getParam("itemNo${item.itemNo}disp_idx${j}", params))
	                                    } catch (NumberFormatException nfe) {
	                                        numberFormatException = true
	                                    }
										if (numberFormatException || !detail.condition || !detail.disposition) {
											flash.message = 'Please select a condition and a disposition for each received item'
											return error()
										}
										if (detail.disposition.code == "RETURN TO STOCK"){
											boolean errorWarehouse = false
											boolean errorLocation = false
											if (detail.dtlWarehouse.trim() == 'P'){
												if (!detail.dtlLocation){
													errorWarehouse = true
												}
												if (! BinLocationMaster.findWhere (compCode: '01', warehouse:detail.dtlWarehouse?:'', location:detail.dtlLocation)){
													errorLocation = true
												}
											}
											if (errorWarehouse){
												flash.message = 'Please enter location for parts warehouse'
												return error()
											}
											if (errorLocation){
												flash.message = "Location does not exist"
												return error()
											}
										}
	                                }
	                                def freightClaimAmount = params["itemNo${item.itemNo}FreightClaimAmount_idx${j}"] 
	                                if (freightClaimAmount) {
	                                	detail.freightClaimAmount = freightClaimAmount.toBigDecimal()
	                                }
	                                detail.freightClaimGLCode = params["itemNo${item.itemNo}FreightClaimGLCode_idx${j}"]
	                                def freightDenial = params["itemNo${item.itemNo}freightDenial_idx${j}"]
	                                if (freightDenial && freightDenial != 'null') {
	                                    detail.freightDenial = ReturnFreightDenial.get(freightDenial.toInteger())
	                                } else {
	                                	detail.freightDenial = null
	                                }
	                                ItemMaster itemMaster = ItemMaster.findByCompCodeAndItemNo(flow.ra.customer.compCode, item.itemNo)
									if (itemMaster?.activeCode == 'I' &&  detail.disposition == ReturnDisposition.get(1)) {
										flash.message = 'Disposition cannot be Return to Stock for an inactive item'
										return error()
									}
	                            }
								// delete details where count is greater than item's qty
	                            if (itemCmd.qty) {
		                                while (item.details.size() > itemCmd.qty[i]) { 
											ReturnItemDetail dtlToDelete = item.details.toArray()[item.details.size()-1]
											item.removeFromDetails(dtlToDelete)
											dtlToDelete.delete() // could use hibernate's cascade delete...
		                                }
								    // add details where count is less than item's qty
									boolean detailsAdded = false
									while (item.details.size() < itemCmd.qty[i]) {
										item.addToDetails(new ReturnItemDetail())
										detailsAdded = true
									}
									if (detailsAdded) {
										flash.message = 'Please select a condition and a disposition for each received item'
										return error()
									}
	                            }
							}
						} else if (itemCmd?.qty) { // ReturnItemDetail do not exist yet so add them
							item.details = null // clear in case previous update (with no disk write) put them there
							(0..<itemCmd.qty[i]).each {j ->
								def dtl = new ReturnItemDetail()
								if (flow.warehouse) {
									def dtlWarehouse = params["itemNo${item.itemNo}dtlWar${j}"]
									def dtlLocation = params["itemNo${item.itemNo}dtlLoc${j}"]
									def cond = params["itemNo${item.itemNo}cond_idx${j}"]
									if (cond) {
										dtl.condition = ReturnCondition.get(cond.toInteger())
									}
									def disp = params["itemNo${item.itemNo}disp_idx${j}"]
									if (disp) {
										dtl.disposition = ReturnDisposition.get(disp.toInteger())
									}
									if (!cond || !disp) {
										flash.message = 'Please select a condition and a disposition for each received item'
										return error()
									}
	                                def freightClaimAmount = params["itemNo${item.itemNo}FreightClaimAmount_idx${j}"] 
	                                if (freightClaimAmount) {
	                                    dtl.freightClaimAmount = freightClaimAmount.toBigDecimal()
	                                }
	                                dtl.freightClaimGLCode = params["itemNo${item.itemNo}FreightClaimGLCode_idx${j}"]
	                                def freightDenial = params["itemNo${item.itemNo}freightDenial_idx${j}"]
	                                if (freightDenial) {
	                                	dtl.freightDenial = ReturnFreightDenial.get(freightDenial.toInteger())
	                                }
	                            }
								item.addToDetails(dtl)
							}
						}
					}
				}
			}
        }  //  if (flow.ra.status == null || null == ['CMFIN', 'DENYD'].find {it == flow.ra.status?.id})
   		// add/update comments
		if (params.aNote) {
			def notes = []
			def noteIds = []
			if (params.aNote?.class == java.lang.String) { // convert single to a list
				notes << params.aNote
				noteIds << params.aNoteId
			} else {
				notes = params.aNote
				noteIds = params.aNoteId
			}
			// clear all new notes as they will be re-added
			flow.ra.notes.findAll {it.id == null}.each {flow.ra.notes -= it }
			notes.eachWithIndex {note, i ->
				def noteExists = flow.ra.notes.find {it.id == noteIds[i]?.toLong()}
				if (noteExists) {
					noteExists.note = note
					noteExists.showOnPdf =  params["aNotePdf${i}"]=='on'?true:false
				} else {
					flow.ra.addToNotes (new ReturnNote(note:note, user:SecurityUtils.getSubject()?.getPrincipal(), showOnPdf:params["aNotePdf${i}"]=='on'?true:false))
				}
			}
		}
		
		// update Return 
		if (!flow.ra.name) {
			// get address from first Invoiced Order, use ShipTo, if available, otherwise Cust address
			def itemWithOrder = flow.ra.items.find {it.orderNo}
			if (itemWithOrder) {
				InvoicedOrderHeader invoice = InvoicedOrderHeader.findByCompCodeAndOrderNo(flow.ra.customer.compCode, itemWithOrder.orderNo)
				flow.shipTo = ShipTo.retreiveShipTo(invoice.compCode, invoice.custNo, invoice.shipToNo, invoice.orderNo, invoice.shipNo)
				if (flow.shipTo) {
					flow.ra.properties =  flow.shipTo.properties
				}
			}  
		}
		if (!flow.ra.name) { // if address is still not there, use the customer address
			flow.ra.name = flow.ra.customer.name
			flow.ra.addr1 = flow.ra.customer.addr1
			flow.ra.addr2 = flow.ra.customer.addr2?:''
			flow.ra.addr3 = flow.ra.customer.addr3?:''
			flow.ra.city = flow.ra.customer.city
			flow.ra.state = flow.ra.customer.state
			flow.ra.zipCode = flow.ra.customer.zipCode
			flow.ra.countryCode = flow.ra.customer.countryCode
		}
		
		flow.images = putImage(flow.ra, request, session)

		if (!flow.ra.status) {
			if (flow.salesUser) flow.ra.status = ReturnStatus.get('NEWRA')
			else flow.ra.status = ReturnStatus.get(flow.warehouse?'NORA':'NEWRA') // set a default so validate() doesn't report a status error
		}
        flow.fgtClmAmtTtl = sumFreightClaimAmount(flow.ra)
		if (flow.warehouse && flow.ra.id && flow.ra.status == ReturnStatus.get('NEWRA')) {
			if (!flow.ra.save(flush:true)) {

                flow.ra.errors.each{println it}
				return error()
			}
		}
        flow.raTotal = returnsService.calcTotal(flow.ra)
   	}  
	
	// when item no is in the RA multiple times the value in params is an array...
	// handle single or multiple params of duplicate name/key
	private int getParam(String key, def params) {
		if (params[key].size()) {
			return params[key][0].toInteger()
		}
		return params[key].toInteger()
	}

	private String getParamString(String key, def params) {
		if (params[key].size()) {
			return params[key]
		}
		return params[key]?:''
	}

		
    def invoicedItemsByOrder = {
		int orderNo
        if (params.poNo) {
        	orderNo = InvoicedOrderHeader.findByPoNo(params.poNo)?.orderNo?:0 
        } else if (params.freightTrackingNo) {
        	orderNo = InvoicedOrderHeader.findByFreightTrackingNo(params.freightTrackingNo)?.orderNo?:0 
        } else if (params.orderNo) {
        	orderNo = params.orderNo?.toInteger()?:0
        }
        def list
        def count 
        if (orderNo) {
	        list = InvoicedItem.findAllWhere(compCode:params.compCode, custNo:params.custNo, orderNo:orderNo, lineType:'I')
		    count = list?.size()?:0
        }
        if (!count) {
        	log.warn "null = InvoicedItem.findAllWhere(compCode:$params.compCode, custNo:$params.custNo, orderNo:$orderNo, lineType:'I')"
        }
        response.setHeader("Cache-Control", "no-store")
        render(template:"invoicedItemsByOrder", model:[list:list, count:count])
    }

    def invoicedOrderSelect = {
        params.max = params.max?:'10' 
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'orderNo'
		params.order = params.order?:'desc'
		def list 
        def count 
		if ((params.poNo && params.poNo != 'undefined') || 
            (params.freightTrackingNo && params.freightTrackingNo != 'undefined') ) {
				log.debug "search by custNo $params.custNo and poNo $params.poNo or freightTrackingNo $params.freightTrackingNo"
	        	list = InvoicedOrderHeader.withCriteria {
                	and {
						eq("custNo",		params.custNo)
						if (params.poNo && params.poNo != 'undefined') {
							eq("poNo", 		params.poNo) 
						}
						if (params.freightTrackingNo && params.freightTrackingNo != 'undefined') {
							eq("freightTrackingNo", 		params.freightTrackingNo) 
						}
						ne("creditMemoCode", 'Y')
					}
	                maxResults(Integer.parseInt(params.max))
                    firstResult(Integer.parseInt(params.offset))
                    order(params.sort, params.order)
			}
        	def countArray = InvoicedOrderHeader.withCriteria {
                    projections {rowCount()}
                	and {
						eq("custNo",		params.custNo)
						if (params.poNo && params.poNo != 'undefined') {
							eq("poNo", 		params.poNo) 
						}
						if (params.freightTrackingNo && params.freightTrackingNo != 'undefined') {
							eq("freightTrackingNo", 		params.freightTrackingNo) 
						}
						ne("creditMemoCode", 'Y')
					}
                }
        	count = countArray[0]
		} else {
			log.debug "list all orders for custNo: params.custNo"
			list = InvoicedOrderHeader.findAllByCustNo(params.custNo, params)
        	count = InvoicedOrderHeader.count()
		}
        response.setHeader("Cache-Control", "no-store")
        render(template:"invoicedOrderSelect", model:[list:list, count:count])
    }
	
	
    def invoicedOrderDataTableAsJSON = {
    	def ordList = InvoicedOrderHeader.findAllByCustNo(params.custNo, params)
        def ordCount = InvoicedOrderHeader.count()//ByCustNo(flash.custNo)
        response.setHeader("Cache-Control", "no-store")
		def list = []
		ordList.each {
            list << [ orderNo:
                      "<a href='#' onclick=\"\$('orderNo').value=\'${it.orderNo}\';GRAILSUI.invoicedOrderDataTableDialog.cancel();\$('invoicedOrderDataTableDiv').hide();ajaxInvoicedItemLookup();\">${it.orderNo}</a>",
                      poNo:it.poNo, orderDate:it.orderDate]
        }
        def data = [ totalRecords: ordCount, results: list ]
        render data as JSON
    }

	def invoicedOrderSearchforDataTable = {
		render template:"invoicedOrderDataTable"
	}
    
    def total = {
		Return ra = Return.get(params.id)
        if (ra) {
        	render returnsService.calcTotal(ra) as String
        } else {
        	render '0.00'
        }
    }
	private BigDecimal sumFreightClaimAmount(Return ra) {
	   BigDecimal fgtClmAmt = 0.00g
	   ra.items?.each {item -> 
	       item?.details.each {dtl ->
            	fgtClmAmt += dtl.freightClaimAmount?:0
	       }
	   }
	   return fgtClmAmt   
	}
    def photo = {
    	println request.getFile("file").inputStream.text
    }
    private boolean isMultiOrder (Return ra) {
    	int count = ReturnItem.withCriteria {
    		eq 'ra', ra
    		projections {countDistinct "orderNo"}
    	}[0]?:1
    	return (count > 1) as boolean
    }
}



// use command to handle multiple input table elements of the same name
class BuildReturnItemsCommand {
		
	String[] itemNo
	int[] orderNo
    int[] shipNo
    int[] qty
	BigDecimal[] unitPrice
	String[] desc
	String[] newYorN
	String[] delete
	String[] reasonId
	String[] dtlWarehouse
	String[] dtlLocation
}
