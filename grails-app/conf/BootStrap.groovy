import com.kettler.domain.orderentry.share.SalesTax
import com.kettler.domain.orderentry.share.Carrier
import com.kettler.domain.orderentry.share.SalesPerson
import com.kettler.domain.orderentry.PackListCode
import com.kettler.domain.orderentry.FOBCode
import com.kettler.domain.orderentry.Terms
import com.kettler.domain.orderentry.StateCode
import com.kettler.domain.orderentry.PrintCode
import com.kettler.domain.orderentry.ReferenceCode
import com.kettler.domain.orderentry.share.SalesTax

import com.kettler.domain.actrcv.Distribution
import com.kettler.domain.actrcv.share.TableCode
import com.kettler.domain.item.share.NatlMotorFreightClass

import com.kettler.domain.varsity.Country

import grails.util.Environment
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH


class BootStrap {
    def sessionFactory

     def init = { servletContext ->
     	
     	switch (Environment.current) {
     	case Environment.TEST: 
            PopulateTestDomain.populate(sessionFactory)
            break
        case Environment.DEVELOPMENT:
         	
        	CH.config.grails.serverURL = 'http://localhost:8080' //'http://192.168.1.5:8080' // 'http://localhost:8080' //  'http://10.0.2.2:8080'  
            break
        case Environment.PRODUCTION:
         	// hack as setting in Config does not seem to work
         	CH.config.grails.serverURL =  'https://www.kettlerusa.com'  
        	// preload "lookup" cache-enabled tables
        	 Carrier.list().each {}
        	 Country.list().each {}
        	 Distribution.list().each {}
        	 FOBCode.list().each {}
        	 NatlMotorFreightClass.list().each {}
        	 PackListCode.list().each {}
        	 PrintCode.list().each {}
        	 ReferenceCode.list().each {}
        	 SalesTax.list().each {}
        	 SalesPerson.list().each {}
        	 StateCode.list().each {}
        	 TableCode.list().each {}
        	 Terms.list().each {}
             break
        }
      }
     def destroy = {
     }
} 
