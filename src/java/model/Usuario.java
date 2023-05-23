package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Usuario {

    public static Exception exception = null;

    public static String createTableUsuario() {
        return "create table if not exists usuario (\n"
                    + "id_usuario int auto_increment primary key,\n"
                    + "nome varchar(100) not null,\n"
                    + "email varchar(50) not null unique, \n"
                    + "senha varchar(250) not null)";

        }

}
