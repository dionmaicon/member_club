/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import PER.PERFuncionario;
import VO.Funcionario;

/**
 *
 * @author jao
 */
public class RNFuncionario {
    private Funcionario f;

    public RNFuncionario(Funcionario f) {
        this.f = f;
    }
    
    public boolean consultarFuncionarioCPFChefe(String cpf){
        PERFuncionario pers = new PERFuncionario(f);
        return pers.consultarFuncionarioCPFChefe(cpf);
    }
    public int consultarFuncionarioCPFSetor(String cpf, String senha){
        PERFuncionario pers = new PERFuncionario(f);
        return pers.consultarFuncionarioCPFSetor(cpf, senha);
    }
}
