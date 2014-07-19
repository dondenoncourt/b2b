package com.kettler.domain.actrcv
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class Distribution implements Serializable {
	String compCode
	String serviceCode
	String invDiscCode
	String returnsCode
	static constraints = {
		compCode(maxSize:2,nullable:false)
		serviceCode(maxSize:3,nullable:false)
		invDiscCode(maxSize:3,nullable:false)
		returnsCode(maxSize:3,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'ardtbl',schema:CH.config.accounting.schema)
//		cache usage:'read-only', include:'non-lazy'  Second-level cache is not enabled
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','serviceCode'])
		columns {
			id (composite:['compCode','serviceCode'])
			compCode (column:'RCOMP', type:'string')
			serviceCode (column:'RSCDE', type:'string')
			invDiscCode (column:'RDCDE', type:'string')
			returnsCode (column:'RRCDE', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
	String toString() {"$compCode:$serviceCode:$invDiscCode:$returnsCode"}
}
