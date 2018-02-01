/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import PER.PERAmbiente;
import VO.Ambiente;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author jao
 */
public class RNAmbiente {
    private Ambiente ambiente;
    
    public RNAmbiente() {
    
    }
    public RNAmbiente(Ambiente ambiente) {
        this.ambiente = ambiente;
    }
    public int salvar() throws SQLException/* throws SQLException*/{
        PERAmbiente pers = new PERAmbiente(ambiente);
        if(pers.consultarAmbientePorId()){
            pers.atualizar();
            return 0;
        }      
        if(pers.cadastrar()){
            return 1;
        }
        return -1;
    }

    public Ambiente getAmbientePorID() {
        PERAmbiente pers = new PERAmbiente(ambiente);
        return pers.getAmbientePorID();
    }
    public ArrayList<Ambiente> getTodosAmbientes(){
        PERAmbiente pers = new PERAmbiente();
        return pers.getTodosAmbientes();
    }
    
}
