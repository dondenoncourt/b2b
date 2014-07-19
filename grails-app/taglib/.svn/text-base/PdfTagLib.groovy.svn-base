import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib

/**
 * A simple taglib for producing links to the PDF creation for a page.
 *
 * @author Glen Smith
 */
class PdfTagLib {



    /**
     * Creates a PDF creation link for the supplied URL.
     *
     * eg. <g:pdf url="/test.gsp" filename="sample.pdf" icon="true"/>
     *
     */
    def pdf = { attrs, body ->

        def url = attrs.remove("url")         
        def icon = attrs.remove("icon")           

        out << "<a href='"
        out << new ApplicationTagLib().createLink(url: [controller: 'pdf', action:'show', pdf:'true',
                params: [url: url+'&pdf=true', pdf:'true', filename: attrs.filename ?: 'document.pdf'] ] )
        out << "' title='Click to display a PDF version of this page'"

        // process remaining attributes before closing anchor and appending image tag 
		attrs.each { k, v -> 
			out << " ${k}='${v.encodeAsHTML()}' " 
		}
        
        out << ">"


        if (icon) {
            out << "<img src='"
            out << createLinkTo(dir:'images/skin', file:'pdficon_small.gif')
            out << "' alt='PDF Version'/>"

        }

        out << body()

        out << "</a>"
           

    }

}
