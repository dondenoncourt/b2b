package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class FreightDistCodes implements Serializable {
	String id
	String distrCode
	static constraints = {
		distrCode(maxSize:3,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table name:'oefrdist'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'SVTMET',type:'string')
			distrCode (column:'ODIST', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['transportationMethodCode', 'newEntity']
	def getTransportationMethodCode() {
		if (id) return id
		return 
	}
	void setTransportationMethodCode (def vlu) { id = vlu }
}
