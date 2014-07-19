package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class FOBCode implements Serializable {
	String id
	String desc
	String transportCode
	String freightCode
	static constraints = {
		desc(maxSize:30,nullable:false)
		transportCode(maxSize:3,nullable:false)
		freightCode(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oefobc',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'FCODE',type:'string')
			desc (column:'FDESC', type:'string')
			transportCode (column:'FTRNCD', type:'string')
			freightCode (column:'FFRTCD', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['fobCode', 'newEntity']
	def getFobCode() {
		if (id) return id
		return 
	}
	void setFobCode (def vlu) { id = vlu }
}
