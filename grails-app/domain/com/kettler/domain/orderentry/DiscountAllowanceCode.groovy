package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class DiscountAllowanceCode implements Serializable {
	String id
	String desc
	String affectCommission
	String discReturnCode
	String taxable
	static constraints = {
		desc(maxSize:30,nullable:false)
		affectCommission(maxSize:1,nullable:false)
		discReturnCode(maxSize:1,nullable:false)
		taxable(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oedcal',schema:CH.config.orderentry.schema)
		version (false)
		cache usage:'read-only', include:'non-lazy'
		id (generator:'assigned')
		columns {
			id (column:'DACODE',type:'string')
			desc (column:'DADESC', type:'string')
			affectCommission (column:'DACOMM', type:'string')
			discReturnCode (column:'DAACCT', type:'string')
			taxable (column:'DATXBL', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['discAllowType', 'newEntity']
	def getDiscAllowType() {
		if (id) return id
		return 
	}
	void setDiscAllowType (def vlu) { id = vlu }
}
