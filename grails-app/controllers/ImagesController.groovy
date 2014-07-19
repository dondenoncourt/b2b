import java.util.List;

import org.codehaus.groovy.grails.commons.ApplicationHolder;
import grails.util.Environment
import org.jsecurity.SecurityUtils

import com.kettler.domain.item.share.Dealer
import com.kettler.domain.item.share.WebDivision
import com.kettler.domain.item.share.WebCategory
import com.kettler.domain.item.share.ItemMasterExt

import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role

import com.kettler.domain.actrcv.share.Customer

public class ImagesController {
	def shopController 
	
	def beforeInterceptor = {
		log.debug "action: $actionName params: $params flash: $flash "
	}

	def list = {
		[divisions:WebDivision.list()]	
	}
	def expand = {
		def id = params.divCatOrItem.replaceAll(/[-_ A-Za-z]/, '')
       	switch (params.divCatOrItem) {
    	case ~/^division_\d*/:
    		assert false, 'should not get here'
    		break
    	case ~/^category_\d*/:
    		def category = WebCategory.get(id as int)
    		render template:'items', model:[items:ItemMasterExt.category(category.division.name, category.name, null, null, null).list()]
	    	return
    		break
    	case ~/^item_\d*/:
    		assert false, 'should not get here'
    		break
       	}
	}
	def showImages = {
		def item = ItemMasterExt.get(params.id as int)
   		render template:'images', model:[item:item, otherImages:getOtherImages(item)]
	}
	def downloadImage = {
			params.qualifiedImage = params.qualifiedImage.replaceAll(/\.([A-Z]).jpg/, /.$1_FULL.jpg/)
	   		String rootPath = getRootPath()
	   		File imageFile = new File(rootPath+"/retail/images/${params.qualifiedImage}") //.replaceAll(/ /, "\\ "))    		
			log.debug(" new File( ${rootPath}/images/${params.qualifiedImage})")	
	   		if (Environment.current == Environment.DEVELOPMENT) {
	   			imageFile = new File(rootPath+"retail/web-app/images/${params.qualifiedImage}") //.replaceAll(/ /, "\\ "))
	   		}
			response.setContentType("image/jpg")
			response.setHeader("Content-disposition", "attachment;filename=${imageFile.getName()}")
			response.outputStream << imageFile.newInputStream() // Performing a binary stream copy	

	}
   	private List getOtherImages(ItemMasterExt item) {
   		def divScrunched = item.division.name.replaceAll(/^\/\w*/,'')
   		String rootPath = getRootPath()
   		File imageFiles = new File(rootPath+"/retail/images/${divScrunched}/${item.category.name}")  
   		if (Environment.current == Environment.DEVELOPMENT) {
   			imageFiles = new File(rootPath+"retail/web-app/images/${divScrunched}/${item.category.name}") 
   		}
    	def otherImages = []
    	imageFiles.eachFile {file ->
			if (file.name ==~ /${item.itemNo}\.[A-Z]?\..*/) {
				if (otherImages.size() < 4) {
					otherImages << file.name
				}
			}
	   	}
		return otherImages
   	}
	private String getRootPath() {
   		String rootPath = ApplicationHolder.application.parentContext.getResource("images").file.getAbsolutePath()
   		rootPath = rootPath.replaceAll(/\w*\/web-app\/images/, '')
   		rootPath = rootPath.replaceAll(/\\kettler\\images/, '')
	}
}
