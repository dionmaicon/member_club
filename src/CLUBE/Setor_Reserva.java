/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package CLUBE;

import RN.RNAmbiente;
import RN.RNDependente;
import RN.RNReserva;
import RN.RNSocio;
import RN.Util;
import VO.Ambiente;
import VO.Dependente;
import VO.Reserva;
import VO.Socio;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

/**
 *
 * @author jao
 */
public class Setor_Reserva extends javax.swing.JFrame {
    private Socio socio;
    /**
     * Creates new form Setor_Reserva
     */
    public Setor_Reserva() {
         initComponents();
        tfCPF.setEditable(true);
    }
    
    public Setor_Reserva(Socio socio) {
        this.socio = socio;
        initComponents();
        tfCPF.setText(socio.getCpf());
        tfCPF.setEditable(false);
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        jButton1 = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        tAConvidados = new javax.swing.JTextArea();
        jButton2 = new javax.swing.JButton();
        tfCPF = new javax.swing.JTextField();
        comboAmbiente = new javax.swing.JComboBox<>();
        spinnerHora = new javax.swing.JSpinner();
        jLabel6 = new javax.swing.JLabel();
        dtChooserData = new com.toedter.calendar.JDateChooser();
        jLabel7 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Setor de Reserva");
        addWindowFocusListener(new java.awt.event.WindowFocusListener() {
            public void windowGainedFocus(java.awt.event.WindowEvent evt) {
                formWindowGainedFocus(evt);
            }
            public void windowLostFocus(java.awt.event.WindowEvent evt) {
            }
        });

        jLabel1.setText("Ambiente:");

        jLabel2.setText("CPF:");

        jLabel3.setText("Data:");

        jLabel4.setText("Hora:");

        jLabel5.setText("Convidados:");

        jButton1.setText("Solicitar Acesso as Piscinas");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(157, 157, 157)
                .addComponent(jButton1)
                .addContainerGap(151, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(103, 103, 103)
                .addComponent(jButton1)
                .addContainerGap(103, Short.MAX_VALUE))
        );

        tAConvidados.setColumns(20);
        tAConvidados.setRows(5);
        jScrollPane1.setViewportView(tAConvidados);

        jButton2.setText("Enviar");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        tfCPF.setEditable(false);

        spinnerHora.setModel(new javax.swing.SpinnerNumberModel(7, 7, 22, 1));

        jLabel6.setText(":");

        dtChooserData.setToolTipText("01/12/1989");
        dtChooserData.setDateFormatString("dd/MM/yyyy");
        dtChooserData.setMaxSelectableDate(new java.util.Date(1577847698000L));
        dtChooserData.setMinSelectableDate(new java.util.Date(1467777698000L));

        jLabel7.setText("00");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jButton2))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel5)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel2)
                                    .addComponent(jLabel1)
                                    .addComponent(jLabel3))
                                .addGap(9, 9, 9)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(tfCPF, javax.swing.GroupLayout.DEFAULT_SIZE, 175, Short.MAX_VALUE)
                                    .addComponent(comboAmbiente, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(dtChooserData, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addGap(18, 18, 18)
                                .addComponent(jLabel4)
                                .addGap(3, 3, 3)
                                .addComponent(spinnerHora, javax.swing.GroupLayout.PREFERRED_SIZE, 51, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(6, 6, 6)
                                .addComponent(jLabel6)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel7)))
                        .addGap(0, 137, Short.MAX_VALUE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(tfCPF, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(comboAmbiente, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3)
                    .addComponent(dtChooserData, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel4)
                        .addComponent(spinnerHora, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel6)
                        .addComponent(jLabel7)))
                .addGap(58, 58, 58)
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jButton2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 22, Short.MAX_VALUE)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        
        try {
            String err = verificarCampos();
            if (err.equals("")){ //Nao ha erros
                Socio socio = new Socio();
                socio.setCpf(tfCPF.getText());
                
                RNSocio rnSocio = new RNSocio(socio);
                socio = rnSocio.getSocioPeloCPF();
                
                Ambiente ambiente = new Ambiente();
                RNAmbiente rnA = new RNAmbiente();
                ArrayList<Ambiente> list = rnA.getTodosAmbientes();
        
                for (Ambiente ambiente1 : list) {
                    if (comboAmbiente.getItemAt(0).equals(ambiente1.getNome())){
                        ambiente = ambiente1;
                    }
                }
                
                Reserva reserva = new Reserva(ambiente, socio, dtChooserData.getDate() , Integer.parseInt(spinnerHora.getValue().toString()),tAConvidados.getText());
                RNReserva rnReserva = new RNReserva();
                ArrayList<Reserva> lista = rnReserva.getTodasReservas(dtChooserData.getDate());
                
                boolean disponivel = true;
                
                if (!lista.isEmpty() || lista != null){
                 
                    for (Reserva reserva1 : lista) {
                        if ( reserva1.getHora_reserva() == reserva.getHora_reserva()){
                            disponivel = false;
                            break;
                        }
                    }
                }
                
                if ( disponivel ){
                    rnReserva = new RNReserva(reserva);
                    try {
                        rnReserva.salvar();
                        JOptionPane.showMessageDialog(this, "Cadastro de Horario realizado com SUCESSO!" , "Setor de Reserva", JOptionPane.INFORMATION_MESSAGE);
                    } catch (SQLException ex) {
                        Logger.getLogger(Setor_Reserva.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }else{
                
                   JOptionPane.showMessageDialog(this, "O horario esta ocupado, tente outro horario" , "Setor de Reserva ", JOptionPane.ERROR_MESSAGE);
                   return;              
                }  
            
            }else{
                JOptionPane.showMessageDialog(this, err , "Setor de Reserva ", JOptionPane.ERROR_MESSAGE);
            }
        } catch (ParseException ex) {
            Logger.getLogger(Setor_Reserva.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }//GEN-LAST:event_jButton2ActionPerformed

    private void formWindowGainedFocus(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowGainedFocus
        preencherCombo();        
    }//GEN-LAST:event_formWindowGainedFocus

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
       
       if(!tfCPF.getText().equals("")){
           Socio socio = new Socio();
           socio.setCpf(tfCPF.getText());
           RNSocio rn = new RNSocio(socio);
           socio = rn.getSocioPeloCPF();
           rn.apto();
           
           JOptionPane.showMessageDialog(null, "Socio "+ socio.getNome()+ " autorizado! ",  "Autorizaçao Piscinas", JOptionPane.INFORMATION_MESSAGE);

           
           RNDependente rnDep = new RNDependente();
           ArrayList<Dependente> list =  rnDep.getTodosDependentes();
           
           if (list.isEmpty()){
               return;
           }
           
           for (Dependente dependente : list) {
                
                Random rand = new Random();
                double numero = rand.nextDouble();
                
                if (numero > 0.15 && dependente.getSocio().getId() == socio.getId()){
                    rnDep.apto( dependente.getId());
                    JOptionPane.showMessageDialog(null, "Dependente "+ dependente.getNome()+ " autorizado! ",  "Autorizaçao Piscinas", JOptionPane.INFORMATION_MESSAGE);
                }
    
           }
           
       }
       
       
    }//GEN-LAST:event_jButton1ActionPerformed

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
            java.util.logging.Logger.getLogger(Setor_Reserva.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Setor_Reserva.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Setor_Reserva.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Setor_Reserva.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Setor_Reserva().setVisible(true);
            }
        });
    }
    private String verificarCampos() throws ParseException {
        
        String mensagem = "";
        
        try {
            String date = dtChooserData.getDate().toString();
        } catch ( NullPointerException e) {
            return  mensagem.concat(" Selecione a data de nascimento.");
        }
                        
        Util util = new Util();
        String dataMenosAtual = util.calcularDataAtual();
        String dataMaisAtual = util.converterDataChooser(dtChooserData);
        
        long diferenca = util.calcularDiferencaEntreDatas(dataMaisAtual, dataMenosAtual, "Dias");
         
        if(diferenca <= 10){
            mensagem = mensagem.concat(" A data minima para reserva eh de 10 dias de antecedencia");
        }
        
        return mensagem;
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox<String> comboAmbiente;
    private com.toedter.calendar.JDateChooser dtChooserData;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSpinner spinnerHora;
    private javax.swing.JTextArea tAConvidados;
    private javax.swing.JTextField tfCPF;
    // End of variables declaration//GEN-END:variables

    private void preencherCombo() {
        comboAmbiente.removeAllItems();
        Ambiente ambiente = new Ambiente();
        RNAmbiente rnA = new RNAmbiente();
        ArrayList<Ambiente> list = rnA.getTodosAmbientes();
        
        for (Ambiente ambiente1 : list) {
            if (!ambiente1.getNome().equals("Piscina Aquecida") && !ambiente1.getNome().equals("Piscina") 
                    && !ambiente1.getNome().equals("Piscina Semi Olimpica")) comboAmbiente.addItem(ambiente1.getNome());
        }
    }
}