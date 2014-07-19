import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.orderentry.share.OrderDetailComment
import com.kettler.domain.orderentry.share.OrderDetailMisc
import com.kettler.domain.orderentry.ContractPrice

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemWarehouse
import com.kettler.domain.item.share.BillOfMaterials as BOM

import com.kettler.domain.work.Komment

import org.apache.commons.lang.StringUtils;
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

public class OrderServiceUnitTests extends grails.test.GrailsUnitTestCase {

	
	protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void test_get_contract_price() {
    	ContractPrice cp = new ContractPrice(compCode:'01', custNo:'test', itemNo:'widget', beginDate:new Date()-10,  expireDate:new Date()+10, qtyUnitMeasCode:'EA', unitPrice1:1.24g)
    	mockDomain(ContractPrice, [cp])
    	def orderService = new OrderService()
    	assertEquals 1.24g, orderService.getContractPrice('01', 'test', 'widget', new Date())
    	
    }
    void test_bom_availability() {
    	boolean debug = true
    	mockLogging(OrderService, debug)
    	ItemMaster pingPongKit =    new ItemMaster(compCode:'01', itemNo:'ping-pong-kit',    lowestUnitMeas:'EA' )
    	ItemMaster pingPongBall =   new ItemMaster(compCode:'01', itemNo:'ping-pong-ball',   lowestUnitMeas:'EA' )
    	ItemMaster pingPongPaddle = new ItemMaster(compCode:'01', itemNo:'ping-pong-paddle', lowestUnitMeas:'EA' )
    	BOM bomBall =   new BOM(compCode:'01', itemNo:pingPongKit.itemNo, seqNo:1, partItemNo:pingPongBall.itemNo,   partQty: 6)
    	BOM bomPaddle = new BOM(compCode:'01', itemNo:pingPongKit.itemNo, seqNo:2, partItemNo:pingPongPaddle.itemNo, partQty: 2)
    	ItemWarehouse pingPongBallWhs   = new ItemWarehouse(id:2, compCode:'01', itemNo:pingPongBall.itemNo,   warehouse:'1', qtyOnHand:10, qtyAlloc:8)
    	ItemWarehouse pingPongPaddleWhs = new ItemWarehouse(id:3, compCode:'01', itemNo:pingPongPaddle.itemNo, warehouse:'1', qtyOnHand:13, qtyAlloc:8)
    	mockDomain(BOM, [bomBall, bomPaddle])
    	mockDomain(ItemWarehouse, [pingPongBallWhs, pingPongPaddleWhs]) 
    	mockDomain(ItemMaster, [pingPongKit, pingPongBall, pingPongPaddle])

    	assertEquals 2, ItemWarehouse.list().size()
		def orderService = new OrderService()

    	assertFalse orderService.isBOMPartInventoryAvail (bomBall, 10, '1')
    	assertTrue orderService.isBOMPartInventoryAvail (bomPaddle, 1, '1')
    }
    void test_calc_line_disc() {
    	boolean debug = true
    	mockLogging(OrderService, debug)
    	OrderHeader ord = new OrderHeader(lineDiscCode:true, profitCenter1:'9', lineDisc1:1.0g, profitCenter2:'1', lineDisc2:2.0g)
    	OrderDetailItem orderItem1 = new OrderDetailItem(orderQty:1, itemNo:'bike')
    	OrderDetailItem orderItem2 = new OrderDetailItem(orderQty:1, itemNo:'trike')
    	ItemMaster item1 = new ItemMaster(compCode:'01', itemNo:'bike',  basePrice:100.00g, profitCenterClass:'9' )
    	ItemMaster item2 = new ItemMaster(compCode:'01', itemNo:'trike', basePrice:100.00g, profitCenterClass:'1' )
    	mockDomain(OrderHeader, [ord])
    	mockDomain(ItemMaster, [item1, item2])
    	mockDomain(OrderDetailItem, [orderItem1,orderItem2])
    	def orderService = new OrderService()
    	orderService.calcLineDisc(ord, orderItem1, item1)
    	assertEquals 99.0g, orderItem1.amount
    	orderService.calcLineDisc(ord, orderItem2, item2)
    	assertEquals 98.0g, orderItem2.amount
    }
    void test_ord_line_write_to_db() {
        def zeroPad4 = new java.text.DecimalFormat('0000')

    	boolean debug = true
        mockLogging(OrderService, debug)

    	mockDomain(OrderDetailComment)
        mockDomain(OrderDetailMisc)
        mockDomain(ItemMaster, [
        		new ItemMaster(compCode:'01', itemNo:'notkit'),
        		new ItemMaster(compCode:'01', itemNo:'kit'),
        		new ItemMaster(compCode:'01', itemNo:'prt11'),
        		new ItemMaster(compCode:'01', itemNo:'prt12'),
        		new ItemMaster(compCode:'01', itemNo:'prt21'),
        		new ItemMaster(compCode:'01', itemNo:'prt22')
        	]
        )
    	
		def ordLines = new TreeMap()
    	def orderNo = 12345
    	def items = [
      	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'notkit', lineNo:10, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt11',  lineNo:21, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt12',  lineNo:22, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt21',  lineNo:41, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt22',  lineNo:42, lineType:'I', orderQty:1)
        ]
    	mockDomain(OrderDetailItem, items)
    	
    	ordLines.put "0010", items[0]
	    ordLines.put "0020", new Komment(lineNo:20, printCodes:['I'],text:'ITEM DESC FOR KIT')
    	ordLines.put "0021", items[1]
    	ordLines.put "0022", items[2]
	    ordLines.put("0030", new Komment(lineNo:30, printCodes:['I'],
	    	text:"This is how the seminal exercise in Drawing on the Right Side of the Brain works: you take a drawing, turn it upside down, and then duplicate it. Instead of looking at it as -- draw a nose, then draw eyes -- you have to refer back and forth to the drawing, again and again, because it becomes a collection of lines and intersections. Through this exercise, you begin to see the world as lines and connections while youre drawing."
			)
	    )
	    /* kit */
	    ordLines.put "0040", new Komment(lineNo:40, printCodes:['I'],text:'ITEM DESC FOR KIT')
    	ordLines.put "0041", items[3]
    	ordLines.put "0042", items[4]
	    ordLines.put("0050", new Komment(lineNo:50, printCodes:['I'],
	    		text:"""Im not talking about -- thinking outside the box, -- which is tame by comparison. -- 
As long as you respect the box, youre still beholden to it, whether youre inside or outside. 
Its relatively easy to think outside the box because the box gives you a lot of structure and 
comfort; all youre doing is variations on a theme."""
	    	)
     	)
    	def orderService = new OrderService()
//        orderService.sessionFactory = new Expando(getCurrentSession: {
//	    		return new Expando(flush:{})
//	    	}
//	    )
        
        // OrderDetailItem's schema:CH.config.orderentry.schema was failing with null CH.config
        CH.config = new groovy.util.ConfigObject()
        CH.config.putAt 'orderentry.schema', 'kettler'
        println "CH ${CH}"

    	orderService.writeOrderLines(ordLines, '01', orderNo, 0)
    	
    	def comments = OrderDetailComment.list() 
    	assertEquals 31, comments.size()
    	def dtlItems = OrderDetailItem.list() 
    	assertEquals items.size(), dtlItems.size()
dtlItems.each {println "$it.lineNo $it.itemNo"}
comments.each {println "$it.lineNo <$it.text>"}
    	
    	assertEquals  10, dtlItems[0].lineNo
    	assertEquals  20, comments[0].lineNo
    	assertEquals  21, dtlItems[1].lineNo
    	assertEquals  22, dtlItems[2].lineNo
    	assertEquals  30, comments[1].lineNo
    	assertEquals 190, comments[17].lineNo
    	assertEquals 201, dtlItems[3].lineNo
    	assertEquals 202, dtlItems[4].lineNo

    	assertEquals 'ITEM DESC FOR KIT', StringUtils.stripEnd(comments[0].text, ' ')
    	assertEquals 'ITEM DESC FOR KIT', StringUtils.stripEnd(comments[18].text, ' ')
    	assertEquals 'This is how the seminal', StringUtils.stripEnd(comments[1].text, ' ')
    	assertEquals 'exercise in Drawing on the',    StringUtils.stripEnd(comments[2].text, ' ')
     	assertEquals 'Right Side of the Brain works:',    StringUtils.stripEnd(comments[3].text, ' ')
     	assertEquals ' you take a drawing, turn it',    StringUtils.stripEnd(comments[4].text, ' ') 

    }
    void test_ord_line_pop_from_db() {
    	def orderNo = 12345
    	mockDomain(OrderDetailItem, [
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'notKit', lineNo:10, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt11',  lineNo:21, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt12',  lineNo:22, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt21',  lineNo:191, lineType:'I', orderQty:1),
    	   new OrderDetailItem(compCode:'01', orderNo:orderNo, itemNo:'prt22',  lineNo:192, lineType:'I', orderQty:1)
        ])
    	mockDomain(OrderDetailComment, [
       	    /* kit */
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:20, text:'4 SIDE BLUE & BLUE PAD', printCode:'I'),
    	    
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:20, printCode:'I',text:'4 SIDE BLUE & BLUE PAD'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:30, printCode:'I',text:'While playing with Spring Roo'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:40, printCode:'I',text:'the other day I noticed Roo'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:50, printCode:'I',text:'isusing Dojo - and to be more'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:60, printCode:'I',text:'specific Dijit Forms - to'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:70, printCode:'I',text:'enhance plain htlm input'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:80, printCode:'I',text:'fields with javascript. For'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:90, printCode:'I',text:'example Number fields are'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:100, printCode:'I',text:'decorated with a Dojo'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:110, printCode:'I',text:'dijit.form.NumberTextBox;'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:120, printCode:'I',text:'whatthis means is that the'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:130, printCode:'I',text:'user can only enter digits and'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:140, printCode:'I',text:'no text. The lack of this'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:150, printCode:'I',text:'featurewith plain html inputs'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:160, printCode:'I',text:'is a problem that has always'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:170, printCode:'I',text:'bothered me when developing'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:180, printCode:'I',text:'business web applications.'),
    	    /* kit */
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:190, printCode:'I',text:'4 SIDE BLUE & RED PAD'),
    	    
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:210, printCode:'I',text:'So I dived into the magic of'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:220, printCode:'I',text:'Dojo and its Dijit form'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:230, printCode:'I',text:'controls last week, and it'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:240, printCode:'I',text:'does not only validate values'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:250, printCode:'I',text:'using javascript, but it also'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:260, printCode:'I',text:'contains nice'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:270, printCode:'I',text:'widgets. During the weekend'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:280, printCode:'I',text:'I decided to create a small'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:290, printCode:'I',text:'Grails application to leverage'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:300, printCode:'I',text:'all Dijit form controls using'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:310, printCode:'I',text:'a tag library. The following'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:320, printCode:'I',text:'Dijit enabled form controls'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:330, printCode:'I',text:'are available in this tag'),
    	    new OrderDetailComment(compCode:'01', orderNo:orderNo, lineNo:340, printCode:'I',text:'library:')
            ])
            mockDomain(OrderDetailMisc)
    	def orderService = new OrderService()
    	TreeMap ordLines = orderService.getOrderLines ('01', orderNo)
    	assert ordLines
//    	ordLines.each {key, detail ->
//    		if (detail.lineType == 'C') {
//    			println "$key $detail.lineType $detail.text"
//    		} else {
//    			println "$key $detail.lineType $detail.itemNo"
//    		}
//    	}
    	assertEquals 9, ordLines.size()
    	assertEquals 'I',                      ordLines.get("0010").lineType
    	assertEquals 'notKit',                 ordLines.get("0010").itemNo
    	assertEquals 'C',                      ordLines.get("0020").lineType
    	assertEquals '4 SIDE BLUE & BLUE PAD', ordLines.get("0020").text.trim()
    	assertEquals 'I',                      ordLines.get("0021").lineType
    	assertEquals 'prt11',                  ordLines.get("0021").itemNo
    	assertEquals 'I',                      ordLines.get("0022").lineType
    	assertEquals 'prt12',                  ordLines.get("0022").itemNo
    	assertEquals 'C',                      ordLines.get("0030").lineType
    	assertEquals 'C',                      ordLines.get("0190").lineType
    	assertEquals '4 SIDE BLUE & RED PAD',  ordLines.get("0190").text.trim()
    	assertEquals 'prt21',                  ordLines.get("0191").itemNo
    	assertEquals 'prt22',                  ordLines.get("0192").itemNo
    	assertEquals 'C',                      ordLines.get("0210").lineType
    }
}
