<%-- 
    Document   : cadastrarUsuario
    Created on : 4 de jun. de 2023, 22:59:06
    Author     : kakaz
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%@include file="WEB-INF/jspf/cdnCss.jspf" %>
    </head>
    <style>
        div.card_form{
            border-radius: 10px;
        }
    </style>
    <body>
        <main class="container-fluid m-0 p-0 d-flex flex-column">
            <div class="card_form shadow align-self-center p-3 mt-5 w-50">
                <form id="cadastro-usuario">
                    <div class="top_cadastro-usuario">
                        <h3 class="text-center">Cadastrar usuários</h3>
                        <hr class="m-0">
                    </div>
                    <div class="form-group">
                        <label for="nome" class="form-label">Nome:</label>
                        <input type="text" class="form-control" id="nome" v-model="nome" required/>
                    </div>
                    <div class="form-group row">
                        <div class="col">
                            <label for="email" class="form-label">Email:</label>
                            <input type="text" class="form-control" id="email" v-model="email" required/>
                        </div>
                        <div class="col">
                            <label for="senha" class="form-label">Senha:</label>
                            <input type="text" class="form-control" id="senha" v-model="senha" required/>
                        </div>
                    </div>
                    <div class="action d-flex justify-content-center mt-3">
                        <button type="button" class="btn btn-primary" @click="addUsuario">Cadastrar</button>
                    </div>
                </form>
            </div>
            
        </main>
    </body>
    <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
    <script>    
    const app = Vue.createApp({
        data() {
            return{
                error: null,
                nome: "",
                email:"",
                senha: ""
            };
        },
        methods: {
            async request(url = "", method, data) {
                try{
                    const response = await fetch(url, {
                        method: method,
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify(data)
                    });
                    if(response.status===200){
                        return response.json();
                    }else{
                        this.error = response.statusText;
                    }
                } catch(e){
                    this.error = e;
                    return null;
                }
            },
            async addUsuario() {
                const data = await this.request("http://localhost:8080/TP-JavaEE/api/usuarios", "POST", 
                {nome: this.nome, email: this.email, senha: this.senha});
                //if(data){
                //    this.nome = "";
                //    this.senha  = "";
                //    this.senha = "";
                //}
            }
       },
        mounted() {
            
        }
    });
    app.mount('main');
</script>
</html>
