/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import PER.PERReserva;
import VO.Reserva;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author Lucas
 */
public class RNReserva {
    
    private Reserva reserva;

    public RNReserva() {
    }
    
    public RNReserva (Reserva reserva){
        this.reserva = reserva;
    }
    
    public int salvar() throws SQLException/* throws SQLException*/{
        PERReserva pers = new PERReserva(reserva);
        if(pers.consultarReservaId()){
            pers.atualizar();
            return 0;
        }      
        if(pers.cadastrar()){
            return 1;
        }
        return -1;
    }
    public Reserva getReserva(){
        return this.reserva;
    }

    public ArrayList<Reserva> getTodasReservas(Date data){
        PERReserva pers = new PERReserva();
        return pers.getTodasReservas(data);
    }
    public ArrayList<Reserva> getTodasReservasMes(int mes) {
        PERReserva pers = new PERReserva();
        return pers.getTodasReservasMes(mes);
    
    }
    
}

