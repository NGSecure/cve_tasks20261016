/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.teste;

import br.com.magazine.dao.ClienteDAO;
import br.com.magazine.dao.EditoraDAO;
import br.com.magazine.dao.GeneroDAO;
import br.com.magazine.dao.ProdutoDAO;
import br.com.magazine.entidade.Produto;
import br.com.magazine.entidade.Genero;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;


        public class TesteProdutoDAO {    
        

        public static void main(String[] args) throws ParseException, ClassNotFoundException, SQLException {
        //Cadastro
       Genero genero = new Genero();
       genero.setNome("Linhares");
       genero.setIdGenero(2);
            
        Produto produto = new Produto();
        produto.setTitulo("Evandro iz");
        produto.setAutor("Bruno Sella");
        produto.setEditora("1");
        produto.setPreco(20.89);
        produto.setGenero(genero);
        ProdutoDAO produtoDAO = new ProdutoDAO();
      int oi =  produtoDAO.cadastrarProduto(produto);
        System.out.println(oi);
        
            
            

            
        
        
        //Listar
//        List<Produto> listaProdutos = new ArrayList();
//        ProdutoDAO produtoDAO = new ProdutoDAO();
//        listaProdutos = produtoDAO.listarProduto();
//        for(Produto teste : listaProdutos){
//            System.out.println(teste.getTitulo());;
        }
    }
/**
 *
 * @author brunosella
 */

    

