package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class PackListCode implements Serializable {
	String id
	String desc
	String clpName
	String printerId
	static constraints = {
		desc(maxSize:30,nullable:false)
		clpName(maxSize:10,nullable:false)
		printerId(maxSize:10,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oeplst',schema:CH.config.orderentry.schema)
		cache usage:'read-only', include:'non-lazy'
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'PLCODE',type:'string')
			desc (column:'PLDESC', type:'string')
			clpName (column:'PLPGM', type:'string')
			printerId (column:'PLPRTR', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['packingListCode', 'newEntity']
	def getPackingListCode() {
		if (id) return id
		return 
	}
	void setPackingListCode (def vlu) { id = vlu }
}
