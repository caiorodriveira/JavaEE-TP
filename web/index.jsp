<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="WEB-INF/jspf/cdnCss.jspf" %>
        <title>Home Page</title>
    </head>
    <body>
        <style>
            .container{
                padding: 0;
                margin-top: 5%;
                min-height: 50vh;
                display: flex;
                flex-direction: column;
                max-height: max-content;
            }

            .title-container{
                margin:0;
                min-height: 40px;
                background-color: #a8a8a8;
                text-align: center;
            }

            .content-container{
                padding-top: 20px;
                padding-left: 40px;
                padding-right: 35px;
                width: 100%;

                max-height: 485px;
            }

            .aviso{
                border-radius: 4px;
                margin-left: 37px;
                margin-bottom: 20px;

                min-height: 100px;
                display: flex;
                flex-direction: column;
                justify-content: space-around;
            }

            .aviso:hover {
                cursor: pointer;
                -webkit-transform: scale(1.2);
                -ms-transform: scale(1.2);
                transform: scale(1.2);
                transition: 0.3s;
                background-color: #fff;
                z-index: 99;
            }

            .modal-body {
                max-height: 60vh;
                overflow-wrap: break-word;
                word-wrap: break-word;
                word-break: break-word;
                overflow-y: auto;
            }

            .aviso-header{
                display: flex;
                justify-content: flex-end;
            }

            .btn-close{
                width: 10px;
                height: 10px;
            }

            @media only screen and (max-width: 1399px) {
                .aviso {
                    margin-left: 32px;
                }
            }
            @media only screen and (max-width: 1199px) {
                .aviso {
                    margin-left: 19px;
                    width: 158px;
                }
            }
            @media only screen and (max-width: 991px) {
                .content-container {
                    padding-left: 20px;
                    padding-right: 0px;
                }
                .aviso {
                    width: 150px;
                }
                .aviso:hover{
                    -webkit-transform: scale(1.1);
                    -ms-transform: scale(1.1);
                    transform: scale(1.1);
                }
            }
            @media only screen and (max-width: 552px) {
                .content-container {
                    padding-left: 0px;
                    padding-right: 0px;
                }
                .aviso {
                    margin-left: 30px;
                    width: 90%;
                }
                .aviso:hover{
                    -webkit-transform: scale(1.05);
                    -ms-transform: scale(1.05);
                    transform: scale(1.05);
                }

            }
        </style>
        <%@include file="WEB-INF/jspf/header.jspf" %>

        <div id="app" class="container-fluid">
            <div v-if="session">

                <div class="container shadow">

                    <div class="title-container">
                        <h3><strong>QUADRO DE AVISOS</strong></h3>
                    </div>

                    <div class="content-container row">

                        <div class="aviso col-md-2 shadow" v-for="aviso in avisos" @click="showAviso(aviso)">

                            <span class="text-center"><strong> {{aviso.titulo}} </strong></span>
                            <span><strong>Data: </strong> {{aviso.data}}</span>

                        </div>

                    </div>
                </div>
            </div>
        </div>

        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        session: null,
                        error: null,
                        avisos: [],
                        objAviso: null,
                    }
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
                    async loadAvisos() {
                        const data = await this.request("http://localhost:8080/TP-JavaEE/api/avisos", "GET");
                        if (data) {
                            this.avisos = data.avisos;
                        }
                    },
                    showAviso(aviso) {    
                        this.openSwal({title: aviso.titulo, html: aviso.conteudo})
                    },
                    openSwal({title, html=""}){
                        Swal.fire({
                            title: title,
                            html: html
                        })
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
                },
            });
            app.mount('#app');
        </script>
    </body>
</html>