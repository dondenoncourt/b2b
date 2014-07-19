import grails.converters.JSON
import com.kettler.domain.orderentry.Terms

class DataTableController {

    def grailsUITagLibService // not used yet.

    def index = { }

    def dataTableDataAsJSON = {
        def list = []
        def termsList = Terms.list(params) 
        response.setHeader("Cache-Control", "no-store")
        termsList.each {
            list << [ id:it.id, desc:it.desc, dataUrl:g.createLink(action: 'pickTerm') + "/$it.id" ]
        }
        def data = [ totalRecords: Terms.count(), results: list ]
        render data as JSON
    }

    def pickTerm = {
        def term = Terms.get(params.id)
        render view:'/dataTableDemo', model:[term:term]
    }
}  
