package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class Location3rdPartyBill implements Serializable {
	String compCode
	String custNo
	int shipToNo
	String carrier
	String accountNo
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		shipToNo(max:9999,nullable:false)
		carrier(maxSize:4,nullable:false)
		accountNo(maxSize:15,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oebil2',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','shipToNo','carrier'])
		columns {
			id (composite:['compCode','custNo','shipToNo','carrier'])
			compCode (column:'BCOMP', type:'string')
			custNo (column:'BCUST', type:'string')
			shipToNo (column:'STNUMB', type:'int')
			carrier (column:'BCARR', type:'string')
			accountNo (column:'BACCT', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
