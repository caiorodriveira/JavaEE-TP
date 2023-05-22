package model;

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

    public static void createTableAviso() {
        try {
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("create table if not exists aviso (\n"
                    + "id_aviso int auto_increment primary key,\n"
                    + "nm_titulo varchar(100) not null,\n"
                    + "ds_conteudo text,\n"
                    + "id_usuario int not null,\n"
                    + "dt_aviso varchar(50), \n"
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
    
      public static ArrayList<Aviso> getAvisos() throws Exception{
         ArrayList<Aviso> avisos = new ArrayList<>();
         Connection con = getConnection();
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery("select * from aviso");
         while(rs.next()){
             avisos.add(new Aviso(rs.getString("nm_titulo"),rs.getString("ds_conteudo"), rs.getString("dt_aviso")));
         }
         rs.close();
         stmt.close();
         con.close();
         return avisos;
    }
      
    public static void addAviso(String titulo, String conteudo, String data) throws Exception{
        Connection con = getConnection();
        PreparedStatement stmt = con.prepareStatement("insert into aviso values(?)");
        stmt.setString(1, titulo);
        stmt.setString(2,conteudo);
        stmt.setString(3, data);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void removeAviso(String titulo, String conteudo, String data) throws Exception{
        Connection con = getConnection();
        PreparedStatement stmt = con.prepareStatement("delete from aviso where id_aviso = ?");
        stmt.setString(1, titulo);
        stmt.setString(2,conteudo);
        stmt.setString(3, data);
        stmt.execute();
        stmt.close();
        con.close();
    }  
    
  
     
        private String titulo;
        private String conteudo;
        private String data;
  
     public Aviso(){
        this.setTitulo("[NEW]");
        this.setConteudo("[NEW]");
    }
    
    public Aviso(String titulo, String conteudo, String data){
        this.titulo = titulo;
        this.conteudo = conteudo;
        this.data = data;
    }
    
    public String getTitulo(){
        return titulo;
    }
    public String getConteudo(){
        return titulo;
    }
    public String getData(){
        return data;
    }
    
    public void setTitulo(String titulo){
        this.titulo = titulo;
    }
    
    public void setConteudo(String conteudo){
        this.conteudo = conteudo;
    }
        
    public void setData(String data){
        this.data = data;
    }
    
}
