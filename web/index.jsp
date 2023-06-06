<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="WEB-INF/jspf/cdnCss.jspf" %>
        <title>JSP Page</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>

        <div id="app" class="container-fluid">
            
        </div>

        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        shared: shared,
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
                        const data = await this.request("http://localhost:17822/TP-JavaEE/api/avisos");
                        if (data) {
                            this.avisos = data;
                            console.log(this.avisos);
//                            for(let of data){
//                                console.log(a.conteudo);
//                            }
                        }
                    },
                },

                mounted() {
                    this.loadAvisos();
                },
            });
            app.mount('#app');
        </script>
    </body>
</html>