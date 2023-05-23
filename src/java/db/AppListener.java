package db;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Date; 
import model.Aviso;
import model.Usuario;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author kakaz
 */

@WebListener
public class AppListener implements ServletContextListener {

    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:db_avisos.db";
    public static String initializeLog = "";
    public static Exception exception = null;

    public static Connection getConnection() throws Exception {
        Class.forName(CLASS_NAME);
        return DriverManager.getConnection(URL);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/OverriddenMethodBody
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try{
            Connection c = AppListener.getConnection();
            Statement s = c.createStatement();
            initializeLog += new Date() + ": Initializing database creation; ";
            
            //Usuario
            initializeLog += "Creating Usuario table if not exists...";
            s.execute(Usuario.createTableUsuario());
            initializeLog += "done; ";
            //criar verificação se não existir usuário criar um admin com metodos da classe
            
            //Avisos
            initializeLog += "Creating Aviso table if not exists...";
            s.execute(Aviso.createTableAviso());
            initializeLog += "done.";
            s.close();
            c.close();
            
        } catch (Exception ex){
            initializeLog += "Erro: " + ex.getMessage();
            System.out.println("Erro: " + ex.getMessage());
        }
    }
    
    
}
