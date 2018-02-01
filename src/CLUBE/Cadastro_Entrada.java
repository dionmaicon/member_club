/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package CLUBE;

import RN.RNDependente;
import RN.RNEndereco;
import RN.RNSocio;
import RN.Util;
import VO.Dependente;
import VO.Endereco;
import VO.Socio;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import org.jrimum.domkee.comum.pessoa.id.cprf.CPF;

/**
 *
 * @author jao
 */
public class Cadastro_Entrada extends Cadastro_Socio {

    /**
     * Creates new form Entrada
     */
    public Cadastro_Entrada() {
        initComponents();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        btSalvar = new javax.swing.JButton();
        btEnviar = new javax.swing.JButton();
        btCancelar = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Cadastros de Novos Socios");
        setMinimumSize(new java.awt.Dimension(780, 700));

        btSalvar.setText("Salvar");
        btSalvar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btSalvarActionPerformed(evt);
            }
        });

        btEnviar.setText("Enviar");
        btEnviar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btEnviarActionPerformed(evt);
            }
        });

        btCancelar.setText("Cancelar");
        btCancelar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btCancelarActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap(532, Short.MAX_VALUE)
                .addComponent(btCancelar, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(btSalvar, javax.swing.GroupLayout.PREFERRED_SIZE, 99, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(btEnviar, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(597, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(btEnviar)
                    .addComponent(btCancelar, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(btSalvar))
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btSalvarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btSalvarActionPerformed
        String erros = "";
        int status = 0;
        
        try {
            erros = verificarCampos();
        } catch (ParseException ex) {
            Logger.getLogger(Cadastro_Entrada.class.getName()).log(Level.SEVERE, null, ex);
            erros.concat(" Problemas ao tentar converter Campos de Salario e Outras Rendas, tente outro valor.");
            
        }
        if (erros.equals("")){
        //----------------Socio----------------
        String cpf = super.getTfCPF().getText();
        String nome = super.getTfNome().getText();
        Date dt_nasc = super.getDtChooserData_Nasc().getDate();
        String rg = super.getTfRG().getText();
        String celular = super.getTfCelular().getText();
        String mail = super.getTfEmail().getText();
        String formacao = super.getTfFormacao().getText();
        String telefone = super.getTfTelefone().getText();
        String profissao = super.getTfProfissao().getText();
        Double salario_mensal = Double.parseDouble(super.getTfSalarioMensal().getText());
        Double outras_rendas = Double.parseDouble(super.getTfOutrasRendas().getText());
        //--------------Endereco----------
        String rua = super.getTfRua().getText();
        String numero = super.getTfNumero().getText();
        String bairro = super.getTfBairro().getText();
        String cidade = super.getTfCidade().getText();
        String estado = (String) super.getCbxEstado().getSelectedItem();
        //-------------Dependentes--------------
        
        
        Socio socio = new Socio();
        socio.setCpf(cpf);
        RNSocio rnSocio = new RNSocio(socio);
        
        if  (rnSocio.consultarCPFDeSocio()){
            socio = rnSocio.getSocioPeloCPF(); //pega o objeto pelo CPF
            
            String cpfSocio  = socio.getCpf(); //Pego os parametros para uso em um novo update
            int idSocio = socio.getId();
            int idEndereco = socio.getEndereco().getId();
            
                        
            try {
                Endereco endereco = new Endereco(rua, numero, bairro, cidade, estado);
                endereco.setId(idEndereco);
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.salvar();
                
                Socio newSocio = new Socio(nome, dt_nasc, cpf, rg, celular, mail, formacao,  socio.getSenha(), socio.getApto_piscina(), telefone, profissao, salario_mensal, outras_rendas, endereco);
                newSocio.setId(idSocio);
                newSocio.setCpf(cpfSocio);
                
                rnSocio = new RNSocio(newSocio);
                rnSocio.salvar();
                status = 1;
                
                ArrayList<Dependente> list = verificarCamposDependentes(newSocio);
                for (Dependente dependente : list) {
                    RNDependente rnDependente = new RNDependente(dependente);
                    if (rnDependente.consultarRGDependente()){
                        dependente.setNome(dependente.getNome());
                        rnDependente.salvar();
                    }else{
                        if (rnDependente.consultarQuantidade() < 5){
                            rnDependente.salvar();
                        }else{
                            break;
                        }
                    }
                }
            } catch (SQLException ex) {
                Logger.getLogger(Cadastro_Entrada.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else{
           
            try {
                Endereco endereco = new Endereco(rua, numero, bairro, cidade, estado);
                RNEndereco rnEndereco = new RNEndereco(endereco);
                rnEndereco.salvar();
                
                Socio newSocio = new Socio(nome, dt_nasc, cpf, rg, celular, mail, formacao,  "12345678", false, telefone, profissao, salario_mensal, outras_rendas, endereco);
                rnSocio = new RNSocio(newSocio);
                rnSocio.salvar();
                status = 2; 
                
                ArrayList<Dependente> list = verificarCamposDependentes(newSocio);
                for (Dependente dependente : list) {
                    RNDependente rnDependente = new RNDependente(dependente);
                    if (rnDependente.consultarRGDependente()){
                        dependente.setNome(dependente.getNome());
                        rnDependente.salvar();
                    }else{
                        if (rnDependente.consultarQuantidade() < 5){
                            rnDependente.salvar();
                        }else{
                         break;
                        }
                    }
                }
            } catch (SQLException ex) {
                Logger.getLogger(Cadastro_Entrada.class.getName()).log(Level.SEVERE, null, ex);
            }
               
        }
                      
            switch (status) {
                case 2:
                    JOptionPane.showMessageDialog(null, "Socio cadastrado com sucesso!", "Cadastro de novos socios", JOptionPane.INFORMATION_MESSAGE);
                    limparCampos();
                    break;

                case 1:
                    JOptionPane.showMessageDialog(null, "Socio alterado com sucesso", "Cadastro de novos socios", JOptionPane.INFORMATION_MESSAGE);
                    break;
                default:
                    JOptionPane.showMessageDialog(null, "Erro ao tentar salvar/alterar endereco", "Cadastro de novos socios", JOptionPane.ERROR_MESSAGE);
                    break;
            }
        
        }else{
            JOptionPane.showMessageDialog(null, erros , "Cadastro de novos socios", JOptionPane.ERROR_MESSAGE);
                  
        }
    }//GEN-LAST:event_btSalvarActionPerformed

    private void btEnviarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btEnviarActionPerformed
       int reply = JOptionPane.showConfirmDialog(null, "Enviar e fechar a janela atual?", "Cadastro de novos socios", JOptionPane.YES_NO_OPTION);
        if (reply == JOptionPane.YES_OPTION){
            limparCampos();
            super.setVisible(false);
        }
        
    }//GEN-LAST:event_btEnviarActionPerformed

    private void btCancelarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btCancelarActionPerformed
       int reply = JOptionPane.showConfirmDialog(null, "Deseja limpar os campos preenchidos? ", "Cadastro de novos socios", JOptionPane.YES_NO_OPTION);
        if (reply == JOptionPane.YES_OPTION){
            limparCampos();
            
        }
        
    }//GEN-LAST:event_btCancelarActionPerformed
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Cadastro_Entrada.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Cadastro_Entrada.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Cadastro_Entrada.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Cadastro_Entrada.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Cadastro_Entrada().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btCancelar;
    private javax.swing.JButton btEnviar;
    private javax.swing.JButton btSalvar;
    // End of variables declaration//GEN-END:variables

    private String verificarCampos() throws ParseException {
        
        String mensagem = "";
        try {
            String date = super.getDtChooserData_Nasc().getDate().toString();
        } catch ( NullPointerException e) {
            return  mensagem.concat(" Selecione a data de nascimento.");
        }
        
        if( super.getTfNome().getText().equals("") || super.getTfCPF().getText().equals("") || super.getTfRG().getText().equals("") || super.getTfCelular().getText().equals("") || super.getTfEmail().getText().equals("") || super.getTfFormacao().getText().equals("") || super.getTfTelefone().getText().equals("") || super.getTfProfissao().getText().equals("") || super.getTfRua().getText().equals("") || super.getTfNumero().getText().equals("") || super.getTfBairro().getText().equals("") || super.getTfCidade().getText().equals("")){
            return  mensagem.concat(" Alguns campos nao foram preenchidos corretamente.");
        }
        
        Util util = new Util();
       
        if (!Util.validar(super.getTfEmail().getText())){
            mensagem = mensagem.concat("Email invalido");
        }
        
        String dataMenosAtual = util.converterDataChooser(super.getDtChooserData_Nasc());
        String dataMaisAtual = util.calcularDataAtual();
        long diferenca = util.calcularDiferencaEntreDatas(dataMaisAtual, dataMenosAtual, "Anos");
         
        if(diferenca < 25){
            mensagem = mensagem.concat(" Socio titular deve ter 25 anos ou mais.");
        }
        
        try {
            Double salario_mensal = Double.parseDouble(super.getTfSalarioMensal().getText());
            Double outras_rendas = Double.parseDouble(super.getTfOutrasRendas().getText());
        if (salario_mensal < 0 || outras_rendas < 0){
            mensagem = mensagem.concat(" Campos de salario e outras rendas nao podem ser negativos.");
        
        }    
        
        } catch (NumberFormatException e) {
            e.printStackTrace();
            mensagem = mensagem.concat(" Campos de salario devem ser preenchidos com valores reais.");
        }
        return mensagem;
    }

    private void limparCampos() {
        super.getTfCPF().setText("");
        super.getTfNome().setText("");
        super.getTfRG().setText("");
        super.getTfCelular().setText("");
        super.getTfEmail().setText("");
        super.getTfFormacao().setText("");
        super.getTfTelefone().setText("");
        super.getTfProfissao().setText("");
        super.getTfSalarioMensal().setText("");
        super.getTfOutrasRendas().setText("");
        //--------------Endereco----------
        super.getTfRua().setText("");
        super.getTfNumero().setText("");
        super.getTfBairro().setText("");
        super.getTfCidade().setText("");
        //--------------Dependentes-------
        super.getTfDependenteRG1().setText("");
        super.getTfDependenteRG2().setText("");
        super.getTfDependenteRG3().setText("");
        super.getTfDependenteRG4().setText("");
        super.getTfDependenteRG5().setText("");
        super.getTfDependente1().setText("");
        super.getTfDependente2().setText("");
        super.getTfDependente3().setText("");
        super.getTfDependente4().setText("");
        super.getTfDependente5().setText("");
    }
    private ArrayList<Dependente> verificarCamposDependentes( Socio socio){
        
        ArrayList<Dependente> list = new ArrayList<>();
        
        String rg1 = super.getTfDependenteRG1().getText();
        String rg2 = super.getTfDependenteRG2().getText();
        String rg3 = super.getTfDependenteRG3().getText();
        String rg4 = super.getTfDependenteRG4().getText();
        String rg5 = super.getTfDependenteRG5().getText();
        String dn1 = super.getTfDependente1().getText();
        String dn2 = super.getTfDependente2().getText();
        String dn3 = super.getTfDependente3().getText();
        String dn4 = super.getTfDependente4().getText();
        String dn5 = super.getTfDependente5().getText();
        
        if(rg1.equals("") || dn1.equals("")){
            super.getTfDependenteRG1().setText("");
            super.getTfDependente1().setText("");
        }else{
            
            Dependente d = new Dependente(dn1, rg1, false, socio);
            list.add(d);
        }
        if(rg2.equals("") || dn2.equals("")){
            super.getTfDependenteRG2().setText("");
            super.getTfDependente2().setText("");
        }else{
            
            Dependente d = new Dependente(dn2, rg2, false, socio);
            list.add(d);
        }
        if(rg3.equals("") || dn3.equals("")){
            super.getTfDependenteRG3().setText("");
            super.getTfDependente3().setText("");
        }else{
            
            Dependente d = new Dependente(dn3, rg3, false, socio);
            list.add(d);
        }
        if(rg4.equals("") || dn4.equals("")){
            super.getTfDependenteRG4().setText("");
            super.getTfDependente4().setText("");
        }else{
            
            Dependente d = new Dependente( dn4, rg4,false, socio);
            list.add(d);
        }
        if(rg5.equals("") || dn5.equals("")){
            super.getTfDependenteRG5().setText("");
            super.getTfDependente5().setText("");
        }else{
            
            Dependente d = new Dependente(dn5, rg5,  false, socio);
            list.add(d);
        }
        return list;
    }
}
