package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class CustDiscAllow implements Serializable {
	String compCode
	String custNo
	String profitCenter
	String code
	String ediCode = ''
	BigDecimal percent = 0.0g
	Date beginDate
	Date endDate
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		profitCenter(maxSize:1,nullable:false)
		code(maxSize:4,nullable:false)
		ediCode(maxSize:4,nullable:false)
		percent(max:new BigDecimal("99.999"),nullable:false)
		beginDate(nullable:true)
		endDate(nullable:true)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oecda',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','profitCenter','code'])
		columns {
			id (composite:['compCode','custNo','profitCenter','code'])
			compCode (column:'CCOMP', type:'string')
			custNo (column:'CCUST', type:'string')
			profitCenter (column:'CPCTR', type:'string')
			code (column:'CDACD', type:'string')
			ediCode (column:'CEDICD', type:'string')
			percent (column:'CDAPCT', type:'big_decimal')
			beginDate (column:'CBEGDT', type:'date')
			endDate (column:'CENDDT', type:'date')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
