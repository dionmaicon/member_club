/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PER;

import RN.RNEndereco;
import RN.Util;
import VO.Endereco;
import VO.Socio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Dion
 */
public class PERSocio extends Persistencia{

    private Socio socio;
    private conexao conexao = new conexao();
    private Connection con;
    
    public PERSocio(Socio socio){
        this.socio = socio;
    }
    public boolean cadastrar(){
        int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into socio (nome,dt_nasc, cpf, rg, celular, mail, formacao, senha, apto_piscina, telefone, profissao, salario_mensal, outras_rendas, id_endereco) "
                    + "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            stm.setString(i++, socio.getNome());
            stm.setDate(i++, new java.sql.Date(socio.getDt_nasc().getTime()));
            stm.setString(i++, socio.getCpf());
            stm.setString(i++, socio.getRg());
            stm.setString(i++, socio.getCelular());
            stm.setString(i++, socio.getMail());
            stm.setString(i++, socio.getFormacao());
            stm.setString(i++, socio.getSenha());
            stm.setBoolean(i++, socio.getApto_piscina());
            stm.setString(i++, socio.getTelefone());
            stm.setString(i++, socio.getProfissao());
            stm.setDouble(i++, socio.getSalario_mensal());
            stm.setDouble(i++, socio.getOutras_rendas());
            stm.setInt(i++, socio.getEndereco().getId());
            
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                socio.setId(key);
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return status > 0;
    }
    
    //retorna verdadeiro se o socio existe
    public boolean consultarID(){
        
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from socio where "
                    + "idtitular = "+ socio.getId() +" ;";

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
    public boolean consultarCPF(){
        
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from socio where "
                    + "cpf = '"+ socio.getCpf()+"' ";

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
    //Instancia um socio cadastrado
    public Socio consultarSocio(){
        
        ResultSet rs;
        String query;
        
        try{
                  query = " select * from socio where "
                          + "idtitular = " + socio.getId() +" ;";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            if(rs.next()){
                socio.setId(rs.getInt("idtitular"));
                socio.setDt_nasc(rs.getDate("dt_nasc"));
                socio.setCpf(rs.getString("cpf"));
                socio.setRg(rs.getString("rg"));
                socio.setCelular(rs.getString("celular"));
                socio.setMail(rs.getString("mail"));
                socio.setApto_piscina(rs.getBoolean("apto_piscina"));
                socio.setTelefone(rs.getString("telefone"));
                socio.setProfissao(rs.getString("profissao"));
                socio.setSalario_mensal(rs.getDouble("salario_mensal"));
                socio.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                socio.setAceito(rs.getBoolean("aceito"));
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(socio.getId());
                socio.setEndereco(rnEndereco.getEndereco());
                
                                
            }
            return socio;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    public Socio consultarSocioCPF(){
        
        ResultSet rs;
        String query;
        
        try{
                  query = " select idtitular, nome, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito from socio where "
                          + "cpf = '" + socio.getCpf()+"' ;";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            if(rs.next()){
                socio.setId(rs.getInt("idtitular"));
                socio.setNome(rs.getString("nome"));
                socio.setDt_nasc(rs.getDate("dt_nasc"));
                socio.setRg(rs.getString("rg"));
                socio.setCelular(rs.getString("celular"));
                socio.setMail(rs.getString("mail"));
                socio.setSenha(rs.getString("senha"));
                socio.setApto_piscina(rs.getBoolean("apto_piscina"));
                socio.setTelefone(rs.getString("telefone"));
                socio.setProfissao(rs.getString("profissao"));
                socio.setSalario_mensal(rs.getDouble("salario_mensal"));
                socio.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                socio.setAceito(rs.getBoolean("aceito"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(socio.getId());
                socio.setEndereco(rnEndereco.getEndereco());
                
                                
            }
            return socio;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    public ArrayList<Socio> consultarSocios(){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
        try{
                  query = " select nome, idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, cpf from socio order by idtitular";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
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
                    "UPDATE socio SET "
                            + "nome = ?, "
                            + "dt_nasc = ?, "
                            + "idtitular = ?, "
                            + "rg = ?, "
                            + "celular = ?, "
                            + "mail = ?, "
                            + "formacao = ?, "
                            + "senha = ?, "
                            + "apto_piscina = ?, "
                            + "telefone = ?, "
                            + "profissao = ?, "
                            + "salario_mensal = ?, "
                            + "outras_rendas = ?, "
                            + "id_endereco = ? "
                            + "WHERE cpf = ?";
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            int i = 1;
            stm.setString(i++, socio.getNome());
            stm.setDate(i++, new java.sql.Date(socio.getDt_nasc().getTime()));
            stm.setInt(i++, socio.getId());
            stm.setString(i++, socio.getRg());
            stm.setString(i++, socio.getCelular());
            stm.setString(i++, socio.getMail());
            stm.setString(i++, socio.getFormacao());
            stm.setString(i++, socio.getSenha());
            stm.setBoolean(i++, socio.getApto_piscina());
            stm.setString(i++, socio.getTelefone());
            stm.setString(i++, socio.getProfissao());
            stm.setDouble(i++, socio.getSalario_mensal());
            stm.setDouble(i++, socio.getOutras_rendas());
            stm.setInt(i++, socio.getEndereco().getId());
            
            stm.setString(i++, ""+ socio.getCpf() +"");
            
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
    public boolean aceitar() {
      int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            String query = 
                    "UPDATE socio SET "
                            + "aceito = true "
                            + "WHERE cpf = ?";
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            
            stm.setString(1, ""+socio.getCpf()+"");
            
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
    
    public void apto() {
     
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            String query = 
                    "UPDATE socio SET "
                            + "apto_piscina = true "
                            + "WHERE cpf = ?";
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            
            stm.setString(1, ""+socio.getCpf()+"");
            
            // Confere se alguma linha do BD foi modificada
             stm.executeUpdate();
                    
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }
        
    public boolean analisar() {
      int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            String query = 
                    "UPDATE socio SET "
                            + "analise = true "
                            + "WHERE cpf = ?";
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            
            stm.setString(1, ""+socio.getCpf()+"");
            
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

   
    public void adicionarListaAnalise(boolean passou){
        int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into analise( cpf , passou) "
                    + "values (?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            stm.setString(i++, socio.getCpf());
            stm.setBoolean(i++, passou);
                        
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        
    }
     public ArrayList<Socio> consultarSociosAnaliseUm(){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
        try{
                  query = " select nome, idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, socio.cpf from socio, analise where socio.cpf = analise.cpf and analise.passou is true and socio.aceito is false order by idtitular";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }

    
    public boolean consultarLista(){
        
        ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from analise where "
                    + "cpf = '"+ socio.getCpf()+"' ";

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

    
   public ArrayList<Socio> consultarSociosAnalise(){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
        try{
                  query = " select nome, idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, cpf from socio where socio.analise is false and aceito is false order by idtitular";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }

    
    public void adicionarListaNegados(String motivo){
        
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into negados( cpf , motivo) "
                    + "values (?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            stm.setString(i++, socio.getCpf());
            stm.setString(i++, motivo);
                        
            // Confere se alguma linha do BD foi modificada
            stm.executeUpdate();
                        
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        
    }

     public void deletar() {
        ResultSet rs;
        String query1;
        String query2;
        String query3;
        
                   query1 = " delete from socio where "
                    + "idtitular = "+ socio.getId() +" ";
        
                   query2 = " delete from endereco where "
                    + "idendereco = "+ socio.getEndereco().getId() +" ";
                   
                   query3 = " delete from analise where "
                    + "cpf = '"+ socio.getCpf() +"' ";

            super.ExecuteUpdate(query1);
            super.ExecuteUpdate(query2);
            super.ExecuteUpdate(query3);
    }

    //consulta socios aceitos que nao tiveram o boleto de joia emitido
    public ArrayList<Socio> consultarSociosAceitos(){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
        try{
                  query = " select nome, idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, cpf from socio where socio.aceito is true and socio.idtitular not in ("
                          + "select idtitular from joia where idtitular is not null) order by socio.idtitular";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    //Consulta socios que tem joia paga.
    public ArrayList<Socio> consultarSociosRegulares(){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
        try{
                  query = " select nome, socio.idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, cpf from socio,joia where socio.aceito is true and joia.pago is true order by socio.idtitular";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    //consulta socios com joia em debito
    public ArrayList<Socio> consultarSociosDebitos(){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
        try{
                  query = " select nome, idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, cpf from socio, joia where socio.aceito is true and socio.idtitular = joia.idtitular and"
                          + "joia.pago is false";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
        
    }
    //Consulta todos os socios que estao com pagamento atrasado no  mes e ano informados
    public ArrayList<Socio> consultarSociosDebitosMensalidade(int mes, int ano){
        
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
                   
        try{
                  query = " select nome, socio.idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, cpf from socio, pagamento,joia where socio.aceito is true and socio.idtitular = pagamento.idtitular and "
                          + "pagamento.pago is false and mes_de_referencia = "+ mes +" and ano_de_referencia = " + ano+" and joia.pago is true group by socio.idtitular,"
                          + "socio.nome,socio.dt_nasc, socio.rg, socio.celular, socio.mail, socio.senha, socio.apto_piscina, socio.telefone, socio.profissao, socio.salario_mensal, socio.outras_rendas, socio.id_endereco, socio.aceito, socio.cpf ";

            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    }
    // Consulta a soma de todas as joias pagas
    public Double consultarTotalJoiasPagas() {
        
        ResultSet rs;
        String query;
     
                  query = "select SUM(valor) as total from joia where pago is true";

            rs = super.ExecuteQuery(query);
        Double soma = 0.0;   
        try {
            while(rs.next()){
                soma += rs.getDouble("total") ; 
            }
        } catch (SQLException ex) {
            Logger.getLogger(PERSocio.class.getName()).log(Level.SEVERE, null, ex);
        }
        return soma;
    }

    public void enviarBoletoJoia(Double valor) {
        int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into joia (idtitular,pago, valor) "
                    + "values (?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            
            stm.setInt(i++, socio.getId());
            stm.setBoolean(i++, false);
            stm.setDouble(i++, valor);
           
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        
    }

    public void inserirTabelaInadimplentes() {
        int status = 0;
        
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into inadimplentes(idtitular, cpf, nome, telefone) "
                    + "values (?,?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            
            stm.setInt(i++, socio.getId());
            stm.setString(i++, socio.getCpf());
            stm.setString(i++, socio.getNome());
            stm.setString(i++, socio.getTelefone());
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
                //System.out.println(key);
                // Adicionando pro Objeto o devido ID
                
            }
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    public void deletarTabelaInadimplentes(){
        ResultSet rs;
        String query1;
        
        
                   query1 = " truncate inadimplentes";
        
                  
            super.ExecuteUpdate(query1);
    }

    public ArrayList<Socio> consultarSociosDebitosInadimplentes(boolean contatado) {
            
        ResultSet rs;
        String query;
        ArrayList<Socio> list = new ArrayList<>();
                   
        try{
            if (contatado) {
                  query = " select socio.nome, socio.idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, socio.telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, socio.cpf from socio, inadimplentes where socio.aceito is true and inadimplentes.contatado is true and socio.idtitular = inadimplentes.idtitular";
            }else{
                query = " select socio.nome, socio.idtitular, dt_nasc, rg, celular,mail, senha, apto_piscina, socio.telefone, profissao, salario_mensal, "
                          + "outras_rendas, id_endereco, aceito, socio.cpf from socio, inadimplentes where socio.aceito is true and inadimplentes.contatado is false and socio.idtitular = inadimplentes.idtitular";
            }
            rs = super.ExecuteQuery(query);
             
            //verifica se o resultset é vazio
            while(rs.next()){
                Socio s = new Socio();
                s.setId(rs.getInt("idtitular"));
                s.setDt_nasc(rs.getDate("dt_nasc"));
                s.setRg(rs.getString("rg"));
                s.setCelular(rs.getString("celular"));
                s.setMail(rs.getString("mail"));
                s.setSenha(rs.getString("senha"));
                s.setApto_piscina(rs.getBoolean("apto_piscina"));
                s.setTelefone(rs.getString("telefone"));
                s.setProfissao(rs.getString("profissao"));
                s.setSalario_mensal(rs.getDouble("salario_mensal"));
                s.setOutras_rendas(rs.getDouble("outras_rendas"));
                Endereco endereco = new Endereco();
                endereco.setId(rs.getInt("id_endereco"));
                s.setAceito(rs.getBoolean("aceito"));
                s.setNome(rs.getString("nome"));
                s.setCpf(rs.getString("cpf"));
 
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.consultarEnderecoSocio(s.getId());
                s.setEndereco(rnEndereco.getEndereco());
                
                list.add(s);
            }
            return list;
        }catch(SQLException e){
            
            //System.out.printf("erro de sql pesquisar com id %s\n", e);
            return null;          
            
        }
    
    }

    public void inserirNovaMensalidade(Double valor, int mes, int ano) {
       int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            // SQL que vai ser executada
            String query = "insert into pagamento (idtitular, valor, mes_de_referencia, ano_de_referencia, pago) "
                    + " values (?,?,?,?,?) ";
            
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            
            stm.setInt(i++, socio.getId());
            stm.setDouble(i++, valor);
            stm.setInt(i++, mes);
            stm.setInt(i++, ano);
            stm.setBoolean(i++, false);
            
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
            
            if(status == 1) {
                // Reebendo o ID recentemente adicionado no BD
                ResultSet keys = stm.getGeneratedKeys();    
                keys.next();  
                
                int key = keys.getInt(1);
               
            }
            
            conexao.desconectar();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        
    }

    public boolean consultarTabelaPagamentos(int mes, int ano) {
      ResultSet rs;
        String query;
        int aux = 0;
        try{
            query = " select * from pagamento where "
                    + "mes_de_referencia = "+ mes + " and ano_de_referencia = "+ ano+ "";

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

    public void retirarInadimplentes() {
        int status = 0;
        try {
            // Connect with database
            
            Connection con = conexao.conectar();
            
            String query = 
                    "UPDATE inadimplentes SET "
                            + " data_contato = now(), "
                            + " contatado = true "
                            + " WHERE cpf = ? ";
            PreparedStatement stm;
            // Statement.RETURN_GENERATED_KEYS retorna os ID gerados pelo Statement no BD
            stm = con.prepareStatement(query);
            
            stm.setString(1, ""+socio.getCpf()+"");
            
            // Confere se alguma linha do BD foi modificada
            status = stm.executeUpdate();
                    
            conexao.desconectar();
            return;
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return;
    }
    
}
  



