import grails.test.*
import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.orderentry.share.Control
import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.share.OrderDiscountAllowance
import com.kettler.domain.orderentry.CustDiscAllow

import org.jsecurity.SecurityUtils
import org.jsecurity.subject.Subject

class OrderFlowTests extends WebFlowTestCase {
	def ordCtl
	def loginCtl
	def session = [:]
	def getFlow() {ordCtl.orderFlow}
	def orderService
    def dataSource

    protected void setUp() {
        super.setUp()
        SecurityUtils.metaClass.'static'.getSubject = {->
            return [getPrincipal: {-> return 'customer@kettlerusa.com'} ] as Subject
        } 
		OrderController.metaClass.getSession = { -> session }
		ordCtl = new OrderController()
		ordCtl.orderService = orderService
		loginCtl = new LoginController()
    }

    protected void tearDown() {
        super.tearDown()
    }

/* TODO add test for a kit using the example of H1056-B227 which gen's the following in o99kno
 Line Item Number    Description                     Qty      Price     Amount  
  10                4 SIDE BLUE & BLUE PAD                                    
  11 H1056-227      FOLDABLE PLAYPEN, BLUE           200     95.000   19000.00
  12 H9054-227      4-SIDED PLAYPEN PAD, BLUE        200     30.000    6000.00
 */

    void test_order_happy_path() {
    	loginCtl.params.email='customer@kettlerusa.com'
       	loginCtl.params.password='customer@kettlerusa.com'
    	loginCtl.login()
    	
		def hdrCount = OrderHeader.count()
		assertEquals "Header count should be zero", 0, hdrCount
		def ordItmCount = OrderDetailItem.count()
		assertEquals "Order Item count should be zero", 0, ordItmCount
        assert Control.get('01')
        assert Customer.findByCustNo('AM0302W')
		startFlow()
		
		assertCurrentStateEquals "lineItemSubfile"
		signalEvent('item')
		assertCurrentStateEquals "item"
        ordCtl.params.itemNo = 'one'
        ordCtl.params.orderQty = '1'
		signalEvent('add')	
		getFlowScope().ordItem.errors.allErrors.each { println it.inspect() }
		// no qty any more: assertEquals 24, getFlowScope().invInfo?.qtyOnHand // Note: this fails if you run both integration and unit tests, so use -integration option

		def model = getFlowScope()
		assert model
		assert model.ord
        def orderNo = model.ord.orderNo
        def ordLines = model.ordLines
        
        assertEquals 'AM0302W:1', model.ord.enteredBy
				
		assertFalse ordLines.get('0010').hasErrors()
		assertCurrentStateEquals "itemDetail"
        ordCtl.params.lineNo = "00"+(model.ordLines.values() as List)[0].lineNo.toString()
		signalEvent('update')
		assertCurrentStateEquals "lineItemSubfile"

        assertEquals 1, model.ordLines.size()
		assertCurrentStateEquals "lineItemSubfile"
		signalEvent('next')
		
		assertCurrentStateEquals "shippingInfo"
		ordCtl.params.shipToNo = 1111
		signalEvent('next')
		assertEquals "", model.ord.shipVia
		assertNotNull model.ord.carrierCode
		model.ord.errors.allErrors.each { println it.inspect() }
        assertFalse model.ord.hasErrors()

        assertEquals "AM0302W", model.ord.custNo
        ordCtl.params.warehouse = '1'
        ordCtl.params.poNo = '2' // use an even number for the rpgService stub to be valid

		signalEvent('next')
/* TODO, put this code back in
        assertCurrentStateEquals "discAllow"
		def custDiscAllowList = orderService.getCustDiscAllow(model.ord.compCode, model.ord.custNo, model.ord.pickDate)
		assertEquals 3, custDiscAllowList.size()
		ordCtl.params.profitCenter = []
		ordCtl.params.code = []
		ordCtl.params.percent = []
        (0..(custDiscAllowList.size()-1)).each { i ->
    		ordCtl.params.profitCenter[i] = '1'
    		ordCtl.params.code[i] = 'A'
    		ordCtl.params.percent[i] = "${(i+1)}.0"
        }
		signalEvent('next')
		assertEquals 3, getFlowScope().ordDiscAllowList.size()
		getFlowScope().ordDiscAllowList.each {ordDiscAllow ->
			if (ordDiscAllow.hasErrors()) {
				ordDiscAllow.allErrors.each { println it.inspect() } 
			}
			assertFalse ordDiscAllow.hasErrors()
		}
		assertEquals 4.00g, getFlowScope().ordDiscAllowList[2].percent
*/

        /* webflow sometimes craps out on hibernate save
         * so flow objects are moved to session in the complete event
         * and the completeOrder action save()s the objects
         * But integration tests need some setup to:
         *      manually do the redirect
         *  and simulate the HttpSession
        */
        session.ord = model.ord
        session.ordLines = model.ordLines
        session.custBillToAddr = model.custBillToAddr
        session.ordDiscAllowList = model.ordDiscAllowList

//		signalEvent('review')
 		assertCurrentStateEquals "review"
		signalEvent('complete')
        assertNotNull ordCtl.session.ord
        assertNotNull ordCtl.session.ordLines
        assertNotNull ordCtl.session.ordDiscAllowList

        ordCtl.completeOrder() // manually do orderFlow's redirect

		hdrCount = OrderHeader.count()
		assertEquals "Header count should be 1", 1, hdrCount
		ordItmCount = OrderDetailItem.count()
		assertEquals "Order Item count should be 4", 4, ordItmCount // 3 are non-inv disc allowances
        def ordAdded = OrderHeader.findByCustNoAndOrderNo('AM0302W', 1)
        assertNotNull ordAdded
        def items = OrderDetailItem.list()
        assertEquals 'one', items[0].itemNo
        assertEquals 10, items[0].lineNo
        assertEquals 'I', items[0].lineType
        assertEquals 3, OrderDiscountAllowance.list().size()
        assertEquals 'N', items[1].lineType 
        assertEquals 'N', items[2].lineType 
        assertEquals 'N', items[3].lineType 

    }
    void test_order_happy_path_with_comments() {
    	CustDiscAllow.list()*.delete(flush:true) // don't bother with order disc allowance
    	
		def hdrCount = OrderHeader.count()
		assertEquals "Header count should be zero", 0, hdrCount
		def ordItmCount = OrderDetailItem.count()
		assertEquals "Order Item count should be zero", 0, ordItmCount

		startFlow()
		assertCurrentStateEquals "lineItemSubfile"

		def model = getFlowScope()
        def orderNo = model.ord.orderNo
        def ordLines = model.ordLines
        assertEquals "AM0302W", model.ord.custNo

        assert !model.ord.hasErrors()
		assertCurrentStateEquals "lineItemSubfile"
		signalEvent('comment')
		assertCurrentStateEquals "comment"
        ordCtl.params.komment =
"""When the test runs, the controller will invoke this mock version rather than the tag.
This approach will work regardless of whether the controller uses link(...) or
g.link(...). The notable missing feature is support for other tag namespaces, so if
your controller calls tags that are in a custom namespace, you’ll need to use integra-
tion tests.
    It’s all very well mocking tags when testing controllers, but it might be a good idea
to test the tags themselves. They do contain code, after all.
"""
        ordCtl.params.printCodeA = true
        ordCtl.params.printCodeI = true
        ordCtl.params.printCodeF = true
        ordCtl.params.printCodeL = true
		signalEvent('add')
		assertCurrentStateEquals "lineItemSubfile"

        assertEquals 1, model.ordLines.size()

        signalEvent('next')
        assertCurrentStateEquals "shippingInfo"
        ordCtl.params.poNo = '2' // use an even number for the rpgService stub to be valid
		signalEvent('next')

        /*  simulate the HttpSession (see comment in first test */
        session.ord = model.ord
        session.ordLines = model.ordLines
        session.custBillToAddr = model.custBillToAddr
        session.ordDiscAllowList = model.ordDiscAllowList

 		assertCurrentStateEquals "review"
		signalEvent('complete')
        assertNotNull ordCtl.session.ord
        assertNotNull ordCtl.session.ordLines

        ordCtl.completeOrder() // manually do orderFlow's redirect

		hdrCount = OrderHeader.count()
		assertEquals "Header count should be 1", 1, hdrCount
		def ordCmtCount = OrderDetailComment.count()
		assertEquals "Order Comment count should be 18", 18, ordCmtCount
        def ordAdded = OrderHeader.findByCustNoAndOrderNo('AM0302W', 1)
        assertNotNull ordAdded
        def comments = OrderDetailComment.list()
        assertEquals 'When the test runs, the ', comments[0].text
        assertEquals 'A', comments[0].printCode
        assertEquals 'F', comments[0].printCode2
        assertEquals 'I', comments[0].printCode3
    }

    void test_order_happy_path_with_misc() {
     	CustDiscAllow.list()*.delete(flush:true) // don't bother with order disc allowance

     	assertEquals "Header count should be zero", 0, OrderHeader.count()
		assertEquals "Order Misc count should be zero", 0, OrderDetailMisc.count()
		startFlow()
		assertCurrentStateEquals "lineItemSubfile"

		def model = getFlowScope()
        def orderNo = model.ord.orderNo
        def ordLines = model.ordLines
        assertEquals "AM0302W", model.ord.custNo
        assertEquals '01', model.ord.compCode
        assert !model.ord.hasErrors()

		assertCurrentStateEquals "lineItemSubfile"

		signalEvent('misc')
		assertCurrentStateEquals "misc"
        ordCtl.params.desc = 'test desc'
        ordCtl.params.amount = '1.98'
        ordCtl.params.cost = '1.23'
        ordCtl.params.distrCode = 'AMX'
        ordCtl.params.printCode = 'I'
        ordCtl.params.subjToTax1 = 'true'
        ordCtl.params.subjToTax2 = 'false'
        ordCtl.params.subjToTax3 = 'true'

		signalEvent('add')
		//getFlowScope().misc.errors.allErrors.each { println it.inspect() }
		assertCurrentStateEquals "lineItemSubfile"

        assertEquals 1, model.ordLines.size()
        //println model.ordLines.inspect()
        List lines = model.ordLines.values() as List
        assertEquals 'M', lines[0].lineType
        assertEquals '01', lines[0].compCode
        assertEquals model.ord.orderNo, lines[0].orderNo
        assertEquals 'test desc', lines[0].desc
        assertEquals 1.98g, lines[0].amount
        assertEquals 1.23g, lines[0].cost
        assertEquals 'AMX', lines[0].distrCode
        assertEquals 'I', lines[0].printCode
        assertEquals true, lines[0].subjToTax1
        assertEquals false, lines[0].subjToTax2
        assertEquals true, lines[0].subjToTax3

        /*  simulate the HttpSession (see comment in first test */
        session.ord = model.ord
        session.ordLines = model.ordLines
        session.custBillToAddr = model.custBillToAddr
        session.ordDiscAllowList = model.ordDiscAllowList
        
        assertCurrentStateEquals "lineItemSubfile"

        signalEvent('next')
        assertCurrentStateEquals "shippingInfo"
        ordCtl.params.poNo = '2' // use an even number for the rpgService stub to be valid
		signalEvent('next')
        
 		assertCurrentStateEquals "review"
		signalEvent('complete')
        ordCtl.completeOrder() // manually do orderFlow's redirect

		assertEquals "Header count should be 1", 1, OrderHeader.count()
		assertEquals "Order Misc count should be 1", 1, OrderDetailMisc.count()
        def ordAdded = OrderHeader.findByCustNoAndOrderNo('AM0302W', 1)
        assertNotNull ordAdded
        def miscs = OrderDetailMisc.list()
        assertEquals 'test desc', miscs[0].desc
     }
}
