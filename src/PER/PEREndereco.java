/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;

import VO.Endereco;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 *
 * @author Lucas
 */
public class PEREndereco extends Persistencia{

    private Endereco endereco;
    private conexao conexao = new conexao();
    private Connection con;
    
    public PEREndereco(Endereco endereco){
        this.endereco = endereco;
    }
    public boolean cadastrar(){
        int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into endereco (rua, bairro, cidade, estado, numero) "
                    + "values (?,?,?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            stm.setString(i++, endereco.getRua());
            stm.setString(i++, endereco.getBairro());
            stm.setString(i++, endereco.getCidade());
            stm.setString(i++, endereco.getEstado());
            stm.setString(i++, endereco.getNumero());
            
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                endereco.setId(key);
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;
    }
    
    //este pesquisar utiliza o um id e devolve um vo com as informações deste endereço
    //retorno nulo erro de sql
    public boolean consultarEnderecoPorID(){
        
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from endereco where "
                    + "idendereco = "+ endereco.getId() +" ;";

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
    
    public Endereco consultarEnderecoSocio(int idSocio){
        
        ResultSet rs;
        String query;
        
        try{
                  query = " select * from endereco, socio where "
                          + "endereco.idendereco ="+" socio.id_endereco and "
                          + "socio.idtitular = " + idSocio +" ;";

            rs = super.ExecuteQuery(query);
            
            //verifica se o resultset é vazio
            if(rs.next()){
                endereco.setId(rs.getInt("idendereco"));
                endereco.setRua(rs.getString("rua"));
                endereco.setBairro(rs.getString("bairro"));
                endereco.setCidade(rs.getString("cidade"));
                endereco.setNumero(rs.getString("numero"));
                endereco.setEstado(rs.getString("estado"));
                
            }
            return endereco;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    public boolean atualizar() {
      int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            // UPDATE automovel SET modelo = focuss WHERE idAutomovel = ?;

            String query = 
                    "UPDATE endereco SET "
                            + "rua = ?, "
                            + "bairro = ?, "
                            + "cidade = ?, "
                            + "estado = ?, "
                            + "numero = ? "
                            + "WHERE idendereco = ?";
            
            PreparedStatement stm;
            stm = con.prepareStatement(query);
            int i = 1;
            stm.setString(i++, endereco.getRua());
            stm.setString(i++, endereco.getBairro());
            stm.setString(i++, endereco.getCidade());
            stm.setString(i++, endereco.getEstado());
            stm.setString(i++, endereco.getNumero());
            
            stm.setInt(i++, endereco.getId());
            
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
                       
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;
    }
    
}
  



