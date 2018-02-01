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
public class Dependente {
    private int id;
    private String nome;
    private String rg;
    private Boolean apto_piscina;
    private Socio socio;

    public Dependente(int id, String nome, String rg, Boolean apto_piscina, Socio socio) {
        this.id = id;
        this.nome = nome;
        this.rg = rg;
        this.apto_piscina = apto_piscina;
        this.socio = socio;
    }
     public Dependente( String nome, String rg, Boolean apto_piscina, Socio socio) {
        
        this.nome = nome;
        this.rg = rg;
        this.apto_piscina = apto_piscina;
        this.socio = socio;
     }

    public Dependente() {
        
    }

    public Boolean getApto_piscina() {
        return apto_piscina;
    }

    public void setApto_piscina(Boolean apto_piscina) {
        this.apto_piscina = apto_piscina;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getRg() {
        return rg;
    }

    public void setRg(String rg) {
        this.rg = rg;
    }

    public Socio getSocio() {
        return socio;
    }

    public void setSocio(Socio socio) {
        this.socio = socio;
    }
     
    
}
