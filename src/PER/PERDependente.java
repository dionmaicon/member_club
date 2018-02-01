/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;

import RN.RNSocio;
import VO.Dependente;
import VO.Socio;
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
public class PERDependente extends Persistencia{
    
    private Dependente dependente;
    private conexao conexao = new conexao();
    private Connection con;
    
    public PERDependente(Dependente dependente) {
        this.dependente = dependente; //To change body of generated methods, choose Tools | Templates.
    }

    public PERDependente() {

    }

    public Dependente consultarDepente() {
      ResultSet rs;
        String query;
        
        try{
                  query = " select * from dependente where "
                          + " rg = '" + dependente.getRg()+"' ;";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            if(rs.next()){
                dependente.setId(rs.getInt("iddependente"));
                dependente.setApto_piscina(rs.getBoolean("apto_piscina"));
                dependente.setNome(rs.getString("nome"));
                Socio socio = new Socio();
                socio.setId(rs.getInt("idtitular"));
                RNSocio rnSocio = new RNSocio(socio);
                socio = rnSocio.consultarSocio();
                dependente.setSocio(socio);
                                
            }
            return dependente;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }

    public boolean consultarRG(){
        
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from dependente where "
                    + "rg = '"+ dependente.getRg() +"' ";

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

    public boolean atualizar() {
      int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            // UPDATE automovel SET modelo = focuss WHERE idAutomovel = ?;

            String query = 
                    "UPDATE dependente SET "
                            + "nome = ?, "
                            //+ "iddependente = ?, "
                            + "apto_piscina = ? "
                            + "WHERE rg = ?";
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            int i = 1;
            stm.setString(i++, dependente.getNome());
            //stm.setInt(i++, dependente.getSocio().getId());
            //stm.setInt(i++, dependente.getId());
            stm.setBoolean(i++, dependente.getApto_piscina());
            
            stm.setString(i++, ""+dependente.getRg()+"");
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
                    
            conexao.desconectar();
            return status == 1;
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;
    }

    public boolean cadastrar(){
        int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into dependente (nome, idtitular, rg, apto_piscina) "
                    + "values (?,?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            stm.setString(i++, dependente.getNome());
            stm.setInt(i++, dependente.getSocio().getId());
            stm.setString(i++, dependente.getRg());
            stm.setBoolean(i++, dependente.getApto_piscina());
            
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                dependente.setId(key);
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;
    }


    public int consultarQuantidadeDependentesPorSocio() {
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from dependente where "
                    + "idtitular = "+ dependente.getSocio().getId() +" ";

            rs = super.ExecuteQuery(query);
            
            //conta quantas linhas voltaram de resultado
            while (rs.next()){
                aux++;
            }
        
            return aux ;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
        return aux ;          
            
        } //To change body of generated methods, choose Tools | Templates.
    }
    public int deletar() {
        ResultSet rs;
        String query;
        int aux = 0;
                   query = " delete from dependente where "
                    + "idtitular = "+ dependente.getSocio().getId() +" ";

            aux = super.ExecuteUpdate(query);
            
                        
            return aux ;
        
    }
    
    public ArrayList<Dependente> getTodosDependentes() {
      ResultSet rs;
        String query;
        ArrayList<Dependente> list = new ArrayList<>();
        try{
                  query = " select * from dependente ";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                
                Dependente dependente1 = new Dependente();
                
                dependente1.setId(rs.getInt("iddependente"));
                dependente1.setApto_piscina(rs.getBoolean("apto_piscina"));
                dependente1.setNome(rs.getString("nome"));
                Socio socio = new Socio();
                socio.setId(rs.getInt("idtitular"));
                RNSocio rnSocio = new RNSocio(socio);
                socio = rnSocio.consultarSocio();
                dependente1.setSocio(socio);
               
                list.add(dependente1);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }

    public void apto(int id) {
      
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            // UPDATE automovel SET modelo = focuss WHERE idAutomovel = ?;

            String query = 
                    "UPDATE dependente SET "
                            + "apto_piscina = true "
                            + "WHERE iddependente = " + id;
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            
            stm.executeUpdate();
                    
            conexao.desconectar();
           
        }
        catch(Exception e) {
            e.printStackTrace();
        }
  
    }
}
