package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class StandardComments implements Serializable {
	String id
	String commentLine1
	String commentLine2
	String commentLine3
	String printCode
	String printCode2
	String printCode3
	String printCode4
	String printCode5
	String printCode6
	static constraints = {
		commentLine1(maxSize:30,nullable:false)
		commentLine2(maxSize:30,nullable:false)
		commentLine3(maxSize:30,nullable:false)
		printCode(maxSize:1,nullable:false)
		printCode2(maxSize:1,nullable:false)
		printCode3(maxSize:1,nullable:false)
		printCode4(maxSize:1,nullable:false)
		printCode5(maxSize:1,nullable:false)
		printCode6(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'OESCMT',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'SCCODE',type:'string')
			commentLine1 (column:'SCCMT1', type:'string')
			commentLine2 (column:'SCCMT2', type:'string')
			commentLine3 (column:'SCCMT3', type:'string')
			printCode (column:'SCPCOD', type:'string')
			printCode2 (column:'SCPCD2', type:'string')
			printCode3 (column:'SCPCD3', type:'string')
			printCode4 (column:'SCPCD4', type:'string')
			printCode5 (column:'SCPCD5', type:'string')
			printCode6 (column:'SCPCD6', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['stdCommentCode', 'newEntity']
	def getStdCommentCode() {
		if (id) return id
		return 
	}
	void setStdCommentCode (def vlu) { id = vlu }
}
