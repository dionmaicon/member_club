/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author jao
 */
public abstract class Persistencia {
   
    private conexao conexao = new conexao();
    private Connection con;
    private Statement st;
    private ResultSet rs;

    
    
    //realiza uma inserção, deleção ou atualização na base de dados
    //devolve a quantidade de tuplas atingidas pelas execução do sql
    //ou devolve o número do erro gerado no SQLException
    protected int ExecuteUpdate(String query){
         
        con = conexao.conectar();
        
        try{
            
            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            
            
            //numero de inclusões da tabela vai para auxs
            int aux = st.executeUpdate(query);
            st.getGeneratedKeys();
           
            
            //se aux>0 houveram inclusões caso contrario não
            return  aux;
            
            
        }catch(SQLException e){
            
            return e.getErrorCode();           
        }
        finally{
            conexao.desconectar();
        }
    }
    
     protected ResultSet ExecuteQuery(String query){
         
        con = conexao.conectar();
        
        try{
            
            st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            st.getGeneratedKeys();
            //numero de inclusões da tabela vai para auxs
            rs = st.executeQuery(query);
            
           
            
            //se aux>0 houveram inclusões caso contrario não
            return  rs;
            
            
        }catch(SQLException e){
             e.printStackTrace();
        }
        finally{
            conexao.desconectar();
        }
        return rs;
    }
    public Statement getSt() {
        return st;
    }
    public Connection getConnection(){
        return con;
    }
    
}
