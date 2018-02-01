/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package CLUBE;

import RN.RNSocio;
import VO.Funcionario_Analise;
import VO.Socio;
import static java.lang.Double.parseDouble;
import javax.swing.JOptionPane;

/**
 *
 * @author jao
 */
public class Setor_De_Analise_Documental extends Tabela_De_Socios_Analise_Documental {
    Funcionario_Analise func;
    /**
     * Creates new form Setor_De_Entrada
     */
    public Setor_De_Analise_Documental() {
        initComponents();
    }
    
    public Setor_De_Analise_Documental( Funcionario_Analise func) {
        this.func = func;
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

        jPanelValidar = new javax.swing.JPanel();
        btValidar = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        tfIdade = new javax.swing.JTextField();
        tfIDividas = new javax.swing.JTextField();
        tfRenda = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();

        setTitle("Setor de Analise Documental");
        setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        setResizable(false);
        setSize(new java.awt.Dimension(570, 570));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowOpened(java.awt.event.WindowEvent evt) {
                formWindowOpened(evt);
            }
        });

        jPanelValidar.setBorder(new javax.swing.border.SoftBevelBorder(javax.swing.border.BevelBorder.RAISED));

        btValidar.setText("Validar");
        btValidar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btValidarActionPerformed(evt);
            }
        });

        jLabel4.setText("Idade minima:");

        jLabel5.setText("Possui dividas:");

        jLabel6.setText("Renda minima mensal:");

        jLabel7.setText("Sim ou Nao");

        tfIDividas.setText("Nao");

        javax.swing.GroupLayout jPanelValidarLayout = new javax.swing.GroupLayout(jPanelValidar);
        jPanelValidar.setLayout(jPanelValidarLayout);
        jPanelValidarLayout.setHorizontalGroup(
            jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelValidarLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel6)
                    .addComponent(jLabel4)
                    .addComponent(jLabel5))
                .addGap(4, 4, 4)
                .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(tfRenda, javax.swing.GroupLayout.DEFAULT_SIZE, 48, Short.MAX_VALUE)
                    .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(tfIdade)
                        .addComponent(tfIDividas, javax.swing.GroupLayout.DEFAULT_SIZE, 48, Short.MAX_VALUE)))
                .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanelValidarLayout.createSequentialGroup()
                        .addGap(15, 15, 15)
                        .addComponent(jLabel7)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanelValidarLayout.createSequentialGroup()
                        .addGap(155, 155, 155)
                        .addComponent(btValidar)))
                .addContainerGap())
        );
        jPanelValidarLayout.setVerticalGroup(
            jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelValidarLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(tfIdade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(8, 8, 8)
                .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jLabel7)
                    .addComponent(tfIDividas, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanelValidarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(btValidar, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(tfRenda, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        jLabel1.setText("Prencha os campos com as restriçoes atuais.");

        jLabel2.setText("Recomendado, 25 anos ");

        jLabel3.setText("e renda de R$ 1.000,00 mensais. ");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanelValidar, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel3)))
                        .addGap(0, 119, Short.MAX_VALUE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(409, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanelValidar, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(36, 36, 36))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void formWindowOpened(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowOpened
        //Tabela_De_Socios tabela = new Tabela_De_Socios();
        //tabela.setVisible(true);
        
    }//GEN-LAST:event_formWindowOpened

    private void btValidarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btValidarActionPerformed
     Socio socio = new Socio();
     if (tfIdade.getText().equals("") || tfIDividas.getText().equals("") || tfRenda.getText().equals("")){
     
         JOptionPane.showMessageDialog(null, "Campos nao foram prenchidos!", "Analise Documental", JOptionPane.INFORMATION_MESSAGE);
         return;
     }else if (!tfIDividas.getText().equalsIgnoreCase("Nao")){
         JOptionPane.showMessageDialog(null, "O socio informado tem dividas e nao pode ser inserido!", "Analise Documental", JOptionPane.INFORMATION_MESSAGE);
         return;
     }else if (super.getCPF().equals("")){
              JOptionPane.showMessageDialog(null, "Nenhum socio foi selecionado!", "Analise Documental", JOptionPane.INFORMATION_MESSAGE);

     }
     
            
    
     if (!super.getCPF().isEmpty()){
         socio.setCpf(super.getCPF());
         RNSocio rn = new RNSocio(socio);
         socio = rn.getSocioPeloCPF();
         //System.out.println(socio.getNome() +" "+ socio.getCpf() +" "+ socio.getSalario_mensal()+" "+ socio.getDt_nasc());
         Funcionario_Analise funci = new Funcionario_Analise(); //Teste
         boolean ret = funci.validar(Integer.parseInt(tfIdade.getText()), tfIDividas.getText(), Double.parseDouble(tfRenda.getText()), socio);
         if (ret){
            if(!rn.consultarLista()){
                rn.listaEspera(ret);
                rn.enviarAnalise();
                JOptionPane.showMessageDialog(null, "Socio aguarda a aprovaçao do diretor.", "Analise documental", JOptionPane.INFORMATION_MESSAGE);
                limparCampos();
                organizaTabela();
            }else{
                JOptionPane.showMessageDialog(null, "Socio ja consta na base de dados e aguarda aprovaçao.", "Analise Documental", JOptionPane.INFORMATION_MESSAGE);
            }
         }
         limparCampos();
         organizaTabela();
     }
     
    }//GEN-LAST:event_btValidarActionPerformed

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
            java.util.logging.Logger.getLogger(Setor_De_Analise_Documental.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Setor_De_Analise_Documental.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Setor_De_Analise_Documental.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Setor_De_Analise_Documental.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Setor_De_Analise_Documental().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btValidar;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanelValidar;
    private javax.swing.JTextField tfIDividas;
    private javax.swing.JTextField tfIdade;
    private javax.swing.JTextField tfRenda;
    // End of variables declaration//GEN-END:variables

    private void limparCampos() {
         //To change body of generated methods, choose Tools | Templates.
         //tfIDividas.setText("");
         tfIdade.setText("");
         tfRenda.setText("");
    }
}