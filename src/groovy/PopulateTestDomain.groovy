import groovy.sql.Sql
import org.codehaus.groovy.grails.commons.ConfigurationHolder

import com.kettler.domain.orderentry.share.Carrier
import com.kettler.domain.orderentry.share.Control
import com.kettler.domain.orderentry.share.ShipTo
import com.kettler.domain.orderentry.share.UserControl
import com.kettler.domain.orderentry.share.SalesTax
import com.kettler.domain.orderentry.share.SalesPerson
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role
import com.kettler.domain.orderentry.CustDiscAllow

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemWarehouse
import com.kettler.domain.item.share.BillOfMaterials as BOM
import com.kettler.domain.item.share.NatlMotorFreightClass as NMFC

import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.actrcv.share.TableCode

/**
 * Note: BootStrap runs every test iteration
 * and I had issues with ItemWarehouse multiplying
 * so I did the ItemWarehouse.list()*.delete()
 * but when I put the same for the other domains, I had problems.
 * My guess is that the domains with composite-non-uid keys
 * work OK.
 *
 * Note: Marc Palmer submitted the BootStrap execution per test method as a bug
 *
 */
class PopulateTestDomain {
    static SDF = new java.text.SimpleDateFormat("yyyy-MM-dd")

    static void populate(def sessionFactory) {
        //Control.list()*.delete()
    	Control ctrl = new Control(id:'01', nextOrderNo:1, arInstalled:'', includeMisc:'', crChkARDays:0, crChkOrdValue:0, shipAvailQty:'', qtyUnitMeasDefault:'', printBulkPick:'', nextInvoiceNo:0, nextQuoteNo:0, nextBolNo:0)
        ctrl.id = '01' // seems to be required
        assert ctrl.save(insert:true)
        
        //Customer.list()*.delete()
        def cust = new Customer(compCode:'01', custNo:'AM0302W', salespersonCode:'DGD', hireDate:new Date(), lineDiscCode:false, termsCode:'F10', addr1:'1st St', countryCode:'USA', name:'Amazon',salesDivision:'1', salesGroup: 'AB', shortName:'Amazon', city:'X', state:'XY', zipCode:'12345', taxCode1:'GS1', taxCode2:'VA')
        def ok = cust.save(insert:true)
        if (!ok) {
            cust.errors.allErrors.each { println it.inspect() }
            assert ok
        }
    	cust = new Customer(compCode:'01', custNo:'test', salespersonCode:'DGD', hireDate:new Date(), lineDiscCode:true, termsCode:'F10', addr1:'1st St', countryCode:'USA', name:'test',salesDivision:'1', salesGroup: 'AB', shortName:'test', city:'X', state:'XY', zipCode:'12345', taxCode1:'GS1', taxCode2:'VA')
        ok = cust.save(insert:true)
        if (!ok) {
            cust.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        
        ShipTo.list()*.delete(flush:true)
        def shipTo =  new ShipTo(compCode:'01', custNo:'AM0302W', shipToNo:1111, shipNo:'00',
            name:'D', residentialCommercial:'C', countryCode:'USA', countryName:'USA',
                addr1:'1 First St', city:'Richmond', state:'VA', zipCode:'23238')
        ok = shipTo.save()  
        if (!ok) {
            shipTo.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        new ShipTo(compCode:'01', custNo:'AM0302W', shipToNo:9999, orderNo:'12345', shipNo:'00',
                name:'D', residentialCommercial:'C', countryCode:'USA', countryName:'USA',
                   addr1:'1 First St', city:'Richmond', state:'VA', zipCode:'23238').save()


        ItemMaster.list()*.delete()
        def item = new ItemMaster(compCode:'01', itemNo:'Beer Box', nmfcNo:'15520-9')
        ok = item.save()
        if (!ok) {
            item.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        assert new ItemMaster(compCode:'01', itemNo:'one',        shortName:'one',          nmfcNo:'15520-9', basePrice:199.32g, taxableCode:true, desc:'one desc', arDistrictCode:'FIT', stdUnitMeas:'EA',  lowestUnitMeas:'EA').save()
        assert new ItemMaster(compCode:'01', itemNo:'two',        shortName:'two',          nmfcNo:'15520-9', basePrice:214.01g, taxableCode:false, desc:'two desc', arDistrictCode:'TOY', stdUnitMeas:'PCK', lowestUnitMeas:'EA', convFactor:50).save() 
        assert new ItemMaster(compCode:'01', itemNo:'chair-desk', shortName:ItemMaster.KIT, nmfcNo:'15520-9').save()
        assert new ItemMaster(compCode:'01', itemNo:'chair',      shortName:'chair',        nmfcNo:'15520-9').save()
        assert new ItemMaster(compCode:'01', itemNo:'desk',       shortName:'desk',         nmfcNo:'15520-9').save()

        ItemWarehouse.list()*.delete()
        def whs = new ItemWarehouse(compCode:'01', itemNo:'one', warehouse:'1', qtyOnOrder: 12, qtyOnHand:24, qtyAlloc:6, qtyOnBackOrder:2, qtyFutureShip:3, qtyOnCredHold:1)
        ok = whs.save()
        if (!ok) {
            whs.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        assert new ItemWarehouse(compCode:'01', itemNo:'two',   warehouse:'1', qtyOnOrder: 12, qtyOnHand:24, qtyAlloc:6, qtyOnBackOrder:2, qtyFutureShip:3, qtyOnCredHold:1).save()
        assert new ItemWarehouse(compCode:'01', itemNo:'chair', warehouse:'1', qtyOnOrder: 12, qtyOnHand:24, qtyAlloc:6, qtyOnBackOrder:2, qtyFutureShip:3, qtyOnCredHold:1).save()
        assert new ItemWarehouse(compCode:'01', itemNo:'desk',  warehouse:'1', qtyOnOrder: 12, qtyOnHand:24, qtyAlloc:6, qtyOnBackOrder:2, qtyFutureShip:3, qtyOnCredHold:1).save()


        //BOM.list()*.delete()
        def bom = new BOM(compCode:'01', itemNo:'chair-desk', seqNo:1, partItemNo:'chair', partQty:2, partUnitMeas:'EA')
        ok = bom.save()
        if (!ok) {
            bom.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        assert new BOM(compCode:'01', itemNo:'chair-desk', seqNo:2, partItemNo:'desk', partQty:2, partUnitMeas:'EA').save()

        def nmfc = new NMFC(id:'15520-9', desc:'SPORTING GOODS', classCode:'70')
        nmfc.id = '15520-9'
        ok = nmfc.save()
        if (!ok) {
            nmfc.errors.allErrors.each { println it.inspect() }
            assert ok
        }
        
    	UserControl user = new UserControl(id:'DOND', username:'Test User', priceOverride:true)
        user.id = 'DOND' // seems to be required
        assert user.save(insert:true)

        if (WebUser.list().size() == 0) {
	        def webUser = new WebUser(email:'customer@kettlerusa.com', password:'customer',compCode:'01', custNo:'AM0302W', firstname:'Don', lastname:'Denoncourt', 'salesperson.id':'T01')
	    	webUser.role = new Role(role:2) // Customer role
	    	ok = webUser.save()
	        if (!ok) {
	        	webUser.errors.allErrors.each { println it.inspect() }
	            assert ok
	        }
        }

    	Date now = new Date()
    	Date earlier = now - (365*2)
    	Date later = now + (365*2)
    	assert new CustDiscAllow(compCode:'01', custNo:'AM0302W', profitCenter:'1', code:'COOP', ediCode:'A260', percent:2.50g,beginDate:earlier,endDate:later).save()
    	assert new CustDiscAllow(compCode:'01', custNo:'AM0302W', profitCenter:'1', code:'LOGI', ediCode:'A260', percent:1.50g,beginDate:earlier,endDate:later).save()
    	assert new CustDiscAllow(compCode:'01', custNo:'AM0302W', profitCenter:'1', code:'RETN', ediCode:'A260', percent:4.00g,beginDate:earlier,endDate:later).save()
    	assert new CustDiscAllow(compCode:'01', custNo:'test', profitCenter:'1', code:'COOP', ediCode:'A260', percent:2.50g).save(flush:true)
    	assert new CustDiscAllow(compCode:'01', custNo:'test', profitCenter:'1', code:'LOGI', ediCode:'A260', percent:1.50g).save(flush:true)
    	assert new CustDiscAllow(compCode:'01', custNo:'test', profitCenter:'1', code:'RETN', ediCode:'A260', percent:4.00g).save(flush:true)
    	
    	def daList =  CustDiscAllow.findAll(" from CustDiscAllow as da where  da.compCode = :compCode and da.custNo = :custNo", // and  da.beginDate = da.endDate",
    										[compCode:'01', custNo:'test'])
    	assert 3 == daList.size()
    	
        /* the following Domains are set to cache and GORM inserts cause:  
         * java.lang.UnsupportedOperationException: Can't write to a readonly object
        */
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
        sql.execute("delete from oesper") 
        sql.execute("insert into oesper (spcode, spcomp, spema, sphdat, sphflg, spname, spvend) values (?, ?, ?, ?, ?, ?, ?)", 
        		['DGD', '01', 'don@denoncourt.com', '90909', '', 'Don Denoncourt', 'VEND'])
        sql.execute("delete from oestax") 
        [['GS1', 'GS1', 'GST TAX ON FRT', 13.00g ],
 		 ['GST', 'GST', 'GST TAX - CN #894791854RT10001', 5.00g ],
		 ['VA',  'VA',  'VIRGINIA STATE SALES TAX', 5.00g ],
		 ['WI',  'WI',  'WISCONSIN STATE SALES TAX', 5.00g ]].each {row ->
		 	sql.execute("insert into oestax (txcode, txarcd, txdesc, txpcnt) values (?, ?, ?, ?)", row)
    	}

        sql.execute("delete from oedcal") // DiscountAllowanceCode
		[['COOP', 'Y', 'COOP ADVERTISING', 'D', 'Y'],	
	  	 ['INVD', 'Y', 'INVOICE DISCOUNT', 'D', 'Y'],	
		 ['LOGI', 'Y', 'LOGISTICS DISCOUNT', 'D', 'Y'],	
		 ['RETN', 'Y', 'RETURN ALLOWANCES', 'R', 'Y']].each {row ->
        	sql.execute("insert into oedcal (DACODE, DACOMM, DADESC,	DAACCT,	DATXBL) values (?, ?, ?, ?, ?)", row)
    	}
        sql.execute("delete from artabl") 
        [
         ['01', 'S',   'UPS',6041500, 1201000,'FREIGHT OUT UPS/FDX', '+',    'N',    ''],
         ['01', 'S',   'AMX',7008500, 1201000,'AMERICAN EXPRESS FEE', '+',    'N',    ''],
         ['01', 'S',   'DTY',4510000, 1201000,'DISCOUNTS -TOYS', '+',    'N',    ''],
         ['01', 'S',   'FRT',6040500, 1201000,'FREIGHT OUT TRADE', '+',    'N',    '']
        ].each {row ->
        	sql.execute("insert into artabl (RCOMP, RTYPE, RCODE, RCACCT, RDACCT, RDESC, RNSIGN, RSLSCD, RSLSDV) values(?, ?, ?, ?, ?, ?, ?, ?, ?)", row) 
        }

        sql.execute("delete from ardtbl") 
        def rows = [['01', 'BKE', 'DBK', 'BKR'], ['01', 'BKS', 'DBS', 'BSR'], ['01', 'CON', 'DCN', 'CNR'], ['01', 'CSR', 'DCS', 'CSR'], ['01', 'DFR', 'DFR', 'FRN'], ['01', 'DST', 'DST', 'SRN'], ['01', 'DTY', 'DTY', 'TRN'], ['01', 'FIT', 'FIT', 'FTR'], ['01', 'FRN', 'DFR', 'FRN'], ['01', 'FUR', 'DFR', 'FRN'], ['01', 'HER', 'DHR', 'HRN'], ['01', 'HRN', 'DHR', 'HRN'], ['01', 'JLA', 'DJL', 'SRN'], ['01', 'JUV', 'DJU', 'JRN'], ['01', 'LAM', 'DLA', 'ERN'], ['01', 'LAN', 'DLN', 'LRN'], ['01', 'MWH', 'DMW', 'MRN'], ['01', 'OPE', 'DOP', 'ORN'], ['01', 'SPT', 'DST', 'SRN'], ['01', 'TMM', 'DTM', 'TMR'], ['01', 'TOY', 'DTY', 'TRN'], ['01', 'TPM', 'DTP', 'TPM'], ['02', 'BKE', 'DBK', 'BKE'], ['02', 'BKS', 'DBS', 'BKS'], ['02', 'FIT', 'DFT', 'FTR'], ['02', 'JUV', 'DJU', 'JRN'], ['02', 'OPE', 'DOP', 'ORN'], ['02', 'SPT', 'DST', 'SRN'], ['02', 'TOY', 'DTY', 'TRN']]                       	
        rows.each { row -> sql.execute("insert into ardtbl (RCOMP, RSCDE, RDCDE, RRCDE) values (?, ?, ?, ?)", row) }
        	
        sql.execute("delete from oeprtc") 
        rows = [['A', 'Print on all Documents'], ['F', 'Proforma Invoice'], ['I', 'Invoice'], ['L', 'Bill of Lading'], ['N', 'Do not print on Documents     	'], ['P', 'Pick Ticket'], ['S', 'Packing Slip']] 
        rows.each { row -> sql.execute("insert into oeprtc (PCCODE, PCDESC) values (?, ?)", row) }

        sql.execute("delete from ctrlsi")  
		[
			['C-TRAILER','', '01','A','','','','','',''],
			['R-ABFF','ABFF','01','A','','','','','',''],
			['C-BAX-1D','BAX','1D','A','','','','','',''],
			['R-BAX-1D','BAX','1D','A','','','','','',''],
			['R-BAX-2D','BAX','2D','A','','','','','',''],
			['C-BAX-2D','BAX','2D','A','','','','','',''],
			['R-BAX-BS','BAX','BS','A','','','','','',''],
			['C-BAX-BS','BAX','BS','A','','','','','',''],
			['R-BAX-ECON','BAX','DF','A','','','','','',''],
			['C-CNWY','CNWY','01','A','','','','','',''],
			['R-CNWY-DEFERRED','CNWY','01','A','','','','','',''],
			['R-CNWY','CNWY','01','A','','','','','',''],
			['C-CNWY-DEFERRED','CNWY','01','A','','','','','',''],
			['R-EGLB-WG','EGLB','01','A','','','','','',''],
			['R-EGLB-TD','EGLB','01','A','','','','','',''],
			['R-EGLB-RC','EGLB','01','A','','','','','',''],
			['R-EGLB-ID','EGLB','01','A','','','','','',''],
			['C-EGLB','EGLB','01','A','','','','','',''],
			['R-EGLB-WGA','EGLB','01','A','','','','','',''],
			['R-EGLB','EGLB','01','A','','','','','',''],
			['R-FX-PRTY OVRNT','FEDEX','11','A','','','','','',''],
			['C-FX-PRTY OVRNT','FEDEX','11','A','','','','','',''],
			['C-FX-XP SAVER','FEDEX','20','A','','','','','',''],
			['R-FX-XP SAVER','FEDEX','20','A','','','','','',''],
			['R-FEDEX-2D','FEDEX','30','A','','','','','',''],
			['R-FX-ECON 2 DAY','FEDEX','30','A','','','','','',''],
			['C-FX-ECON 2 DAY','FEDEX','30','A','','','','','',''],
			['C-FX-STD OVRNT','FEDEX','51','A','','','','','',''],
			['R-FX-STD OVRNT','FEDEX','51','A','','','','','',''],
			['R-FEDEX-1D','FEDEX','51','A','','','','','',''],
			['R-FX-1ST OVRNT','FEDEX','61','A','','','','','',''],
			['C-FX-1ST OVRNT','FEDEX','61','A','','','','','',''],
			['C-FEDEX GROUND','FEDEX','GD','A','','','','','',''],
			['R-FEDEX-HOME DL','FEDEX','HD','A','','','','','',''],
			['R-FEDEX-XP','FEDEX','XP','A','','','','','',''],
			['R-PITD','PITD','01','A','','','','','',''],
			['C-PITD','PITD','01','A','','','','','',''],
			['C-RDWY','RDWY','01','A','','','','','',''],
			['R-RDWY','RDWY','01','A','','','','','',''],
			['R-SEFL','SEFL','01','A','','','','','',''],
			['C-SEFL','SEFL','01','A','','','','','',''],
			['C-UPS GND COMMR','UPS','01','A','','','','','',''],
			['R-EXT-MENLO','UPS','01','A','','','','','',''],
			['R-EXT_MENLO','UPS','01','A','','','','','',''],
			['R-THIRD PARTY','UPS','01','A','','','','','',''],
			['C-THIRD PARTY','UPS','01','A','','','','','',''],
			['C-EXT_MENLO','UPS','01','A','','','','','',''],
			['C-UPS 2 DY AIR','UPS','02','A','','','','','',''],
			['C-UPS NXT DY AI','UPS','03','A','','','','','',''],
			['C-UPS NXT DY LT','UPS','04','A','','','','','',''],
			['C-UPS HNDRDWT','UPS','07','A','','','','','',''],
			['R-UPS HNDRDWT','UPS','07','A','','','','','',''],
			['C-UPS 3 DY SLCT','UPS','09','A','','','','','',''],
			['R-UPS GND RESID','UPS','11','A','','','','','',''],
			['C-UPS ND AIR AM','UPS','12','A','','','','','',''],
			['C-UPS ND AIR SV','UPS','13','A','','','','','',''],
			['C-UPS 2 DY A LT','UPS','14','A','','','','','',''],
			['R-UPS 3 DAY RES','UPS','19','A','','','','','',''],
			['R-UPS 2DY AIR R','UPS','52','A','','','','','',''],
			['R-UPS ND AR RES','UPS','53','A','','','','','',''],
			['R-UPS ND A LRES','UPS','54','A','','','','','',''],
			['R-UPS ND AIR SV','UPS','55','A','','','','','',''],
			['R-USPS-PRIORTY','USPS','01','A','','','','','',''],
			['R-WWAT','WWAT','01','A','','','','','',''],
			['C-WWAT','WWAT','01','A','','','','','',''],
			['C-YFSY','YFSY','01','A','','','','','',''],
			['R-YFSY','YFSY','01','A','','','','','',''],
		 ].each {row ->
        	sql.execute("insert into ctrlsi (sishin, sicrcd, sisvtp, siaccd,sibcrd,sibcmn,sibsvt,sibusr,sibwhs,sispcf) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", row)
    	}
        sql.execute "delete from rtrnstat"
        [
	        ['RAREQ',  1, 'RA requested by customer or rep via website'],
	        ['NEWRA',  2, 'RA created by sales'],
	        ['NORA',   3, 'warehouse user enters new return without RA, sales review needed'],
	        ['CMQUE',  4, 'CM not approved, questions need to be answered by sales assistant'],
	        ['CMDIF',  5, 'return that has a discrepancy(ies) from original authorization, sales review needed'],
	        ['CMPEN',  6, 'CM pending approval by management'],
	        ['CMAPP',  7, 'Controller approves CM'],
	        ['DENYD',  8, 'Controller does not approve CM'],
	        ['CMFIN',  9, 'Assistant accounts receivable manager reviews and posts CM'],
	        ['RAREJ', 99, 'return is rejected']
        ].each {row ->
        	sql.execute("insert into rtrnstat (code, collcklvl, descr) values(?, ?, ?)", row)
        }

         // Appendix B Reason codes for returns:
        sql.execute "delete from rtrnreas" 
        sql.execute "delete from oersnc"
        [
         ['CR', 'CUSTOMER RETURN'], ['DM', 'DEFECTIVE MERCHANDISE'], ['FD', 'FREIGHT DAMAGED MDSE'], ['PA', 'PRICE ADJUSTMENT'], ['OT', 'OTHER-ONLY FOR SMALL AMOUNTS'], ['CO', 'COOP ADVERTISING'], ['SA', 'SALES ALLOWANCES'], ['BC', 'BILLING CORRECTION'], ['BD', 'BAD DEBT WRITE OFFS'], ['DO', 'DUPLICATE ORDER'], ['UD', 'UNABLE TO DELIVER MDSE'], ['SM', 'SAMPLE MDSE'], ['AD', 'ADDITIONAL DISCOUNT'], ['SH', 'MDSE SHORTAGE'], ['TS', 'THE SPORTS AUTH RTN'], ['IP', 'INCORRECT PRODUCT SHIPPED'], ['FL', 'FREIGHT LOST MDSE'], ['DW', 'DEFECTIVE WARRANTY RETURN'], ['UT', 'UNIT TRANSFER TO DIFF DLR'], ['MR', 'MDSE REPLACEMENT'], ['RE', 'SALES REP ERROR'], ['IN', 'INSUFFICNT PACKAGING'], ['FR', 'FREIGHT REIMBURSEMENT'], ['OE', 'ORDER ENTRY ERROR'], ['SE', 'SHIPPING ERROR'], ['DF', 'FLD DESTROY/DONATE'], ['EM', 'EXTRA MDSE SHIPPED'], ['NC', 'REPL. NO CHRG'], ['IC', 'INVENTORY CORRECTION'], ['EC', 'EMPLOYEE COUPON'], ['PR', 'PROMO (SPECIAL)'],
         ['RT', 'RETAILER ERROR'], ['IE', 'INSIDE SALES ERROR'], ['PD', 'PAST DUE ACCOUNT']
        ].each {row ->
     		sql.execute("insert into oersnc (rccode, rcdesc) values(?, ?)", row)
        }         
        [
	        [1, 0, 'DEFECTIVE MERCHANDISE', 'DM'],
	        [2, 0, 'INSUFFICIENT PACKAGING', 'IN'],
	        [3, 0, 'FREIGHT DAMAGE', 'FD'],
	        [4, 0, 'FREIGHT LOST BY CARRIER', 'FL'],
	        [5, 0, 'CUSTOMER RETURN', 'CR'],
	        [6, 0, 'ORDER ENTRY ERROR', 'OE'],
	        [7, 0, 'SHIPPING ERROR', 'SE'],
	        [8, 0, 'RETAILER ERROR', 'RT'],
	        [9, 0, 'INSIDE SALES ERROR', 'IE'],
	        [10, 0, 'SALES REP ERROR', 'RE'],
	        [11, 0, 'PAST DUE ACCOUNT', 'PD']
        ].each {row ->
        	sql.execute("insert into rtrnreas (id, version, code, crs_reason_id) values(?, ?, ?, ?)", row)
        }

         
         // Appendix C Conditions codes for returned goods: 
        sql.execute "delete from rtrncond"
        [
	        [1, 0, 'NEW'],
	        [2, 0, 'PACKAGING DAMAGED'],
	        [3, 0, 'DEFECTIVE'],
	        [4, 0, 'REPAIRABLE DAMAGE'],
	        [5, 0, 'SUBSTANTIAL DAMAGE']
        ].each {row ->
        	sql.execute("insert into rtrncond (id, version, code) values(?, ?, ?)", row)
        }



         // Appendix D Reason codes for disposition of goods:
        sql.execute "delete from rtrndisp"
        [
	        [1, 0, 'RETURN TO STOCK'],
	        [2, 0, 'SCRAPPED FOR PARTS'],
	        [3, 0, 'RETURN TO MANUFACTURER'],
	        [4, 0, 'SCRAPPED'],
	        [5, 0, 'HELD FOR SALE AS SD'],
	        [6, 0, 'FIELD DESTROY']
        ].each {row ->
        	sql.execute("insert into rtrndisp (id, version, code) values(?, ?, ?)", row)
        }


         // Appendix E Reason codes for freight claim denials:
        sql.execute "delete from rtrnnix"
        [
	        [0, 'CUSTOMER DID NOT INSPECT'],
	        [0, 'INSUFFICIENT PACKAGING'],
	        [0, 'FILED TOO LATE']
        ].each {row ->
        	sql.execute("insert into rtrnnix (version, code) values(?, ?)", row)
        }

        sql.execute "delete from rtrnfgtdsc"
        [
         [1, 0,'Shipping and Handling'],
         [2, 0,'Drop Ship Charge'],
         [3, 0,'Inbound Handling Charge']
        ].each {row ->
    		sql.execute("insert into rtrnfgtdsc (id, version, descr) values(?, ?, ?)", row)
        }
        
        new Carrier(id:'SIFF', scacCode:'SIFF', 
	        desc:'DB SCHENKER GROUND SERVICE',
	    	shortDesc:'SCHENKER GRND',
	    	commercialShipNotes:'',
	    	residentialShipNotes:'',
	    	phoneNoRequired:'Y',
	    	carrierAssignedMShipperAssignedUCode:' ',
	    	transMethodCode:'M')
        .save(insert:true, failOnError:true)
    }
	
}

