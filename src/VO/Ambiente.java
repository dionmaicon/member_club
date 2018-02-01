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
public class Ambiente {
    private int idambiente;
    private String nome;

    public Ambiente() {
    }

    public Ambiente( String nome) {
        this.nome = nome;
    }

    public int getIdambiente() {
        return idambiente;
    }

    public void setIdambiente(int idambiente) {
        this.idambiente = idambiente;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
    
    
}
