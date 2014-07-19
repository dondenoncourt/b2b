package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class ReferenceCode implements Serializable {
	String id
	String referenceDesc
	static constraints = {
		referenceDesc(maxSize:20,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oerfcd',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'RFCODE',type:'string')
			referenceDesc (column:'RFDESC', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['referenceCode', 'newEntity']
	def getReferenceCode() {
		if (id) return id
		return 
	}
	void setReferenceCode (def vlu) { id = vlu }
}
