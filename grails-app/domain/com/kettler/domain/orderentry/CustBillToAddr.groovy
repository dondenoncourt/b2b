package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class CustBillToAddr implements Serializable {
	String compCode
	int orderNo
	int shipNo
	String name
	String addr1
	String addr2
	String city
	String state
	String zipCode
	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:999999,nullable:false)
		shipNo(max:99,nullable:false)
		name(maxSize:30,blank:false,nullable:false)
		addr1(maxSize:30,blank:false,nullable:false)
		addr2(maxSize:30,nullable:false)
		city(maxSize:15,blank:false,nullable:false)
		state(maxSize:2,blank:false,nullable:false)
		zipCode(maxSize:9,blank:false,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oecbtf',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','shipNo'])
		columns {
			id (composite:['compCode','orderNo','shipNo'])
			compCode (column:'BTCOMP', type:'string')
			orderNo (column:'BTORDN', type:'int')
			shipNo (column:'BTSHPN', type:'int')
			name (column:'BTNAME', type:'string')
			addr1 (column:'BTADR1', type:'string')
			addr2 (column:'BTADR2', type:'string')
			city (column:'BTCITY', type:'string')
			state (column:'BTSTAT', type:'string')
			zipCode (column:'BTZIPC', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
	
    static def get(String compCode, int orderNo, int shipNo) {
        return CustBillToAddr.withCriteria(uniqueResult:true) {
    		and {
    			eq('compCode', compCode)
    			eq('orderNo', orderNo)
    			eq('shipNo', shipNo)
    		}
        }     
    }
	
}
