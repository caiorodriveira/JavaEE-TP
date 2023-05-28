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
@WebServlet(name = "UsuarioServiet", urlPatterns = {"/api/*"})
public class ApiServlet extends HttpServlet {

    private JSONObject getJSONBody(BufferedReader reader) throws Exception {
        StringBuilder buffer = new StringBuilder();
        String line = null;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
        return new JSONObject(buffer.toString());
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("applcation/json;charset=UTF-8");
        JSONObject file = new JSONObject();
        try{
           if(request.getRequestURI().endsWith("/api/session")){
               processSession(file, request, response);
           } else if(request.getRequestURI().endsWith("/api/usuarios")){
               processUsuarios(file, request, response);
           } else if(request.getRequestURI().endsWith("api/avisos")) {
               processAvisos(file, request, response);
           } else {
               response.sendError(400, "URL invalida!");
               file.put("error", "URL invalida");
           }
        } catch(Exception ex){
            response.sendError(500, "Erro interno: " + ex.getLocalizedMessage());
            file.put("error", "Erro interno: " + ex.getLocalizedMessage());
        }
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
       processRequest(request, response);
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
        processRequest(request, response);

    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       processRequest(request, response);
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

    private void processSession(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception { 
        if(request.getMethod().toLowerCase().equals("put")){
            JSONObject body = getJSONBody(request.getReader());
            String email = body.getString("email");
            String senha = body.getString("senha");
            Usuario u = Usuario.getUsuario(email, senha);
            if(u == null){
                response.sendError(403, "Email ou Senha invalidos!");
            } else {
                request.getSession().setAttribute("usuario", u);
                file.put("email", u.getEmail());
                file.put("nome", u.getNome());
                file.put("role", u.getRole());
                file.put("senha", u.getSenha());
                
                file.put("message", "Logado com sucesso!");
            }
        } else if(request.getMethod().toLowerCase().equals("delete")){
            
        } else if(request.getMethod().toLowerCase().equals("get")){
        
        } else {
            response.sendError(405, "Method not allowed");
        }
    }
    private void processUsuarios(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    }

    private void processAvisos(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    }


}
