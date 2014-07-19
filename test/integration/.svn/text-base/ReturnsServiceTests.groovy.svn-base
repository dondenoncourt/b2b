import grails.test.*
import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.actrcv.share.Return
import com.kettler.domain.actrcv.share.ReturnCondition;
import com.kettler.domain.actrcv.share.ReturnDisposition;
import com.kettler.domain.actrcv.share.ReturnFreightDesc
import com.kettler.domain.actrcv.share.ReturnFreightDenial;
import com.kettler.domain.actrcv.share.ReturnItem;
import com.kettler.domain.actrcv.share.ReturnItemDetail;
import com.kettler.domain.actrcv.share.ReturnNote;
import com.kettler.domain.actrcv.share.ReturnReason;
import com.kettler.domain.actrcv.share.ReturnStatus;

import com.kettler.domain.orderentry.share.InvoicedOrderDetailComment
import com.kettler.domain.orderentry.share.InvoicedOrderDetailItem
import com.kettler.domain.orderentry.share.InvoicedOrderDetailMisc
import com.kettler.domain.orderentry.share.InvoicedOrderHeader
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.ShipTo


class ReturnsServiceTests extends GroovyTestCase {
	def returnsService
	def orderService
	
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }
	/* populate script adds: 
		ItemMaster: one two chair-desk chair desk
		Customer: test
	 */
    void test_order_with_discounts() {
    	Customer cust = Customer.findByCustNo('test')
    	InvoicedOrderHeader invoiceWithLineItemDisc = new InvoicedOrderHeader(compCode:'01', custNo:'test', orderNo:1234, creditMemoCode:false, invoiceDate: new Date() - 12,
    			warehouse:'1', poNo:'PONO123', shipVia:'shipVia', termsCode:'TC', salesperson1:'SPX', invoiceDiscPct:10.1g, invoiceNo:54321, orderTotal:1987.23g, fobCode:'XY', shippedStatus:'x', shipInstructions:'', specialChrgCd1:'a', specialChrgCd2:'b', specialChrgCd3:'c', shipComplete:false, packingListCode:'01', cube:0.0g, splitTermsCode:false, lineDisc1:1.0g, lineDisc2:2.0g, lineDisc3:3.0g, lineDisc4:4.0g, lineDisc5:5.0g)
        if (!invoiceWithLineItemDisc.save(flush:true)) {invoiceWithLineItemDisc.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 1, InvoicedOrderHeader.count()
    	InvoicedOrderDetailItem invItem = new InvoicedOrderDetailItem(compCode:'01', custNo:'test', orderNo:invoiceWithLineItemDisc.orderNo, lineNo:1, lineType:'I', 
    				itemNo:'one', desc:'one', orderQty:3, shipQty:3,
    				invoiceDate: new Date() - 12, salesperson1:cust.salespersonCode,
    				itemDiscPct:2.30g
    		)
        if (!invItem.save(flush:true)) {invItem.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 1, InvoicedOrderDetailItem.count()
    	Return ra = new Return(customer:cust, createDate:new Date(), 
 				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
 				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3),
 				addr1:'11203 Pinewood Court', city:'Richmond', name:'Don Denoncourt', state:'PA', zipCode:'23238',
 				invoiceDisc:0.067g
    	)

		ReturnItem raItem1 = new ReturnItem(orderNo:invoiceWithLineItemDisc.orderNo, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:1, authQty:1 )
		ra.addToItems(raItem1)
		raItem1.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(1), disposition:ReturnDisposition.get(1)))
		if (!ra.save(flush:true)) {ra.errors.allErrors.each { println it.inspect() }; assert false;}
		
		def gendOrderNo = returnsService.convertToCreditMemo (ra, 'dond')

		assertEquals "CM item details", 1, OrderDetailItem.count()
		
		def orderDetailItem = OrderDetailItem.list()[0]
		assert orderDetailItem
		assertEquals "discount", 2.30g, orderDetailItem.itemDiscPct
		
		// test CM for invoice with invoice discount and return allowances as non-inventory line item
		// note sample data from select * from o99files.oeinv1 where oordn = 349246
    	InvoicedOrderHeader invWithInvDiscAndReturnAllowance = new InvoicedOrderHeader(compCode:'01', custNo:'test', orderNo:1235, creditMemoCode:false, invoiceDate: new Date() - 12,
    			warehouse:'1', poNo:'PONO123', shipVia:'shipVia', termsCode:'TC', salesperson1:'SPX', invoiceDiscPct:10.1g, invoiceNo:121212, orderTotal:1987.23g, fobCode:'XY', shippedStatus:'x', shipInstructions:'', specialChrgCd1:'a', specialChrgCd2:'b', specialChrgCd3:'c', shipComplete:false, packingListCode:'01', cube:0.0g, splitTermsCode:false, lineDisc1:1.0g, lineDisc2:2.0g, lineDisc3:3.0g, lineDisc4:4.0g, lineDisc5:5.0g)
        if (!invWithInvDiscAndReturnAllowance.save(flush:true)) {invWithInvDiscAndReturnAllowance.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 2, InvoicedOrderHeader.count()
    	invItem = new InvoicedOrderDetailItem(compCode:'01', custNo:'test', orderNo:invWithInvDiscAndReturnAllowance.orderNo, lineNo:1, lineType:'I', 
    				itemNo:'one', desc:'one', orderQty:3, shipQty:3,
    				invoiceDate: new Date() - 12, salesperson1:cust.salespersonCode,
    				itemDiscPct:2.30g
    		)
        if (!invItem.save(flush:true)) {invItem.errors.allErrors.each { println it.inspect() }; assert false;}
    	InvoicedOrderDetailItem invDisc = new InvoicedOrderDetailItem(compCode:'01', custNo:'test', orderNo:invWithInvDiscAndReturnAllowance.orderNo, lineNo:2, lineType:'N', 
    				itemNo:'INVD', desc:'INVOICE DISCOUNT', orderQty:-1, shipQty:-1, unitPrice: 0.343g,
    				invoiceDate: new Date() - 12, salesperson1:cust.salespersonCode,
    				discAllowProfitCenter:'4', discAllowCode: 'INVD', discAllowEDICode:'I570', discAllowPct:0.010g
    		)
        if (!invDisc.save(flush:true)) {invDisc.errors.allErrors.each { println it.inspect() }; assert false;}
    	InvoicedOrderDetailItem returnAllow = new InvoicedOrderDetailItem(compCode:'01', custNo:'test', orderNo:invWithInvDiscAndReturnAllowance.orderNo, lineNo:3, lineType:'N', 
    				itemNo:'RETN', desc:'RETURN ALLOWANCES', orderQty:-1, shipQty:-1, unitPrice: 0.446g,
    				invoiceDate: new Date() - 12, salesperson1:cust.salespersonCode,
    				discAllowProfitCenter:'4', discAllowCode: 'RETN', discAllowEDICode:'C000', discAllowPct:0.013g
    		)
        if (!returnAllow.save(flush:true)) {returnAllow.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals "3 from this order and 1 from before" , 4, InvoicedOrderDetailItem.count()
    	Return raWithInvDiscAndReturnAllowance = new Return(customer:cust, createDate:new Date(), 
 				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
 				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3),
 				addr1:'11203 Pinewood Court', city:'Richmond', name:'Don Denoncourt', state:'PA', zipCode:'23238')

		ReturnItem raItemInvDisc = new ReturnItem(orderNo:invWithInvDiscAndReturnAllowance.orderNo, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:1, authQty:1 )
		raWithInvDiscAndReturnAllowance.addToItems(raItemInvDisc)
		raItemInvDisc.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(1), disposition:ReturnDisposition.get(1)))
		if (!raWithInvDiscAndReturnAllowance.save(flush:true)) {raWithInvDiscAndReturnAllowance.errors.allErrors.each { println it.inspect() }; assert false;}
		
		gendOrderNo = returnsService.convertToCreditMemo (raWithInvDiscAndReturnAllowance, 'dond')

		assertEquals "CM item details", 4, OrderDetailItem.count() // 1 from the 1st order and 3 from this last one
		orderDetailItem = OrderDetailItem.list()[2]
		assertEquals "Invoice Discount", 'INVD', orderDetailItem.itemNo
		orderDetailItem = OrderDetailItem.list()[3]
		assertEquals "Return Allowance", 'RETN', orderDetailItem.itemNo 
		assertEquals 'Invoice discount desc', '6.7% Invoice Discount', OrderDetailMisc.findWhere(compCode:'01', distrCode:'DTY').desc
		assertEquals 'Invoice discount amount', -26.93g, OrderDetailMisc.findWhere(compCode:'01', distrCode:'DTY').amount
		assertEquals 'order total', -401.98g, OrderHeader.findByOrderNo(gendOrderNo).orderTotal
		
    }
    void test_with_order()	 {
    	assertEquals 11, ReturnReason.count()

    	Customer cust = Customer.findByCustNo('test')
    	assert cust

    	InvoicedOrderHeader inv1 = new InvoicedOrderHeader(compCode:'01', custNo:'test', orderNo:1234, creditMemoCode:false, invoiceDate: new Date() - 12,
    			warehouse:'1', poNo:'PONO123', shipVia:'shipVia', termsCode:'TC', salesperson1:'SPX', invoiceDiscPct:10.1g, invoiceNo:54321, orderTotal:1987.23g, fobCode:'XY', shippedStatus:'x', shipInstructions:'', specialChrgCd1:'a', specialChrgCd2:'b', specialChrgCd3:'c', shipComplete:false, packingListCode:'01', cube:0.0g, splitTermsCode:false, lineDisc1:1.0g, lineDisc2:2.0g, lineDisc3:3.0g, lineDisc4:4.0g, lineDisc5:5.0g)
        if (!inv1.save(flush:true)) {inv1.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 1, InvoicedOrderHeader.count()
    	InvoicedOrderDetailItem invItem = new InvoicedOrderDetailItem(compCode:'01', custNo:'test', orderNo:inv1.orderNo, lineNo:1, lineType:'I', 
    				itemNo:'one', desc:'one', orderQty:1, shipQty:1,
    				invoiceDate: new Date() - 12, salesperson1:cust.salespersonCode)
        if (!invItem.save(flush:true)) {invItem.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 1, InvoicedOrderDetailItem.count()

    	InvoicedOrderHeader inv2 = new InvoicedOrderHeader(compCode:'01', custNo:'test', orderNo:4321, creditMemoCode:false, invoiceDate: new Date() - 12,
    			warehouse:'1', poNo:'PON04321', shipVia:'shipVia', termsCode:'TC', salesperson1:'SPX', invoiceDiscPct:10.1g, invoiceNo:12345, orderTotal:1987.23g, fobCode:'XY', shippedStatus:'x', shipInstructions:'', specialChrgCd1:'a', specialChrgCd2:'b', specialChrgCd3:'c', shipComplete:false, packingListCode:'01', cube:0.0g, splitTermsCode:false, lineDisc1:1.0g, lineDisc2:2.0g, lineDisc3:3.0g, lineDisc4:4.0g, lineDisc5:5.0g)
        if (!inv2.save(flush:true)) {inv2.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 2, InvoicedOrderHeader.count()
    	invItem = new InvoicedOrderDetailItem(compCode:'01', custNo:'test', orderNo:inv2.orderNo, lineNo:1, lineType:'I', 
    				itemNo:'two', desc:'two', orderQty:2, shipQty:2,
    				invoiceDate: new Date() - 12, salesperson1:cust.salespersonCode) 
        if (!invItem.save(flush:true)) {invItem.errors.allErrors.each { println it.inspect() }; assert false;}
    	assertEquals 2, InvoicedOrderDetailItem.count()

    	Return ra = new Return(customer:cust, createDate:new Date(), 
	             				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
	             				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3),
	             				addr1:'11203 Pinewood Court', city:'Richmond', name:'Don Denoncourt', state:'PA', zipCode:'23238',
	             				freightCustCrDistrCode:'UPS'
	             	)

    	ReturnItem raItem1 = new ReturnItem(orderNo:inv1.orderNo, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:1, authQty:1 )
    	ReturnItem raItem2 = new ReturnItem(orderNo:inv2.orderNo, itemNo:'two', unitPrice:101.98g, desc:'second item', reason:ReturnReason.get(2),receivedQty:2, authQty:2 )
	    ra.addToItems(raItem1)
	    ra.addToItems(raItem2)
    	raItem1.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(1), disposition:ReturnDisposition.get(1)))
    	raItem2.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(2), disposition:ReturnDisposition.get(2)))

    	ra.addToNotes(new ReturnNote(note:"comment 1 comment 1 comment 1 comment 1 comment 1 comment 1 comment 1 comment 1", user:'dondenoncourt@gmail.com'))
    	ra.addToNotes(new ReturnNote(note:"comment 2 comment 2 comment 2 comment 2 comment 2 comment 2 comment 2", user:'dondenoncourt@gmail.com', showOnPdf:false))
    	
	    if (!ra.save(flush:true)) {ra.errors.allErrors.each { println it.inspect() }; assert false;}
	    
    	def gendOrderNo = returnsService.convertToCreditMemo (ra, 'dond')
		assertEquals 'header count', 2, OrderHeader.count()
    	assertEquals 'detail count', 2, OrderDetailItem.count()
//		InvoicedOrderDetailMisc.list().each {println it}
//		OrderDetailMisc.list().each {println it}
    	assertNotNull OrderDetailMisc.findWhere(compCode:'01', orderNo:gendOrderNo, distrCode:'UPS') 
    	
    	// TODO test rtrn isa freight claim and OrderDetailMisc created
    	assertEquals 'misc count',2, OrderDetailMisc.count()
    	ShipTo.list().each {
    		println "ShipTo added: compCode:$it.compCode,  orderNo:$it.orderNo, custNo:$it.custNo, shipNo:$it.shipNo, shipToNo:$it.shipToNo"
    	}
    	def gendOrder = OrderHeader.findByOrderNo(gendOrderNo)
    	assert gendOrder
    	println "ShipTo.findWhere(compCode:$gendOrder.compCode,  orderNo:$gendOrderNo, custNo:$gendOrder.custNo, shipNo:$gendOrder.shipNo, shipToNo:9999)" 
    	assertEquals 'ship to', '11203 Pinewood Court', 	
    						ShipTo.findWhere(compCode:gendOrder.compCode,  orderNo:gendOrderNo, custNo:gendOrder.custNo, 
    								shipNo:new java.text.DecimalFormat('00').format(gendOrder.shipNo), shipToNo:9999).addr1 
    	
    	assertTrue 'should have invoiceNo 12345', OrderHeader.findByInvoiceNo(12345) != null
    	assertTrue 'should have invoiceNo 54321', OrderHeader.findByInvoiceNo(54321) != null
    	assertTrue 'should have PoNo PONO123CM', OrderHeader.findByPoNo('PONO123CM') != null
    	assertTrue 'should have PoNo PON04321CM', OrderHeader.findByPoNo('PON04321CM') != null
    	
    	assertEquals 'First note text', 'comment 1 comment 1 comment 1', OrderDetailComment.findByOrderNoAndLineNo(2, 110).text.trim()
    	assertEquals 'First note print code',  'I', OrderDetailComment.findByOrderNoAndLineNo(2, 130).printCode
    	assertEquals 'comment count', 13, OrderDetailComment.count()
    	assertEquals "don't print on invoice comments", 3, OrderDetailComment.findAllByPrintCode('N').size()

    	// test multiple CMs against the same invoice
    	new InvoicedOrderHeader(compCode:'01', custNo:'test', orderNo:9876, invoiceNo:54321, invoiceDate: new Date() - 12, 
    			creditMemoCode:true, poNo:'PONO123CM').save(flush:true) 
    	
    	ra = new Return(customer:cust, createDate:new Date(), 
 				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
 				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3))
    			// addr added later...
    	
		raItem1 = new ReturnItem(orderNo:inv1.orderNo, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:1, authQty:1 )
		ra.addToItems(raItem1)
		raItem1.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(1), disposition:ReturnDisposition.get(1)))
		
		assert !ra.validate() // should fail on address
    	ra.addr1 = '11203 Pinewood Court'
    	ra.city = 'Richmond'
    	ra.name = 'Don Denoncourt' 
    	ra.state = 'PA' 
    	ra.zipCode = '23238'
		if (!ra.save(flush:true)) {ra.errors.allErrors.each { println it.inspect() }; assert false;}
		
		returnsService.convertToCreditMemo (ra, 'dond')
    	assertEquals 'header count', 3, OrderHeader.count()
    	assertTrue 'should have PoNo PONO123CM002', OrderHeader.findByPoNo('PONO123CM002') != null

    	// test multiple CMs against the same invoice
    	new InvoicedOrderHeader(compCode:'01', custNo:'test', orderNo:9877, invoiceNo:54321, invoiceDate: new Date() - 12, 
    			creditMemoCode:true, poNo:'PONO123CM002').save(flush:true) 
    	ra = new Return(customer:cust, createDate:new Date(), 
 				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
 				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3),
 				addr1:'11203 Pinewood Court', city:'Richmond', name:'Don Denoncourt', state:'PA', zipCode:'23238')

		raItem1 = new ReturnItem(orderNo:inv1.orderNo, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:1, authQty:1 )
		ra.addToItems(raItem1)
		raItem1.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(1), disposition:ReturnDisposition.get(1)))
		
		if (!ra.save(flush:true)) {ra.errors.allErrors.each { println it.inspect() }; assert false;}
		
		returnsService.convertToCreditMemo (ra, 'dond')
    	assertEquals 'header count', 4, OrderHeader.count()
    	OrderHeader.list().each {println "${it.poNo} CM: ${it.creditMemoCode}"}
    	assertTrue 'should have PoNo PONO123CM003', OrderHeader.findByPoNo('PONO123CM003') != null

    	// field destroy and CustRA No
    	ra = new Return(customer:cust, createDate:new Date(), fieldDestroy:true,
 				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
 				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3),
 				addr1:'11203 Pinewood Court', city:'Richmond', name:'Don Denoncourt', state:'PA', zipCode:'23238')
		raItem1 = new ReturnItem(orderNo:inv1.orderNo, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:0, authQty:1 )
		ra.addToItems(raItem1)
		if (!ra.save(flush:true)) {ra.errors.allErrors.each { println it.inspect() }; assert false;}
		
		int orderNo = returnsService.convertToCreditMemo (ra, 'dond')
		def comments = OrderDetailComment.findAllByOrderNo(orderNo)
		assertTrue 'field destroy note', comments.find {it.text == 'Field Destroy/Donated'}?.text.size() > 0
		assertTrue 'cust RA No note', comments.find {it.text ==~ /RA#:.*/}?.text.size() > 0
		comments = OrderDetailComment.findAllByOrderNo(3)
		//OrderDetailComment.list().each { comment-> println comment }
		assertTrue 'Condition', comments.find {it.text ==~ /Condition:.*/}?.text.size() > 0
		assertTrue 'Disposition', comments.find {it.text ==~ /Disposition:.*/}?.text.size() > 0
		assertEquals 'comments count', 4, comments.size()

     	// Note the assignment of OrderNo varies is so just use itemNo for read 
		//OrderDetailItem.list().each {println it}
    	assertEquals 'crs Reason', 'DM', OrderDetailItem.findByItemNo('one').reasonCode  
    	assertEquals 'crs Reason', 'IN', OrderDetailItem.findByItemNo('two').reasonCode
    	assertEquals 'distr code', 'FTR', OrderDetailItem.findByItemNo('one').distrCode
    	assertEquals 'distr code', 'TRN', OrderDetailItem.findByItemNo('two').distrCode

    }
    void test_no_order() {
    	Customer cust = Customer.findByCustNo('test')
    	assert cust
    	Return ra = new Return(customer:cust, createDate:new Date(), 
 				createUser:'kettler@kettlerusa.com', status:ReturnStatus.get('CMAPP'),
 				shipHandCustCr:100.00g, shipHandDesc:ReturnFreightDesc.get(1), freightCustCr:200.00g, freightDesc:ReturnFreightDesc.get(3),
 				addr1:'11203 Pinewood Court', city:'Richmond', name:'Don Denoncourt', state:'PA', zipCode:'23238')
		
		ReturnItem raItem1 = new ReturnItem(orderNo:0, itemNo:'one', unitPrice:101.98g, desc:'number one item', reason:ReturnReason.get(1),receivedQty:1, authQty:1 )
		ReturnItem raItem2 = new ReturnItem(orderNo:0, itemNo:'two', unitPrice:101.98g, desc:'second item', reason:ReturnReason.get(2),receivedQty:2, authQty:2 )
		ra.addToItems(raItem1)
		ra.addToItems(raItem2)
		raItem1.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(1), disposition:ReturnDisposition.get(1)))
		raItem2.addToDetails(new ReturnItemDetail(condition:ReturnCondition.get(2), disposition:ReturnDisposition.get(2)))
	    if (!ra.save(flush:true)) {ra.errors.allErrors.each { println it.inspect() }; assert false;}

		returnsService.convertToCreditMemo (ra, 'dond')
		assertEquals 'header count', 1, OrderHeader.count()
		assertEquals 'detail count',2, OrderDetailItem.count()
		// test rtrn isa freight claim and OrderDetailMisc created
		assertEquals 'misc count',2, OrderDetailMisc.count()
		assertEquals 'Shipping and Handling', OrderDetailMisc.list()[0].desc
		assertEquals 'Inbound Handling Charge', OrderDetailMisc.list()[1].desc
    }
}
