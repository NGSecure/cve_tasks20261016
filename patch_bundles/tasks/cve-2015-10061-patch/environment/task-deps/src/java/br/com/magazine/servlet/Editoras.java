/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.servlet;

import br.com.magazine.dao.EditoraDAO;
import br.com.magazine.entidade.Editora;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Yuri
 */
@WebServlet(name = "Editoras", urlPatterns = {"/administrador/Editoras"})
public class Editoras extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
           if ("cadastrar".equals(request.getParameter("action"))) {
                Editora editora = new Editora();
                editora.setNome(request.getParameter("editora"));
                EditoraDAO editoraDAO = new EditoraDAO();
                editoraDAO.cadastrarEditora(editora);
                response.sendRedirect("./Editoras");
                return;
            }
           if ("editar".equals(request.getParameter("action"))) {
               System.out.println("oi");
                Editora editora = new Editora();
                editora.setNome(request.getParameter("editora-nome"));
                editora.setIdEditora(Integer.parseInt(request.getParameter("editora-id")));
                EditoraDAO editoraDAO = new EditoraDAO();
                editoraDAO.atualizarEditora(editora);
                response.sendRedirect("./Editoras");
                return;
            }           
            if ("remover".equals(request.getParameter("action"))) {
                Editora editora = new Editora();
                editora.setIdEditora(Integer.parseInt(request.getParameter("id")));
                EditoraDAO editoraDAO = new EditoraDAO();
                editoraDAO.removerEditora(editora);
                response.sendRedirect("./Editoras");
                return;
            }
            else{
                
                List<Editora> listaEditoras = new ArrayList();
                EditoraDAO editoraDAO = new EditoraDAO();
                listaEditoras = editoraDAO.listarEditoras();
                
                request.setAttribute("editoraLista", listaEditoras);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/administrador/cadastrarEditora.jsp");
                rd.forward(request,response);
                
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Editoras.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Editoras.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Editoras.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Editoras.class.getName()).log(Level.SEVERE, null, ex);
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
