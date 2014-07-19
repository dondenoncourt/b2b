import grails.test.*
import com.kettler.domain.orderentry.share.OrderDetailItem
import com.kettler.domain.item.share.ItemMaster
import grails.converters.XML

class OrderDetailItemTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void test_create() {
        def ordItem = new OrderDetailItem(compCode:'01', orderNo:1, lineNo:1,
                        lineType:'I', itemNo:'Bogus', priceOverride:true, newEntity:true)
        assertFalse ordItem.validate()
        assertTrue ordItem.hasErrors()
        def errors = ordItem.errors
        //ordItem.errors.each {println it.dump() }        
        
		assertNotNull errors.getFieldError("itemNo")
		assertNotNull errors.getFieldError("orderQty")

        def converter = ordItem as XML
        File xml = new File("target/test-reports/ordItem.xml")
        println xml.absolutePath+".ordItem.xml" 
        xml.write(converter.toString())

        ordItem = new OrderDetailItem(compCode:'01', orderNo:1, lineNo:1, nmfcNo:'15520-9', orderQty:1, 
                        lineType:'I', itemNo:'one', newEntity:true)
        ordItem.validate()
        ordItem.errors.allErrors.each { println it.inspect() }

        assertTrue ordItem.validate()
        assertFalse ordItem.hasErrors()

    }
}
