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
                    + "id_usuario integer primary key autoincrement, \n"
                    + "nome varchar(100) not null,\n"
                    + "email varchar(50) not null unique, \n"
                    + "role varchar (5) not null, \n"
                    + "senha varchar(250) not null, \n"
                    + "estado integer not null) \n";

        }
    
    public static ArrayList<Usuario> getUsuarios() throws Exception {
        ArrayList<Usuario> usuarios = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("select * from usuario where estado = 1");
        while (rs.next()) {
            usuarios.add(new Usuario(rs.getString("nome"), rs.getString("email"), rs.getString("role"), rs.getString("senha"), rs.getLong("id_usuario"), rs.getBoolean("estado")));
        }
        rs.close();
        stmt.close();
        con.close();
        return usuarios;
    }
    
    public static ArrayList<Usuario> getUsuarioByEmail(String email) throws Exception {
        ArrayList<Usuario> usuarios = new ArrayList<>();
        Connection con = AppListener.getConnection();
        String sql = "SELECT * from usuario WHERE email=? AND estado = true";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        usuarios.add(new Usuario(rs.getString("nome"), rs.getString("email"), rs.getString("role"), rs.getString("senha"), rs.getLong("id_usuario"), rs.getBoolean("estado")));
        rs.close();
        stmt.close();
        con.close();
        return usuarios;
    }
    
    public static void addUsuario(String nome, String email, String role, String senha, Boolean estado) throws Exception {
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("insert into usuario(nome, email, role, senha, estado) values(?, ?, ? ,?, ?)");
        stmt.setString(1, nome);
        stmt.setString(2, email);
        stmt.setString(3, role);
        stmt.setString(4, AppListener.getMd5Hash(senha));
        int auxEstado;
        if(estado){
            auxEstado = 1;
        }else{
            auxEstado = 0;
        }
        stmt.setInt(5, auxEstado);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static Usuario getUsuario(String email, String senha) throws Exception {
        Usuario user = null;
        Connection con = AppListener.getConnection();
        String sql = "SELECT * from usuario WHERE email=? AND senha=? AND estado = true";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, AppListener.getMd5Hash(senha));
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            String nome = rs.getString("nome");
            String emailUsuario = rs.getString("email");
            String role = rs.getString("role");
            String senhaHash = rs.getString("senha");
            Long idUsuario = rs.getLong("id_usuario");
            Boolean estado = rs.getBoolean("estado");
            user = new Usuario(nome, emailUsuario, role, senhaHash, idUsuario, estado);
        }
        rs.close();
        stmt.close();
        con.close();
        return user;
    }
    
    public static void deleteUsuario(Long id) throws Exception {
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("update usuario set estado = false where id_usuario = ?");
        stmt.setLong(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
        
    public static void updateUsuario(Long id, String nome, String email, String senha, String role) throws Exception{
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("update usuario set nome = ?, email = ?, senha = ?, role = ? where id_usuario = ?");
        stmt.setString(1, nome);
        stmt.setString(2, email);
        stmt.setString(3, AppListener.getMd5Hash(senha));
        stmt.setString(4, role);
        stmt.setLong(5, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    
    private Long ID;
    private String nome;
    private String email;
    private String senha;
    private String role;
    private Boolean estado;


    
    public Usuario() {
        this.setNome("[NEW]");
        this.setEmail("[NEW]");
        this.setSenha("[NEW]");
        this.setRole("[NEW]");
        this.setEstado(true);
    }

    public Usuario(String nome, String email, String role, String senha, Long id, Boolean estado) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.role = role;
        this.ID = id;
        this.estado = estado;
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

    public String getRole() {
        return role;
    }

    public Long getID(){
        return ID;
    }
    
    public Boolean getEstado(){
        return estado;
    }
    
    public void setRole(String role) {
        this.role = role;
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
    
    public void setEstado(Boolean estado){
        this.estado = estado;
    }
    
}
