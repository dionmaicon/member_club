
package PER;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class conexao {
    
    private Connection con = null;
    
    public conexao(){}
    
    public Connection conectar(){
        try{
				  
                            Class.forName("org.postgresql.Driver");  
                           con = DriverManager.getConnection( "jdbc:postgresql://192.168.56.102:5"
                            + "432/clube", "jao", "post");
                            System.out.printf(con.getClientInfo().toString());
						
			}catch(ClassNotFoundException e){

                            System.out.printf("erro de classe não encontrada %s\n", e);
                            con = null;
			}catch(SQLException e){

                            System.out.printf("erro de sql conexao %s\n", e);
                            con = null;
			}
        
        return con;
    
    }
    
    
    public Connection desconectar(){
        
        try{
            con.close();
        }catch(SQLException e){
            System.out.printf("erro de sql conexao %s\n", e);
        }
        
        return con;
    }
}
