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
public class Reserva {
    private int idreserva;
    private Ambiente ambiente;
    private Socio socio;
    private Date data_reserva;
    private int hora_reserva;
    private String nome_dos_usuarios;

    public Reserva() {
    }
    
    public Reserva(Ambiente ambiente, Socio socio, Date data_reserva, int hora_reserva, String nome_dos_usuarios) {
        
        this.ambiente = ambiente;
        this.socio = socio;
        this.data_reserva = data_reserva;
        this.hora_reserva = hora_reserva;
        this.nome_dos_usuarios = nome_dos_usuarios;
    }

    

    public Ambiente getAmbiente() {
        return ambiente;
    }

    public void setAmbiente(Ambiente ambiente) {
        this.ambiente = ambiente;
    }

    public Socio getSocio() {
        return socio;
    }

    public void setSocio(Socio socio) {
        this.socio = socio;
    }

    public Date getData_reserva() {
        return data_reserva;
    }

    public void setData_reserva(Date data_reserva) {
        this.data_reserva = data_reserva;
    }

    public int getHora_reserva() {
        return hora_reserva;
    }

    public void setHora_reserva(int hora_reserva) {
        this.hora_reserva = hora_reserva;
    }

    public String getNome_dos_usuarios() {
        return nome_dos_usuarios;
    }

    public void setNome_dos_usuarios(String nome_dos_usuarios) {
        this.nome_dos_usuarios = nome_dos_usuarios;
    }

    public void setId(int id) {
        this.idreserva = id;
    }
    public int getID(){
        return this.idreserva;
    }
}
