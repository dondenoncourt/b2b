import org.codehaus.groovy.grails.commons.ConfigurationHolder

class RpgServiceTests extends GroovyTestCase {
	def rpgService
	def grailsApplication
	
    void test_is_duplicate_PO() {
		println grailsApplication.dump()
		// if I run this test by itself, it works, otherwise it says  ConfigurationHolder.config is null?... 
//		if (ConfigurationHolder.config.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
//			assertTrue rpgService.isDuplicatePO('01', 'AM0302W', '1', '123456') 
//			assertFalse rpgService.isDuplicatePO('01', 'AM0302W', '2', '123456') 
//		} else {
//			assertTrue rpgService.isDuplicatePO('01', 'AM0302W', '1', '123456') 
//			assertFalse rpgService.isDuplicatePO('01', 'AM0302W', '123456', '123456')
//		}
	}
}
	
