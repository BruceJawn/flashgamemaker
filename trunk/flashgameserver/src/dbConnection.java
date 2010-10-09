// CLASSE QUI GERE La connection a la BDD
import dbwConnection.*;
import java.util.Vector;

public class dbConnection {

    DbwConnection conn;
    String location = "http://localhost/dbw.php";
    String username = "angelstreet";
    String pwd = "dollars";
    String host = "localhost";
    String dataBase = "serveurSocket";
    private Vector list;

    public  dbConnection() {
        try {
            list = new Vector();
            conn = new DbwConnection(location, username, pwd, host, dataBase);
            Login();
        } catch (Exception e) {
            System.out.println("Problème de connexion a la BDD");
            System.out.println("--------");
        }
    }

    public void Login() {
        try {
            ResultSet rs = conn.executeQuery("SELECT * FROM `user` ");
            while (rs.next()) {
                list.add(new User(rs.getString(2),rs.getString(3)));
                System.out.println(rs.getString(2)+","+rs.getString(3));
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Problème de recuperation des donnee BDD");
            System.out.println("----Fermeture--du--Serveur----");
            System.exit(1);
        }
    }

    public String Identification(String login, String pass){
        String result = "";
        if(list.contains(new User(login,pass)))
            result ="Identification réussie";
        else
            result ="Identification échouée";
        return result;

    }
}

class User {

    String login;
    String pass;

    public User( String login, String pass) {
        this.login = login;
        this.pass = pass;
    }
}
