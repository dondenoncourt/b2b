package com.kettler.domain.item
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class Warehouse implements Serializable {
	String compCode
	String code
	String name
	String allowOrderEntryPick
	String inclInOrdReq
	String addr1
	String addr2
	String addr3
	String city
	String state
	String zipCode
	String phoneNo
	String faxNo
	String contactPerson
	String labelOutq
	static constraints = {
		compCode(maxSize:2,nullable:false)
		code(maxSize:3,nullable:false)
		name(maxSize:30,nullable:false)
		allowOrderEntryPick(maxSize:1,nullable:false)
		inclInOrdReq(maxSize:1,nullable:false)
		addr1(maxSize:30,nullable:false)
		addr2(maxSize:30,nullable:false)
		addr3(maxSize:30,nullable:false)
		city(maxSize:15,nullable:false)
		state(maxSize:2,nullable:false)
		zipCode(maxSize:9,nullable:false)
		phoneNo(maxSize:10,nullable:false)
		faxNo(maxSize:10,nullable:false)
		contactPerson(maxSize:20,nullable:false)
		labelOutq(maxSize:10,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'inwhse',schema:CH.config.inventory.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','code'])
		columns {
			id (composite:['compCode','code'])
			compCode (column:'WCOMP', type:'string')
			code (column:'WWHSE', type:'string')
			name (column:'WNAME', type:'string')
			allowOrderEntryPick (column:'WPICK', type:'string')
			inclInOrdReq (column:'WORDR', type:'string')
			addr1 (column:'WADR1', type:'string')
			addr2 (column:'WADR2', type:'string')
			addr3 (column:'WADR3', type:'string')
			city (column:'WCITY', type:'string')
			state (column:'WSTAT', type:'string')
			zipCode (column:'WZIPC', type:'string')
			phoneNo (column:'WPHON', type:'string')
			faxNo (column:'WFAXN', type:'string')
			contactPerson (column:'WCNTC', type:'string')
			labelOutq (column:'WLBLOQ', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
