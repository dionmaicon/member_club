/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VO;

import java.util.Date;

/**
 *
 * @author jao
 */
public class Pagamento {
    private int id;
    private Socio socio;
    private Double real;
    private int mes_de_referencia;
    private int ano_de_referencia;
    
    public Pagamento(int id, Socio socio, Double real, int mes_de_referencia, int ano_de_referencia) {
        this.id = id;
        this.socio = socio;
        this.real = real;
        this.mes_de_referencia = mes_de_referencia;
        this.ano_de_referencia = ano_de_referencia;
    
    }

    public Pagamento() {
    }
    

    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Socio getSocio() {
        return socio;
    }

    public void setSocio(Socio socio) {
        this.socio = socio;
    }

    public Double getReal() {
        return real;
    }

    public void setReal(Double real) {
        this.real = real;
    }

    public int getMes_de_referencia() {
        return mes_de_referencia;
    }

    public void setMes_de_referencia(int mes_de_referencia) {
        this.mes_de_referencia = mes_de_referencia;
    }

    public int getAno_de_referencia() {
        return ano_de_referencia;
    }

    public void setAno_de_referencia(int ano_de_referencia) {
        this.ano_de_referencia = ano_de_referencia;
    }

        
}
