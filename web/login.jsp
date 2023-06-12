<%-- 
    Document   : login
    Created on : 7 de jun. de 2023, 12:40:06
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
    <body>
        <style>
            main.container-fluid{
                min-height: 100vh;
                width: 100vw;
            }
            div.login_container{
                height: 365px;
                width: 730px;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }
            .form-group{
                width: 80%;
                align-self: center;
            }

        </style>
        <div class="d-flex login_container shadow">
            <div id="login" class="p-3 w-50">
                <div class="top_login">
                    <h3 class="text-center">Login</h3>
                    <hr class="m-0">
                </div>
                <div class="body_login">
                    <form class="mt-5 d-flex flex-column">
                        <div class="form-group">
                            <label for="login" class="form-label">Login:</label>
                            <input type="text" class="form-control" id="login" v-model="email"/>
                        </div>
                        <div class="form-group">
                            <label for="senha" class="form-label">Senha:</label>
                            <input type="password" class="form-control" id="senha" v-model="senha"/>
                        </div>
                        <div class="w-100 d-flex justify-content-center">
                            <span v-if="error && error != 'N o existe sess o'" class="text-danger"> {{error}} </span>
                        </div>
                        <div class="action d-flex justify-content-center mt-3">
                            <button type="submit" class="btn btn-primary" @click="login($event)">Login</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="p-3 py-5 img_login bg-dark w-50 h-100 d-flex flex-column justify-content-between">
                <div class="icon_login align-self-center">
                    <span class="material-symbols-outlined" style="font-size: 200px; color: #d6d6d6"> grid_view </span>
                </div>
                <div class="title_login align-self-center">
                    <h2 class="text-light text-center" style="color: #d6d6d6">Quadro de avisos</h2>
                </div>
            </div>
        </div>
        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
        <script>
            const login = Vue.createApp({
                data() {
                    return{
                        error: null,
                        email: "",
                        senha: "",
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
                            } else {
                                this.error = response.statusText;
                            }
                        } catch (e) {
                            this.error = e;
                            return null;
                    }
                    },
                    async login(e) {
                        e.preventDefault();
                        const data = await this.request("http://localhost:8080/TP-JavaEE/api/session", "PUT", {email: this.email, senha: this.senha});
                        if (data) {
                            this.error = null;
                            this.data = data;
                            window.location.href = "index.jsp"
                        }
                    },
                },
                mounted() {
                }
            });
            login.mount('#login');
        </script>
    </body>
</html>
