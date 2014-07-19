package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class StateCode implements Serializable {
	String id
	String name
	static constraints = {
		name(maxSize:30,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oestac',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'STCODE',type:'string')
			name (column:'STNAME', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['stateCode', 'newEntity']
	def getStateCode() {
		if (id) return id
		return 
	}
	void setStateCode (def vlu) { id = vlu }
}
