import grails.util.Environment
import com.kettler.domain.item.share.Dealer
import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.item.share.DealerLocation
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import com.kettler.domain.item.share.ItemMasterExt
import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.orderentry.share.InvoicedOrderDetailItem
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.item.share.DealerInventory
import com.kettler.domain.item.share.ItemWarehouse

import org.jsecurity.SecurityUtils

class InventoryMaintenanceController {

    def beforeInterceptor = {
    	log.debug "action: $actionName params: $params flash: $flash $Environment.current"
    }

    // Dummy page just to get custno
    def index = {
        if (!params.division) {
            params.division = 'patio'
        }
        [division: params.division]
    }

    def stockStatus = {
        WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal());
        Date cutoffDate = new Date() - (365 * (Environment.current == Environment.DEVELOPMENT?2:1))
        def l = InvoicedOrderDetailItem.withCriteria {
            eq 'custNo', user.custNo
            ge 'invoiceDate', cutoffDate
            projections {distinct "itemNo"}
        }
        log.debug "distinct items for ${user.custNo} count: $l.size"
        l.sort{it}
        def stockStatus = [:]
        l.each {itemNo ->
            def itm = ItemMaster.findByItemNo(itemNo)
            if (itm) {
                def whs = ItemWarehouse.getItemWarehouse('01', itemNo, '1')
                stockStatus.putAt(itm, whs)
            }
        }
        [stockStatus:stockStatus, customer:Customer.findByCustNo(user.custNo)]
    }

    // Find dealer by custno, displays view showing locations
    def search = {
        def model = [division: params.division, custno: params.custno]
        if (!params.custno || params.custno?.trim().length()==0) {
            flash.message = "Account number is required"
            redirect(action: 'index')
        } else {
            Customer c = Customer.findByCustNo(params.custno.toUpperCase())
            if (c) {
                Dealer d = Dealer.findByCustomer(c)
                if (d) {
                    model.dealer = d
                    // This is a hack to make list be in same order each time
                    def locs = d.locations.sort{it.toString()}
                    model.locs = locs
                }
            } else {
                flash.message = "No dealer found for customer number: ${params.custno}"
                redirect(action: 'index')
            }
        }
        model
    }

    // User selected location, display "possible" inventory for location
    def location = {
       	session.maxInactiveInterval = (120 * 60) // set to 2 hours as some use screen for a long time
        def model = [division: params.division, custno: params.custno]
        model.location = DealerLocation.get(params.id)
        model.inventories = model.location.inventories
        model.purchasedItems = getInvoicedItems(params.custno, model.location, getInvoiceCustoff().getTime())
        model.months = CH.config.invoiceCutoffMonths * -1
        model
    }

    private List getInvoicedItems(String custno, DealerLocation loc, Date cutoffDate) {
        log.debug "Cutoff order invoice date: ${cutoffDate}"
        def l = InvoicedOrderDetailItem.withCriteria {
            eq 'custNo', custno
            ge 'invoiceDate', cutoffDate 
            projections {distinct "itemNo"}
        } 
        log.debug "order invoice detail count: $l.size"
        def purchasedItems = []
        l.each {itemNo ->
            def itm = ItemMasterExt.findByItemNo(itemNo)
            if (itm && !purchasedItems.contains(itm)) {
                purchasedItems.add(itm)
            }
        }
    	return purchasedItems.sort{it.desc}
    }
    private GregorianCalendar getInvoiceCustoff() {
        def cal = new GregorianCalendar()
        cal.add(Calendar.MONTH, CH.config.invoiceCutoffMonths)
        cal
    }
    // Dealer select what DealerInventory is still available, update it
    // then redirect back to search so they can pick another location.
    def invAvail = {
        def model = [custno: params.custno, division: params.division]
        def loc = DealerLocation.get(params.locId as long)
        if (!loc) {
        	log.error = 'An error occurred retrieving inventory locations. May have been a login redirect'
        	forward controller:'login', action:'loginRedirect'
        	return
        }
        DealerLocation.withTransaction{ status ->
	        loc.inventories.each { inv ->
		    	inv.available = false
		    	inv.save()
		    }
        }

        boolean updated = false
        def keys = params.keySet()
        keys.each { key ->
            if (key.startsWith('cbInvAvail_')) {
                def sId = key.substring(key.indexOf('_')+1)
                def item = ItemMasterExt.get(sId as long)
                def di = DealerInventory.findByDealerLocationAndItem(loc, item)
                if (!di) {
                    di = new DealerInventory(item:item)
                    loc.addToInventories(di)
                    loc.save(flush:true)
                } 
                di.available = true
                updated = true
                di.save(flush:true)
            }
        }
        if (updated) {
            DealerLocation dl = DealerLocation.get(params.locId)
            GregorianCalendar gc = new GregorianCalendar()
            gc.set(Calendar.HOUR_OF_DAY,0)
            gc.set(Calendar.MINUTE,0)
            gc.set(Calendar.SECOND,0)
            dl.availabilityUpdated = gc.getTime()
            dl.availabilityExpired = false
            dl.save(flush:true)
            flash.message = "Availability has been updated for ${dl}"
        }
        redirect(action:'search', params: model)
    }

    // Adds items selected to a DealerLocation.  Redirect back to location for Dealer
    // to select inventory available.
    def addInv = {
        def model = [id: params.locId, division: params.division, custno: params.custno ]
        def loc = DealerLocation.get(params.locId)
        def keys = params.keySet()
        keys.each { key ->
            if (key.startsWith('itemId_')) {
                def sId = key.substring(key.indexOf('_')+1)
                def itm = ItemMasterExt.get(sId as long)
                log.debug itm
                DealerInventory di = new DealerInventory(item:itm)
                loc.addToInventories(di)
                if (!di.save()) {
                	di.errors.each {log.error it}
                }
            }
        }
        loc.save(flush:true)
        flash.message = "Items added to inventory list, please click Update Inventory to flag available items"
        redirect(action:"location", params: model)
    }
}
