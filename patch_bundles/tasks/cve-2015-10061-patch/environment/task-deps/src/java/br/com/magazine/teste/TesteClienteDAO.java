
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.teste;

import br.com.magazine.dao.ClienteDAO;
import br.com.magazine.entidade.Cliente;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Evandro-PC
 */
public class TesteClienteDAO {
    public static void main(String[] args) throws ParseException, ClassNotFoundException, SQLException{
//    Cliente evandro = new Cliente();
//    evandro.setNome("Evandro Luis Machado");
//    evandro.setSexo("m");
//    evandro.setCpf("123.456.789-99");
//    String nascimentoStr = "25/10/1993";
//    
//    DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
//    java.util.Date nascimentoUtil = format.parse(nascimentoStr);
//    java.sql.Date nascimentoSql = new java.sql.Date(nascimentoUtil.getTime());
//    evandro.setNascimento(nascimentoSql);
//    
//    evandro.setTelefone("(041)3203-8677");
//    evandro.setEmail("evandrolmass@gmail.com");
//    evandro.setSenha("123456");
//    evandro.setCep("82540-080");
//    evandro.setEndereco("Rua Benvenuto Gusso");
//    evandro.setEndNumero("1280");
//    evandro.setEndComplemento("Casa");
//    evandro.setBairro("Boa Vista");
//    evandro.setCidade("Curitiba");
//    evandro.setEstado("Paraná");
//
//    ClienteDAO clienteDAO = new ClienteDAO();
//    clienteDAO.cadastrarCliente(evandro);
        
        
        //Buscar Por ID
//        Cliente cliente = new Cliente();
//        cliente.setId(1);
//        ClienteDAO clienteDAO = new ClienteDAO();
//        cliente = clienteDAO.buscarClienteId(cliente);
//        System.out.println(cliente.getBairro());
//        System.out.println(cliente.getNascimento());
        
        
//        Listar por nome
        List<Cliente> listaClientes = new ArrayList();
        ClienteDAO clienteDAO = new ClienteDAO();
        listaClientes = clienteDAO.buscarFuncionarioNome("R");
//        listaClientes = clienteDAO.buscarClienteCPF("8");
//        listaClientes = clienteDAO.buscarFuncionarioEmail("5");
         for(Cliente teste : listaClientes){
            System.out.println(teste.getNome());
        }
        
    }
}
