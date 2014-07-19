import com.kettler.domain.orderentry.share.Role;
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.actrcv.share.Customer

import grails.test.*

class DeleteInactiveUsersJobTests extends GroovyTestCase {
    def grailsApplication
    def deleteInactiveUsersJob
	
    protected void setUp() {
        super.setUp()
        deleteInactiveUsersJob = grailsApplication.mainContext.getBean('DeleteInactiveUsersJob')          
    	new Customer(compCode:'01', custNo:'INACTIV', salespersonCode:'DGD',  
                lineDiscCode:false, termsCode:'F10', addr1:'1st St', countryCode:'USA', name:'Amazon',
                salesDivision:'1', salesGroup: 'AB', shortName:'Amazon', city:'X', state:'XY', zipCode:'12345', 
                taxCode1:'GS1', taxCode2:'VA',
                activeCode:'I').save(failOnError:true)
                
    	def user = new WebUser(email:'inactive@kettlerusa.com', password:'customer',compCode:'01', custNo:'INACTIV', firstname:'Don', lastname:'Denoncourt')
	    user.role = new Role(role:2) // Customer role
    	user.save(failOnError:true)
    }

    protected void tearDown() {
        super.tearDown()
        Customer.findAllByCustNo('INACTIV')*.delete()
        WebUser.findAllByCustNo('INACTIV')*.delete()
    }

    void test_delete_inactive_users() {
    	assertEquals 3, Customer.count()
    	assertEquals 2, WebUser.count()
    	assertEquals 1, Customer.countByCustNo('INACTIV')
    	assertEquals 1, WebUser.countByCustNo('INACTIV')
    	deleteInactiveUsersJob.execute() 
    	assertEquals 0, WebUser.countByCustNo('INACTIV')
    	assertEquals 3, Customer.count()
    	assertEquals 1, WebUser.count()
    }
}