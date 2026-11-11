/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.dao;

import br.com.magazine.entidade.Produto;
import br.com.magazine.util.ConnectionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Groupo X
 */
public class ProdutoDAO {
    //sem imagem
    private final String stmtCadastraProduto = "insert into produto (titulo, autor, fkeditora, preco, fkgenero) values (?,?,?,?,?)";
    //private final String stmtCadastraProduto = "insert into produto (titulo, autor, editora, categoria, preco, genero, idImg) values (?,?,?,?,?,?)";
    private final String stmtAtualizaProduto = "update produto set titulo = ?, autor = ?, editora = ?, preco = ?, genero = ? where idProduto = ?";
    private final String stmtRemoveProduto = "update produto set inativo = true where idProduto = ?";
    private final String stmtListaProduto = "select * from produto";
//
    
    public int cadastrarProduto (Produto p) throws ClassNotFoundException{ 
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = ConnectionFactory.getConnection();
            con.setAutoCommit(false);
            stmt = con.prepareStatement(stmtCadastraProduto, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, p.getTitulo());
            stmt.setString(2, p.getAutor());
            stmt.setInt(3, Integer.parseInt(p.getEditora()));
            stmt.setDouble(4, p.getPreco());
            stmt.setString(5, p.getGenero().getNome());
            //sem imagem
            //stmt.setInt(6, p.getidImg());
            stmt.executeUpdate();
            con.commit();
            
             try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                return generatedKeys.getInt("idimg");
            }
            else {
                throw new SQLException("Creating user failed, no ID obtained.");
            }
        }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inserir um produto no banco de dados. Origem: " + e.getMessage());
        } finally {
            try {
                stmt.close();
            } catch (SQLException ex) {
                System.out.println("Erro ao fechar statement. Ex = " + ex.getMessage());
            }
            try {
                con.close();
            } catch (SQLException ex) {
                System.out.println("Erro ao fechar a conexao. Ex = " + ex.getMessage());
            }
        }
        
    }
        public void atualizarProduto(Produto p) throws ClassNotFoundException {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = ConnectionFactory.getConnection();
            con.setAutoCommit(false);
            stmt = con.prepareStatement(stmtAtualizaProduto);
            stmt.setString(1, p.getTitulo());
            stmt.setString(2, p.getAutor());
            stmt.setString(3, p.getEditora());
            stmt.setDouble(4, p.getPreco());
            stmt.setString(5, p.getGenero().getNome());
            stmt.setInt(6, p.getIdProduto());
            stmt.executeUpdate();
            con.commit();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                stmt.close();
            } catch (SQLException ex) {
                System.out.println("Erro ao fechar statement. Ex = " + ex.getMessage());
            }
            try {
                con.close();
            } catch (SQLException ex) {
                System.out.println("Erro ao fechar a conexao. Ex =" + ex.getMessage());
            }
        }
    }
     
        public void removerProduto(Produto p) throws ClassNotFoundException {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = ConnectionFactory.getConnection();
            stmt = con.prepareStatement(stmtRemoveProduto);
            stmt.setInt(1, p.getIdProduto());
            stmt.executeUpdate();
            con.commit();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                stmt.close();
            } catch (Exception ex) {
                System.out.println("Erro ao fechar stmt. Ex=" + ex.getMessage());
            }
            try {
                con.close();
            } catch (Exception ex) {
                System.out.println("Erro ao fechar conexao. Ex = " + ex.getMessage());
            }
        }
    }
        
     
        
        
    public List<Produto> listarProduto() throws SQLException, ClassNotFoundException {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = ConnectionFactory.getConnection();
            stmt = con.prepareStatement(stmtListaProduto);
            rs = stmt.executeQuery();
            List<Produto> listaProdutos = new ArrayList();
            while (rs.next()) {
                Produto produto = new Produto();
                produto.setIdProduto(rs.getInt("idProduto"));
                produto.setTitulo(rs.getString("titulo"));
                listaProdutos.add(produto);
            }
            return listaProdutos;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                rs.close();
            } catch (Exception ex) {
                System.out.println("Erro ao fechar result set.Erro: " + ex.getMessage());
            }
            try {
                stmt.close();
            } catch (SQLException ex) {
                System.out.println("Erro ao fechar statement. Ex = " + ex.getMessage());
            }
            try {
                con.close();
            } catch (SQLException ex) {
                System.out.println("Erro ao fechar a conexao. Ex = " + ex.getMessage());
            }
        }

    }    
        
        
    }
