<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
Grails Runtime Exception occurred on web user: ${user?.firstname} ${user?.lastname} ${user?.email}  
Error Details:
Message: ${exception.message?.encodeAsHTML()} 
Caused by: ${exception.cause?.message?.encodeAsHTML()} 
Class: ${exception.className}   		  		
At Line: [${exception.lineNumber}]   		
Code Snippet: 		
<g:each var="cs" in="${exception.codeSnippet}"> 
	${cs}  			
</g:each>  	
Time:[${new Date()}]   		
Stack Trace
${exception.stackTraceText
