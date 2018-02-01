/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;


import VO.Ambiente;
import VO.Reserva;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 *
 * @author jao
 */
public class PERAmbiente extends Persistencia{
    private conexao conexao = new conexao();
    private Connection con;
    
    private Ambiente ambiente;
    
    public PERAmbiente(Ambiente ambiente) {
        this.ambiente = ambiente;
    }

    public PERAmbiente() {
    
    }

    public ArrayList<Ambiente> getTodosAmbientes() {
        ResultSet rs;
        String query;
        
        ArrayList<Ambiente> list = new ArrayList<>();
        
        try{
            
            query = "select idambiente, nome from ambiente";

            rs = super.ExecuteQuery(query);
            
            //verifica se o resultset é vazio
            while(rs.next()){
                
                Ambiente ambiente1  = new Ambiente();
                
                ambiente1.setIdambiente(rs.getInt("idambiente"));
                ambiente1.setNome(rs.getString("nome"));
                
                list.add(ambiente1);
            }            
            return list;
            
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }

    public void atualizar() {
        
    }

    public boolean consultarAmbientePorId() {
     ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from ambiente where "
                    + "idambiente = "+ ambiente.getIdambiente() +" ;";

            rs = super.ExecuteQuery(query);
            
            //conta quantas linhas voltaram de resultado
            while (rs.next()){
                aux++;
            }
        
            return aux > 0;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return false;          
            
        }
    
    }
    public Ambiente getAmbientePorID() {
        ResultSet rs;
        String query;
        ArrayList<Ambiente> list = new ArrayList<>();
        
        try{
            query = " select * from ambiente where "
                    + "idambiente = "+ ambiente.getIdambiente() +" ;";
            
            rs = super.ExecuteQuery(query);
            
            //verifica se o resultset é vazio
            while(rs.next()){
                Ambiente ambiente1 = new Ambiente();
                ambiente1.setIdambiente( rs.getInt("idambiente"));
                ambiente1.setNome(rs.getString("nome"));
                
                list.add(ambiente1);
            }
            
            return list.get(0);
            
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    
    }

    public boolean cadastrar() {
                    int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into ambiente( idambiente,nome) "
                    + "values (?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            
            stm.setInt(i++, ambiente.getIdambiente());
            stm.setString(i++, ambiente.getNome());
           
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                ambiente.setIdambiente(key);
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;  
    }
    
}
