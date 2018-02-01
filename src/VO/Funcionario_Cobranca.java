/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VO;

import RN.RNSocio;

/**
 *
 * @author jao
 */
public class Funcionario_Cobranca extends Funcionario implements Cobranca{

   
    @Override
    public void enviarBoletoMensalidade(Double valor,int mes, int ano, Socio socio) {
        Boleto boleto = new Boleto(socio);
        boleto.gerarBoleto(valor);
        RNSocio rn = new RNSocio(socio);
        rn.enviarBoletoMensalidade(valor, mes, ano);
    }

    @Override
    public void enviarBoletoJoia(Double cub, Double joia, Socio socio) {
        Boleto boleto = new Boleto(socio);
        boleto.gerarBoleto(cub, joia); //Boleto de Nova Associacao
        RNSocio rn = new RNSocio(socio);
        rn.enviarBoletoJoia(joia + cub);
    }
    
}
