package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class CustReq3rdPartyBill implements Serializable {
	String compCode
	String custNo
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oebil1',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo'])
		columns {
			id (composite:['compCode','custNo'])
			compCode (column:'BCOMP', type:'string')
			custNo (column:'BCUST', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
