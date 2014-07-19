import grails.test.*
import com.kettler.domain.orderentry.share.ShipTo

// Note: this was in Unit but mock objects seems to have problems with criterion in constraints
class ShipToTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void test_validation() {
    	def shipTo = new ShipTo(compCode:'01',custNo:'AL0125',orderNo:1234)
    			                                    
		assertFalse shipTo.validate()
		assertTrue shipTo.hasErrors()
		def errors = shipTo.errors
		assertEquals "nullable", errors.getFieldError("addr1").code
		assertNull errors.getFieldError("compCode")
		assertNull errors.getFieldError("custNo")
		assertNull errors.getFieldError("orderNo")
		
		shipTo.shipToNo = 0
		shipTo.countryName = ''
		assertFalse shipTo.validate()
		assertTrue shipTo.hasErrors()
		errors = shipTo.errors
		assertEquals "min.notmet", errors.getFieldError("shipToNo").code
		assertEquals "blank", errors.getFieldError("countryName").code

		shipTo.shipToNo = 1
		shipTo.countryName = 'USA'
		assertFalse shipTo.validate()
		assertTrue shipTo.hasErrors()

		shipTo = new ShipTo(compCode:'01', orderNo:12345, custNo:'DON001',shipNo:1,shipToNo:9999)
    	shipTo.validate()
        assertEquals '01', shipTo.shipNo

        shipTo = new ShipTo(compCode:'01', orderNo:12345, custNo:'DON001',shipNo:'1',shipToNo:9999)
    	shipTo.validate()
        assertEquals '01', shipTo.shipNo

    }
}
