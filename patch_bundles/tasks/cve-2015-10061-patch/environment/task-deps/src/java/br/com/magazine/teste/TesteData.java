/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.magazine.teste;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 *
 * @author Evandro-PC
 */
public class TesteData {
   public static void main(String[] args) throws ParseException{
       String dataStr = "12/02/2012";
       DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
       java.util.Date utilData = format.parse(dataStr);
       java.sql.Date sqlData = new java.sql.Date(utilData.getTime());
       System.out.println(sqlData);
   } 
}
