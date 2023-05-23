/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package api;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.util.ArrayList;
import model.Aviso;
import model.Usuario;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Fatec
 */
@WebServlet(name = "UsuarioServiet", urlPatterns = {"/usuarios"})
public class UsuarioServiet extends HttpServlet {

    private JSONObject getJSONBody(BufferedReader reader) throws Exception {
        StringBuilder buffer = new StringBuilder();
        String line = null;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
        return new JSONObject(buffer.toString());
    }
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
 
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json/charset=UTF-8");
        JSONObject file = new JSONObject();
        try {
            file.put("exception", Usuario.exception);
            ArrayList<Usuario> list = Usuario.getUsuarios();
            JSONArray arr = new JSONArray();
            for(Usuario u: list){
                JSONObject nomeJson = new JSONObject();
                JSONObject emailJson = new JSONObject();
                JSONObject senhaJson = new JSONObject();
                nomeJson.put("nome", u.getNome());
                emailJson.put("email", u.getEmail());
                senhaJson.put("senha", u.getSenha());
                arr.put(nomeJson);
                arr.put(emailJson);
                arr.put(senhaJson);
            }
            file.put("usuarios", arr);
        } catch (Exception ex) {
            response.setStatus(500);
            file.put("Error", ex.getLocalizedMessage());
            response.getWriter().print(file.toString());
        }
        response.getWriter().print(file.toString());
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json/charset=UTF-8");
        JSONObject file = new JSONObject();
        try {
            JSONObject body = getJSONBody(request.getReader());
            String nome = body.getString("nome");
            String email = body.getString("email");
            int senha = (Integer) body.getString("senha").hashCode();
            String senhaHash = Integer.toString(senha);
            if (nome != null && email != null && senhaHash != null) {
                Usuario.addUsuario(nome, email, senhaHash);
            }
            ArrayList<Usuario> list = Usuario.getUsuarios();
            JSONArray arr = new JSONArray();
            for(Usuario u: list){
                JSONObject nomeJson = new JSONObject();
                JSONObject emailJson = new JSONObject();
                JSONObject senhaJson = new JSONObject();
                nomeJson.put("nome", u.getNome());
                emailJson.put("email", u.getEmail());
                senhaJson.put("senha", u.getSenha());
                arr.put(nomeJson);
                arr.put(emailJson);
                arr.put(senhaJson);
            }
            file.put("usuarios", arr);
            response.getWriter().print(file.toString());
            
        } catch (Exception ex) {
            response.setStatus(500);
            file.put("Error", ex.getLocalizedMessage());
            response.getWriter().print(file.toString());
        }
    
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
