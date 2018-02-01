/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import PER.PEREndereco;
import VO.Endereco;
import java.sql.SQLException;

/**
 *
 * @author Lucas
 */
public class RNEndereco {
    
    private Endereco end;
    
    public RNEndereco (Endereco endereco){
        this.end = endereco;
    }
        
    //retorna um objeto endereco
    public Endereco consultarEnderecoSocio(int id){
        PEREndereco persEnd;
        persEnd = new PEREndereco(end);
        
        return persEnd.consultarEnderecoSocio(id);
    }
    
    //salva o enderço caso ele ainda não esteja presente na base
    //retorna true se a operacao foi realizada com sucesso;
    //retorna falso se foi alterado
    public int salvar() throws SQLException/* throws SQLException*/{
        PEREndereco pers = new PEREndereco(end);
        if(pers.consultarEnderecoPorID()){
            pers.atualizar();
            return 0;
        }      
        if(pers.cadastrar()){
            return 1;
        }
        return -1;
    }
    public Endereco getEndereco(){
        return this.end;
    }

    public void update() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
