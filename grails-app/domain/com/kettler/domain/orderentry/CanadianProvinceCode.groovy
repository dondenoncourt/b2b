package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class CanadianProvinceCode implements Serializable {
	String id
	String name
	String productTaxCode
	String freightTaxCode
	static constraints = {
		name(maxSize:30,nullable:false)
		productTaxCode(maxSize:3,nullable:false)
		freightTaxCode(maxSize:3,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oecanp',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'PCODE',type:'string')
			name (column:'PNAME', type:'string')
			productTaxCode (column:'PPTXCD', type:'string')
			freightTaxCode (column:'PFTXCD', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['provinceCode', 'newEntity']
	def getProvinceCode() {
		if (id) return id
		return 
	}
	void setProvinceCode (def vlu) { id = vlu }
}
