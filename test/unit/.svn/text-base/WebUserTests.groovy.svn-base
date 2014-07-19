import grails.test.*
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.share.SalesPerson
import com.kettler.domain.orderentry.share.UserControl
import com.kettler.domain.actrcv.share.Customer

class WebUserTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testIt() {
    	def webUser = new WebUser(role:new Role(role:Role.getNo(Role.CUSTOMER)))
    	mockDomain(WebUser, [webUser])
    	mockDomain(Customer, [new Customer(compCode:'01', custNo:'DE00001', salespersonCode:'D01')])
    	mockDomain(SalesPerson, [new SalesPerson(compCode:'01',salespersonCode:'D01')])
    	mockDomain(UserControl, [new UserControl(id:'DOND')])
    	webUser.validate()
        assertTrue webUser.hasErrors()
        def errors = webUser.errors
        
		assertNotNull errors.getFieldError("email")
		assertNotNull errors.getFieldError("password")
		assertNotNull errors.getFieldError("custNo")
		assertNotNull errors.getFieldError("firstname")
		assertNotNull errors.getFieldError("lastname")
    	webUser.email = 'dondenoncourt@gmail.com'
    	webUser.password = 'secret1234'
    	webUser.custNo = 'DE00001'
    	webUser.firstname = 'D'
    	webUser.lastname = 'D'
    	webUser.validate()
        assertFalse webUser.hasErrors()

    	def webUser2 = new WebUser(role:new Role(role:Role.getNo(Role.REP)))
    	webUser2.email = 'dondenoncourt@gmail.com'
    	webUser2.password = 'secret1234'
    	webUser2.salesperson = SalesPerson.get('D01')
    	webUser2.firstname = 'D'
    	webUser2.lastname = 'D'
    	webUser2.validate()
    	
    }
}
