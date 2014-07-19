import com.kettler.domain.orderentry.share.Carrier
import com.kettler.domain.orderentry.ContractPrice
import com.kettler.domain.orderentry.share.Control
import com.kettler.domain.orderentry.CustDiscAllow
import com.kettler.domain.orderentry.CustomerComments
import com.kettler.domain.orderentry.DiscountAllowanceCode
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.share.OrderDiscountAllowance
import com.kettler.domain.orderentry.QuoteDetailItem
import com.kettler.domain.orderentry.QuoteDetailComment
import com.kettler.domain.orderentry.QuoteDetailMisc
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.share.SalesTax
import com.kettler.domain.orderentry.SalesTermsTier
import com.kettler.domain.orderentry.share.ShipTo
import com.kettler.domain.orderentry.share.ShipVia
import com.kettler.domain.orderentry.Terms
import com.kettler.domain.orderentry.share.UserControl
import com.kettler.domain.orderentry.share.WebUser

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemWarehouse
import com.kettler.domain.item.share.BillOfMaterials as BOM

import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.actrcv.Distribution

import com.kettler.domain.varsity.ShippingInstructions

import com.kettler.domain.work.InventoryInfo
import com.kettler.domain.work.OrderTotalInfo
import com.kettler.domain.work.Komment

import grails.util.Environment

import org.codehaus.groovy.grails.commons.ConfigurationHolder

class OrderService implements Serializable {

    boolean transactional = false //true
    def sessionFactory
    
    def zeroPad4 = new java.text.DecimalFormat('0000')

    TreeMap getOrderLines(String compCode, int orderNo) {
    	return getQuoteOrOrderLines(compCode, orderNo, 'Order')
    }
    TreeMap getQuoteLines(String compCode, int orderNo) {
    	return getQuoteOrOrderLines(compCode, orderNo, 'Quote')
    }

    /* get order lines from order item, comments, and miscellaneous tables */
    private TreeMap getQuoteOrOrderLines (String compCode, int orderNo, String orderOrQuote) {
		def ordLines = new TreeMap()
        
        def lineMap = new TreeMap()

		if (orderOrQuote == 'Order') {
	        OrderDetailItem.findAllByCompCodeAndOrderNo(compCode,    orderNo, [sort:'lineNo']).each {lineMap.put(it.lineNo, it) }
	        OrderDetailComment.findAllByCompCodeAndOrderNo(compCode, orderNo, [sort:'lineNo']).each {lineMap.put(it.lineNo, it) }
	        OrderDetailMisc.findAllByCompCodeAndOrderNo(compCode,    orderNo, [sort:'lineNo']).each {lineMap.put(it.lineNo, it) }
		} else {
	        QuoteDetailItem.findAllByCompCodeAndOrderNo(compCode,    orderNo, [sort:'lineNo']).each {lineMap.put(it.lineNo, it) }
	        QuoteDetailComment.findAllByCompCodeAndOrderNo(compCode, orderNo, [sort:'lineNo']).each {lineMap.put(it.lineNo, it) }
	        QuoteDetailMisc.findAllByCompCodeAndOrderNo(compCode,    orderNo, [sort:'lineNo']).each {lineMap.put(it.lineNo, it) }
		}

		def cmtList = []
		List keys = lineMap.keySet().toArray()
        lineMap.eachWithIndex {key, detail, i ->
        	detail.discard()
            if (detail.lineType == 'C') {
            	if (keys.size() > i+1 && keys[i+1] % 10) { // the next detail is a BOM comment
    				if (cmtList.size()) {
    					mergeComments(ordLines, cmtList, keys[i])
    					cmtList = []
    				}
            	}  
            	cmtList << new Komment(lineNo:detail.lineNo, text:detail.text, 
						printCodes:[detail.printCode, detail.printCode2, detail.printCode3, detail.printCode4, detail.printCode5, detail.printCode6])
            } else if (detail.lineType == 'I' || detail.lineType == 'N' || detail.lineType == 'M') {
				ordLines.put (zeroPad4.format(detail.lineNo), detail)
				if (cmtList.size()) {
					mergeComments(ordLines, cmtList, keys[i])
					cmtList = []
				}
            }
        }
		if (cmtList.size()) {
			mergeComments(ordLines, cmtList, null)
		}
    	return ordLines
    }

	/* merge comments to the order lines map */
    def mergeComments(TreeMap ordLines, List cmtList, def nextLineMap) {
		def uniqueComment  
		cmtList.each {cmt ->
			 if (!uniqueComment) { 
				 uniqueComment = cmt 
		     } else if (cmt.lineNo < 9900 && cmt.printCodes == uniqueComment?.printCodes) { 
		    	 uniqueComment.text += cmt.text 
		     } else {
				 ordLines.put (zeroPad4.format(uniqueComment.lineNo), uniqueComment)
				 uniqueComment = cmt
			 } 
		}
		if (uniqueComment) { 
			ordLines.put (zeroPad4.format(uniqueComment.lineNo), uniqueComment)	
		}
	}
    
    def writeOrderLines(TreeMap ordLines, String compCode, int orderNo, int shipNo) {
		OrderDetailItem.findAllByCompCodeAndOrderNo(compCode, orderNo)*.delete(flush:true)
		OrderDetailComment.findAllByCompCodeAndOrderNo(compCode, orderNo)*.delete(flush:true)
		OrderDetailMisc.findAllByCompCodeAndOrderNo(compCode, orderNo)*.delete(flush:true)
		//sessionFactory.getCurrentSession().flush()
		
		def nextLineNo = 10 // line num increments of 10 but don't reset 9900s or xx0xs
        def lastLineNo = 10
        ordLines.each {lineIndex, ordDtl ->
            switch (ordDtl.lineType) {
                case 'I':
                	if (lineIndex.toInteger() % 10) {// BOM item use single digits
                		ordDtl.lineNo = lastLineNo.intdiv(10)*10 + (lineIndex.toInteger() % 10)
                    } else {
	                    ordDtl.lineNo = nextLineNo
                    }
                    nextLineNo += 10
                    if (!ordDtl.save(insert:true, flush:true)) {
                        ordDtl.errors.each { log.error it.inspect()}
                        assert false
                    }
            		break
                case 'N':
                case 'M':
                    ordDtl.lineNo = nextLineNo
                    nextLineNo += 10
                    if (!ordDtl.save(insert:true, flush:true)) {
                        ordDtl.errors.each { log.error it.inspect()}
                        assert false
                    }
                    break
                case 'C':
                    if (ordDtl.lineNo < 9900) {
                        splitTextToMultiLine(ordDtl.text, 30).each {comment ->
                            def ordDtlCmt = new OrderDetailComment(
                                compCode:compCode, orderNo:orderNo, shipNo:shipNo,
                                lineNo:nextLineNo,
                                lineType:'C', text:comment,
                                printCode:ordDtl.printCodes[0]?:' ',
                                printCode2:ordDtl.printCodes[1]?:' ',
                                printCode3:ordDtl.printCodes[2]?:' ',
                                printCode4:ordDtl.printCodes[3]?:' ',
                                printCode5:ordDtl.printCodes[4]?:' ',
                                printCode6:ordDtl.printCodes[5]?:' ')
                            if (!ordDtlCmt.save(insert:true, flush:true)) {
                            	assert false
                                ordDtlCmt.errors.each { log.error it.inspect()}
                            }
                            nextLineNo += 10
                            ordDtl.lineNo = ordDtlCmt.lineNo // save for later set of lastLineNo
                        }
                    } else { 
                        def ordDtlCmt = new OrderDetailComment(
                            compCode:compCode, orderNo:orderNo, shipNo:shipNo,
                            lineNo:ordDtl.lineNo,
                            lineType:'C', text:ordDtl.text,
                            printCode:ordDtl.printCodes[0]?:' ',
                            printCode2:ordDtl.printCodes[1]?:' ',
                            printCode3:ordDtl.printCodes[2]?:' ',
                            printCode4:ordDtl.printCodes[3]?:' ',
                            printCode5:ordDtl.printCodes[4]?:' ',
                            printCode6:ordDtl.printCodes[5]?:' ')
                        if (!ordDtlCmt.save(insert:true, flush:true)) {
                            ordDtlCmt.errors.each { log.error it.inspect()}
                            assert false
                        }
                    }
                    break
                default:
                    log.error "invalid order detail line type: ${ordDtl.lineType}"
            }
            lastLineNo = ordDtl.lineNo
        }
    }
    
    /* replaces O99KNO.WHSBOM
     * only call this if the item has a BOM (shortName = ItemMaster.KIT)
    * Note, RPG set the shipQty but this returns avail boolean
    * expecting the controller to set item's shipQty to its orderQty
    */
    def isBOMInventoryAvail (def compCode, def itemNo, def warehouse, def orderQty) {
		boolean inventoryAvail = true
        BOM.findAllByCompCodeAndItemNo(compCode, itemNo).each {part ->
        	if (!isBOMPartInventoryAvail (part, orderQty, warehouse) ) {
        		inventoryAvail = false
        	}
        }
        return inventoryAvail
    }
    def isBOMPartInventoryAvail (BOM part, int orderQty, String warehouse) {
        def item = ItemMaster.findByCompCodeAndItemNo( part.compCode, part.partItemNo)
        assert item
        int extendedQty = part.partQty
        if (part.partUnitMeas != item.lowestUnitMeas && item.convFactor > 0) {
        	extendedQty = item.convFactor * part.partQty
        }  
        extendedQty *= orderQty

        def partWhs  
        if (Environment.current == Environment.TEST) {  
            // TODO, find out why findWhere doesn't work in unit test 
            partWhs = ItemWarehouse.findByCompCodeAndItemNo(part.compCode, part.partItemNo)
        } else {
        	partWhs = ItemWarehouse.findWhere([compCode:part.compCode, itemNo:part.partItemNo, warehouse:warehouse])
        }
        assert partWhs

        if (extendedQty > (partWhs.qtyOnHand - partWhs.qtyAlloc - InventoryInfo.INV_AVAIL_FUDGE_FACTOR)) {
        	return false
        }
        return true
    }

    String[] splitTextToMultiLine(input, linewidth = 30) throws IllegalArgumentException {
        if(input == null)
            throw new IllegalArgumentException("Input String must be non-null")
        if(linewidth <= 1)
            throw new IllegalArgumentException("Line Width must be greater than 1")

        input = input.replaceAll(/\r/, ' ').replaceAll(/\n/, ' ')
        
        int lineWidthMinus1 = linewidth-1
        input = input.replaceAll(/\S{$lineWidthMinus1}/,  {it+' '})
        
        def lines = []
        def line = ""

        input.split(" ").each() { wrd ->
            if( (line.size() + wrd.size()) <= linewidth ) {
                line <<= wrd
                if (line.size() < linewidth) {
                    line <<= ' '
                }
            } else {
            	def priorLine = line.toString()
                lines += line
                if (priorLine.endsWith(' ')) {
                    line = wrd+' '
                } else {
                	line = ' '+wrd+' '
                }
            }
        }
        lines += line
        return lines
    }

    def addCallBeforeShipping(TreeMap ordLines) {
    	// check to see if callBeforeShipping already in 
    	if (!callBeforeShippingExists(ordLines)) {
		    int max = ordLines.keySet().findAll {it >= '9900'}.max() as Integer
		    if (!max) max = 9900
		    else if (max < 9990) max += 10
		    else max += 1
		    ordLines.put(zeroPad4.format(max), 
		    		new Komment(lineNo:max, lineType:'C', text:'Call before shipping', printCodes:['N','','','','','']))
    	}
    }

    def callBeforeShippingExists(TreeMap ordLines) {
    	// check to see if callBeforeShipping already in 
    	boolean exists = false
    	ordLines.each{key, detail ->
            if (detail.lineType == 'C' && detail.text == 'Call before shipping') {
            	exists = true
            }
    	}
    	return exists
    }
    def removeCallBeforeShipping(TreeMap ordLines) {
    	ordLines.each{key, detail ->
            if (detail.lineType == 'C' && detail.text == 'Call before shipping') {
            	ordLines.remove(key)
            }
    	}
    }

    List createCustCommentList(String compCode, String custNo) {
        def comments = []
        CustomerComments.findAllByCompCodeAndCustNo(compCode, custNo).each {it ->
            def comment = new Komment(lineNo:it.lineNo, lineType:'C', text:it.text,
                    printCodes:[it.printCode,it.printCode2,it.printCode3,it.printCode4,it.printCode5,it.printCode6])
            comments << comment
        }
        return comments
    }

    /* logic gleaned from edi850j
    Update the allocated & back order quantity in the item master and warehouse master files.
    Note, at this point the order items are transient
    */
    def allocateAndBackOrder (List orderItems, String warehouse) {
        orderItems.each {orderItem ->
            if (ItemMaster.findByCompCodeAndItemNo(orderItem.compCode, orderItem.itemNo).shortName == ItemMaster.KIT) {
                BOM.findAllByCompCodeAndItemNo(orderItem.compCode, orderItem.itemNo).each {bom ->
                    itemAllocation(orderItem, bom.partItemNo, warehouse, bom.partQty)
                }
            } else {
                itemAllocation(orderItem,  orderItem.itemNo, warehouse)
            }
        }
    }
    
    /* note: itemNo could be a BOM component item rather than the lineItem's item no
     * so it is passed separate
     */
    private itemAllocation (OrderDetailItem orderItem, String itemNo, String warehouse, int partQty = 0 ) {
        ItemMaster item = ItemMaster.findByCompCodeAndItemNo(orderItem.compCode, itemNo)
        assert item
        item.qtyAlloc += (partQty? partQty * orderItem.shipQty : orderItem.shipQty) + 
        				 (partQty? partQty * orderItem.backOrderQty : orderItem.backOrderQty)
		item.qtyOnBackOrder += (partQty ? partQty * orderItem.backOrderQty : orderItem.backOrderQty)
        item.save()

        def itemWhs = getItemWarehouse(orderItem.compCode, itemNo, warehouse)
        itemWhs.qtyAlloc += (partQty? partQty * orderItem.shipQty : orderItem.shipQty) + 
		 					(partQty? partQty * orderItem.backOrderQty : orderItem.backOrderQty)
        itemWhs.qtyOnBackOrder += (partQty ? partQty * orderItem.backOrderQty : orderItem.backOrderQty)
        itemWhs.save()
    }
    
    def getContractPrice(String compCode, String custNo, String itemNo, Date date) {
    	ContractPrice cp  
        if (Environment.current == Environment.TEST) {  
            // TODO, find out why findWhere doesn't work in unit test 
        	cp = ContractPrice.findByCustNoAndItemNo(custNo, itemNo)
        } else {
        	cp = ContractPrice.findWhere([compCode:compCode, custNo:custNo, itemNo:itemNo] )
        }
    	if (cp && date >= cp.beginDate && date <= cp.expireDate) {
    		return cp.unitPrice1
    	}
    	return null
    }
    def getItemWarehouse(String compCode, String itemNo, String warehouse) {
        return ItemWarehouse.withCriteria(uniqueResult:true) {
    		and {
    			eq('compCode', compCode)
    			eq('itemNo', itemNo)
    			eq('warehouse', warehouse)
    		}
        }     
    }
    
    def fleshOutOrderHeaderOnAdd(OrderHeader orderHeader, Customer cust) { 
    	orderHeader.salesperson1 = cust.salespersonCode
    	orderHeader.lineDiscCode = cust.lineDiscCode
    	orderHeader.termsCode = cust.termsCode
    	orderHeader.shipComplete = cust.shipComplete
    	orderHeader.packingListCode = cust.packingListCode
    	(1..5).each {i -> orderHeader."lineDisc${i}" = cust."lineDisc${i}" }
    	(1..5).each {i -> orderHeader."profitCenter${i}" = cust."profitCenter${i}" }
    	(1..3).each {i -> orderHeader."taxCode${i}" = cust."taxCode${i}" }
    	(1..4).each {i -> orderHeader."refCode${i}" = cust."refCode${i}" }
    	
    	def custDiscAllowList = getCustDiscAllow(cust.compCode, cust.custNo, orderHeader.pickDate) 
    	orderHeader.discAllowCode = (custDiscAllowList.size() > 0) as boolean 
    	def discAllowList = []
    	custDiscAllowList.each { 
    		def discAllow = new OrderDiscountAllowance(compCode:orderHeader.compCode,orderNo:orderHeader.orderNo,
    				shipNo:orderHeader.shipNo,profitCenter:it.profitCenter,code:it.code,
    				percent:it.percent)
    		discAllow.discard()
    		discAllowList << discAllow
    	}
    	return discAllowList
    }

    // code inspired from o99kno.edit3
    def fleshOutOrderHeaderOnUpdate(OrderHeader ord) { 	
		(1..3).each {i ->
			if (ord."taxCode$i") {
				def salesTax = SalesTax.get(ord."taxCode$i") 
				if (salesTax) {
					ord."taxPct$i" = salesTax.taxPct / 100.0g
				}
			}
		}
    	if (!ord.lineDiscCode) {
    		(1..5).each {i ->
    			ord."lineDisc${i}" = 0.0g
    		}
    	}
		/* set order's transient resiComm from shipTo or set to Commercial if shipTo not set */
		def shipTo = ShipTo.retreiveShipTo(ord.compCode, ord.custNo, ord.shipToNo, ord.orderNo, ord.shipNo)
		ord.residentialCommercial = shipTo?.residentialCommercial?:'C'

		/* if order transient shipViaSCACShipIns is set
    	 *    assume cust or rep entry as otherwise shipViaSCACShipIns is null
    	 *    set shipInstructions and specialChrgCd1,2,&3
    	 */
    	if (ord.shipViaSCACShipIns) {  
    		ShipVia shipVia = ShipVia.get(ord.shipViaSCACShipIns)
    		assert shipVia
    		ord.shipInstructions = shipVia.commShipInstr
    		if (ord.residentialCommercial == 'R') {
    			ord.shipInstructions = shipVia.resiShipInstr
    		}

    		if (ord.fobCode != 'CF' &&  // COLLECT,CREDITED TO CUSTOMER
    			ord.fobCode != 'PC' &&  // Third Pargy
    			ord.fobCode != 'TP' ) { // otherwise the customer sets it specifically
    	    	ord.carrierCode = shipVia.scacCode
    	    }
    		log.debug "$ord.shipViaSCACShipIns signatureRequired:$ord.signatureRequired, insurance:$ord.insurance, liftGate:$ord.liftGate, insideDelivery:$ord.insideDelivery, resiDelivery:$ord.resiDelivery"
    		// set specialChrgCd1,2,&3 from checkboxes
    		(1..3).each {i -> ord."specialChrgCd${i}" = ''}
    		def oneTwoThree = 1
    		if (ord.signatureRequired) {
    			if (ord.shipViaSCACShipIns[0..2] == 'UPS') {
    				ord."specialChrgCd${oneTwoThree}" = 'SDCR' // default to commercial
    				if (ord.residentialCommercial == 'R') { // residential
    					ord."specialChrgCd${oneTwoThree}" = 'ASCDR'
    				}
        			oneTwoThree++
    			} else if (ord.shipViaSCACShipIns[0..4].toUpperCase() == 'FEDEX') {
    				ord."specialChrgCd${oneTwoThree}" = 'ASR'
   	    			oneTwoThree++
    			}
    		}
    		if (ord.insurance && ord.shipViaSCACShipIns[0..2] == 'UPS') {
    			ord."specialChrgCd${oneTwoThree}" = 'INS'
    			oneTwoThree++
    		}
    		if (ord.liftGate) { 
    			ord."specialChrgCd${oneTwoThree}" = 'GATE'
    			oneTwoThree++
    		}
    		if (ord.insideDelivery) { 
    			ord."specialChrgCd${oneTwoThree}" = 'IND'
    			oneTwoThree++
    		}
    		if (ord.resiDelivery) {
    			ord."specialChrgCd${oneTwoThree}" = 'RESD'
    			oneTwoThree++
    		}
    		log.debug "carrierCode: $ord.carrierCode shipInstructions: $ord.shipInstructions Special Charge Codes 1: $ord.specialChrgCd1 2:  $ord.specialChrgCd2  3: $ord.specialChrgCd3 "
    	}

		if (ord.shipInstructions) {
			ord.carrierCode = getCarrierCodeFromShippingInstructions(ord.shipInstructions)
		}
		if (ord.carrierCode) {
			ord.shipVia = Carrier.get(ord.carrierCode)?.shortDesc
		}
    }

    String getCarrierCodeFromShippingInstructions(String shipInstructions) {
		// code from O99LIB/OERPGSRC(O99SIXRF)
		def shipInstr = ShippingInstructions.get(shipInstructions)
		if (shipInstr) {
			switch (shipInstr.carrierCode) {
			case 'UPS':
				return 'UPSN'
			case 'FEDEX':
				if (['HD', 'GD'].find {it == shipInstr.servType}) {
					return 'FDEG'
				} else {
					return 'FDE'
				}
				break
			case 'BAX':
				return 'SIFF'
				break
			default:
				if (shipInstr.carrierCode) {
					return shipInstr.carrierCode[0..3]
				}
			}
		}
		return ''
    }
    def setOrderTransientsOnInqUpd(OrderHeader ord) {
    	log.debug "setOrderTransientsOnInqUpd"
    	if (ord.shipInstructions) {
    		ord.residentialCommercial = ord.shipInstructions[0]
    	} else {
    		ord.residentialCommercial = 'C'
    	}
    	ShipVia shipVia = null
    	if (ord.residentialCommercial == 'R') {
    		shipVia = ShipVia.findByResiShipInstr(ord.shipInstructions)
    	} else { // it must be commercial
    		shipVia = ShipVia.findByCommShipInstr(ord.shipInstructions)
    	}
    	if (shipVia) {
    		ord.shipViaSCACShipIns = shipVia.id
    	}
    	(1..3).each {i ->
    		switch (ord."specialChrgCd${i}") {
    		case 'SDCR':
    		case 'ASCDR':
    		case 'ASR':
        		ord.signatureRequired = true
        		break
    		case 'INS':
        		ord.insurance = true
        		break
    		case 'GATE':
        		ord.liftGate = true 
        		break
    		case 'IND':
        		ord.insideDelivery = true 
        		break
    		case 'RESD':
        		ord.resiDelivery = true
        		break
    		}
    	}
		log.debug "$ord.shipViaSCACShipIns signatureRequired:$ord.signatureRequired, insurance:$ord.insurance, liftGate:$ord.liftGate, insideDelivery:$ord.insideDelivery, resiDelivery:$ord.resiDelivery"
    }

    def fleshOutOrderItemOnAdd(OrderDetailItem orderItem, OrderHeader orderHeader, Map ordLines, def ordDiscAllowList) {
        if (orderItem.lineType == 'N') {// non-inventory, don't flesh out
        	return
        }
        assert orderItem.lineType == 'I'
		def item = ItemMaster.findByCompCodeAndItemNo(orderItem.compCode, orderItem.itemNo)
		assert item
        orderItem.desc        = item.desc
        orderItem.distrCode   = item.arDistrictCode
        orderItem.nmfcNo      = item.nmfcNo
        orderItem.qtyUnitMeas = item.stdUnitMeas
        if (Control.get(orderItem.compCode).qtyUnitMeasDefault == 'A' &&
        	item.altUnitMeas?.trim() != '') {
            orderItem.qtyUnitMeas = item.altUnitMeas
        }
        orderItem.priceUnitMeas = item.priceUnitMeas
        orderItem.unitPrice   = item.basePrice
        def contractPrice = getContractPrice(orderItem.compCode, orderHeader.custNo, orderItem.itemNo, new Date())
        if (contractPrice > 0.0g) {
            orderItem.unitPrice = contractPrice
        }
        if (item.taxableCode) {
        	orderItem.subjToTax1 = true
        	orderItem.subjToTax2 = true
        	orderItem.subjToTax3 = true
        }
       	orderItem.subjToTax1 = orderHeader.taxCode1?:false
       	orderItem.subjToTax2 = orderHeader.taxCode2?:false
     	orderItem.subjToTax3 = orderHeader.taxCode3?:false
        
       	calcLineDisc(orderHeader, orderItem, item)
       	
       	OrderTotalInfo orderTotalInfo = calcTotal(ordLines, orderHeader, ordDiscAllowList, false)
       	return orderTotalInfo
    }

    /*
     * code gleaned from o99kno.edit6
     */
    def fleshOutOrderItemOnUpdate(OrderDetailItem orderItem, OrderHeader orderHeader, Map ordLines, def ordDiscAllowList) {
    	if (orderItem.lineType == 'N') {
    		return
    	}
    	if (!orderItem.orderQty) {
    		orderItem.amount = 0.0g
    		return
    	}
    	ItemMaster item = ItemMaster.findByItemNo(orderItem.itemNo)
    	if (!orderItem.priceUnitMeas) {
    		orderItem.priceUnitMeas = orderItem.qtyUnitMeas
    	}
    	
		// this section only checks that order price is > ave cost and item price
		// TODO put usercontrol in security strategy
    	if (orderHeader.custNo != 'KE0002') {//) && !UserControl.get('DOND').priceOverride) {
        	BigDecimal prcwrk = 0.000g
    		if (orderItem.itemDiscPct) {
    			def netprc = orderItem.unitPrice - 
    						(orderItem.unitPrice * orderItem.itemDiscPct.divide(100g, 3, BigDecimal.ROUND_HALF_UP))
    			prcwrk = netprc
	    		if (orderItem.priceUnitMeas != item.costUnitMeas) {
	    			prcwrk = netprc * item.convFactor
	    		}  
    		} else {
    			prcwrk = orderItem.unitPrice
	    		if (orderItem.priceUnitMeas != item.costUnitMeas) {
	    			prcwrk = orderItem.unitPrice * item.convFactor
	    		}  
    		}
    		if (!item.closeoutCode && prcwrk < item.aveCost && prcwrk < item.basePrice) {
    			log.error "Net price less than unit cost, order: $orderHeader.orderNo item: $orderItem.itemNo unitPrice: $orderItem.unitPrice discount: $orderItem.itemDiscPct netPrice: $prcwrk aveCost: $item.aveCost"  
    		}
    	}
//    	if (orderHeader.shipVia == '') {             Blank means "ROUTING'
//    		orderHeader.shipVia = 'ROUTING'
//    	}
    	if (item.catchWeightCode == 'W') {
    		orderItem.convCode = 'W'
    		orderItem.orderWeight = itemOrder.orderQty * item.unitWeight
    		order.amount = orderItem.unitPrice * orderItem.orderWeight 
    	} else {
	    	def price = orderItem.unitPrice
    		if (!item.fulfillmentCode) {// note: only 1 prod row is 'Y'
    			if (orderItem.qtyUnitMeas != orderItem.priceUnitMeas) {
    				orderItem.convFactor = item.convFactor
    				if (orderItem.qtyUnitMeas != item.lowestUnitMeas) {
    					orderItem.convCode = '/' // amount based on divisor conversion
    					price *= orderItem.convFactor
    				} else {
        	    		orderItem.convCode = '*' // amount based on multiplier
    				}
       			}
    		}
    		orderItem.amount = orderItem.orderQty * price
        	if (orderItem.discDistrCode) {
        		orderItem.amount -= orderItem.amount * orderItem.itemDiscPct.divide(100g, 3, BigDecimal.ROUND_HALF_UP)
        	}
    	}
    	calcLineDisc(orderHeader, orderItem, item)

       	OrderTotalInfo orderTotalInfo = calcTotal(ordLines, orderHeader, ordDiscAllowList, false)
       	
       	return orderTotalInfo
    }

    def calcLineDisc(OrderHeader ord, OrderDetailItem orderItem, ItemMaster item) {
		if (ord.lineDiscCode) {
			(1..5).each {i ->
				log.debug  'ord.profitCenter${i}:'+ord."profitCenter${i}"+"ord.lineDisc${i}:"+ord."lineDisc${i}"
				if (ord."profitCenter${i}" == item.profitCenterClass && !item.closeoutCode) {
					orderItem.unitPrice = item.basePrice
					orderItem.itemDiscPct = ord."lineDisc${i}"
					if (orderItem.orderQty) {
						orderItem.amount = (orderItem.unitPrice * orderItem.orderQty) - 
						                   (orderItem.unitPrice * orderItem.orderQty * 
						                    (orderItem.itemDiscPct / 100)
						                   ).setScale(2, BigDecimal.ROUND_HALF_UP )
					} 
	   				log.debug  "$orderItem.amount = ($orderItem.unitPrice * $orderItem.orderQty) - ($orderItem.unitPrice * $orderItem.orderQty * ($orderItem.itemDiscPct / 100))"
				}
			}
		} else {
			orderItem.itemDiscPct = 0g
			if (orderItem.orderQty) {
				orderItem.amount = (orderItem.unitPrice * orderItem.orderQty).setScale(2, BigDecimal.ROUND_HALF_UP )
			}
		}
    }

    def getCustDiscAllow(String compCode, String custNo, Date pickDate) {
        // 	da.beginDate = da.endDate is a 400 hack as IS NULL doesn't work with oecda.cenddt
    	if (ConfigurationHolder.config.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
        	return CustDiscAllow.findAll(
        			" from CustDiscAllow as da "+
        			"where da.compCode = :compCode and da.custNo = :custNo  "+
        			"  and ( (da.beginDate < :pickDate and da.endDate > :pickDate ) "+
        			"        or da.beginDate is null and da.endDate is null)",
        			[compCode:compCode, custNo:custNo, pickDate:pickDate])
    		
    	}
    	return CustDiscAllow.findAll(
    			" from CustDiscAllow as da "+
    			"where da.compCode = :compCode and da.custNo = :custNo  "+
    			"  and ( (da.beginDate < :pickDate and da.endDate > :pickDate ) "+
    			"        or da.beginDate = da.endDate)",
    			[compCode:compCode, custNo:custNo, pickDate:pickDate])
    }
    
    def getShipToList(String compCode, String custNo, int orderNo) {
    	return ShipTo.withCriteria {
            and {
                eq('compCode', compCode)
                eq('custNo', custNo)
                ne('shipToNo', 9999)
                or {
                    eq('orderNo', '')
                    eq('orderNo', orderNo.toString())
                }
            }
        }    
    }
        
    /*
     * code gleand from the center of o99kno.edit5
     * 
     * note I didn't do anything with alternate unit of measure
     * it looks like informational only
     */
    InventoryInfo getInvInfo(String compCode, String itemNo, String warehouse) {
		def item = ItemMaster.findByCompCodeAndItemNo(compCode, itemNo)
        def itemWhs = getItemWarehouse(compCode, itemNo, warehouse)
        
    	InventoryInfo invInfo = new InventoryInfo()
		
    	if (itemWhs) { 
    		invInfo.avail = itemWhs.qtyOnHand - itemWhs.qtyAlloc 
    		invInfo.qtyOnHand = itemWhs.qtyOnHand
    		invInfo.qtyOnBackOrder = itemWhs.qtyOnBackOrder
    		invInfo.qtyAlloc = itemWhs.qtyAlloc
    		invInfo.qtyOnCredHold = itemWhs.qtyOnCredHold
    		invInfo.qtyFutureShip = itemWhs.qtyFutureShip
        	if (item.stdUnitMeas != item.lowestUnitMeas && item.convFactor != 0) {
        		invInfo.qtyOnHand /= item.convFactor
        		invInfo.qtyAlloc /= item.convFactor
        		invInfo.qtyOnBackOrder /= item.convFactor
        		invInfo.avail /= item.convFactor
        		// Note: o99kno puts the remainder in various fields for display but I don't see the need
        	}
    	} else {
    		log.warn "no item warehouse found for Comp: $compCode Item: $itemNo warehouse: $warehouse "
    	}
    	return invInfo
     }
    
     OrderTotalInfo calcTotal(Map orderLines, def orderHeader, def ordDiscAllowList, boolean inquiry) {
    	 	OrderTotalInfo total = new OrderTotalInfo()
			orderLines.values().findAll {it.lineType ==~ /I|N|M/}.each {detail ->
				if (detail.subjToTax1) {
					total.taxableAmount1 += detail.amount 
				}
				if (detail.subjToTax2) {
					total.taxableAmount2 += detail.amount 
				}
				if (detail.subjToTax3) {
					total.taxableAmount3 += detail.amount 
				}
				switch (detail.lineType) {
					case 'I':
						calcLineDisc(orderHeader, detail, ItemMaster.findByItemNo(detail.itemNo))
					case 'N': 
						if (detail.lineNo > 9990) {  
							total.discAllowAmount += detail.amount
						} else {
							total.netAmount += detail.amount
						}
						break
					case 'M':
						total.miscAmount += detail.amount ?: 0.0g
						break
				}
    	 	}

			total.tax += (orderHeader.taxPct1 * total.taxableAmount1).setScale(2, BigDecimal.ROUND_HALF_UP )
			total.tax += (orderHeader.taxPct2 * total.taxableAmount2).setScale(2, BigDecimal.ROUND_HALF_UP )
			total.tax += (orderHeader.taxPct3 * total.taxableAmount3).setScale(2, BigDecimal.ROUND_HALF_UP )
			
			total.salesAmount = total.netAmount
			total.netAmount += total.miscAmount + total.tax + total.discAllowAmount

			orderHeader.orderTotal = total.netAmount
			
			WebUser enteredByKettlerLogin = WebUser.findWhere('user400.id': orderHeader.enteredBy)
			if (orderHeader.termsCode.trim() != Terms.CREDIT_CARD && (!enteredByKettlerLogin || enteredByKettlerLogin.role.name !=  Role.KETTLER) ) {
				def cust = Customer.findByCompCodeAndCustNo(orderHeader.compCode, orderHeader.custNo)
				def termsCodeByTier = getTermsCodeByTier(orderHeader, cust.salesDivision, cust.salesGroup)
				if (termsCodeByTier && !inquiry) {
					orderHeader.termsCode = termsCodeByTier
				}
			}
            if (!inquiry) {
				total.discAllowAmount = 0
				buildNonInvForOrdDiscAllow(orderHeader.custNo, ordDiscAllowList, total.netAmount).each{
		        	total.discAllowAmount += it.amount
		        }
            }
			
    	 	return total
     }

     String getTermsCodeByTier(def orderHeader, def salesDivision, def salesGroup) {
		if (ContractPrice.inEffectForCust(orderHeader.compCode, orderHeader.custNo)) {
			return null
		}
		return SalesTermsTier.getTermByTier(orderHeader.compCode, salesDivision, salesGroup, orderHeader.orderTotal)
     }
     
     List buildNonInvForOrdDiscAllow(String custNo, List ordDiscAllowList, BigDecimal netAmount) {  
 		List nonInvDiscAllow = []
        def maxLineNo = 9990
		ordDiscAllowList.each { ordDiscAllow ->
			def discAllowCode = DiscountAllowanceCode.get(ordDiscAllow.code)
			assert discAllowCode
			def custDiscAllow = CustDiscAllow.findWhere([compCode:ordDiscAllow.compCode,custNo:custNo,
							 profitCenter:ordDiscAllow.profitCenter,code:discAllowCode.id])
			assert custDiscAllow
			def discCode = Distribution.findByCompCodeAndServiceCode(ordDiscAllow.compCode, ordDiscAllow.code) //item.arDistrictCode)
			maxLineNo ++
			def orderDetailItem = new OrderDetailItem(
				compCode:ordDiscAllow.compCode, orderNo:ordDiscAllow.orderNo, shipNo:ordDiscAllow.shipNo, lineNo:maxLineNo,
				lineType:'N', itemNo:ordDiscAllow.code, desc:discAllowCode.desc,
				discAllowProfitCenter:ordDiscAllow.profitCenter, discAllowCode:ordDiscAllow.code, discAllowEDICode:custDiscAllow.ediCode,
				orderQty:-1, shipQty:-1, qtyUnitMeas:'EA', priceUnitMeas: 'EA', discAllowPct:ordDiscAllow.percent
			)
			orderDetailItem.unitPrice = (netAmount * (ordDiscAllow.percent / 100)).setScale(2, BigDecimal.ROUND_HALF_UP )
			orderDetailItem.amount = orderDetailItem.unitPrice * -1
			if (discCode) { 
				orderDetailItem.distrCode = discCode.invDiscCode 
				if (discAllowCode.discReturnCode == 'R') {
					orderDetailItem.distrCode = discCode.returnsCode 
				}
			}
			orderDetailItem.discard()
			nonInvDiscAllow << orderDetailItem
		}
     	return nonInvDiscAllow
     }
     def getTotalBalance(String compCode, String custNo, int orderNo) {
		def cust = Customer.findByCompCodeAndCustNo(compCode, custNo)
		assert cust
		def totalBal = cust.prevBalance + cust.currentChgs + cust.currentPmts + cust.currentAdjs + cust.futureChgs + cust.futurePmts + cust.futureAdjs
		log.debug "$totalBal = $cust.prevBalance + $cust.currentChgs + $cust.currentPmts + $cust.currentAdjs + $cust.futureChgs + $cust.futurePmts + $cust.futureAdjs"
		def orderTotalSum =  OrderHeader.withCriteria(uniqueResult:true) {
			projections {sum("orderTotal")}
			eq('compCode', compCode)
			eq('custNo', custNo)
			ne('orderNo', orderNo)
			'in'('statusCode', ['N', 'O', 'S', 'C'])
		}    	
		log.debug "sum(orderTotal) for $custNo: $orderTotalSum"
		totalBal += orderTotalSum?:0
		return totalBal
     }
}
