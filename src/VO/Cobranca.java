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
interface Cobranca {
   void enviarBoletoMensalidade(Double valor,int mes, int ano, Socio socio);
   void enviarBoletoJoia(Double cub, Double joia, Socio socio);
}
