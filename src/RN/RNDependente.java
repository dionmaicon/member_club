/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import PER.PERDependente;
import VO.Dependente;
import java.util.ArrayList;

/**
 *
 * @author jao
 */
public class RNDependente {
    private Dependente dependente;
    public RNDependente(Dependente dependente) {
        this.dependente = dependente; //To change body of generated methods, choose Tools | Templates.
    }

    public RNDependente() {
    }
    public Dependente consultarDependente(){
        PERDependente pers = new PERDependente(dependente);
        return pers.consultarDepente();
    }
    public int salvar(){
        PERDependente pers = new PERDependente(dependente);
        if(pers.consultarRG()){
            
            pers.atualizar();
            return 0;
        }      
        if(pers.cadastrar()){
            return 1;
        }
        return -1;
    }
//    public Dependente getDependentePeloRG(){
//        PERDependente pers = new PERDependente(dependente);
//        return pers.consultarDepenteRG();
//    }

    public boolean consultarRGDependente() {
         //To change body of generated methods, choose Tools | Templates.
        PERDependente pers = new PERDependente(dependente);
        return pers.consultarRG();
    }
    public int consultarQuantidade(){
        PERDependente pers = new PERDependente(dependente);
        return pers.consultarQuantidadeDependentesPorSocio();
    }

    public void deletar() {
        //To change body of generated methods, choose Tools | Templates.
        PERDependente pers = new PERDependente(dependente);
        pers.deletar();
    }
    public ArrayList<Dependente> getTodosDependentes(){
        PERDependente pers = new PERDependente();
        return pers.getTodosDependentes();
    }

    public void apto(int id) {
        PERDependente pers = new PERDependente(); //To change body of generated methods, choose Tools | Templates.
        pers.apto(id);
    }
}
