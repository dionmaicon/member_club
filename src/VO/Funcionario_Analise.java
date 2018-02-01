/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VO;

import RN.Util;

/**
 *
 * @author jao
 */
public class Funcionario_Analise extends Funcionario implements Analise {

    public Funcionario_Analise(int id, Setor setor, String nome, String senha, Boolean eh_diretor) {
        super(id, setor, nome, senha, eh_diretor);
    }

   public Funcionario_Analise(){
  
   }

    @Override
    public boolean validar(int idade, String divida, Double renda, Socio socio) {
        Util util = new Util();
        
        String dataMenosAtual = util.converterData(socio.getDt_nasc());
        String dataMaisAtual = util.calcularDataAtual();
        long diferenca = util.calcularDiferencaEntreDatas(dataMaisAtual, dataMenosAtual, "Anos");
        
        if(diferenca > idade && divida.equalsIgnoreCase("Nao") && socio.getSalario_mensal() >= renda ){
            System.out.println("Idade:"+ diferenca + "sdalario "+ socio.getSalario_mensal());
            return true;
        }
        return false;

    }
    
}
