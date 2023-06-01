package model;

import db.AppListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.sql.Date;

public class Aviso {

    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:db_avisos.db";

    public static Exception exception = null;

    public static String createTableAviso() {
        return "create table if not exists aviso (\n"
                + "nm_titulo varchar(100) not null,\n"
                + "ds_conteudo text,\n"
                + "id_usuario int not null,\n"
                + "dt_aviso varchar(50), \n"
                + "constraint fk_usuario foreign key (id_usuario) references usuario (rowid))";

    }

    public static ArrayList<Aviso> getAvisos() throws Exception {
        ArrayList<Aviso> avisos = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("select rowid,* from aviso");
        while (rs.next()) {
            avisos.add(new Aviso(rs.getString("nm_titulo"), rs.getString("ds_conteudo"), rs.getString("dt_aviso"), rs.getLong("rowid")));
        }
        rs.close();
        stmt.close();
        con.close();
        return avisos;
    }

    public static void addAviso(String titulo, String conteudo, String data) throws Exception {
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("insert into aviso values(?, ?, ?)");
        stmt.setString(1, titulo);
        stmt.setString(2, conteudo);
        stmt.setString(3, data);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public static void removeAviso(Long id) throws Exception {
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("delete from aviso where id_aviso = ?");
        stmt.setLong(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public static void updateAviso(Long id, String titulo, String conteudo, String data) throws Exception{
        Connection con = AppListener.getConnection();
        PreparedStatement stmt = con.prepareStatement("update aviso set titulo = ?, conteudo = ?, data = ? where id_aviso = ?");
        stmt.setString(1, titulo);
        stmt.setString(2, conteudo);
        stmt.setString(3, data);
        stmt.setLong(4, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    private String titulo;
    private String conteudo;
    private String data;
    private Long id;

    public Aviso() {
        this.setTitulo("[NEW]");
        this.setConteudo("[NEW]");
    }

    public Aviso(String titulo, String conteudo, String data, Long id) {
        this.titulo = titulo;
        this.conteudo = conteudo;
        this.data = data;
        this.id = id;
    }

    
        
    public String getTitulo() {
        return titulo;
    }

    public String getConteudo() {
        return titulo;
    }

    public String getData() {
        return data;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public void setConteudo(String conteudo) {
        this.conteudo = conteudo;
    }

    public void setData(String data) {
        this.data = data;
    }

}
