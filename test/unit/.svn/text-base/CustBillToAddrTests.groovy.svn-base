import grails.test.*
import com.kettler.domain.orderentry.CustBillToAddr

class CustBillToAddrTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void test_custom_get() {
    	def custBillToAddr = new CustBillToAddr(compCode:'01', orderNo:12345, shipNo:0, newEntity:true)
        assertFalse custBillToAddr.validate()
        assertTrue custBillToAddr.hasErrors()
		assertNotNull errors.getFieldError("name")
		assertNotNull errors.getFieldError("addr1")
		assertNotNull errors.getFieldError("city")
		assertNotNull errors.getFieldError("state")
		assertNotNull errors.getFieldError("zipCode")
		custBillToAddr.name = 'Don Denoncourt'
		custBillToAddr.addr1 = '1 First St.'
		custBillToAddr.City = 'Westhampton'
		custBillToAddr.state = 'VA'
		custBillToAddr.zipCode = '23233'
	    assert custBillToAddr.validate()
	    assert custBillToAddr.save()
    	custBillToAddr = CustBillToAddr.get('01', 12345, 0)
    	assert custBillToAddr
    	assertEquals null, CustBillToAddr.get('01', 54321, 0)
    }
}
