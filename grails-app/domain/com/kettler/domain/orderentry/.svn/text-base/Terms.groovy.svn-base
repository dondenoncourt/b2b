package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class Terms implements Serializable {
	String id
	String desc
	BigDecimal termsPct
	int discountDays
	String discProxCode
	int netDays
	String netProxCode
	String dueDateFlag
	int freightAllowancePct
	String printCode
	static constraints = {
		desc(maxSize:30,nullable:false)
		termsPct(max:new BigDecimal("99.99"),nullable:false)
		discountDays(max:999,nullable:false)
		discProxCode(maxSize:1,nullable:false)
		netDays(max:999,nullable:false)
		netProxCode(maxSize:1,nullable:false)
		dueDateFlag(maxSize:1,nullable:false)
		freightAllowancePct(max:999,nullable:false)
		printCode(maxSize:1,nullable:false)
	}
	static final String CREDIT_CARD = '9'
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oeterm',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'TMCODE',type:'string')
			desc (column:'TMDESC', type:'string')
			termsPct (column:'TMPCNT', type:'big_decimal')
			discountDays (column:'TMDDYS', type:'int')
			discProxCode (column:'TMDPCD', type:'string')
			netDays (column:'TMNDYS', type:'int')
			netProxCode (column:'TMNPCD', type:'string')
			dueDateFlag (column:'TMDDAT', type:'string')
			freightAllowancePct (column:'TFAPCT', type:'int')
			printCode (column:'TPRTCD', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['termsCode', 'newEntity']
	def getTermsCode() {
		if (id) return id
		return 
	}
	void setTermsCode (def vlu) { id = vlu }
}
