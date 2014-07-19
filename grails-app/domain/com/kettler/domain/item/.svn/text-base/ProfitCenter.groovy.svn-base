package com.kettler.domain.item
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class ProfitCenter implements Serializable {
	String id
	String desc
	static constraints = {
		desc(maxSize:30,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'inpctr',schema:CH.config.inventory.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'PCCODE',type:'string')
			desc (column:'PCDESC', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['profitCenterCode', 'newEntity']
	def getProfitCenterCode() {
		if (id) return id
		return 
	}
	void setProfitCenterCode (def vlu) { id = vlu }
}

