<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main" />
  <title>Customer Locations</title>
</head>
<body>
<div class="body">
<h2>${dealer} Locations</h2>
<g:if test="${flash.message}">
  <div class="message">${flash.message}</div>
</g:if>
<table>
  <g:each in="${locs}" var="loc">
    <tr>
      <td>${loc}</td>
      <td>
        <g:form action="location" id="${loc.id}" method="post">
          <g:hiddenField name="division" value="${division}"/>
          <g:hiddenField name="custno" value="${custno}"/>
          <span class="buttons">
            <g:submitButton name="review" class="show" value="Review Inventory"/>
          </span>
        </g:form>
      </td>
    </tr>
  </g:each>
</table>
</div>
</body>
</html>