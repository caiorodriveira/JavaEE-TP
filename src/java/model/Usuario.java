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
                    + "role varchar (5) not null, \n"
                    + "senha varchar(250) not null)";

        }
    
    public static ArrayList<Usuario> getUsuarios() throws Exception {
        ArrayList<Usuario> usuarios = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("select * from usuario");
        while (rs.next()) {
            usuarios.add(new Usuario(rs.getString("nome"), rs.getString("email"), rs.getString("role"), rs.getString("senha")));
        }
        rs.close();
        stmt.close();
        con.close();
        return usuarios;
    }
    
    public static void addUsuario(String nome, String email, String role, String senha) throws Exception {
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("insert into usuario(nome, email, role, senha) values(?, ?, ? ,?)");
        stmt.setString(1, nome);
        stmt.setString(2, email);
        stmt.setString(3, role);
        stmt.setString(4, senha);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static Usuario getUsuario(String email, String senha) throws Exception {
        Usuario user = null;
        Connection con = AppListener.getConnection();
        String sql = "SELECT * from usuario WHERE email=? AND senha=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, AppListener.getMd5Hash(senha));
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            String nome = rs.getString("nome");
            String emailUsuario = rs.getString("email");
            String role = rs.getString("role");
            String senhaHash = rs.getString("senha");
            user = new Usuario(nome, emailUsuario, role, senhaHash);
        }
        rs.close();
        stmt.close();
        con.close();
        return user;
    }
    
    private String nome;
    private String email;
    private String senha;
    private String role;

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    
    public Usuario() {
        this.setNome("[NEW]");
        this.setEmail("[NEW]");
        this.setSenha("[NEW]");
        this.setRole("[NEW]");
    }

    public Usuario(String nome, String email, String role, String senha) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.role = role;
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
