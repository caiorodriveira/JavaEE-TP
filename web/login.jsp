<%-- 
    Document   : login
    Created on : 29 de mai. de 2023, 22:06:28
    Author     : kakaz
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="WEB-INF/jspf/cdnCss.jspf" %>
        <title>Login</title>
    </head>
    <style>
        main.container-fluid{
            min-height: 100vh;
            width: 100vw;
        }
        div.login_container{
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }
    </style>
    <body>

        <main class="container-fluid m-0 p-0 d-flex flex-column">

            <div class="login_container shadow p-3">
                <div class="top_login">
                    <h3 class="text-center">Login</h3>
                    <hr class="m-0">
                </div>
                <div class="body_login">
                    <form action="login.jsp">
                        <div class="form-group">
                            <label for="login" class="form-label">Login:</label>
                            <input type="text" class="form-control" id="login" name="login"/>
                        </div>
                        <div class="form-group">
                            <label for="senha" class="form-label">Senha:</label>
                            <input type="password" class="form-control" id="senha" name="senha"/>
                        </div>
                        <div class="action d-flex justify-content-center mt-3">
                            <button type="submit" class="btn btn-primary">Login</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
    </body>
</html>
