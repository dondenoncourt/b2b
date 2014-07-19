package com.kettler.domain.varsity
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class SpecialChargesMaster implements Serializable {
	String carrierCode
	String account_shipperNo
	String serviceType
	String specialChargeCode
	String chgCodeDescr
	int sequence
	String chargeClass
	String rangeType
	String chargeLevel
	String timingOfCalc
	String mandatoryQuestionUserSelectQuestion
	String reqdOnAllPkgsQuestion
	String includeInFreight
	String billCustomerQuestion
	String restrictionType
	String restrictionCode
	String restrictionValue
	String includeInGroup1Question
	String includeInGroup2Question
	String includeInGroup3Question
	String carrierOrUser
	int compatibilitySequen
	String compatibilityFlags
	int dateAddedToFile
	int timeAddedToFile
	String addedByUserId
	int dateUpdated
	int timeUpdated
	String updatedByUserId
	static constraints = {
		carrierCode(maxSize:5,nullable:false)
		account_shipperNo(maxSize:15,nullable:false)
		serviceType(maxSize:2,nullable:false)
		specialChargeCode(maxSize:5,nullable:false)
		chgCodeDescr(maxSize:30,nullable:false)
		sequence(max:999,nullable:false)
		chargeClass(maxSize:5,nullable:false)
		rangeType(maxSize:3,nullable:false)
		chargeLevel(maxSize:1,nullable:false)
		timingOfCalc(maxSize:10,nullable:false)
		mandatoryQuestionUserSelectQuestion(maxSize:1,nullable:false)
		reqdOnAllPkgsQuestion(maxSize:1,nullable:false)
		includeInFreight(maxSize:1,nullable:false)
		billCustomerQuestion(maxSize:1,nullable:false)
		restrictionType(maxSize:1,nullable:false)
		restrictionCode(maxSize:1,nullable:false)
		restrictionValue(maxSize:36,nullable:false)
		includeInGroup1Question(maxSize:1,nullable:false)
		includeInGroup2Question(maxSize:1,nullable:false)
		includeInGroup3Question(maxSize:1,nullable:false)
		carrierOrUser(maxSize:1,nullable:false)
		compatibilitySequen(max:999,nullable:false)
		compatibilityFlags(maxSize:30,nullable:false)
		dateAddedToFile(max:99999999,nullable:false)
		timeAddedToFile(max:999999,nullable:false)
		addedByUserId(maxSize:10,nullable:false)
		dateUpdated(max:99999999,nullable:false)
		timeUpdated(max:999999,nullable:false)
		updatedByUserId(maxSize:10,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'vsspcchgp',schema:CH.config.varsity.schema)
//		cache usage:'read-only', include:'non-lazy'  Second-level cache is not enabled
		version (false)
		id (generator:'assigned')
		id (composite:['carrierCode','account_shipperNo','serviceType','specialChargeCode'])
		columns {
			id (composite:['carrierCode','account_shipperNo','serviceType','specialChargeCode'])
			carrierCode (column:'CHCRCD', type:'string')
			account_shipperNo (column:'CHACCT', type:'string')
			serviceType (column:'CHSVTP', type:'string')
			specialChargeCode (column:'CHCODE', type:'string')
			chgCodeDescr (column:'CHDESC', type:'string')
			sequence (column:'"CHSEQ#"', type:'int')
			chargeClass (column:'CHCLAS', type:'string')
			rangeType (column:'CHRNGT', type:'string')
			chargeLevel (column:'CHLEVL', type:'string')
			timingOfCalc (column:'CHTIMN', type:'string')
			mandatoryQuestionUserSelectQuestion (column:'CHTYPE', type:'string')
			reqdOnAllPkgsQuestion (column:'CHREQA', type:'string')
			includeInFreight (column:'CHFRGT', type:'string')
			billCustomerQuestion (column:'CHBCUS', type:'string')
			restrictionType (column:'CHRSTY', type:'string')
			restrictionCode (column:'CHRSCO', type:'string')
			restrictionValue (column:'CHRSVA', type:'string')
			includeInGroup1Question (column:'CHGRP1', type:'string')
			includeInGroup2Question (column:'CHGRP2', type:'string')
			includeInGroup3Question (column:'CHGRP3', type:'string')
			carrierOrUser (column:'CHOWNR', type:'string')
			compatibilitySequen (column:'CHCOMQ', type:'int')
			compatibilityFlags (column:'CHCOMF', type:'string')
			dateAddedToFile (column:'CHADDT', type:'int')
			timeAddedToFile (column:'CHADTI', type:'int')
			addedByUserId (column:'CHADUS', type:'string')
			dateUpdated (column:'CHUPDT', type:'int')
			timeUpdated (column:'CHUPTI', type:'int')
			updatedByUserId (column:'CHUPUS', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
