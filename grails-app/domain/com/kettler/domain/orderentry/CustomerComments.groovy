package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class CustomerComments implements Serializable {
	String compCode
	String custNo
	int lineNo
	String text
	String printCode
	String printCode2 = ''
	String printCode3 = ''
	String printCode4 = ''
	String printCode5 = ''
	String printCode6 = ''
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		lineNo(max:9999,nullable:false)
		text(maxSize:30,nullable:false)
		printCode(maxSize:1,nullable:false)
		printCode2(maxSize:1,nullable:false)
		printCode3(maxSize:1,nullable:false)
		printCode4(maxSize:1,nullable:false)
		printCode5(maxSize:1,nullable:false)
		printCode6(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oeccmt',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','lineNo'])
		columns {
			id (composite:['compCode','custNo','lineNo'])
			compCode (column:'CCOMP', type:'string')
			custNo (column:'CCUST', type:'string')
			lineNo (column:'CSEQN', type:'int')
			text (column:'CCOMT', type:'string')
			printCode (column:'CCODE', type:'string')
			printCode2 (column:'CCODE2', type:'string')
			printCode3 (column:'CCODE3', type:'string')
			printCode4 (column:'CCODE4', type:'string')
			printCode5 (column:'CCODE5', type:'string')
			printCode6 (column:'CCODE6', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
