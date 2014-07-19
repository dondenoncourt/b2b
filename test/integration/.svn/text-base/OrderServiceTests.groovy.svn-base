import grails.test.*
import com.kettler.domain.orderentry.share.Control
import com.kettler.domain.orderentry.share.OrderHeader as OrderHeader
import com.kettler.domain.orderentry.share.OrderDetailComment  as OrderComment
import com.kettler.domain.orderentry.share.OrderDetailItem as OrderItem
import com.kettler.domain.orderentry.share.OrderDetailMisc as OrderMisc
import com.kettler.domain.orderentry.CustomerComments
import com.kettler.domain.orderentry.CustDiscAllow
import com.kettler.domain.orderentry.share.ShipTo

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemWarehouse
import com.kettler.domain.item.share.BillOfMaterials as BOM

import com.kettler.domain.actrcv.share.Customer

import com.kettler.domain.work.InventoryInfo
import com.kettler.domain.work.OrderTotalInfo
import com.kettler.domain.work.Komment

class OrderServiceTests extends GroovyTestCase {
	def orderService
	
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }
    void test_getCarrierCodeFromShippingInstructions() {
    	assertEquals 'ABFF', orderService.getCarrierCodeFromShippingInstructions('R-ABFF')
    	
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('C-BAX-1D')
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('C-BAX-2D')
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('C-BAX-BS')
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('R-BAX-1D')
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('R-BAX-2D')
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('R-BAX-BS')
    	assertEquals 'SIFF', orderService.getCarrierCodeFromShippingInstructions('R-BAX-ECON')
    	
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('C-EGLB')
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('R-EGLB')
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('R-EGLB-ID')
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('R-EGLB-RC')
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('R-EGLB-TD')
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('R-EGLB-WG')
    	assertEquals 'EGLB', orderService.getCarrierCodeFromShippingInstructions('R-EGLB-WGA')

    	assertEquals 'PITD', orderService.getCarrierCodeFromShippingInstructions('C-PITD')
    	assertEquals 'PITD', orderService.getCarrierCodeFromShippingInstructions('R-PITD')
    	assertEquals 'RDWY', orderService.getCarrierCodeFromShippingInstructions('C-RDWY')
    	assertEquals 'RDWY', orderService.getCarrierCodeFromShippingInstructions('R-RDWY')
    	assertEquals 'SEFL', orderService.getCarrierCodeFromShippingInstructions('C-SEFL')
    	assertEquals 'SEFL', orderService.getCarrierCodeFromShippingInstructions('R-SEFL')
    	assertEquals 'CNWY', orderService.getCarrierCodeFromShippingInstructions('R-CNWY')
    	assertEquals 'CNWY', orderService.getCarrierCodeFromShippingInstructions('R-CNWY-DEFERRED')
    	assertEquals 'CNWY', orderService.getCarrierCodeFromShippingInstructions('C-CNWY')
    	assertEquals 'CNWY', orderService.getCarrierCodeFromShippingInstructions('C-CNWY-DEFERRED')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-EXT-MENLO')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-EXT_MENLO')

    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-THIRD PARTY')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-THIRD PARTY')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-EXT_MENLO')
    	
    	assertEquals 'FDEG', orderService.getCarrierCodeFromShippingInstructions('C-FEDEX GROUND')
    	assertEquals 'FDEG', orderService.getCarrierCodeFromShippingInstructions('R-FEDEX-HOME DL')

    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('C-FX-1ST OVRNT')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('C-FX-ECON 2 DAY')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('C-FX-PRTY OVRNT')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('C-FX-STD OVRNT')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('C-FX-XP SAVER')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FEDEX-1D')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FEDEX-2D')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FEDEX-XP')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FX-1ST OVRNT')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FX-ECON 2 DAY')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FX-PRTY OVRNT')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FX-STD OVRNT')
    	assertEquals 'FDE', orderService.getCarrierCodeFromShippingInstructions('R-FX-XP SAVER')
    	
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS 2DY AIR R')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS 3 DAY RES')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS GND RESID')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS HNDRDWT')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS ND A LRES')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS ND AIR SV')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('R-UPS ND AR RES')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS 2 DY A LT')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS 2 DY AIR')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS 3 DY SLCT')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS GND COMMR')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS HNDRDWT')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS ND AIR AM')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS ND AIR SV')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS NXT DY AI')
    	assertEquals 'UPSN', orderService.getCarrierCodeFromShippingInstructions('C-UPS NXT DY LT')
    	
    	assertEquals 'USPS', orderService.getCarrierCodeFromShippingInstructions('R-USPS-PRIORTY')

    	
    	assertEquals 'WWAT', orderService.getCarrierCodeFromShippingInstructions('R-WWAT')
    	assertEquals 'YFSY', orderService.getCarrierCodeFromShippingInstructions('R-YFSY')
    	assertEquals 'WWAT', orderService.getCarrierCodeFromShippingInstructions('C-WWAT')
    	assertEquals 'YFSY', orderService.getCarrierCodeFromShippingInstructions('C-YFSY')
    	
    	assertEquals '',     orderService.getCarrierCodeFromShippingInstructions('C-TRAILER')
    }
    void test_build_non_inv_for_ord_disc_allowances() {
    	def daList2 =  CustDiscAllow.findAll(" from CustDiscAllow as da where  da.compCode = :compCode and da.custNo = :custNo", // and  da.beginDate = da.endDate",
				[compCode:'01', custNo:'test'])
		assertEquals 3, daList2.size()
		daList2.each {println "$it.beginDate = $it.endDate"}

    	List daList = orderService.getCustDiscAllow('01', 'test', new Date())
    	assertEquals 3, daList.size()
    	
    	OrderHeader ord = new OrderHeader(compCode:'01', custNo:'test', orderNo:123)
    	Customer cust = Customer.findByCompCodeAndCustNo('01', 'test')
    	assert cust
		List ordDiscAllowList = orderService.fleshOutOrderHeaderOnAdd(ord, cust)
    	assertEquals 3, ordDiscAllowList.size()
        def nonInvList = orderService.buildNonInvForOrdDiscAllow(ord.custNo, ordDiscAllowList, 100.00g) 
    	assertEquals 3, nonInvList.size()
    	assertEquals 9993, nonInvList[2].lineNo
    	assertEquals 'N', nonInvList[2].lineType
    	assertEquals 'A260', nonInvList[2].discAllowEDICode
    	assertEquals 'EA', nonInvList[2].qtyUnitMeas
    	assertEquals (-1, nonInvList[2].orderQty) 
    	assertEquals (-1, nonInvList[2].shipQty)
    	assertEquals 'COOP', nonInvList[0].itemNo
    	assertEquals 'LOGI', nonInvList[1].itemNo
    	assertEquals 'RETN', nonInvList[2].itemNo
    	assertEquals 'COOP', nonInvList[0].discAllowCode
    	assertEquals 'LOGI', nonInvList[1].discAllowCode
    	assertEquals 'RETN', nonInvList[2].discAllowCode
    	assertEquals 'COOP ADVERTISING', nonInvList[0].desc
    	assertEquals 'LOGISTICS DISCOUNT', nonInvList[1].desc
    	assertEquals 'RETURN ALLOWANCES', nonInvList[2].desc
    	assertEquals (2.50g, nonInvList[0].unitPrice)
    	assertEquals (1.50g, nonInvList[1].unitPrice)
    	assertEquals (4.0g, nonInvList[2].unitPrice)
    	assertEquals (-2.50g, nonInvList[0].amount)
    	assertEquals (-1.50g, nonInvList[1].amount)
    	assertEquals (-4.0g, nonInvList[2].amount)
    	assertEquals (2.50g, nonInvList[0].discAllowPct)
    	assertEquals (1.50g, nonInvList[1].discAllowPct)
    	assertEquals (4.0g, nonInvList[2].discAllowPct)
    	// what about distrCode?  
    }
    void test_get_shipto_list() {
    	def shipToList = orderService.getShipToList('01', 'AM0302W', 0)
    	assert shipToList
    	assertEquals 1, shipToList.size()
    	ShipTo shipTo = ShipTo.retreiveShipTo('01', 'AM0302W', 9999, 12345, 0) 
    	assert shipTo
    	assertEquals '12345', shipTo.orderNo
    	assertEquals '00', shipTo.shipNo
    }
    void test_get_cust_disc_allow() {
    	def daList = orderService.getCustDiscAllow('01', 'AM0302W', new Date())
    	assertEquals 3, daList.size()
    	daList = orderService.getCustDiscAllow('01', 'AM0302W', new Date()+(365*10))
    	assertEquals 0, daList.size()
    	daList = orderService.getCustDiscAllow('01', 'test', new Date())
    	assertEquals 3, daList.size()
    }
    void test_flesh_out_order_header() {
    	OrderHeader orderHeader = new OrderHeader(compCode:'01', orderNo:1, custNo:'test') 

    	orderService.fleshOutOrderHeaderOnAdd(orderHeader, Customer.findByCustNo(orderHeader.custNo))
        assertEquals true, orderHeader.lineDiscCode
        assertEquals 'F10', orderHeader.termsCode
        assertTrue orderHeader.discAllowCode

    	orderHeader = new OrderHeader(compCode:'01', orderNo:1, custNo:'AM0302W') 

    	orderService.fleshOutOrderHeaderOnAdd(orderHeader, Customer.findByCustNo(orderHeader.custNo))
        assertEquals false, orderHeader.lineDiscCode
        assertEquals 'F10', orderHeader.termsCode
        
        orderHeader.shipInstructions = 'C-BAX-1D'
        orderService.fleshOutOrderHeaderOnUpdate(orderHeader)
        assertEquals 0.13g, orderHeader.taxPct1
        assertEquals 0.05g, orderHeader.taxPct2
        assertEquals 'should have been set from ord.shipInstruction', 'SCHENKER GRND', orderHeader.shipVia
    }
    void test_flesh_out_order_item_on_add_update() {
    	
    	OrderHeader orderHeader = new OrderHeader(compCode:'01', orderNo:1, custNo:'AM0302W', taxCode1:'GS1', taxCode2:'VA')
    	// TODO set orderHeader.lineDiscCode = true and profitCenter1-5/lineDisc1-5 
    	
    	OrderItem orderItem = new OrderItem(lineNo:10,   lineType:'I', compCode:'01', orderNo:1, itemNo:'one',     orderQty:3, shipQty:3)
    	orderService.fleshOutOrderItemOnAdd(orderItem, orderHeader, ['0010':orderItem], [])
    	assertEquals true, orderItem.subjToTax1
    	assertEquals true, orderItem.subjToTax2
    	assertEquals false, orderItem.subjToTax3
    	assertEquals 'one desc', orderItem.desc 
    	assertEquals 'FIT', orderItem.distrCode 
        assertEquals 'EA', orderItem.qtyUnitMeas 
        assertEquals '15520-9', orderItem.nmfcNo
        assertEquals 199.32g, orderItem.unitPrice
        // TODO test orderItem.convCode and orderWeight
        
        orderService.fleshOutOrderItemOnUpdate(orderItem, orderHeader, ['0010':orderItem], [])
        assertEquals ((3.0g*199.32g), orderItem.amount) 

        /* TODO test StdUnitMeas=PCK and LowestUnitMeas=EA with itemNo 'two'
        OrderItem orderItem2 = new OrderItem(lineNo:20,   lineType:'I', compCode:'01', orderNo:1, itemNo:'two',     orderQty:1, shipQty:1, subjToTax1:true,  subjToTax2:false, subjToTax3:false)
    	orderService.fleshOutOrderItemOnAdd(orderItem2, orderHeader)
        orderService.fleshOutOrderItemOnUpdate(orderItem2, orderHeader)
        assertEquals ((214.01g * 0.50g), orderItem2.amount) 
        */

        
    }
    
    void test_calc_total() {
    	// set up tax codes in header
    	OrderHeader orderHeader = new OrderHeader(compCode:'01', orderNo:1, custNo:'test', taxCode1:'GS1', taxCode2:'VA')
        orderService.fleshOutOrderHeaderOnUpdate(orderHeader)

        def ordLines = [:]
    	ordLines.put('10',  new OrderItem(lineNo:10,   lineType:'I', compCode:'01', orderNo:1, itemNo:'one',     orderQty:3, shipQty:3, amount:10.01g, subjToTax1:true,  subjToTax2:false, subjToTax3:false))
    	ordLines.put('20',  new OrderItem(lineNo:20,   lineType:'I', compCode:'01', orderNo:1, itemNo:'one',     orderQty:3, shipQty:3, amount:20.02g, subjToTax1:true,  subjToTax2:true,  subjToTax3:false))
    	ordLines.put('30',  new OrderItem(lineNo:30,   lineType:'I', compCode:'01', orderNo:1, itemNo:'one',     orderQty:3, shipQty:3, amount:30.03g, subjToTax1:true,  subjToTax2:false, subjToTax3:true))
    	ordLines.put('40',  new OrderItem(lineNo:40,   lineType:'N', compCode:'01', orderNo:1, itemNo:'non-inv', orderQty:3, shipQty:3, amount:40.04g, subjToTax1:true,  subjToTax2:false, subjToTax3:false))
    	ordLines.put('50',  new OrderMisc(lineNo:50,   lineType:'M', compCode:'01', orderNo:1,                                          amount:50.05g, subjToTax1:true,  subjToTax2:false, subjToTax3:false))
    	ordLines.put('60',    new Komment(lineNo:60,   lineType:'C', text:'sample comment', printCodes:['P']))
    	ordLines.put('9900',  new Komment(lineNo:9900, lineType:'C', text:'sample customer comment', printCodes:['P']))
    	OrderTotalInfo totals = orderService.calcTotal(ordLines, orderHeader, [])
    	assertNotNull totals
    	assertEquals 150.15g, totals.taxableAmount1
    	assertEquals  20.02g, totals.taxableAmount2
    	assertEquals  30.03g, totals.taxableAmount3
    	assertEquals  50.05g, totals.miscAmount
    	assertEquals  20.52g, totals.tax
    	assertEquals 110.61g, totals.netAmount
    	assertEquals 40.04g, totals.salesAmount
    	assertEquals  0g, totals.discAllowAmount // TODO test calcTotal for disc allowance
    }
    void test_get_warehouse() {
    	ItemWarehouse itemWhs = orderService.getItemWarehouse('01', 'one', '1')
    	assertNotNull itemWhs
    	assertEquals 12, itemWhs.qtyOnOrder
        assertEquals 24, itemWhs.qtyOnHand
        assertEquals 6, itemWhs.qtyAlloc
        assertEquals 2, itemWhs.qtyOnBackOrder
    }

    void test_get_next_order_no() {
    	assertNotNull(orderService)
    	def cont = Control.get('01')
    	assertNotNull(cont)
    	assertEquals 1, cont.nextOrderNo
    	int curOrderNo = cont.nextOrderNo
    	int nextOrderNo = rpgService.getNextOrderNo('01')
    	assertEquals(curOrderNo, nextOrderNo)
    	cont = Control.get('01')
    	assertEquals(curOrderNo+1, cont.nextOrderNo)
    	
    }
	void test_is_inventory_available() {
		
	}

    void test_comment_splitter() {
		def input = "Note From SUPPLIER: Booking confirmed by fax. 4 standard rooms - 3 twin shared, 1 single room, please advise if guests require meals.. "
		
		assertEquals input, teardownAndRebuild(input, 10)
		assertEquals input, teardownAndRebuild(input, 20)
		assertEquals input, teardownAndRebuild(input, 30)
		input = """RA request rec. 4/27/10. Costco Store#48; Van Nuys, CA.  
			Item in original packaging.  Shipment will be picked up; and reconsigned to Lucky Sports.
			Pick-up/Reconsign-scheduledyadayadyad 4/28/10
			RV rec. 5/6/10; RV0004805620"""
		println teardownAndRebuild(input, 30)


    }

	private String teardownAndRebuild(input, width) {
		def splitLines = orderService.splitTextToMultiLine(input, width)
		def rebuiltInput = ""
		splitLines.each() {
			rebuiltInput += it
		}
		return rebuiltInput
	}

    void test_get_customer_comments() {
        def cc =  new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9900, text:'*8901-800 MUST HAVE BAR CODE',    printCode:'P')
        def ok = cc.save()
        if (!ok) {
            cc.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9910, text:'LABEL***',                        printCode:'P').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9920, text:'**GIVE ALLPAPERWORK TO BILL M*',  printCode:'P').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9930, text:'PUT SUBORDINATE BOL IN',          printCode:'P').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9940, text:'ENVELOPE ATTACHED TO MASTER',     printCode:'P').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9950, text:'BOL OR PALLET              ',     printCode:'P').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9960, text:'**CANCEL BACKORDERS ',            printCode:'N').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9970, text:'SHIP BNLS/THIRD PARTY',           printCode:'N').save()
        assert new CustomerComments(compCode:'01', custNo:'AM0302W', lineNo: 9980, text:'SSCC18 LABELS REQUIRED',          printCode:'P').save()
        List comments = orderService.createCustCommentList('01', 'AM0302W')
        assertEquals 9, comments.size()
        assertEquals 9930, comments[3].lineNo
        assertEquals 'ENVELOPE ATTACHED TO MASTER', comments[4].text
        assertEquals 'C', comments[5].lineType
        assertEquals 'P', comments[8].printCodes[0]
    }

    void test_allocate() {
        assertEquals 6, ItemWarehouse.findByItemNo('one').qtyAlloc
        
        def ordItms = []
        ordItms << new OrderItem(compCode:'01', orderNo:1, lineNo:10,  lineType:'I', itemNo:'chair-desk', orderQty:2, shipQty:2)
        ordItms << new OrderItem(compCode:'01', orderNo:1, lineNo:20,  lineType:'I', itemNo:'one', orderQty:3, shipQty:3)
        ordItms << new OrderItem(compCode:'01', orderNo:1, lineNo:30,  lineType:'I', itemNo:'two', orderQty:3, shipQty:3)

        assertEquals 3, ordItms.size()
        
        orderService.allocateAndBackOrder (ordItms, ItemWarehouse.findByWarehouse('1').warehouse);

        def item = ItemMaster.findByCompCodeAndItemNo('01', 'one')
        assertEquals 3, item.qtyAlloc
        assertEquals 0, item.qtyOnBackOrder
        item = ItemMaster.findByCompCodeAndItemNo('01', 'two')
        assertEquals 3, item.qtyAlloc
        assertEquals 0, item.qtyOnBackOrder
        item = ItemMaster.findByCompCodeAndItemNo('01', 'chair')
        assertEquals 4, item.qtyAlloc
        assertEquals 0, item.qtyOnBackOrder
        item = ItemMaster.findByCompCodeAndItemNo('01', 'desk')
        assertEquals 4, item.qtyAlloc
        assertEquals 0, item.qtyOnBackOrder

        def itemWhse = ItemWarehouse.findByItemNo('one')
        assertEquals 9, itemWhse.qtyAlloc
        assertEquals 2, itemWhse.qtyOnBackOrder
        itemWhse = ItemWarehouse.findByItemNo('two')
        assertEquals 9, itemWhse.qtyAlloc
        assertEquals 2, itemWhse.qtyOnBackOrder
        itemWhse = ItemWarehouse.findByItemNo('chair')
        assertEquals 10, itemWhse.qtyAlloc
        assertEquals 2, itemWhse.qtyOnBackOrder
        itemWhse = ItemWarehouse.findByItemNo('desk')
        assertEquals 10, itemWhse.qtyAlloc
        assertEquals 2, itemWhse.qtyOnBackOrder

    }
    
    void test_inventory_info() {
    	InventoryInfo info = orderService.getInvInfo('01', 'one', '1') 	
    	assertEquals 24, info.qtyOnHand
    	assertEquals 2, info.qtyOnBackOrder
    	assertEquals 6, info.qtyAlloc
    	assertEquals 18, info.avail 
    	assertEquals 1, info.qtyOnCredHold
    	assertEquals 3, info.qtyFutureShip
    }
    
}
