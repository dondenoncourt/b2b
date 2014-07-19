<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.PrintCode" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Order Header Information</title>
      <gui:resources components="['dataTable']"/>
      <g:javascript src="application" />
      <g:javascript library="prototype" />
  </head>
<body>
  <script>
	function onloadHandler() { // called in body of layout gsp
		<% if (inquiry) { %>
			disableFormFields('commentForm') ;
		<% } %>
	}
  </script>
    <div class="body">
    	<h1>Order Comment <%= inquiry?'Inquiry':'Maintenance' %></h1>
        <g:if test="${message}"><div class="errors">${message}</div></g:if>
        <g:form action="order" name="commentForm" method="post" >
          <input type="hidden" name="lineNo" value="${g.formatNumber(number:komment?.lineNo, format:'0000')}"/>
          <dl>
              <dt>Comment</dt>
              	<dd>
              		<g:if test="${(komment?.lineNo) >= 9900}">
	              		<g:textField name="komment" size="30" maxlength="30" value="${komment?.text}"/>
              		</g:if>
              		<g:else>
              			<g:textArea name="komment" cols="80" value="${komment?.text}"/>
              		</g:else>
              	</dd>
	           <g:each var="pc" in="${PrintCode.list()}">
	               <dt>${pc.desc}</dt>
	               <dd><g:checkBox name="printCode${pc.id}" value="${(komment?.printCodes?.find { it == pc.id} )}" /></dd>
	            </g:each>
	          </dl>
            <div class="buttons">
		      <g:if test="${!inquiry}">
	              <g:if test="${komment?.lineNo}">
	                <g:submitButton class="save" name="update" value="Update" title="Click to update this comment" />
	                <g:submitButton class="delete" name="delete" value="Delete" title="Click to delete this comment" />
	              </g:if>
	              <g:else>
	                <g:submitButton class="add" name="add" value="Add"  title="Click to add this comment"/>
	              </g:else>
	          </g:if>
              <g:submitButton class="table" name="back" value="Back"  title="Click to return to the list of line items"/>
            </div>
        </g:form>
     </div>
</body>
</html>
