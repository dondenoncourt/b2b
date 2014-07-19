package com.kettler.domain.varsity
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class ShippingInstructions implements Serializable {
	String id
	String activeStatus
	String carrierCode
	String servType
	String billAsCarrier
	String billAsServTyp
	String billAsCompany
	String billAsWarehouse
	String billAsUser
	String spcChgFlag
	static constraints = {
		activeStatus(maxSize:1,nullable:false)
		carrierCode(maxSize:5,nullable:false)
		servType(maxSize:2,nullable:false)
		billAsCarrier(maxSize:5,nullable:false)
		billAsServTyp(maxSize:2,nullable:false)
		billAsCompany(maxSize:4,nullable:false)
		billAsWarehouse(maxSize:10,nullable:false)
		billAsUser(maxSize:10,nullable:false)
		spcChgFlag(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'ctrlsi',schema:CH.config.varsity.schema)
//		cache usage:'read-only', include:'non-lazy'  Second-level cache is not enabled
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'SISHIN',type:'TrimString')
			activeStatus (column:'SIACCD', type:'TrimString')
			carrierCode (column:'SICRCD', type:'TrimString')
			servType (column:'SISVTP', type:'string')
			billAsCarrier (column:'SIBCRD', type:'TrimString')
			billAsServTyp (column:'SIBSVT', type:'TrimString')
			billAsCompany (column:'SIBCMN', type:'TrimString')
			billAsWarehouse (column:'SIBWHS', type:'TrimString')
			billAsUser (column:'SIBUSR', type:'TrimString')
			spcChgFlag (column:'SISPCF', type:'TrimString')
		}
	}
	boolean newEntity = false
	static transients = ['shipInstruct', 'newEntity']
	def getShipInstruct() {
		if (id) return id
		return 
	}
	void setShipInstruct (def vlu) { id = vlu }
	String toString() {"$id $carrierCode $servType"}
}
