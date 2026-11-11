/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.dao;
import br.com.magazine.entidade.Editora;
import br.com.magazine.entidade.Genero;
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
public class EditoraDAO {
    //sem imagem
    private final String stmtCadastraEditora = "insert into editora (nome) values (?)";
    private final String stmtAtualizaEditora = "update editora set nome = ? where idEditora = ?";
    private final String stmtListaEditora = "select * from editora order by nome";
    private final String stmtRemoveEditora = "delete from editora where idEditora= ?";
    private final String stmtBuscaIdEditora = "select idEditora from editora where nome = ?";


    public void cadastrarEditora (Editora editora) throws ClassNotFoundException{ 
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = ConnectionFactory.getConnection();
            con.setAutoCommit(false);
            stmt = con.prepareStatement(stmtCadastraEditora, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, editora.getNome());
            stmt.executeUpdate();
            con.commit();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inserir uma editora no banco de dados. Origem: " + e.getMessage());
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
    
    public List<Editora> listarEditoras() throws SQLException, ClassNotFoundException {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = ConnectionFactory.getConnection();
            stmt = con.prepareStatement(stmtListaEditora);
            rs = stmt.executeQuery();
            List<Editora> listaEditoras = new ArrayList();
            while (rs.next()) {
                Editora editora = new Editora();
                editora.setIdEditora(rs.getInt("idEditora"));
                editora.setNome(rs.getString("nome"));
                listaEditoras.add(editora);
            }
            return listaEditoras;

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
    
        public void atualizarEditora(Editora ed) throws ClassNotFoundException {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = ConnectionFactory.getConnection();
            con.setAutoCommit(false);
            stmt = con.prepareStatement(stmtAtualizaEditora);
            stmt.setString(1, ed.getNome());
            stmt.setInt(2, ed.getIdEditora());
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
                System.out.println("Erro ao fechar a conexao. Ex = " + ex.getMessage());
            }
        }
    }
        
        public void removerEditora(Editora editora) throws ClassNotFoundException {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = ConnectionFactory.getConnection();
            stmt = con.prepareStatement(stmtRemoveEditora);
            stmt.setLong(1, editora.getIdEditora());
            stmt.executeUpdate();
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
        
        public Editora buscarIdEditora(Editora editora) throws ClassNotFoundException{
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                con = ConnectionFactory.getConnection();
                con.setAutoCommit(false);
                stmt = con.prepareStatement(stmtBuscaIdEditora);
                stmt.setString(1, editora.getNome());
                rs = stmt.executeQuery();
                rs.next();
                editora.setIdEditora(rs.getInt("idEditora"));
                return editora;
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
                    System.out.println("Erro ao fechar a conexao. Ex = " + ex.getMessage());
            }
        }
        }
    
    
}
