/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package RN;

import com.toedter.calendar.JDateChooser;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author jao
 */
public class Util {
    public String converterDataChooser(JDateChooser jDateChooser){
        String formato = jDateChooser.getDateFormatString();
        SimpleDateFormat sdf = new SimpleDateFormat(formato);
        Calendar date = jDateChooser.getCalendar();

        Timestamp tms = Timestamp.from(Instant.now());

        TimeZone tz = TimeZone.getTimeZone("America/Sao_Paulo");  
        TimeZone.setDefault(tz);  
        return sdf.format(date.getTime());

    }
    public long calcularDiferencaEntreDatas(String dataMaisAtual, String dataMenosAtual, String diferenca){
            //String ano = 
            
            try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            Date dataDe = sdf.parse(dataMenosAtual);
            Date dataAte = sdf.parse(dataMaisAtual);
            
            switch(diferenca){
                case "Segundos":
                    return (dataAte.getTime() - dataDe.getTime()) / (1000);
                case "Horas":
                    return (dataAte.getTime() - dataDe.getTime()) / (1000*60*60);
                case "Meses":
                    return (dataAte.getTime() - dataDe.getTime()) / (1000*60*60*24) / 30;
                case "Dias":
                    return (dataAte.getTime() - dataDe.getTime()) / (1000*60*60*24);
                case "Anos":
                    return ((dataAte.getTime() - dataDe.getTime()) / (1000*60*60*24) / 30) / 12;
                default:
                    return 0;
            }
            
                        
        } catch (ParseException e) {
            e.printStackTrace();
        }    
        return 0;

    }
    public String calcularDataAtual(){
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar cal = Calendar.getInstance();
        Timestamp tms = Timestamp.from(Instant.now());
        TimeZone tz = TimeZone.getTimeZone("America/Sao_Paulo");  
        TimeZone.setDefault(tz);  
        cal = Calendar.getInstance(tz);
        cal.setTimeInMillis(tms.getTime());
        return sdf.format(cal.getTime());
    }
    public static boolean validar(String email)
    {
        boolean isEmailIdValid = false;
        if (email != null && email.length() > 0) {
            String expression = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";
            Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
            Matcher matcher = pattern.matcher(email);
            if (matcher.matches()) {
                isEmailIdValid = true;
            }
        }
        return isEmailIdValid;
    }
    public String converterData(Date data){
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(data.getTime());
    }
    public String converterDataPostgres(Date data){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(data.getTime());
    }
}
