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
public abstract class Funcionario {
    private int id;
    private Setor setor;
    private String nome;
    private String senha;
    private Boolean eh_diretor;
    private String cpf; 
    public Funcionario(){}
    public Funcionario(int id, Setor setor, String nome, String senha, Boolean eh_diretor) {
        this.id = id;
        this.setor = setor;
        this.nome = nome;
        this.senha = senha;
        this.eh_diretor = eh_diretor;
    }
    public Funcionario( Setor setor, String nome, String senha, Boolean eh_diretor) {
        
        this.setor = setor;
        this.nome = nome;
        this.senha = senha;
        this.eh_diretor = eh_diretor;
    }

    public Boolean getEh_diretor() {
        return eh_diretor;
    }

    public void setEh_diretor(Boolean eh_diretor) {
        this.eh_diretor = eh_diretor;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Setor getSetor() {
        return setor;
    }

    public void setSetor(Setor setor) {
        this.setor = setor;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public void setCpf(String text) {
      this.cpf = cpf;
    }
    public String getCpf() {
      return cpf;
    }
    
}
