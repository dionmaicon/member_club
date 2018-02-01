/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;

import RN.RNAmbiente;
import RN.RNSocio;
import RN.Util;
import VO.Ambiente;
import VO.Reserva;
import VO.Socio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author jao
 */
public class PERReserva extends Persistencia{
    
    private conexao conexao = new conexao();
    private Connection con;
    private Reserva reserva;
    
    public PERReserva() {
    
    }

    public PERReserva(Reserva reserva) {
        this.reserva = reserva;
    }

    public boolean cadastrar() {
            int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into reserva (idambiente, idtitular, data_de_solicitacao, data_reserva, hora_reserva, nome_dos_usuarios) "
                    + "values (?,?,now(),?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            stm.setInt(i++, reserva.getAmbiente().getIdambiente());
            stm.setInt(i++, reserva.getSocio().getId());
            stm.setDate(i++, new java.sql.Date(reserva.getData_reserva().getTime()));
            stm.setInt(i++, reserva.getHora_reserva());
            stm.setString(i++, reserva.getNome_dos_usuarios());
           
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                reserva.setId(key);
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;   
    }
//SELECT nasc FROM clientes WHERE extract('month' from nasc ) = 4
    public ArrayList<Reserva> getTodasReservasMes(int mes) {
        ResultSet rs;
        String query;
        Util util = new Util();
        ArrayList<Reserva> list = new ArrayList<>();
                
        try{
                  query = " select * from reserva where "
                          + "extract( 'month' from data_reserva) = " + mes + "";

            rs = super.ExecuteQuery(query);
            
            //verifica se o resultset é vazio
            while(rs.next()){
                Reserva reserva1 = new Reserva();
                
                reserva1.setId(rs.getInt("idreserva"));
                
                Ambiente ambiente = new Ambiente();
                ambiente.setIdambiente(rs.getInt("idambiente"));
                RNAmbiente rn = new RNAmbiente(ambiente);
                ambiente = rn.getAmbientePorID();
                
                Socio socio = new Socio();
                socio.setId(rs.getInt("idtitular"));
                RNSocio rnSocio = new RNSocio(socio);
                socio = rnSocio.consultarSocio();
                
                reserva1.setSocio(socio);
                reserva1.setAmbiente( ambiente);
                reserva1.setData_reserva(rs.getDate("data_reserva"));
                reserva1.setHora_reserva(rs.getInt("hora_reserva"));
                reserva1.setNome_dos_usuarios(rs.getString("nome_dos_usuarios"));
                
                list.add(reserva1);
            }
            
            return list;
            
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    // 
    public ArrayList<Reserva> getTodasReservas(Date data) {
        ResultSet rs;
        String query;
        Util util = new Util();
        String dataP = util.converterDataPostgres(data);
        //System.out.println(dataP);
        ArrayList<Reserva> list = new ArrayList<>();
                
        try{
                  query = " select * from reserva where "
                          + "data_reserva = '" + dataP + "'";

            rs = super.ExecuteQuery(query);
            
            //verifica se o resultset é vazio
            while(rs.next()){
                Reserva reserva1 = new Reserva();
                
                reserva1.setId(rs.getInt("idreserva"));
                
                Ambiente ambiente = new Ambiente();
                ambiente.setIdambiente(rs.getInt("idambiente"));
                RNAmbiente rn = new RNAmbiente(ambiente);
                ambiente = rn.getAmbientePorID();
                
                Socio socio = new Socio();
                socio.setId(rs.getInt("idtitular"));
                RNSocio rnSocio = new RNSocio(socio);
                socio = rnSocio.consultarSocio();
                
                reserva1.setSocio(socio);
                reserva1.setAmbiente( ambiente);
                reserva1.setData_reserva(rs.getDate("data_reserva"));
                reserva1.setHora_reserva(rs.getInt("hora_reserva"));
                reserva1.setNome_dos_usuarios(rs.getString("nome_dos_usuarios"));
                
                list.add(reserva1);
            }
            
            return list;
            
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    public void atualizar() {
        
    }

    public boolean consultarReservaId() {
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from reserva where "
                    + "idreserva = "+ reserva.getID() +" ;";

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
    
}
