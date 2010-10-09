// CLASSE QUI GERE LES COMMANDES TAPEES A LA CONSOLE
import java.io.*;

class Command extends Thread {

    BufferedReader in;
    String inputLine;
    String ip;
    int port;
    private Server server;

    public Command(Server server) {
        this.server = server;
        this.ip = server.ip;
        this.port = server.port;
        start();
    }

    public void run() {
        printWelcome(ip, port);
        try {
            in = new BufferedReader(new InputStreamReader(System.in));
            while ((inputLine = in.readLine()) != null) {
                if (inputLine.equalsIgnoreCase("quit")) {
                    Quit();
                } else if (inputLine.equalsIgnoreCase("total")) {
                    totalClient();
                } else if (inputLine.equalsIgnoreCase("list")) {
                    listClient();
                }
                else if (inputLine.equalsIgnoreCase("time")) {
                    getTime();
                }else {
                    printCommand();
                }
                System.out.flush(); // on affiche tout ce qui est en attente dans le flux
            }
        } catch (IOException e) {
            System.out.println("Problème dans Command");
            System.out.println("----Fermeture--du--Serveur----");
            System.exit(1);
        }
    }

    public void Quit() {

        try {
            server.closeServeur();
            System.out.println("----Fermeture--du--Serveur----");
            System.exit(0);
        } catch (Exception e) {
            System.out.println("Probleme dans Command : Quit");
        }
    }

    public void totalClient() {
        server.getNbClients();
    }

    public void listClient() {
        server.listClients();
    }

    public void getTime() {
        server.getTime();
    }

    public void printCommand() {
        // si la commande n'est ni "total", ni "quit", on informe l'utilisateur et on lui donne une aide
        System.out.println("Cette commande n'est pas supportee");
        System.out.println("Quitter : \"quit\", Total: \"total\" , Liste: \"list\" ou Time: \"time\"");
        System.out.println("--------");
    }

    static private void printWelcome(String ip, int port) { // Methode : affiche le message d'accueil
        System.out.println("--------");
        System.out.println("ServerXmlSocket : By AngelStreet");
        System.out.println("Copyright : 2008 - Angelstreetv2.free.fr");
        System.out.println("--------");
        System.out.println("Demarrarage du serveur sur l'ip : " + ip + " , port : " + port);
        System.out.println("--------");
        System.out.println("Quitter : tapez \"exit\"");
        System.out.println("Nombre de connectes : tapez \"total\"");
        System.out.println("Liste des connectes : tapez \"list\"");
        System.out.println("Heure Virtuelle : tapez \"time\"");
        System.out.println("--------");
    }
}

