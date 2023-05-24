<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String loginErrorMessage = null;
    if(request.getParameter("btn-registrar") != null){
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        int senha = (Integer) request.getParameter("senha").hashCode();
        String senhaHash = Integer.toString(senha);
        
        try{
               Usuario u = new Usuario();
               u.addUsuario(nome, email, "USER", senhaHash);
               
            
        } catch(Exception ex){
            loginErrorMessage = ex.getMessage();
        } finally {
            response.sendRedirect(request.getContextPath()+"/login.jsp");
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Registro</h2>
        <fieldset>
            <legend>Formulário de Registro</legend>
            <form method="post">
                <label for="nome">Nome</label>
                <input type="text" name="nome" id="nome"/><br/>
                <label for="email">Email</label>
                <input type="email" name="email" id="email"/><br/>
                <label for="senha">Senha</label>
                <input type="password" name="senha" id="senha"/><br/><br/>
                <input type="submit" name="btn-registrar" value="Entrar"/>
            </form>
        </fieldset>
    </body>
</html>