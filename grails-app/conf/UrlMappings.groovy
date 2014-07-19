class UrlMappings {
    static mappings = {
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
     // "/"(view:"/index")
     "/"(controller:"login", action:"loginRedirect")
	 //"500"(view:'/error')
	"500"(controller:'error', action:'error')

	}
}
