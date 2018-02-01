/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VO;

/**
 *
 * @author jao
 */
public interface Analise {

    /**
     *
     * @param idade
     * @param divida
     * @param renda
     * @param socio
     * @return
     */
    public boolean validar(int idade, String divida, Double renda, Socio socio);
}
