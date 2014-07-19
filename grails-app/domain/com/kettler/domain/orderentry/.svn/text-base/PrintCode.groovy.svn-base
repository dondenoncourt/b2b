package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class PrintCode implements Serializable {
	String id
	String desc
	static constraints = {
		desc(maxSize:30,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oeprtc',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'PCCODE',type:'string')
			desc (column:'PCDESC', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['printCode', 'newEntity']
	def getPrintCode() {
		if (id) return id
		return 
	}
	void setPrintCode (def vlu) { id = vlu }
}
