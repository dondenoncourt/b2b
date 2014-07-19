package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class CustomerContact implements Serializable {
	String compCode
	String custNo
	int seqNo
	String type
	String name
	String addr1
	String addr2
	String addr3
	String city
	String state
	String zipCode
	String phoneNo
	String faxNo
	String title
	String emailAddress
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		seqNo(max:999,nullable:false)
		type(maxSize:3,nullable:false)
		name(maxSize:30,nullable:false)
		addr1(maxSize:30,nullable:false)
		addr2(maxSize:30,nullable:false)
		addr3(maxSize:30,nullable:false)
		city(maxSize:15,nullable:false)
		state(maxSize:2,nullable:false)
		zipCode(maxSize:9,nullable:false)
		phoneNo(maxSize:10,nullable:false)
		faxNo(maxSize:10,nullable:false)
		title(maxSize:20,nullable:false)
		emailAddress(maxSize:50,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oeccnt',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','seqNo'])
		columns {
			id (composite:['compCode','custNo','seqNo'])
			compCode (column:'CCCOMP', type:'string')
			custNo (column:'CCCUST', type:'string')
			seqNo (column:'CCSEQN', type:'int')
			type (column:'CCTYPE', type:'string')
			name (column:'CCNAME', type:'string')
			addr1 (column:'CCADR1', type:'string')
			addr2 (column:'CCADR2', type:'string')
			addr3 (column:'CCADR3', type:'string')
			city (column:'CCCITY', type:'string')
			state (column:'CCSTAT', type:'string')
			zipCode (column:'CCZIPC', type:'string')
			phoneNo (column:'CCPHON', type:'string')
			faxNo (column:'CCFAXN', type:'string')
			title (column:'CCTITL', type:'string')
			emailAddress (column:'CCEMA', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
