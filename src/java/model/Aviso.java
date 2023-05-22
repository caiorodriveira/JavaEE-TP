package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Aviso {

    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:db_avisos.db";

    public static Exception exception = null;

    public static void createTableAviso() {
        try {
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("create table if not exists aviso (\n"
                    + "id_aviso int auto_increment primary key,\n"
                    + "nm_titulo varchar(100) not null,\n"
                    + "ds_conteudo text,\n"
                    + "id_usuario int not null,\n"
                    + "constraint fk_usuario foreign key (id_usuario) references usuario (id_usuario))");
            stmt.close();
            con.close();
        } catch (Exception ex) {
            exception = ex;
        }
    }

    public static Connection getConnection() throws Exception {
        Class.forName(CLASS_NAME);
        return DriverManager.getConnection(URL);
    }
}
