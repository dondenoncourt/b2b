import com.kettler.domain.orderentry.ContractPrice
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role

import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.ItemSalesHist
import com.kettler.domain.item.share.BillOfMaterials

import com.kettler.domain.orderentry.share.WebUser

import com.kettler.domain.purchasing.PurchaseOrderDetail
import com.kettler.domain.purchasing.PurchaseOrderHeader

import org.jsecurity.SecurityUtils

import com.kettler.domain.work.DateUtils

public class ItemMasterController{

    def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
    def afterInterceptor = {model ->
        log.debug("action: $actionName model: $model")
    }

	def item = {
		def item
		def bom
		def pod
		if (params.itemNo) {
			WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
	   		if (user.role.name == Role.KETTLER) {
	   			item = ItemMaster.findByItemNo(params.itemNo)
	   		} else { 
	   			item = ItemMaster.findWhere(compCode:user.compCode, itemNo:params.itemNo, activeCode:' ')
	   		} 
			if (item) {
				bom = BillOfMaterials.findAllByCompCodeAndItemNo(item.compCode, params.itemNo)
				// put POs in a map sorted by ETA
				TreeMap podMap = new TreeMap()
				PurchaseOrderDetail.findAllByCompCodeAndItemNo(item.compCode, item.itemNo).each {poDetail ->
					if (poDetail.header?.statusCode == 'S'){
						podMap[poDetail.header.etaDate] = poDetail
					}
				}
				pod = podMap?.firstEntry()?.value
			} else {
				flash.message = "Item $params.itemNo not found"
			}
		}
		[item:item, bom:bom, pod:pod]
	}
    
	def salesHist = {
       	int minYear =  ItemSalesHist.withCriteria(uniqueResult:true) {
		    projections {min("year")}
		     eq ('compCode', params.compCode)
		     eq ('itemNo', params.itemNoForHist)
		}    	
    	int maxYear = ItemSalesHist.withCriteria(uniqueResult:true) {
		    projections {max("year")}
		     eq ('compCode', params.compCode)
		     eq ('itemNo', params.itemNoForHist)
		}
   		int cent = 20
    	int year  
    	if (params.year) {
    		year = params.year[2..3].toInteger()
    	} else {
    		year = maxYear
    		params.year = maxYear + 2000
    	}
		log.debug "ItemSalesHist.findAllWhere(compCode:$params.compCode, itemNo:$params.itemNoForHist, century:$cent, year:$year)"
    	def hist = ItemSalesHist.findAllWhere(compCode:params.compCode, itemNo:params.itemNoForHist, century:cent, year:year)
    	[hist:hist, params:params, minYear:minYear+2000, maxYear:maxYear+2000]
    }
    
    def searchAJAX = {
       	WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
       	/* if the search is done by a customer 
       	 * and they have current ContractPrices 
       	 * return only those items	 */
       	boolean contractPricesFoundForCustomer = false
       	def items 
       	def kount = 0
   		if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN || 
   			user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN && session.cust) {
			def fromCust = 'from ContractPrice cp where cp.custNo = ?'
       		def dateCheck = ' AND ? BETWEEN mod((cp.beginDate * 10000.01), 1000000) AND mod((cp.expireDate * 10000.01), 1000000) '
			def query = fromCust + dateCheck
			def queryParams = []
			queryParams <<  session?.cust?.custNo?:user.custNo
			queryParams << DateUtils.getNowYMD()
			if (ContractPrice.executeQuery("select count(*) " + query, queryParams)[0]) {
				log.debug "item auto-complete, ContractPrices found for cust: ${(session?.cust?.custNo?:user.custNo)}"       		
				contractPricesFoundForCustomer = true
			}
			query +=  " AND itemNo like ? "
			queryParams << (params.query.trim().toUpperCase()+'%')
			items = ContractPrice.executeQuery(query, queryParams, [max:24]) 
			kount = ContractPrice.executeQuery("select count(*) " + query, queryParams)[0]
			log.debug "found $kount by $query"       		
       	}
       	
       	if (!contractPricesFoundForCustomer) {
	        items = ItemMaster.withCriteria {
	        	and {
	        		eq("compCode", 		user.compCode)
	                ilike("itemNo",		params.query.trim()+"%")
                    ne ('profitCenterClass', '6')
	                eq("activeCode",	' ')
	                or {
	        			ne("profitCenterClass",	' ')
	        			eq('shortName', 'KIT')
	        		}
	        	}
	            maxResults(24)
	            order('itemNo', 'asc')
	        }
	        def countArray = ItemMaster.withCriteria(unique:true) {
	            projections {rowCount()}
	        	and {
	        		eq("compCode", 		user.compCode)
	                ilike("itemNo",		params.query.trim()+"%")
                    ne ('profitCenterClass', '6')
	                eq("activeCode",	' ')
	                or {
	        			ne("profitCenterClass",	' ')
	        			eq('shortName', 'KIT')
	        		}
	        	}
	        }
	        kount = countArray[0]
       	}
	    render(contentType: "text/xml") {
	        results() {
	        	items.each {item ->
		            result() { 
		            	name(item.itemNo.trim())
		            }
	        	}
	        	if (items.size() < kount) {
		            result() { 
	                    name("$kount found, key more chars to refine search...")
		            }
	        	}
	        }
	    }

    }
    def getDesc = {
    	def item = ItemMaster.findByCompCodeAndItemNo(params.compCode, params.itemNo)
    	if (item) {
    		render item.desc
    	} else { 
    		render 'Invalid Item No'
    	}
    }
}
