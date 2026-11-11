/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.servlet;

import br.com.magazine.dao.ClienteDAO;
import br.com.magazine.dao.EditoraDAO;
import br.com.magazine.dao.GeneroDAO;
import br.com.magazine.entidade.Cliente;
import br.com.magazine.entidade.Editora;
import br.com.magazine.entidade.Genero;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
 * @author Evandro-PC
 */
@WebServlet(name = "Gerentes", urlPatterns = {"/gerente/Gerentes"})
public class Gerentes extends HttpServlet {

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
            throws ServletException, IOException, ParseException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            if ("cadastrar".equals(request.getParameter("action"))) {
                Cliente cliente = new Cliente();
                
                cliente.setNome(request.getParameter("nome"));
                cliente.setSexo(request.getParameter("sexo"));
                cliente.setCpf(request.getParameter("cpf"));
                
                String nascimentoStr = request.getParameter("nascimento");
                DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
                java.util.Date nascimentoUtil = format.parse(nascimentoStr);
                java.sql.Date nascimentoSql = new java.sql.Date(nascimentoUtil.getTime());
                cliente.setNascimento(nascimentoSql);
                
                cliente.setTelefone(request.getParameter("telefone"));
                cliente.setEmail(request.getParameter("email"));
                cliente.setSenha(request.getParameter("senha"));
                cliente.setCep(request.getParameter("cep"));
                cliente.setEndereco(request.getParameter("endereco"));
                cliente.setEndNumero(request.getParameter("numero"));
                cliente.setEndComplemento(request.getParameter("complemento"));
                cliente.setBairro(request.getParameter("bairro"));
                cliente.setCidade(request.getParameter("cidade"));
                cliente.setEstado(request.getParameter("estado"));
                cliente.setInativo(Boolean.parseBoolean(request.getParameter("perfil")));
                
                ClienteDAO clienteDAO = new ClienteDAO();
                clienteDAO.cadastrarCliente(cliente);
                response.sendRedirect("./buscarFuncionario.jsp");
                return;
            } 
            if ("buscarf".equals(request.getParameter("action"))) {
                List<Cliente> listaClientes = new ArrayList();
                ClienteDAO clienteDAO = new ClienteDAO();
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                if("nome".equals(escolha)){
                    listaClientes = clienteDAO.buscarFuncionarioNome(str);
                } else if("cpf".equals(escolha)){
                    listaClientes = clienteDAO.buscarFuncionarioCPF(str);
                } else if("email".equals(escolha)){
                    listaClientes = clienteDAO.buscarFuncionarioEmail(str);
                }
                request.setAttribute("listaClientes", listaClientes);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/listarFuncionario.jsp");
                rd.forward(request,response);
            }
            if ("buscarc".equals(request.getParameter("action"))) {
                List<Cliente> listaClientes = new ArrayList();
                ClienteDAO clienteDAO = new ClienteDAO();
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                if("nome".equals(escolha)){
                    listaClientes = clienteDAO.buscarClienteNome(str);
                } else if("cpf".equals(escolha)){
                    listaClientes = clienteDAO.buscarClienteCPF(str);
                } else if("email".equals(escolha)){
                    listaClientes = clienteDAO.buscarClienteEmail(str);
                }
                request.setAttribute("listaClientes", listaClientes);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/listarCliente.jsp");
                rd.forward(request,response);
            }
            if ("visualizarf".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente clienteSessao = new Cliente();
                clienteSessao.setIdCliente(Integer.parseInt(request.getParameter("id")));
                Cliente cliente = clienteDAO.buscarClienteId(clienteSessao);
                request.setAttribute("cliente", cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/visualizarFuncionario.jsp");
                rd.forward(request,response);
            }
            if ("visualizarc".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente clienteSessao = new Cliente();
                clienteSessao.setIdCliente(Integer.parseInt(request.getParameter("id")));
                Cliente cliente = clienteDAO.buscarClienteId(clienteSessao);
                request.setAttribute("cliente", cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/visualizarCliente.jsp");
                rd.forward(request,response);
            }
            if ("valterarf".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente clienteSessao = new Cliente();
                clienteSessao.setIdCliente(Integer.parseInt(request.getParameter("id")));
                Cliente cliente = clienteDAO.buscarClienteId(clienteSessao);
                request.setAttribute("cliente", cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/alterarFuncionario.jsp");
                rd.forward(request,response);
            }
            if ("valterarc".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente clienteSessao = new Cliente();
                clienteSessao.setIdCliente(Integer.parseInt(request.getParameter("id")));
                Cliente cliente = clienteDAO.buscarClienteId(clienteSessao);
                request.setAttribute("cliente", cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/alterarCliente.jsp");
                rd.forward(request,response);
            }
            if ("alterarf".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                Cliente cliente = new Cliente();
                
                cliente.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                cliente.setNome(request.getParameter("nome"));
                cliente.setSexo(request.getParameter("sexo"));
                cliente.setCpf(request.getParameter("cpf"));
                
                String nascimentoStr = request.getParameter("nascimento");
                DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
                java.util.Date nascimentoUtil = format.parse(nascimentoStr);
                java.sql.Date nascimentoSql = new java.sql.Date(nascimentoUtil.getTime());
                cliente.setNascimento(nascimentoSql);
                
                cliente.setTelefone(request.getParameter("telefone"));
                cliente.setEmail(request.getParameter("email"));
                cliente.setSenha(request.getParameter("senha"));
                cliente.setCep(request.getParameter("cep"));
                cliente.setEndereco(request.getParameter("endereco"));
                cliente.setEndNumero(request.getParameter("numero"));
                cliente.setEndComplemento(request.getParameter("complemento"));
                cliente.setBairro(request.getParameter("bairro"));
                cliente.setCidade(request.getParameter("cidade"));
                cliente.setEstado(request.getParameter("estado"));
                cliente.setPerfil(Integer.parseInt(request.getParameter("perfil")));
                
                ClienteDAO clienteDAO = new ClienteDAO();
                clienteDAO.atualizarCliente(cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/Gerentes?action=buscarf");
                rd.forward(request,response);
            }
            if ("alterarc".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                Cliente cliente = new Cliente();
                
                cliente.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                cliente.setNome(request.getParameter("nome"));
                cliente.setSexo(request.getParameter("sexo"));
                cliente.setCpf(request.getParameter("cpf"));
                
                String nascimentoStr = request.getParameter("nascimento");
                DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
                java.util.Date nascimentoUtil = format.parse(nascimentoStr);
                java.sql.Date nascimentoSql = new java.sql.Date(nascimentoUtil.getTime());
                cliente.setNascimento(nascimentoSql);
                
                cliente.setTelefone(request.getParameter("telefone"));
                cliente.setEmail(request.getParameter("email"));
                cliente.setSenha(request.getParameter("senha"));
                cliente.setCep(request.getParameter("cep"));
                cliente.setEndereco(request.getParameter("endereco"));
                cliente.setEndNumero(request.getParameter("numero"));
                cliente.setEndComplemento(request.getParameter("complemento"));
                cliente.setBairro(request.getParameter("bairro"));
                cliente.setCidade(request.getParameter("cidade"));
                cliente.setEstado(request.getParameter("estado"));
                cliente.setPerfil(1);
                
                ClienteDAO clienteDAO = new ClienteDAO();
                clienteDAO.atualizarCliente(cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/Gerentes?action=buscarc");
                rd.forward(request,response);
            }
            if ("excluirf".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                Cliente cliente = new Cliente();
                cliente.setIdCliente(Integer.parseInt(request.getParameter("id")));
                ClienteDAO clienteDAO = new ClienteDAO();
                clienteDAO.removerCliente(cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/Gerentes?action=buscarf");
                rd.forward(request,response);
            }
            if ("excluirc".equals(request.getParameter("action"))) {
                String escolha = request.getParameter("escolha");
                String str = request.getParameter("str");
                Cliente cliente = new Cliente();
                cliente.setIdCliente(Integer.parseInt(request.getParameter("id")));
                ClienteDAO clienteDAO = new ClienteDAO();
                clienteDAO.removerCliente(cliente);
                request.setAttribute("escolha", escolha);
                request.setAttribute("str", str);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/gerente/Gerentes?action=buscarc");
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
        } catch (ParseException ex) {
            Logger.getLogger(Gerentes.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Gerentes.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Gerentes.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (ParseException ex) {
            Logger.getLogger(Gerentes.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Gerentes.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Gerentes.class.getName()).log(Level.SEVERE, null, ex);
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
