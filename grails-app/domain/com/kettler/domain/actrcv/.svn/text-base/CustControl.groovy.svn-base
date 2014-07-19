package com.kettler.domain.actrcv
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class CustControl implements Serializable {
	String id
	int nextSeqNo = 1
	static constraints = {
		nextSeqNo(max:9999,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'arcctl',schema:CH.config.accounting.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'CALPHA',type:'string')
			nextSeqNo (column:'CNXSEQ', type:'int')
		}
	}
	boolean newEntity = false
	static transients = ['alphaChars', 'newEntity']
	def getAlphaChars() {
		if (id) return id
		return 
	}
	void setAlphaChars (def vlu) { id = vlu }
}
