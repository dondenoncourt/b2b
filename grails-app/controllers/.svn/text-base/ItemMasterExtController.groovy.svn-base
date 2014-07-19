


import groovy.sql.Sql;
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import com.kettler.domain.item.share.ItemMasterExt
import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.ItemAccessory
import com.kettler.domain.item.share.WebDivision
import com.kettler.domain.item.share.WebCategory


class ItemMasterExtController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def sessionFactory
	
	def beforeInterceptor = {
		log.debug "action: $actionName params: $params flash: $flash "
	}
    def index = {
        redirect(action: "itemMasterList", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'itemNo'
		params.order = params.order?:'asc'
		def itemMasterExtInstanceList
		def itemMasterExtInstanceTotal
		if (params.itemDesc || params.itemNumber) {
        	def itemList = ItemMasterExt.withCriteria {
				'in'('inactive', ['S', 'R'])
                ne ('profitCenterClass', '6')
        		if (params.itemNumber) ilike('itemNo', "${params.itemNumber}%")
        		if (params.itemDesc) ilike('desc', "%${params.itemDesc}%")
	            maxResults(params.max)
	            firstResult(Integer.parseInt(params.offset))
                order(params.sort, params.order)
        	}
            def countArray = ItemMasterExt.withCriteria {
				'in'('inactive', ['S', 'R'])
                ne ('profitCenterClass', '6')
				if (params.itemNumber) ilike('itemNo', "${params.itemNumber}%")
        		if (params.itemDesc) like('desc', "%${params.itemDesc}%")
                projections {rowCount()}
            }	
			itemMasterExtInstanceList = itemList
			itemMasterExtInstanceTotal = countArray
		} else {
			itemMasterExtInstanceList = ItemMasterExt.findAllByInactiveInListAndProfitCenterClassNotEqual(['S', 'R'], '6',params)
			itemMasterExtInstanceTotal = ItemMasterExt.countByInactiveInListAndProfitCenterClassNotEqual(['S', 'R'], '6')
		}
        if (params.keywordMaint) {
        	render view:'keywordMaint', 
        		model:[itemMasterExtInstanceList:itemMasterExtInstanceList, itemMasterExtInstanceTotal:itemMasterExtInstanceTotal, params:params]
        } else {
        	[itemMasterExtInstanceList:itemMasterExtInstanceList, itemMasterExtInstanceTotal:itemMasterExtInstanceTotal, params:params]
        }
    }
    
    def keywordsChanged = {
    	def item = ItemMasterExt.get(params.id)
    	assert item
        item.category = WebCategory.get(item.category.id) // I don't know why I need this?
    	item.keywords = params.keywords
    	if (!item.save()) {
    		item.errors.each {log.error it}
    		render item.itemNo+' keywords change error -- note it must be under 256 characters long' 
    	} else {
    		render 'Item No: '+item.itemNo+' keywords changed'
    	}
    }
	def imageAltChanged = {
		def item = ItemMasterExt.get(params.id)
		assert item
		item.category = WebCategory.get(item.category.id) // I don't know why I need this?
		item.imageAlt = params.imageAlt
		if (!item.save()) {
			item.errors.each {log.error it}
			render item.itemNo+' imageAlt change error -- note it must be under 256 characters long'
		} else {
			render 'Item No: '+item.itemNo+' imageAlt changed'
		}
	}
	def imageTitleChanged = {
		def item = ItemMasterExt.get(params.id)
		assert item
		item.category = WebCategory.get(item.category.id) // I don't know why I need this?
		item.imageTitle = params.imageTitle
		if (!item.save()) {
			item.errors.each {log.error it}
			render item.itemNo+' imageTitle change error -- note it must be under 256 characters long'
		} else {
			render 'Item No: '+item.itemNo+' imageTitle changed'
		}
	}
	def metaDescChanged = {
		def item = ItemMasterExt.get(params.id)
		assert item
		item.category = WebCategory.get(item.category.id) // I don't know why I need this?
		item.metaDesc = params.metaDesc
		if (!item.save()) {
			item.errors.each {log.error it}
			render item.itemNo+' metaDesc change error -- note it must be under 256 characters long'
		} else {
			render 'Item No: '+item.itemNo+' metaDesc changed'
		}
	}

	def itemMasterList = {
		flash.message = ''
		params.max = Math.min(params.max ? params.int('max') : 20, 100)
		params.offset = params.offset?:'0'
		params.sort = params.sort?:'itemNo'
		params.order = params.order?:'asc'
		if (params.itemDesc || params.itemNumber || params.profCenter || params.prodGroup || params.artGroup) {
			def itemList = ItemMaster.withCriteria {
				if (params.itemNumber) ilike('itemNo', "${params.itemNumber}%")
				if (params.itemDesc) ilike('desc', "%${params.itemDesc}%")
				if (params.profCenter) ilike('profitCenterClass', "%${params.profCenter}%")
				if (params.prodGroup) ilike('productGroupClass', "%${params.prodGroup}%")
				if (params.artGroup) ilike('articleGroupClass', "%${params.artGroup}%")
                ne ('profitCenterClass', '6')
				maxResults(params.max)
				firstResult(Integer.parseInt(params.offset))
                order(params.sort, params.order)
			}
			def countArray = ItemMaster.withCriteria {
				if (params.itemNumber) ilike('itemNo', "${params.itemNumber}%")
				if (params.itemDesc) like('desc', "%${params.itemDesc}%")
				if (params.profCenter) ilike('profitCenterClass', "%${params.profCenter}%")
				if (params.prodGroup) ilike('productGroupClass', "%${params.prodGroup}%")
				if (params.artGroup) ilike('articleGroupClass', "%${params.artGroup}%")
                ne ('profitCenterClass', '6')
				projections {rowCount()}
			}
			[ itemMasterInstanceList: itemList, itemMasterInstanceTotal:countArray[0], params:params]
		} else {
			[itemMasterInstanceList: ItemMaster.list(params), itemMasterInstanceTotal: ItemMaster.count(), params:params]
		}
	}

	
    def create = {
        def itemMasterExtInstance = new ItemMasterExt()
        itemMasterExtInstance.properties = params
        return [itemMasterExtInstance: itemMasterExtInstance]
    }

	def add = {
		params.id = params.id.toInteger()
		WebDivision division = WebDivision.list([max:1])[0]
		WebCategory cat = WebCategory.findByDivision(division)
		assert division
		assert cat
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		def sqlString = "insert into " + CH.config.inventory.schema + ".itemmastex(" +
		            "id,          age_from, age_to, also_canada, assembly_required, category_id, collection, commercial,    division_id, kettler_store_only, only_canada, special_order, parts, retail, retail_price, set_up_weight, setup_height, setup_width, setup_length, ship_to_store, store_inventory, weight_limit, truck, you_tube, inactive, lead_time_from, lead_time_to, dealer_id, ignore_Buffer_Stock) values " + 
                    "($params.id,        0,    100,         'N',               'N',   ${cat.id},         '',        'N', ${division.id},                'N',         'N',           'N',   'Y',    'Y',         0.00,             0,            0,           0,            0,           'Y',             'Y',          200,   'N',       '',      'S',              0,            0,         0,                 'N')"
		sql.execute(sqlString)
		log.debug sqlString
		flash.message = "${message(code: 'default.created.message', args: [message(code: 'itemMasterExt.label', default: 'ItemMasterExt'), params.id])}"
        redirect(action: "edit", id: params.id)

	}


    def save = {
        def itemMasterExtInstance = new ItemMasterExt(params)
        if (itemMasterExtInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'itemMasterExt.label', default: 'ItemMasterExt'), itemMasterExtInstance.id])}"
            redirect(action: "show", id: itemMasterExtInstance.id)
        }
        else {
            render(view: "create", model: [itemMasterExtInstance: itemMasterExtInstance] )
        }
    }

    def show = {
        def item = ItemMasterExt.get(params.id)
        if (!item) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'itemMasterExt.label', default: 'ItemMasterExt'), params.id])}"
            redirect(action: "list")
        } else {
            [item: item, accessories:accessories]
        }
    }

    def edit = {
        def item = ItemMasterExt.get(params.id)
        if (!item) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'itemMasterExt.label', default: 'ItemMasterExt'), params.id])}"
            redirect(action: "list")
        } else {
			return [item: item, accessoryItems:ItemMasterExt.findAllByDivisionAndIdNotEqual(item.division, item.id, [sort:'articleGroupClass'])] 
        }
    }
	
    def update = {
    	List<Integer> accessories = params.list('accessories') 
        def item = ItemMasterExt.get(params.id)
        if (item) {
        	def toDelete = []
            item.accessories.each{toDelete << it}
        	toDelete.each {accessory ->
        		item.removeFromAccessories(accessory)
        		accessory.delete()
        	}
            item.properties = params
			if (params.collection && item.division.name != 'patio') {
				flash.message = 'Collection should not be set for non Patio divisions'
				redirect action:"edit", id: params.id
				return		
			}
            if (item.validate()) {
    	        accessories.each{accessoryId ->
    	        	if (accessoryId.toInteger() > 0) {
    	        		item.addToAccessories(new ItemAccessory(accessory:ItemMasterExt.get(accessoryId), item:item).save())
    	        	}
			    }
		if (!item.save()) {item.errors.each{log.debug it}}
                flash.message = "$item.itemNo has been updated"
                redirect(action: "list")
            } else {
            	render (view:'edit', model:
            		[item: item, accessoryItems:ItemMasterExt.findAllByDivisionAndIdNotEqual(item.division, item.id, [sort:'articleGroupClass'])])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'itemMasterExt.label', default: 'ItemMasterExt'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
    	def itemMasterExtInstance = ItemMasterExt.get(params.id)
        if (itemMasterExtInstance) {
    		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
    		def sqlString = "delete from " + CH.config.inventory.schema + ".dealer_inventory where item_id = $params.id "
    		sql.execute(sqlString)
    		sqlString = "delete from " + CH.config.inventory.schema + ".itemacsry where item_id = $params.id or accessory_id = $params.id "
    		sql.execute(sqlString)
    		sqlString = "delete from " + CH.config.orderentry.schema + ".cartitem where item_id = $params.id "
    		sql.execute(sqlString)
    		sqlString = "delete from " + CH.config.inventory.schema + ".itemmastex where id = $params.id "
    		sql.execute(sqlString)
            flash.message = "${itemMasterExtInstance.itemNo} deleted from Item Master Extension "
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'itemMasterExt.label', default: 'ItemMasterExt'), params.id])}"
        }
        redirect(action: "list")
    }
	
	def catsByDiv = {
		def divId = params.divisionId
		WebDivision div = WebDivision.get(divId.toInteger())
		assert div
		String select = "<select name='category.id' id='category.id' >" 
		select += "<option value=''>Please Select...</option>"
		div.categories.each {cat ->
			select += "<option value='${cat.id}' >${cat.name}</option>"
		}
		log.debug select
		render select
    }
	
}
