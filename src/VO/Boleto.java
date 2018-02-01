/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VO;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import org.jrimum.bopepo.BancosSuportados;
import org.jrimum.bopepo.view.BoletoViewer;
import org.jrimum.domkee.comum.pessoa.endereco.CEP;
import org.jrimum.domkee.comum.pessoa.endereco.UnidadeFederativa;
import org.jrimum.domkee.financeiro.banco.febraban.Agencia;
import org.jrimum.domkee.financeiro.banco.febraban.Carteira;
import org.jrimum.domkee.financeiro.banco.febraban.Cedente;
import org.jrimum.domkee.financeiro.banco.febraban.ContaBancaria;
import org.jrimum.domkee.financeiro.banco.febraban.NumeroDaConta;
import org.jrimum.domkee.financeiro.banco.febraban.Sacado;
import org.jrimum.domkee.financeiro.banco.febraban.SacadorAvalista;
import org.jrimum.domkee.financeiro.banco.febraban.TipoDeTitulo;
import org.jrimum.domkee.financeiro.banco.febraban.Titulo;

/**
 *
 * @author jao
 */
public class Boleto {
    Socio socio;
    Endereco endereco;

    
    Boleto(Socio socio) {
       this.socio = socio;
    }
    
    
    public void gerarBoleto(){
    Cedente cedente = new Cedente("Clube Social Campestre", "00.000.208/0001-00");

                /*
                 * INFORMANDO DADOS SOBRE O SACADO.
                 */
                Sacado sacado = new Sacado(socio.getNome(), socio.getCpf());

                // Informando o endereço do sacado.
                org.jrimum.domkee.comum.pessoa.endereco.Endereco enderecoSac = new org.jrimum.domkee.comum.pessoa.endereco.Endereco();
                enderecoSac.setUF(UnidadeFederativa.RN);
                enderecoSac.setLocalidade(socio.getEndereco().getCidade());
                enderecoSac.setCep(new CEP("00000-000"));
                enderecoSac.setBairro(socio.getEndereco().getBairro());
                enderecoSac.setLogradouro(socio.getEndereco().getRua());
                enderecoSac.setNumero(socio.getEndereco().getNumero());
                sacado.addEndereco(enderecoSac);

                /*
                 * INFORMANDO DADOS SOBRE O SACADOR AVALISTA.
                 */
                SacadorAvalista sacadorAvalista = new SacadorAvalista("Clube Social Campestre", "00.000.012/0001-98");

                // Informando o endereço do sacador avalista.
                org.jrimum.domkee.comum.pessoa.endereco.Endereco enderecoSacAval = new org.jrimum.domkee.comum.pessoa.endereco.Endereco();
                enderecoSacAval.setUF(UnidadeFederativa.DF);
                enderecoSacAval.setLocalidade("Ponta Grossa");
                enderecoSacAval.setCep(new CEP("84010-897"));
                enderecoSacAval.setBairro("Centro");
                enderecoSacAval.setLogradouro("Rua Vicente Machado");
                enderecoSacAval.setNumero("890");
                sacadorAvalista.addEndereco(enderecoSacAval);

                /*
                 * INFORMANDO OS DADOS SOBRE O TÍTULO.
                 */
                
                // Informando dados sobre a conta bancária do título.
                ContaBancaria contaBancaria = new ContaBancaria(BancosSuportados.BANCO_BRADESCO.create());
                contaBancaria.setNumeroDaConta(new NumeroDaConta(123456, "0"));
                contaBancaria.setCarteira(new Carteira(30));
                contaBancaria.setAgencia(new Agencia(1234, "1"));
                
                Titulo titulo = new Titulo(contaBancaria, sacado, cedente, sacadorAvalista);
                titulo.setNumeroDoDocumento("123456"+ socio.getId());
                titulo.setNossoNumero("99345678912");
                titulo.setDigitoDoNossoNumero("5");
                titulo.setValor(BigDecimal.valueOf(0.23));
                titulo.setDataDoDocumento(new Date());
                titulo.setDataDoVencimento(new Date());
                titulo.setTipoDeDocumento(TipoDeTitulo.DM_DUPLICATA_MERCANTIL);
                titulo.setAceite(Titulo.Aceite.A);
                titulo.setDesconto(new BigDecimal(0.00));
                titulo.setDeducao(BigDecimal.ZERO);
                titulo.setMora(BigDecimal.ZERO);
                titulo.setAcrecimo(BigDecimal.ZERO);
                titulo.setValorCobrado(BigDecimal.ZERO);

                /*
                 * INFORMANDO OS DADOS SOBRE O BOLETO.
                 */
                org.jrimum.bopepo.Boleto boleto = new org.jrimum.bopepo.Boleto(titulo);
                
                boleto.setLocalPagamento("Pagável preferencialmente na Rede Bradesco ou em " +
                                "qualquer Banco até o Vencimento.");
                boleto.setInstrucaoAoSacado("Senhor "+ socio.getNome() + ", tenha um bom dia!");
//                boleto.setInstrucao1("PARA PAGAMENTO 1 até Hoje não cobrar nada!");
//                boleto.setInstrucao2("PARA PAGAMENTO 2 até Amanhã Não cobre!");
//                boleto.setInstrucao3("PARA PAGAMENTO 3 até Depois de amanhã, OK, não cobre.");
//                boleto.setInstrucao4("PARA PAGAMENTO 4 até 04/xx/xxxx de 4 dias atrás COBRAR O VALOR DE: R$ 01,00");
//                boleto.setInstrucao5("PARA PAGAMENTO 5 até 05/xx/xxxx COBRAR O VALOR DE: R$ 02,00");
//                boleto.setInstrucao6("PARA PAGAMENTO 6 até 06/xx/xxxx COBRAR O VALOR DE: R$ 03,00");
//                boleto.setInstrucao7("PARA PAGAMENTO 7 até xx/xx/xxxx COBRAR O VALOR QUE VOCÊ QUISER!");
//                boleto.setInstrucao8("APÓS o Vencimento, Pagável Somente na Rede X.");

                /*
                 * GERANDO O BOLETO BANCÁRIO.
                 */
                // Instanciando um objeto "BoletoViewer", classe responsável pela
                // geração do boleto bancário.
                BoletoViewer boletoViewer = new BoletoViewer(boleto);

                // Gerando o arquivo. No caso o arquivo mencionado será salvo na mesma
                // pasta do projeto. Outros exemplos:
                // WINDOWS: boletoViewer.getAsPDF("C:/Temp/MeuBoleto.pdf");
                // LINUX: boletoViewer.getAsPDF("/home/temp/MeuBoleto.pdf");
                File arquivoPdf = boletoViewer.getPdfAsFile("Boleto"+ socio.getId()+ ".pdf");

                // Mostrando o boleto gerado na tela.
                mostreBoletoNaTela(arquivoPdf);
        }

        private static void mostreBoletoNaTela(File arquivoBoleto) {

                java.awt.Desktop desktop = java.awt.Desktop.getDesktop();
                
                try {
                        desktop.open(arquivoBoleto);
                } catch (IOException e) {
                        e.printStackTrace();
                }
        }

    void gerarBoleto(Double cub, Double joia) {
            Cedente cedente = new Cedente("Clube Social Campestre", "00.000.208/0001-00");

                /*
                 * INFORMANDO DADOS SOBRE O SACADO.
                 */
                Sacado sacado = new Sacado(socio.getNome(), socio.getCpf());

                // Informando o endereço do sacado.
                org.jrimum.domkee.comum.pessoa.endereco.Endereco enderecoSac = new org.jrimum.domkee.comum.pessoa.endereco.Endereco();
                enderecoSac.setUF(UnidadeFederativa.RN);
                enderecoSac.setLocalidade(socio.getEndereco().getCidade());
                enderecoSac.setCep(new CEP("00000-000"));
                enderecoSac.setBairro(socio.getEndereco().getBairro());
                enderecoSac.setLogradouro(socio.getEndereco().getRua());
                enderecoSac.setNumero(socio.getEndereco().getNumero());
                sacado.addEndereco(enderecoSac);

                /*
                 * INFORMANDO DADOS SOBRE O SACADOR AVALISTA.
                 */
                SacadorAvalista sacadorAvalista = new SacadorAvalista("Clube Social Campestre", "00.000.208/0001-00");

                // Informando o endereço do sacador avalista.
                org.jrimum.domkee.comum.pessoa.endereco.Endereco enderecoSacAval = new org.jrimum.domkee.comum.pessoa.endereco.Endereco();
                enderecoSacAval.setUF(UnidadeFederativa.DF);
                enderecoSacAval.setLocalidade("Ponta Grossa");
                enderecoSacAval.setCep(new CEP("84010-897"));
                enderecoSacAval.setBairro("Centro");
                enderecoSacAval.setLogradouro("Rua Vicente Machado");
                enderecoSacAval.setNumero("890");
                sacadorAvalista.addEndereco(enderecoSacAval);

                /*
                 * INFORMANDO OS DADOS SOBRE O TÍTULO.
                 */
                
                // Informando dados sobre a conta bancária do título.
                ContaBancaria contaBancaria = new ContaBancaria(BancosSuportados.BANCO_BRADESCO.create());
                contaBancaria.setNumeroDaConta(new NumeroDaConta(123456, "0"));
                contaBancaria.setCarteira(new Carteira(30));
                contaBancaria.setAgencia(new Agencia(1234, "1"));
                
                Titulo titulo = new Titulo(contaBancaria, sacado, cedente, sacadorAvalista);
                titulo.setNumeroDoDocumento("123456"+ socio.getId());
                titulo.setNossoNumero("99345678912");
                titulo.setDigitoDoNossoNumero("5");
                titulo.setValor(BigDecimal.valueOf(0.23));
                titulo.setDataDoDocumento(new Date());
                titulo.setDataDoVencimento(new Date());
                titulo.setTipoDeDocumento(TipoDeTitulo.DM_DUPLICATA_MERCANTIL);
                titulo.setAceite(Titulo.Aceite.A);
                titulo.setDesconto(new BigDecimal(0.00));
                titulo.setDeducao(BigDecimal.ZERO);
                titulo.setMora(BigDecimal.ZERO);
                titulo.setAcrecimo(BigDecimal.ZERO);
                titulo.setValorCobrado(BigDecimal.valueOf(joia + cub));

                /*
                 * INFORMANDO OS DADOS SOBRE O BOLETO.
                 */
                org.jrimum.bopepo.Boleto boleto = new org.jrimum.bopepo.Boleto(titulo);
                
                boleto.setLocalPagamento("Pagável preferencialmente na Rede Bradesco ou em " +
                                "qualquer Banco até o Vencimento.");
                boleto.setInstrucaoAoSacado("Senhor "+ socio.getNome() + ", tenha um bom dia!");
//                boleto.setInstrucao1("PARA PAGAMENTO 1 até Hoje não cobrar nada!");
//                boleto.setInstrucao2("PARA PAGAMENTO 2 até Amanhã Não cobre!");
//                boleto.setInstrucao3("PARA PAGAMENTO 3 até Depois de amanhã, OK, não cobre.");
//                boleto.setInstrucao4("PARA PAGAMENTO 4 até 04/xx/xxxx de 4 dias atrás COBRAR O VALOR DE: R$ 01,00");
//                boleto.setInstrucao5("PARA PAGAMENTO 5 até 05/xx/xxxx COBRAR O VALOR DE: R$ 02,00");
//                boleto.setInstrucao6("PARA PAGAMENTO 6 até 06/xx/xxxx COBRAR O VALOR DE: R$ 03,00");
//                boleto.setInstrucao7("PARA PAGAMENTO 7 até xx/xx/xxxx COBRAR O VALOR QUE VOCÊ QUISER!");
//                boleto.setInstrucao8("APÓS o Vencimento, Pagável Somente na Rede X.");

                /*
                 * GERANDO O BOLETO BANCÁRIO.
                 */
                // Instanciando um objeto "BoletoViewer", classe responsável pela
                // geração do boleto bancário.
                BoletoViewer boletoViewer = new BoletoViewer(boleto);

                // Gerando o arquivo. No caso o arquivo mencionado será salvo na mesma
                // pasta do projeto. Outros exemplos:
                // WINDOWS: boletoViewer.getAsPDF("C:/Temp/MeuBoleto.pdf");
                // LINUX: boletoViewer.getAsPDF("/home/temp/MeuBoleto.pdf");
                File arquivoPdf = boletoViewer.getPdfAsFile("Boleto"+ socio.getId()+ new Date().getSeconds() + ".pdf");

                // Mostrando o boleto gerado na tela.
                mostreBoletoNaTela(arquivoPdf);
    }

    void gerarBoleto(Double valor) {
                  Cedente cedente = new Cedente("Clube Social Campestre", "00.000.208/0001-00");

                /*
                 * INFORMANDO DADOS SOBRE O SACADO.
                 */
                Sacado sacado = new Sacado(socio.getNome(), socio.getCpf());

                // Informando o endereço do sacado.
                org.jrimum.domkee.comum.pessoa.endereco.Endereco enderecoSac = new org.jrimum.domkee.comum.pessoa.endereco.Endereco();
                enderecoSac.setUF(UnidadeFederativa.RN);
                enderecoSac.setLocalidade(socio.getEndereco().getCidade());
                enderecoSac.setCep(new CEP("00000-000"));
                enderecoSac.setBairro(socio.getEndereco().getBairro());
                enderecoSac.setLogradouro(socio.getEndereco().getRua());
                enderecoSac.setNumero(socio.getEndereco().getNumero());
                sacado.addEndereco(enderecoSac);

                /*
                 * INFORMANDO DADOS SOBRE O SACADOR AVALISTA.
                 */
                SacadorAvalista sacadorAvalista = new SacadorAvalista("Clube Social Campestre", "00.000.208/0001-00");

                // Informando o endereço do sacador avalista.
                org.jrimum.domkee.comum.pessoa.endereco.Endereco enderecoSacAval = new org.jrimum.domkee.comum.pessoa.endereco.Endereco();
                enderecoSacAval.setUF(UnidadeFederativa.DF);
                enderecoSacAval.setLocalidade("Ponta Grossa");
                enderecoSacAval.setCep(new CEP("84010-897"));
                enderecoSacAval.setBairro("Centro");
                enderecoSacAval.setLogradouro("Rua Vicente Machado");
                enderecoSacAval.setNumero("890");
                sacadorAvalista.addEndereco(enderecoSacAval);

                /*
                 * INFORMANDO OS DADOS SOBRE O TÍTULO.
                 */
                
                // Informando dados sobre a conta bancária do título.
                ContaBancaria contaBancaria = new ContaBancaria(BancosSuportados.BANCO_BRADESCO.create());
                contaBancaria.setNumeroDaConta(new NumeroDaConta(123456, "0"));
                contaBancaria.setCarteira(new Carteira(30));
                contaBancaria.setAgencia(new Agencia(1234, "1"));
                
                Titulo titulo = new Titulo(contaBancaria, sacado, cedente, sacadorAvalista);
                titulo.setNumeroDoDocumento("123456"+ socio.getId());
                titulo.setNossoNumero("99345678912");
                titulo.setDigitoDoNossoNumero("5");
                titulo.setValor(BigDecimal.valueOf(0.23));
                titulo.setDataDoDocumento(new Date());
                titulo.setDataDoVencimento(new Date());
                titulo.setTipoDeDocumento(TipoDeTitulo.DM_DUPLICATA_MERCANTIL);
                titulo.setAceite(Titulo.Aceite.A);
                titulo.setDesconto(new BigDecimal(0.00));
                titulo.setDeducao(BigDecimal.ZERO);
                titulo.setMora(BigDecimal.ZERO);
                titulo.setAcrecimo(BigDecimal.ZERO);
                titulo.setValorCobrado(BigDecimal.valueOf(valor));

                /*
                 * INFORMANDO OS DADOS SOBRE O BOLETO.
                 */
                org.jrimum.bopepo.Boleto boleto = new org.jrimum.bopepo.Boleto(titulo);
                
                boleto.setLocalPagamento("Pagável preferencialmente na Rede Bradesco ou em " +
                                "qualquer Banco até o Vencimento.");
                boleto.setInstrucaoAoSacado("Senhor "+ socio.getNome() + ", tenha um bom dia!");
//                boleto.setInstrucao1("PARA PAGAMENTO 1 até Hoje não cobrar nada!");
//                boleto.setInstrucao2("PARA PAGAMENTO 2 até Amanhã Não cobre!");
//                boleto.setInstrucao3("PARA PAGAMENTO 3 até Depois de amanhã, OK, não cobre.");
//                boleto.setInstrucao4("PARA PAGAMENTO 4 até 04/xx/xxxx de 4 dias atrás COBRAR O VALOR DE: R$ 01,00");
//                boleto.setInstrucao5("PARA PAGAMENTO 5 até 05/xx/xxxx COBRAR O VALOR DE: R$ 02,00");
//                boleto.setInstrucao6("PARA PAGAMENTO 6 até 06/xx/xxxx COBRAR O VALOR DE: R$ 03,00");
//                boleto.setInstrucao7("PARA PAGAMENTO 7 até xx/xx/xxxx COBRAR O VALOR QUE VOCÊ QUISER!");
//                boleto.setInstrucao8("APÓS o Vencimento, Pagável Somente na Rede X.");

                /*
                 * GERANDO O BOLETO BANCÁRIO.
                 */
                // Instanciando um objeto "BoletoViewer", classe responsável pela
                // geração do boleto bancário.
                BoletoViewer boletoViewer = new BoletoViewer(boleto);

                // Gerando o arquivo. No caso o arquivo mencionado será salvo na mesma
                // pasta do projeto. Outros exemplos:
                // WINDOWS: boletoViewer.getAsPDF("C:/Temp/MeuBoleto.pdf");
                // LINUX: boletoViewer.getAsPDF("/home/temp/MeuBoleto.pdf");
                File arquivoPdf = boletoViewer.getPdfAsFile("BoletoMensalidade"+ socio.getId() + ".pdf");
                if (arquivoPdf != null){
                // Mostrando o boleto gerado na tela.
                
                
                mostreBoletoNaTela(arquivoPdf);
                
                
                }
    }
}
