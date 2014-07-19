<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ defaultCodec="html" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Login</title>
      <g:javascript library="prototype" />
  </head>
<body >
   <div  class="frontpage" >
        <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
        <g:form name="loginForm" action="requestLogin" method="post" >
          <dl>
            <dt>eMail:</dt><dd><g:textField name="email" size="30" value="${params?.email}"/></dd>
            <dt>Customer/Rep No:</dt><dd><g:textField name="custRepNo" size="7"  value="${params?.custRepNo}"/></dd>
            <dt>Store/Rep Name:</dt><dd><g:textField name="storeRepName" size="50"  value="${params?.storeRepName}"/></dd>
          </dl>
	      <div class="buttons" style="width:125px;position:relative;left:225px;">
              <g:submitButton class="create" name="requestLogin" value="Request Login" />
          </div>
        </g:form>
   </div>
</body>
</html>
