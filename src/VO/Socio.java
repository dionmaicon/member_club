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
public class Socio {
    private int id;
    private String nome;
    private Date dt_nasc;
    private String cpf;
    private String rg;
    private String celular;
    private String mail;
    private String formacao;
    private String senha;
    private Boolean apto_piscina;
    private String telefone;
    private String profissao;
    private Double salario_mensal;
    private Double outras_rendas;
    private Endereco endereco;
    private Boolean aceito;

    public Socio(int id, String nome, Date dt_nasc, String cpf, String rg, String celular, String mail, String formacao, String senha, Boolean apto_piscina, String telefone, String profissao, Double salario_mensal, Double outras_rendas, Endereco endereco) {
        this.id = id;
        this.nome = nome;
        this.dt_nasc = dt_nasc;
        this.cpf = cpf;
        this.rg = rg;
        this.celular = celular;
        this.mail = mail;
        this.formacao = formacao;
        this.senha = senha;
        this.apto_piscina = apto_piscina;
        this.telefone = telefone;
        this.profissao = profissao;
        this.salario_mensal = salario_mensal;
        this.outras_rendas = outras_rendas;
        this.endereco = endereco;
    }
     public Socio(String nome, Date dt_nasc, String cpf, String rg, String celular, String mail, String formacao, String senha, Boolean apto_piscina, String telefone, String profissao, Double salario_mensal, Double outras_rendas, Endereco endereco) {
        
        this.nome = nome;
        this.dt_nasc = dt_nasc;
        this.cpf = cpf;
        this.rg = rg;
        this.celular = celular;
        this.mail = mail;
        this.formacao = formacao;
        this.senha = senha;
        this.apto_piscina = apto_piscina;
        this.telefone = telefone;
        this.profissao = profissao;
        this.salario_mensal = salario_mensal;
        this.outras_rendas = outras_rendas;
        this.endereco = endereco;
     }

    public Socio() {
        //To change body of generated methods, choose Tools | Templates.
    }

    public Double getOutras_rendas() {
        return outras_rendas;
    }

    public void setOutras_rendas(Double outras_rendas) {
        this.outras_rendas = outras_rendas;
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

    public Date getDt_nasc() {
        return dt_nasc;
    }

    public void setDt_nasc(Date dt_nasc) {
        this.dt_nasc = dt_nasc;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getRg() {
        return rg;
    }

    public void setRg(String rg) {
        this.rg = rg;
    }

    public String getCelular() {
        return celular;
    }

    public void setCelular(String celular) {
        this.celular = celular;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }

    public String getFormacao() {
        return formacao;
    }

    public void setFormacao(String formacao) {
        this.formacao = formacao;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public Boolean getApto_piscina() {
        return apto_piscina;
    }

    public void setApto_piscina(Boolean apto_piscina) {
        this.apto_piscina = apto_piscina;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getProfissao() {
        return profissao;
    }

    public void setProfissao(String profissao) {
        this.profissao = profissao;
    }

    public Double getSalario_mensal() {
        return salario_mensal;
    }

    public void setSalario_mensal(Double salario_mensal) {
        this.salario_mensal = salario_mensal;
    }

    public Endereco getEndereco() {
        return endereco;
    }

    public void setEndereco(Endereco endereco) {
        this.endereco = endereco;
    }

    public Boolean getAceito() {
        return aceito;
    }

    public void setAceito(Boolean aceito) {
        this.aceito = aceito;
    }
    
}
