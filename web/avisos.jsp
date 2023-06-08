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
        <title>Avisos</title>
    </head>
    <body>
        <style>
            div.card_form{
                border-radius: 10px;
            }
            div.table_avisos{
                width: 100%;
            }
            table#table_avisos{
                width: 80%;
            }
            tr.aviso_tr:hover{
                cursor: pointer;
                background-color: #a8a8a8;
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
                    <form id="cadastro-aviso" class="d-flex flex-column">
                        <div class="top_cadastro-aviso">
                            <h3 class="text-center">Criar Avisos</h3>
                            <hr class="m-0">
                        </div>
                        <div class="form-group">
                            <label for="titulo" class="form-label">Titulo:</label>
                            <input type="text" class="form-control" id="nome" v-model="objAviso.titulo" required/>
                        </div>
                        <div class="form-floating mt-3">
                            <textarea class="form-control" id="floatingTextarea" v-model="objAviso.conteudo" style="min-height:100px"></textarea>
                            <label for="floatingTextarea">Conteudo</label>
                        </div>
                        <div class="action d-flex justify-content-center mt-3">
                            <button type="button" class="btn btn-primary" @click="verifyRequest(objAviso)">Salvar</button>
                        </div>
                    </form>
                </div>
                <div class="table_avisos d-flex flex-column mt-5 align-items-center">
                    <table id="table_avisos" class="table table-striped">
                        <thead>
                            <tr class="text-white bg-dark">
                                <th>ID</th>
                                <th>Titulo</th>
                                <th>Data Criação</th>
                                <th></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="aviso_tr" v-for="aviso in avisos">
                                <td @click="showAviso(aviso)">{{aviso.id}}</td>
                                <td @click="showAviso(aviso)">{{aviso.titulo}}</td>
                                <td @click="showAviso(aviso)">{{aviso.data}}</td>
                                <!--<td v-if="usuario.estado" class="text-success text-center" style="cursor: pointer" @click="disableUsuario(usuario)">O</td>
                                <td v-else class="text-danger text-center" style="cursor: pointer" @click="disableUsuario(usuario)">O</td>-->
                                <td>
                                    <span class="material-symbols-outlined text-danger" @click="confirmRemove(aviso)">
                                        delete
                                    </span>
                                </td>
                                <td>
                                    <span class="material-symbols-outlined text-primary" @click="patchForm(aviso)">
                                        edit
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
        <script>
            const aviso = Vue.createApp({
                data() {
                    return{
                        error: null,
                        session: null,
                        objAviso: {
                            id: null,
                            titulo: null,
                            conteudo: null,
                            idUsuario: null,
                            data: null,
                        },
                        avisos: [],
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
                    async loadAvisos() {
                        const data = await this.request("http://localhost:8080/TP-JavaEE/api/avisos", "GET");
                        if (data) {
                            data.avisos.forEach(aviso => {
                                aviso.data = new Date(aviso.data).toLocaleDateString('pt-BR', {timeZone: 'UTC', year: 'numeric', month: '2-digit', day: '2-digit'}).replace(/(\d+)\/(\d+)\/(\d+)/, '$1/$2/$3')
                            });
                            this.avisos = data.avisos;
                        }
                    },
                    showAviso(aviso) {
                        this.openSwal({title: aviso.titulo, html: aviso.conteudo})
                    },
                    async addAviso() {
                        if (!this.objAviso.titulo || !this.objAviso.conteudo) {
                            this.openSwal({title: "Preencha todos os campos", icon: "error"});
                        } else {
                            const data = await this.request("http://localhost:8080/TP-JavaEE/api/avisos?idUsuario=" + this.session.id, "POST", this.objAviso);
                            if (data) {
                                this.objAviso.titulo = null;
                                this.objAviso.conteudo = null;
                                this.loadAvisos();
                            }
                        }
                    },
                    verifyRequest(aviso) {
                        if (aviso.id != null) {
                            this.editAviso(aviso);
                        } else {
                            this.addAviso(aviso);
                        }
                    },
                    patchForm(aviso) {
                        if (this.objAviso.id) {
                            this.avisos.push(this.objAviso);
                        }
                        this.objAviso = aviso;
                        this.avisos.splice(this.avisos.indexOf(this.objAviso), 1);
                    },
                    async editAviso(aviso) {
                        if (!this.objAviso.titulo || !this.objAviso.conteudo) {
                            this.openSwal({title: "Preencha todos os campos", icon: "error"});
                        } else {
                            const data = await this.request("http://localhost:8080/TP-JavaEE/api/avisos?idAviso=" + aviso.id, "PUT", aviso);
                            this.objAviso.titulo = null;
                            this.objAviso.conteudo = null;
                            this.objAviso.id = null;
                            this.objAviso.data = null;
                            this.loadAvisos();
                        }
                    },
                    confirmRemove(aviso) {
                        Swal.fire({
                            icon: "question",
                            html: "<h4>Deseja remover o aviso <strong>" + aviso.titulo + "</strong> </h4>",
                            confirmButtonText: "Remover",
                            confirmButtonColor: "#dc3545",
                            showCancelButton: true,
                            cancelButtonText: "Cancelar",
                            cancelButtonColor: "#0d6efd"
                        }).then(result => {
                            if (result.isConfirmed) {
                                this.removeAviso(aviso);
                            }
                        })
                    },
                    async removeAviso(aviso) {
                        const data = await this.request("http://localhost:8080/TP-JavaEE/api/avisos?idAviso=" + aviso.id, "DELETE");
                        if (data) {
                            this.openSwal({title: "Aviso removido com sucesso", icon: "success"});
                            this.loadAvisos();
                        }
                    },
                    openSwal( {title, text = "", html = "", icon = "", confirm = "Ok", cancel = "cancelar"}){
                        Swal.fire({
                            title: title,
                            text: text,
                            icon: icon,
                            html: html == "" ? html : "<textarea disabled style='width:100%; min-height: 150px; resize: none';'>" + html + "</textarea>",
                            confirmButtonText: confirm,
                            cancelButtonText: cancel
                        });
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
                    this.loadAvisos();
                }
            });
            aviso.mount("main");
        </script>
    </body>
</html>
