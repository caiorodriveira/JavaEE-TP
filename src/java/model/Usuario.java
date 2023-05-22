package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Usuario {

    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:db_avisos.db";

    public static Exception exception = null;

    public static void createTableUsuario() {
        try {
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("create table if not exists usuario (\n"
                    + "id_usuario int auto_increment primary key,\n"
                    + "nome varchar(100) not null,\n"
                    + "email varchar(50) not null unique))");
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
