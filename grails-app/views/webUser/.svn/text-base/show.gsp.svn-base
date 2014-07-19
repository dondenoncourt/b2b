

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show WebUser</title>
    </head>
    <body>
        <div class="body">
            <h1>Show WebUser</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            <td valign="top" class="value">${fieldValue(bean:webUser, field:'id')}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Email:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:webUser, field:'email')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Comp Code:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:webUser, field:'compCode')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Cust No:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:webUser, field:'custNo')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Salesperson:</td>
                            <td valign="top" class="value">
                                <% try { %>
                                ${webUser.salesperson?.id}
                                <% } catch (e) { %>
                                <span style="color:red;">DELETED</span></td>
                                <% } %>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Firstname:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:webUser, field:'firstname')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Lastname:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:webUser, field:'lastname')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">400 Profile:</td>
                            <td valign="top" class="value">
                                <% try { %>
                                    ${webUser.user400?.id}
                                <% } catch (e) { %>
                                    Error: OEUCTL row not found
                                <% } %> 
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Role:</td>
                            
                            <td valign="top" class="value">${webUser.role.name}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${webUser?.id}" />
                    <g:actionSubmit class="edit" value="Edit" /> 
                    <g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" />
                    <g:actionSubmit class="save" action="list" value="Show List" /> 
                </g:form>
            </div>
        </div>
    </body>
</html>
