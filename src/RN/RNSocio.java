/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import PER.PERSocio;
import VO.Socio;
import java.util.ArrayList;

/**
 *
 * @author jao
 */
public class RNSocio {
    private Socio socio;
    public RNSocio(Socio socio) {
        this.socio = socio; //To change body of generated methods, choose Tools | Templates.
    }
    public Socio consultarSocio(){
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSocio();
    }
    public int salvar(){
        PERSocio pers = new PERSocio(socio);
        if(pers.consultarCPF()){
            
            pers.atualizar();
            return 0;
        }      
        if(pers.cadastrar()){
            return 1;
        }
        return -1;
    }
    public Socio getSocioPeloCPF(){
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSocioCPF();
    }

    public boolean consultarCPFDeSocio() {
         //To change body of generated methods, choose Tools | Templates.
         PERSocio pers = new PERSocio(socio);
         return pers.consultarCPF();
    }

    public void aceitarSocio() {
        PERSocio pers = new PERSocio(socio);
        pers.aceitar();
    }
    public void apto() {
        PERSocio pers = new PERSocio(socio);
        pers.apto();
    }
    
    public ArrayList<Socio> getSocios(){
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSocios();
    }

    public void listaEspera(boolean passou) {
        PERSocio pers = new PERSocio(socio);
        pers.adicionarListaAnalise(passou);
    }
    public ArrayList<Socio> consultarSociosAnaliseUm(){
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSociosAnaliseUm();
    }
    public ArrayList<Socio> consultarSociosAnalise(){
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSociosAnalise();
    }

    public boolean consultarLista() {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarLista();
    }
    public void enviarAnalise(){
        PERSocio pers = new PERSocio(socio);
        pers.analisar();
    }
    public void inserirNegados(String motivo){
        PERSocio pers = new PERSocio(socio);
        pers.adicionarListaNegados(motivo);
    }

    public void deletar() {
         PERSocio pers = new PERSocio(socio);
        pers.deletar();
    }

    public ArrayList<Socio> consultarSociosAceitos() {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSociosAceitos();
      
    }

    public Double getValorJoiaAtual() {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarTotalJoiasPagas();
    //To change body of generated methods, choose Tools | Templates.
    }

    public void enviarBoletoJoia(Double valor) {
       PERSocio pers = new PERSocio(socio);
        pers.enviarBoletoJoia(valor); 
    }

    public ArrayList<Socio> consultarInadimplentesMensalidade(int mes, int ano) {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSociosDebitosMensalidade(mes, ano);
    }
    public ArrayList<Socio> consultarInadimplentesMensalidade(boolean contatado) {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSociosDebitosInadimplentes(contatado);
    }

    public void inserirTabelaInadimplementes(Socio s) {
         PERSocio pers = new PERSocio(s);
         pers.inserirTabelaInadimplentes();
    }
    public void deletarTabelaInadimplentes(){
        PERSocio pers = new PERSocio(socio);
        pers.deletarTabelaInadimplentes();
    }

    public void enviarBoletoMensalidade(Double valor, int mes, int ano) {
        PERSocio pers = new PERSocio(socio);
        pers.inserirNovaMensalidade(valor, mes, ano);
    }

    public boolean consultarTabelaPagamentos(int mes, int ano) {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarTabelaPagamentos(mes, ano);
    }

    public ArrayList<Socio> consultarSociosRegulares() {
        PERSocio pers = new PERSocio(socio);
        return pers.consultarSociosRegulares(); //To change body of generated methods, choose Tools | Templates.
    }

    public void retirarInadimplentes() {
        PERSocio pers = new PERSocio(socio);
        pers.retirarInadimplentes();
    }
  
  }
