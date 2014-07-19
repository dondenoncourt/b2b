
import java.math.BigDecimal;
import java.util.Date;

import com.kettler.domain.actrcv.Distribution
import com.kettler.domain.actrcv.share.Return
import com.kettler.domain.actrcv.share.ReturnItem
import com.kettler.domain.actrcv.share.ReturnFreightDesc
import com.kettler.domain.actrcv.share.ReturnStatus
import com.kettler.domain.actrcv.share.ReturnReason

import com.kettler.domain.orderentry.share.InvoicedOrderHeader
import com.kettler.domain.orderentry.share.InvoicedOrderDetailItem
import com.kettler.domain.orderentry.share.InvoicedOrderDetailMisc
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.share.ShipTo

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemLocationMaster

import com.kettler.domain.work.DateUtils

class ReturnsService {
    def orderService
    def rpgService
    def zeroPad3 = new java.text.DecimalFormat('000')

	void updateWarehouseLocation (Return ra) {
		def ilm
        ra.items.each{item ->
			println("IN LOOP")
			println item.dump()
			println item.details.dtlWarehouse.dump()
			item.details.each{dtl ->
				//this will read each line item.  If received qty is 3, there will be 3 line items
				if (dtl.dtlWarehouse.trim() =='P'){
					log.debug "update parts location for item: $item.itemNo warehouse: $dtl.dtlWarehouse location: $dtl.dtlLocation"
					ilm = ItemLocationMaster.findWhere (compCode:'01', itemNo:item.itemNo, warehouse:dtl.dtlWarehouse?:"", binLocation:dtl.dtlLocation?:"")
					if (ilm){
						ilm.qtyOnHand += 1
						ilm.save()
					} else {
						ilm = new ItemLocationMaster(qtyOnHand:1)
						ilm.compCode='01'
						ilm.itemNo=item.itemNo
						ilm.warehouse=dtl.dtlWarehouse?:""
						ilm.binLocation=dtl.dtlLocation?:""
						ilm.qtyOnHand = 1
						ilm.pickSequence = 0
						ilm.save()
					}
				}
			}
		}
    }		
	
    int convertToCreditMemo (Return ra, String user400) {
        log.debug "convertToCreditMemo: Return Authorization: $ra.id"
        OrderHeader ord 
        InvoicedOrderHeader invoice
		def prorateTotal = 0.00g
		def prorate = 1.00g
        int ordersInReturn = getOrdersInReturn(ra)
    	def itemDollarsByOrderMap 
		def totalItemDollars = 0.00g
    	if (ordersInReturn > 1) {
    		itemDollarsByOrderMap = getItemDollarsByOrderMap(ra)
    		itemDollarsByOrderMap.values().collect {totalItemDollars += it}
    	}
        int lastOrderNo
        ReturnItem lastItem
        def nextLineNo = 10
        ra.items.sort{it.orderNo}.each{item ->
            if (!ord || item.orderNo != lastOrderNo) { // 1st loop or multi-order RA order no changed
                if (ord) { // processing next multi-order RA order, so write the prior one out
        			prorate = (itemDollarsByOrderMap[lastOrderNo] / totalItemDollars).setScale(2, BigDecimal.ROUND_HALF_UP)
           			prorateTotal += prorate
        			log.debug "prorate multi-order-return orderNo: $ord.orderNo at $prorate"
        			nextLineNo = writeOrderDetailMisc(ra, ord, getInvoicedOrderHeader(ra, lastItem), prorate, nextLineNo) 
                	nextLineNo = writeOrderDetailItemDiscounts(ord, getInvoicedOrderHeader(ra, lastItem), nextLineNo)
                	nextLineNo = writeOrderDetailComment(ra, ord, nextLineNo)
                    writeOrder(ord)
                }
                nextLineNo = 10
                ord = buildOrderHeaderAndMaybeCreateShipTo(ra, getInvoicedOrderHeader(ra, item), user400) 
                lastOrderNo = item.orderNo
                lastItem = item 
            }
            invoice = getInvoicedOrderHeader(ra, item)
            nextLineNo = writeOrderDetailItem(item, ord, invoice, nextLineNo) 
            nextLineNo += 10
	       	insertWithFlushAndAssert(new OrderDetailComment(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo, lineType:'C', 
	                text:ReturnReason.get(item.reason?.id).code, printCode:'I') )
	        nextLineNo += 10
        } // ra.items.each

		if (ordersInReturn > 1) {
			prorate = (1.00g - prorateTotal)
		}
        nextLineNo = writeOrderDetailMisc(ra, ord, invoice, prorate, nextLineNo) 
        nextLineNo = writeOrderDetailComment(ra, ord, nextLineNo)
        
        if (ord) {
        	nextLineNo = writeOrderDetailItemDiscounts(ord, invoice, nextLineNo)
            writeOrder(ord)
        }
        
        ra.changeUser = user400
        ra.changeDate = new Date()
        ra.debitMemoCreated = new Date()
        ra.status = ReturnStatus.get('CMFIN')
        return ord.orderNo
    }
    private int  getOrdersInReturn (Return ra) {   	
    	return ReturnItem.withCriteria(unique:true) {
			eq 'ra', ra
			projections {countDistinct "orderNo"}
		}[0]?:1
    }
    private writeOrderDetailComment(Return ra, OrderHeader ord, int nextLineNo) {
        ra.notes?.sort {it.createDate}.each {note ->
            orderService.splitTextToMultiLine(note.note).each {comment ->
            	insertWithFlushAndAssert(new OrderDetailComment(
                         compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo, lineType:'C', text:comment,
                         printCode:note.showOnPdf?'I':'N'))
            	nextLineNo += 10
            }
        }
        if (ra.fieldDestroy) {
        	insertWithFlushAndAssert(new OrderDetailComment(
                        compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo, lineType:'C', 
                        text:'Field Destroy/Donated', printCode:'N'))
            nextLineNo += 10
        }
        insertWithFlushAndAssert(new OrderDetailComment(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo, lineType:'C', 
        						text:"RA#: ${ra.id}", printCode:'I'))
        nextLineNo += 10
        return nextLineNo
    }

    private writeOrderDetailMisc(Return ra, OrderHeader ord, InvoicedOrderHeader invoice, BigDecimal prorate, int nextLineNo) {

    	// divvy out RA header amounts based on the original invoice 
        if (ra.shipHandCustCr && ra.shipHandDesc.descr != 'GST'){
        	def credit = 0.00g
        	if (prorate == 1.00g) {
        		credit = ra.shipHandCustCr
        	} else {
        		credit = sumInvoicedDistrCode(invoice, 'HDL')
        	}
        	if (credit) {
	        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ra.customer?.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
	                    distrCode:'HDL', printCode:'I', desc:ra.shipHandDesc.descr, amount:credit * -1) )    
	            nextLineNo += 10
        	}
        }
        if (ra.freightCustCr) {
        	def credit = 0.00g
        	if (prorate == 1.00g) {
        		credit = ra.freightCustCr
        	} else {
        		credit = sumInvoicedDistrCode(invoice, 'FRT')+sumInvoicedDistrCode(invoice, 'UPS')+sumInvoicedDistrCode(invoice, 'IHC')
        	}
        	if (credit) {
	        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
	                    distrCode:ra.freightCustCrDistrCode?:'IHC', printCode:'I',  
	                    desc:ra.freightDesc.descr, amount:credit * -1) )   
	            nextLineNo += 10
        	}
        }
        
        // prorate RA header amounts
        if (ra.shipHandCustCr && ra.shipHandDesc.descr == 'GST'){
        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ra.customer?.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
                    distrCode:'GST', printCode:'I', desc:'GST # 894791854 RT0001', amount: ra.shipHandCustCr * -1 * prorate) )    
            nextLineNo += 10
        }
        if (ra.topPriorCustCr){
        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ra.customer?.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
                    distrCode:'IHC', printCode:'I',  
                    desc:"Top Priority", amount: ra.topPriorCustCr * -1 * prorate) )    
            nextLineNo += 10
        }
        if (ra.freightInCustDb) {
        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
                    distrCode:'IHC', printCode:'I',  
                    desc:'Inbound Freight', amount: ra.freightInCustDb  * prorate))    
            nextLineNo += 10
        }

        // percentage fields:
        def itemTotal = itemTotal(ra)
        if (prorate != 1.0g) {
            itemTotal = 0.00g
            ra.items.each{item ->
            	if (item.orderNo == invoice?.orderNo) {
            		itemTotal += (item.authQty?:item.receivedQty) * item.unitPrice
            	}
            }
        } 
        if (ra.refurbRestockCustDb) {
        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
                    distrCode:'HDL', printCode:'I',  
                    desc:'Restocking Fee', amount: ( ra.refurbRestockCustDb / 100.00 * itemTotal).setScale(2, BigDecimal.ROUND_HALF_UP)))    
            nextLineNo += 10
        }
        if (ra.invoiceDisc || ra.invoiceDiscPct) {
        	BigDecimal invoiceDisc = ra.invoiceDisc
            if (ra.invoiceDiscPct) {
            	invoiceDisc = (ra.invoiceDiscPct / 100.00 * itemTotal).setScale(2, BigDecimal.ROUND_HALF_UP)
            }
        	insertWithFlushAndAssert(new OrderDetailMisc(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo,
                    distrCode:'DTY', printCode:'I',  
                    desc:ra.invoiceDisc?"${ra.invoiceDisc} Invoice Discount":"${ra.invoiceDiscPct}% Invoice Discount", 
                    amount:invoiceDisc))    
            nextLineNo += 10
        }  
        return nextLineNo 
    }
    
    private writeOrderDetailItem(ReturnItem item, OrderHeader ord, InvoicedOrderHeader invoice, int nextLineNo) {
		def itemMaster = ItemMaster.findByCompCodeAndItemNo(ord.compCode, item.itemNo)
		if (!itemMaster) log.warn "ItemMaster.findByCompCodeAndItemNo($ord.compCode, $item.itemNo) not found, issue with CM distribution code"
		def returnDistrCode = Distribution.findByCompCodeAndServiceCode(ord.compCode, itemMaster?.arDistrictCode)?.returnsCode
        if (!returnDistrCode) log.warn "Distribution.findByCompCodeAndServiceCode($ord.compCode, ${itemMaster?.arDistrictCode})  not found, issue with CM distribution code"

    	// write one detail for all non-restock and one detal for restock
        def stockNotStockItemCounts = [0,0]
        stockNotStockItemCounts[0] = item.details.findAll{it.disposition?.code == 'RETURN TO STOCK'}.size()
        stockNotStockItemCounts[1] = item.details.findAll{it.disposition?.code != 'RETURN TO STOCK'}.size()
        stockNotStockItemCounts.eachWithIndex{count, index ->
            boolean restock = (index == 0)
            if (count) {
				OrderDetailItem ordDetail = new OrderDetailItem(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo, lineType:'I',
						itemNo:item.itemNo, desc:item.desc, orderQty:count * -1, shipQty:count * -1,
						distrCode: returnDistrCode?:'',
						custNo:ord.custNo,shipToNo:ord.shipToNo,salesperson1:ord.salesperson1,
						unitPrice:item.unitPrice, amount: item.unitPrice * count * -1,
						reasonCode:item.reason.crsReason.id, 
						returnToStock:restock)
				if (!ordDetail.save(insert:true, flush:true)) {
					ordDetail.errors.each{log.error it}
					assert false
				}
				if (invoice) {
				    InvoicedOrderDetailItem invItem = InvoicedOrderDetailItem.findWhere(
				                                compCode:invoice.compCode, orderNo:invoice.orderNo, shipNo:invoice.shipNo, itemNo:item.itemNo)
				    if (invItem) {
				        ordDetail.itemDiscPct = invItem.itemDiscPct
				    }
				}
				if (!ordDetail.save(insert:true, flush:true)) {
					ordDetail.errors.each{log.error it}
					assert false
				}
				nextLineNo += 10
            }
        }
        return nextLineNo
    }
    private void insertWithFlushAndAssert(def domain) {
        if (!domain.save(flush:true, insert:true)) {
            domain.errors.each { log.error it.inspect()}
            assert false
        }                
    }
    private InvoicedOrderHeader getInvoicedOrderHeader(Return ra, ReturnItem item) {
    	return InvoicedOrderHeader.withCriteria(uniqueResult:true) { 
	        and {
	            eq("custNo",        ra.customer.custNo)
	            eq("orderNo",        item.orderNo) 
	            eq("shipNo",         item.shipNo) 
	            ne("creditMemoCode", 'Y')
	        }
	    }
    }
    private String getMaxPoNo(InvoicedOrderHeader invoice) {
    	if (!invoice) {
    		return ''
    	}
        return InvoicedOrderHeader.withCriteria(uniqueResult:true) {
            projections {max("poNo")}
             eq ('invoiceNo', invoice.invoiceNo)
             eq ('creditMemoCode', true)
        }
    }
    private BigDecimal getOrderTotal(OrderHeader ord) {
    	def itemAmount = OrderDetailItem.withCriteria(uniqueResult:true) {
            eq 'compCode', ord.compCode
            eq 'orderNo', ord.orderNo
            projections {sum "amount"}
        }?:0.00g
		def miscAmount = OrderDetailMisc.withCriteria(uniqueResult:true) {
            eq 'compCode', ord.compCode
            eq 'orderNo', ord.orderNo
            projections {sum "amount"}
        }?:0.00g
        return itemAmount + miscAmount
    }
    
	private Map getItemDollarsByOrderMap(Return ra) {
		def distinctOrders = ReturnItem.withCriteria {
		    eq 'ra', ra
		    projections {distinct "orderNo"}
		} 
		def orderMap = [:]
		distinctOrders.each {orderMap.put(it, 0.00g)}
		ra.items.each{item ->
		    orderMap[item.orderNo] += (item.authQty?:item.receivedQty) * item.unitPrice   
		}
		def total = 0.00g;
		orderMap.values().collect {total += it}
		log.debug "getItemDollarsByOrderMap returning $orderMap with a total of: "+total
	    return orderMap
	}
    private writeOrderDetailItemDiscounts(OrderHeader ord, InvoicedOrderHeader invoice, int nextLineNo) {
        // add invoice discounts, returns allowance, etc.
        if (invoice) {
        	BigDecimal orderTotal = getOrderTotal(ord) 
           def discounts = InvoicedOrderDetailItem.withCriteria() {
                and {
                    eq("custNo",        invoice.custNo)
                    eq("orderNo",         invoice.orderNo) 
                    eq("lineType",        'N')    
                    gt("discAllowPct",    0.0g)
                }
            }        	
            discounts.each {disc ->
                def discAllowPct = (disc.discAllowPct < 1)?disc.discAllowPct:disc.discAllowPct * 0.01g
                OrderDetailItem ordDetail = new OrderDetailItem(compCode:ord.compCode, orderNo:ord.orderNo, shipNo:ord.shipNo, lineNo:nextLineNo, lineType:'N',
                        itemNo:disc.itemNo, desc:disc.desc, orderQty:1, shipQty:1,
                        distrCode: disc.distrCode,  
                        custNo:ord.custNo,shipToNo:ord.shipToNo,salesperson1:ord.salesperson1,
                        unitPrice:orderTotal*discAllowPct, amount:orderTotal*discAllowPct,
                        discAllowProfitCenter:disc.discAllowProfitCenter, discAllowCode:disc.discAllowCode, 
                        discAllowEDICode:disc.discAllowEDICode, discAllowPct:disc.discAllowPct
                )
                log.debug "creating OrderDetailItem with id ([compCode:$ord.compCode, orderNo:$ord.orderNo, shipNo: $ord.shipNo, lineNo: $ord.lineNo], lineType: $ordDetail.lineType and reasonCode: $ordDetail.reasonCode)"                
                if (!ordDetail.save(insert:true, flush:true)) {
                    ordDetail.errors.allErrors.each { log.debug it.inspect() }; 
                    assert false
                }
                nextLineNo += 10
            }
        }
        return nextLineNo
    }
    private void writeOrder(OrderHeader ord) {
    	ord.orderTotal = getOrderTotal(ord) 
        if (!ord.save(flush:true)) {
            ord.errors.allErrors.each { log.debug it.inspect() }; 
            assert false
        }
        log.debug "credit memo (ordHeader) created with orderNo: $ord.orderNo"
    }

    private OrderHeader buildOrderHeaderAndMaybeCreateShipTo(Return ra, InvoicedOrderHeader invoice, String user400) {
        OrderHeader ord = new OrderHeader()
        if (invoice) {
            ord.properties = invoice.properties
        } 
        ord.creditMemoCode = true 
        ord.orderNo =  rpgService.getNextOrderNo(ra.customer.compCode)
        ord.orderDate = new Date()
        ord.shipNo = 1 
        ord.lineNo = 0
        ord.compCode =         ra.customer.compCode
        ord.custNo =         ra.customer.custNo
        ord.ra =             ra
        ord.fobCode =         ''    
        ord.warehouse =     ra.warehouse
        ord.salesperson1 =     ra.customer.salespersonCode
        ord.cancelAfterDate = new Date() + (365 * 10)
        ord.invoiceDate = DateUtils.getYearOne()
        ord.statusCode = 'C'  
        ord.jobIdCode = 'WEBAPP'
        ord.confirmedBy = user400  
        ord.enteredBy = user400
        ord.carrierCode = ''
        ord.shipInstructions = ''
        ShipTo shipTo = new ShipTo(compCode:ord.compCode, orderNo:ord.orderNo, custNo:ord.custNo,shipNo:ord.shipNo,shipToNo:9999)
        shipTo.properties = ra.properties // copy address
        if (!shipTo.save(flush:true)) {
            shipTo.errors.allErrors.each { log.debug it.inspect() }; 
            assert false
        }
        ord.shipToNo = shipTo.shipToNo 
        ord.shippedStatus = 'CC'  
        if (false == ['6', '9'].find {it == ord.termsCode} || !invoice) { // if not 6-prepayment or 9-credit card or no invoice
            ord.termsCode = 'C'  
        }
        if (!ord.termsCode) {
        	ord.termsCode = 'C'
        }
        ord.poNo = (ord.poNo.size() > 19)?ord.poNo[0..19]+'CM':ord.poNo+'CM'
        // if a CM already exists for that invoice, get largest PoNo and increment
        String maxPoNo = getMaxPoNo(invoice)
        if (maxPoNo) {
            def match = maxPoNo =~ /.*(\d\d\d)$/
            if (match) {
                int numSuffix =  match[0][1].toInteger()
                ord.poNo = ord.poNo+zeroPad3.format(++numSuffix)
            } else {// someone manually set suffix, just append it with 3 digit
                ord.poNo = ord.poNo+'002' 
            }
        }
        return ord
    }
	private BigDecimal sumInvoicedDistrCode(InvoicedOrderHeader invoice, String code) {
	    def total = InvoicedOrderDetailMisc.withCriteria {
	        eq 'compCode', invoice.compCode
	        eq 'orderNo', invoice.orderNo
	        eq 'shipNo', invoice.shipNo
	        eq 'distrCode', code
	        projections {sum "amount"};
	    }[0]?:0
	    log.debug "sumInvoicedDistrCode(InvoicdeOrderHeader $invoice.orderNo, String $code) returned: $total"
	    return total
	}
    
    private itemTotal(Return ra) {
        BigDecimal itemTotal = 0.00g
    	ra.items.each{item ->
    		itemTotal += (item.authQty?:item.receivedQty) * item.unitPrice   
        }
        return itemTotal
    }
    BigDecimal calcTotal (Return ra) {
        BigDecimal orderTotal = itemTotal(ra)
        orderTotal += ra.shipHandCustCr
        orderTotal += ra.topPriorCustCr
        orderTotal += ra.freightCustCr
        orderTotal -= ra.freightInCustDb
        if (ra.refurbRestockCustDb) {
        	orderTotal -= ( ra.refurbRestockCustDb / 100.00 * itemTotal(ra)).setScale(2, BigDecimal.ROUND_HALF_UP)
        }
        if (ra.invoiceDisc) {
            orderTotal -= ra.invoiceDisc
        } else if (ra.invoiceDiscPct) {
        	orderTotal -= (ra.invoiceDiscPct / 100.00 * itemTotal(ra)).setScale(2, BigDecimal.ROUND_HALF_UP)
        }
        return orderTotal
    }
    
}
