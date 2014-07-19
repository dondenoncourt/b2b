import grails.test.*

class PoBoxTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void test_po_box_in_address() {
    	List boxes = ['P.O. Box', 
    	              'PO Box',
    	              'POBox',
    	              'pobox',
    	              'p o BOX',
    	              'P.O.Box'
    	              ]
    	boxes.each {
    		assert  ( it ==~ /(?i)P[\. ]?O[\. ]?\s*BOX/ )
    	}
    }
}
