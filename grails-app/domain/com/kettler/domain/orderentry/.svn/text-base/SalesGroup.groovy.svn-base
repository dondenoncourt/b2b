package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class SalesGroup implements Serializable {
	String id
	String desc
	static constraints = {
		desc(maxSize:30,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oesgrp',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'SGCODE',type:'string')
			desc (column:'SGDESC', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['salesGroupCode', 'newEntity']
	def getSalesGroupCode() {
		if (id) return id
		return 
	}
	void setSalesGroupCode (def vlu) { id = vlu }
}
