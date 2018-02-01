/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;

import VO.Funcionario;
import VO.Socio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.management.PersistentMBean;


/**
 *
 * @author jao
 */
public class PERFuncionario extends Persistencia{
    private Funcionario f;
    private conexao conexao = new conexao();
    private Connection con;
    
    public PERFuncionario(Funcionario f){
        this.f = f;
    }

//retorna 0 se nao existe e um codigo de setor caso senha e cpf sejam validos
    public int consultarFuncionarioCPFSetor(String cpf , String senha){
        
        ResultSet rs;
        String query;
        
        try{
                  query = " select * from funcionario where "
                          + "cpf = '" + cpf +"' and senha = '" + senha + "'";

            rs = super.ExecuteQuery(query);
            int setor = 0;
            //verifica se o resultset é vazio
            if(rs.next()){
                setor = rs.getInt("idsetor");
                
            }
            return setor;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return 0;          
            
        }
    }
    ///retorna verdadeiro se eh chefe
     public boolean consultarFuncionarioCPFChefe(String cpf){
        
        ResultSet rs;
        String query;
        
        try{
                  query = " select * from funcionario where "
                          + "cpf = '" + cpf +"'";

            rs = super.ExecuteQuery(query);
            boolean chefe = false;
            //verifica se o resultset é vazio
            if(rs.next()){
                chefe = rs.getBoolean("eh_diretor");
                
            }
            return chefe;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return false;          
            
        }
    }
    
}
