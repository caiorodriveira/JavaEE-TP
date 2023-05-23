package model;

import db.AppListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class Usuario {

    public static Exception exception = null;

    public static String createTableUsuario() {
        return "create table if not exists usuario (\n"
                    + "id_usuario int auto_increment primary key,\n"
                    + "nome varchar(100) not null,\n"
                    + "email varchar(50) not null unique, \n"
                    + "senha varchar(250) not null)";

        }
    
    public static ArrayList<Usuario> getUsuarios() throws Exception {
        ArrayList<Usuario> usuarios = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("select * from usuario");
        while (rs.next()) {
            usuarios.add(new Usuario(rs.getString("nome"), rs.getString("email"), rs.getString("senha")));
        }
        rs.close();
        stmt.close();
        con.close();
        return usuarios;
    }
    
    public static void addUsuario(String nome, String email, String senha) throws Exception {
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("insert into usuario values(?)");
        stmt.setString(1, nome);
        stmt.setString(2, email);
        stmt.setString(3, senha);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    private String nome;
    private String email;
    private String senha;

    
    public Usuario() {
        this.setNome("[NEW]");
        this.setEmail("[NEW]");
        this.setSenha("[NEW]");
    }

    public Usuario(String nome, String email, String senha) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
    }
    
    public String getNome() {
        return nome;
    }

    public String getEmail() {
        return email;
    }

    public String getSenha() {
        return senha;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }
}
