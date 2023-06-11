<%-- 
    Document   : avisos
    Created on : 7 de jun. de 2023, 15:06:42
    Author     : kakaz
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="WEB-INF/jspf/cdnCss.jspf" %>
        <title>Informações</title>
    </head>
    <body>
        <style>
            #infos {
                margin-top: 100px;
            }
        </style>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <div class="container-fluid m-0 p-0 d-flex flex-column" v-if="session">
                
                <div class="card_form shadow align-self-center p-3 w-50" id="infos">
                    <h1 style="text-align:center">Informações do Usuário</h1> <hr>
                <div class="form-group">
                            <label for="nome" class="form-label">Nome</label>
                            <input type="text" class="form-control mb-4" id="nome" disabled v-bind:value="session.nome"/>
                        </div>
                <div class="form-group">
                            <label for="nome" class="form-label">Email</label>
                            <input type="text" class="form-control mb-4" id="nome" disabled v-bind:value="session.email"/>
                        </div>
                <div class="form-group">
                            <label for="nome" class="form-label">Role</label>
                            <input type="text" class="form-control mb-4" id="nome" disabled v-bind:value="session.role"/>
                        </div>
                </div>
              
                        
            </div>
        </main>
        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
        <script>
            const infos = Vue.createApp({
                data() {
                    return{
                        error: null,
                        session: null,
                        
                    };
                },
                methods: {
                    async request(url = "", method, data) {
                        try {
                            const response = await fetch(url, {
                                method: method,
                                headers: {"Content-Type": "application/json"},
                                body: JSON.stringify(data)
                            });
                            if (response.status == 200) {
                                return response.json();
                            } 
                        } catch (e) {
                            this.error = e;
                            return null;
                    }
                    },
                    
                    async loadSession() {
                        const data = await this.request("http://localhost:8080/TP-JavaEE/api/session", "GET");
                        if (data) {
                            this.session = data;
                        } else {
                            window.location.href = "login.jsp";
                        }
                    },
                },
                mounted() {
                    this.loadSession();
                }
            });
            infos.mount("main");
        </script>
    </body>
</html>
