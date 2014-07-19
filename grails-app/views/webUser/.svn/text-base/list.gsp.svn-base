<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
        <title>WebUser List</title>
    </head>
    <body>
        <div class="body">
            <h1>WebUser List</h1>
            <div class="message">${flash.message}</div>
        <h1>Search Criterion</h1>

        <g:form action="list" method="post" >
            <div class="col1">
                <dl>
                    <dt>Email:</dt>        <dd><input type="text" size="50" maxlength="50" name="email" value="${params.email}"/></dd>
                </dl>
            </div>
            <div class="col2">
                <dl>
                    <dt>Last name:</dt>    <dd><input type="text" size="40" maxlength="40" name="lastname" value="${params.lastname}" /></dd>
                </dl>
            </div>
            <div class="col1">
                <dl>
                    <dt>Cust No:</dt><dd><input type="text" size="10" maxlength="10" name="custNo" value="${params.custNo}"/></dd>
                </dl>
            </div>
                <jsec:hasRole name="${Role.SUPER_ADMIN}">       
                    <div class="col2">
                        <dl>
                            <dt>Sales Rep:</dt>  <dd><g:select name="salespersonCode" from="${SalesPerson.list([sort:'name'])}" optionKey="id" optionValue="name"  value="${params?.salespersonCode}" noSelection="${['':'Select One...']}"/></dd>                       
                        </dl> 
                    </div>
                </jsec:hasRole>
            <div class="buttons" >
                <g:submitButton class="search" name="search" value="Search" /> 
            </div>
        </g:form>      
        <br/>      
            <div class="list">
                <table>
                    <thead>
                        <tr>
                               <g:sortableColumn property="id" title="Id" />
                               <g:sortableColumn property="email" title="email" />
                               <g:sortableColumn property="user400" title="400 Profile" />
                               <g:sortableColumn property="firstname" title="Firstname" />
                               <g:sortableColumn property="lastname" title="Lastname" />
                               <g:sortableColumn property="compCode" title="Comp Code" />
                               <g:sortableColumn property="custNo" title="Cust No" />
                               <g:sortableColumn property="salesperson.id" title="Sales" />
                               <g:sortableColumn property="loginFail" title="Login Fails" />
                            <g:sortableColumn property="lastLogin" title="Last Login" />
                               <th>Role</th>
                               <th>Image Copy</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${webUserList}" status="i" var="webUser">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td>
                            <jsec:hasRole name="${Role.SUPER_ADMIN}">
                                <g:link action="show" id="${webUser.id}">${fieldValue(bean:webUser, field:'id')}</g:link>
                            </jsec:hasRole> 
                            <jsec:hasRole name="${Role.KETTLER}">
                                ${webUser.id}
                            </jsec:hasRole>
                            </td>
                            
                            <td>${fieldValue(bean:webUser, field:'email')}</td>
                            <td>
                                <% try { %>
                                    ${webUser.user400?.id}
                                <% } catch (e) { %>
                                    <span style="color:red;">OEUCTL row not found</span>
                                <% } %> 
                            </td>
                            <td>${fieldValue(bean:webUser, field:'firstname')}</td>
                            <td>${fieldValue(bean:webUser, field:'lastname')}</td>
                            <td>${fieldValue(bean:webUser, field:'compCode')}</td>
                            <td>${fieldValue(bean:webUser, field:'custNo')}</td>
                            <% try { %>
                                <td>${webUser.salesperson?.id}</td>
                            <% } catch (e) { %>
                                <span style="color:red;">DELETED</span></td>
                            <% } %> 
                            <td>${fieldValue(bean:webUser, field:'loginFail')}</td>
                            <td><g:formatDate date="${webUser.lastLogin}" format="MM/dd/yy HH:mm"/></td>
                            <td>${webUser.role.name}</td>
                            <td>
                                <g:checkBox name="imageDownload" value="${webUser.imageDownload}" 
                                    onclick="imageDownload(${webUser.id}, this)"
                                    title="Click to toggle image download" 
                                />
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${webUserTotal}" />
            </div>
        </div>
        <g:javascript>
            function imageDownload(id, yesNo) {
              $.ajax({
                 url: "${createLink(controller:'webUser', action:'imageDownload')}/"+id,
                 data: 'yesNo='+yesNo.checked,
                 type: 'POST',
                 success: function(data, textStatus) {
                    $('div.message').show();
                    $('div.message').html(data);
                 },
                 error: function(xhr,textStatus, errorThrown) { alert(textStatus) }
              });
            }
            <g:if test="${flash.message}">
                $('div.message').show();
            </g:if>
            <g:else>
                $('div.message').hide();
            </g:else>
        </g:javascript>
    </body>
</html>
