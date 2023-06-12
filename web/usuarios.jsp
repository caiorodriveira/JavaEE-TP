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
        <title>Usuarios</title>
        <%@include file="WEB-INF/jspf/cdnCss.jspf" %>
    </head>
    <style>
        div.card_form{
            border-radius: 10px;
        }
        div.table_usuarios{
            width: 100%;
        }
        table#table_usuarios{
            width: 80%;
        }
        span.material-symbols-outlined{
            cursor: pointer;
        }
    </style>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <div class="container-fluid m-0 p-0 d-flex flex-column" v-if="session && session.role == 'ADMIN'">
                <div class="card_form shadow align-self-center p-3 mt-5 w-50">
                    <form id="cadastro-usuario">
                        <div class="top_cadastro-usuario">
                            <h3 class="text-center">Cadastrar usuários</h3>
                            <hr class="m-0">
                        </div>
                        <div class="form-group">
                            <label for="nome" class="form-label">Nome:</label>
                            <input type="text" class="form-control" id="nome" v-model="objUsuario.nome" required/>
                        </div>
                        <div class="form-group row">
                            <div class="col">
                                <label for="email" class="form-label">Email:</label>
                                <input type="text" class="form-control" id="email" v-model="objUsuario.email" required/>
                            </div>
                            <div class="col">
                                <label for="senha" class="form-label">Senha:</label>
                                <input type="text" class="form-control" id="senha" v-model="objUsuario.senha" required/>
                            </div>
                        </div>
                        <div class="action d-flex justify-content-center mt-3">
                            <button type="button" class="btn btn-primary" @click="verifyRequest(objUsuario)">Salvar</button>
                        </div>
                    </form>
                </div>
                <div class="table_usuarios d-flex flex-column mt-5 align-items-center">
                    <table id="table_usuarios" class="table table-striped">
                        <thead>
                            <tr class="text-white bg-dark">
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="usuario in usuarios">
                                <td>{{usuario.ID}}</td>
                                <td>{{usuario.nome}}</td>
                                <td>{{usuario.email}}</td>
                                <td>{{usuario.role}}</td>
                                <!--<td v-if="usuario.estado" class="text-success text-center" style="cursor: pointer" @click="disableUsuario(usuario)">O</td>
                                <td v-else class="text-danger text-center" style="cursor: pointer" @click="disableUsuario(usuario)">O</td>-->
                                <td>
                                    <span class="material-symbols-outlined text-danger" @click="confirmRemove(usuario)">
                                        delete
                                    </span>
                                </td>
                                <td>
                                    <span class="material-symbols-outlined text-primary" @click="patchForm(usuario)">
                                        edit
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                    </table>
                </div>
            </div>
        </main>
    </body>
    <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
    <script>
        const usuario = Vue.createApp({
            data() {
                return{
                    error: null,
                    session: null,
                    objUsuario: {
                        id: null,
                        nome: null,
                        email: null,
                        senha: null,
                        role: null,
                    },
                    usuarios: [],
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
                            this.error = response;
                            if (this.error.statusText.indexOf("[SQLITE_CONSTRAINT_UNIQUE]") == 14) {
                                this.openSwal({title: "Não é possível cadastrar com esse email pois ja possui um cadastro", icon: "error"});
                            } else {
                                this.openSwal({title: this.error.statusText, icon: "error"});
                            }

                        }
                    } catch (e) {
                        this.error = e;
                        return null;
                }
                },
                verifyRequest(usuario) {
                    if(usuario.ID != null){
                        this.editUsuario(usuario);
                    } else {
                        this.addUsuario(usuario);
                    }
                },
                async addUsuario() {
                    if (!this.objUsuario.nome || !this.objUsuario.email || !this.objUsuario.senha) {
                        this.openSwal({title: "Preencha todos os campos", icon: "error"});
                    } else {
                        const data = await this.request("http://localhost:8080/TP-JavaEE/api/usuarios", "POST", this.objUsuario);
                        if (data) {
                            this.objUsuario.nome = null;
                            this.objUsuario.email = null;
                            this.objUsuario.senha = null;
                            this.objUsuario.role = null;
                            this.loadUsuarios();
                        }
                    }
                },
                patchForm(usuario){
                  if(this.objUsuario.ID){
                      this.usuarios.push(this.objUsuario);
                  }
                  this.objUsuario = usuario;
                  this.objUsuario.senha = null;
                  this.usuarios.splice(this.usuarios.indexOf(usuario), 1);
                },
                async editUsuario(usuario) {
                    if (!this.objUsuario.nome || !this.objUsuario.email || !this.objUsuario.senha) {
                        this.openSwal({title: "Preencha todos os campos", icon: "error"});
                    } else {
                        const data = await this.request("http://localhost:17822/TP-JavaEE/api/usuarios?id="+usuario.ID, "PUT", usuario);
                        this.objUsuario.nome = null;
                        this.objUsuario.email = null;
                        this.objUsuario.senha = null;
                        this.objUsuario.id = null;
                        this.objUsuario.role = null;
                        this.loadUsuarios();
                    }
                },
                confirmRemove(usuario) {
                    Swal.fire({
                        icon: "question",
                        html: "<h4>Deseja remover o usuario <strong>" + usuario.nome +"</strong> do email <strong>" + usuario.email +" </strong> </h4>",
                        confirmButtonText: "Remover",
                        confirmButtonColor: "#dc3545",
                        showCancelButton: true,
                        cancelButtonText: "Cancelar",
                        cancelButtonColor: "#0d6efd"
                    }).then(result => {
                        if (result.isConfirmed) {
                            this.removeUsuario(usuario);
                        }
                    })
                },
                async removeUsuario(usuario) {
                    const data = await this.request("http://localhost:17822/TP-JavaEE/api/usuarios?id=" + usuario.ID, "DELETE");
                    if (data) {
                        this.openSwal({title: "Usuario removido com sucesso", icon: "success"});
                        this.loadUsuarios();
                    }
                },
                openSwal( {title, text = "", icon = "", confirm = "Ok", cancel = null}){
                    Swal.fire({
                        title: title,
                        text: text,
                        icon: icon,
                        confirmButtonText: confirm,
                        cancelButtonText: cancel
                    });
                },
                async loadUsuarios() {
                    const data = await this.request("http://localhost:17822/TP-JavaEE/api/usuarios", "GET");
                    if (data) {
                        this.usuarios = data.usuarios;
                    }
                },
                async loadSession() {
                    const data = await this.request("http://localhost:17822/TP-JavaEE/api/session", "GET");
                    if (data) {
                        this.session = data;
                    } else {
                        window.location.href = "login.jsp";
                    }
                },

            },
            mounted() {
                this.loadSession();
                this.loadUsuarios();
            }
        });
        usuario.mount('main');
    </script>
</html>
