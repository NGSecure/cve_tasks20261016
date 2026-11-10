
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.teste;

import br.com.magazine.dao.GeneroDAO;
import br.com.magazine.entidade.Genero;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Evandro-PC
 */
public class TesteGeneroDAO {

    public static void main(String[] args) throws ParseException, ClassNotFoundException, SQLException {
        //Cadastrar

//        Genero genero = new Genero();
//        genero.setNome("Aventura");
//        
//        GeneroDAO generoDAO = new GeneroDAO();
//        generoDAO.cadastrarGenero(genero);
        
        
        //Listar
        List<Genero> listaGeneros = new ArrayList();
        GeneroDAO generoDAO = new GeneroDAO();
        listaGeneros = generoDAO.listarGeneros();
        for(Genero teste : listaGeneros){
            System.out.println(teste.getNome());
        }
        
        
        
        //Alterar
//        Genero genero = new Genero();
//        genero.setIdGenero(2);
//        genero.setNome("NovoGen");
//        GeneroDAO generoDAO = new GeneroDAO();
//        generoDAO.atualizarGenero(genero);
        
        
        
//        Remover
//        Genero genero = new Genero();
//        genero.setIdGenero(4);
//        GeneroDAO generoDAO = new GeneroDAO();
//        generoDAO.removerGenero(genero);
//
    }
}
