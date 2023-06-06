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
        <main>
            <h1 v-if="shared.session"> Visualização apenas se estiver logado </h1>
        </main>

        <%@include file="WEB-INF/jspf/cdnJs.jspf" %>
        <script>
            const home = Vue.createApp({
                data() {
                    return{
                        error: null,
                        shared: shared
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
                            }
                        } catch (e) {
                            this.error = e;
                            return null;
                    }
                    }

                },
                mounted() {

                }
            });
            home.mount('main');
        </script>
    </body>
</html>