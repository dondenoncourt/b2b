package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class QuoteDetailComment implements Serializable {
	String compCode
	int orderNo
	int shipNo = 0
	int lineNo
	String lineType = 'C'
	String text
	String printCode = ''
	String printCode2 = ''
	String printCode3 = ''
	String printCode4 = ''
	String printCode5 = ''
	String printCode6 = ''
	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:99999,nullable:false)
		shipNo(max:99,nullable:false)
		lineNo(max:9999,nullable:false)
		lineType(maxSize:1,inList:['C'],nullable:false)
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
		table (name:'oeprq3',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','shipNo','lineNo'])
		columns {
    		id (composite:['compCode','orderNo','shipNo','lineNo'])
			compCode (column:'OCOMP', type:'TrimString')
			orderNo (column:'OQUOT', type:'int')
			shipNo (column:'OSHPN', type:'int')
			lineNo (column:'OSEQN', type:'int')
			lineType (column:'OTYPE', type:'TrimString')
			text (column:'ODESC', type:'TrimString')
			printCode (column:'OPCOD', type:'TrimString')
			printCode2 (column:'OPCOD2', type:'TrimString')
			printCode3 (column:'OPCOD3', type:'TrimString')
			printCode4 (column:'OPCOD4', type:'TrimString')
			printCode5 (column:'OPCOD5', type:'TrimString')
			printCode6 (column:'OPCOD6', type:'TrimString')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
