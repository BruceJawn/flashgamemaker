
import java.net.*;
import java.io.*;
import java.util.Vector;
import org.jdom.*;


class Server {

    private Vector clientsSocket;
    private Vector clientsThread;
    boolean stopThread;
    ServerSocket receptionniste;
    Isoplayer is;
    Isotime time;
    String ip;
    int port = 4444;
    int id = 0;

    public static void main(String[] args) {
        int port = 4444;
        if (args.length > 1) {
            port = new Integer(args[0]);// si pas d'argument : port 4444 par defaut
        } 
        Server s = new Server();
        s.mainLoop(port);
    }

    public void getNbClients() {
        System.out.println("Nombre de connectes : " + clientsThread.size());
        System.out.println("--------");
    }

    public void listClients() {
        int total = clientsThread.size();
        if (total == 0) {
            System.out.println("Aucun client connecte");
        } else {
            System.out.println("Liste des connectes : ");
            for (int i = 0; i < total; i++) {
                String ip = ((SocketThread) clientsThread.elementAt(i)).socket.getInetAddress().toString();
                System.out.println(ip);
            }
            System.out.println("--------");
        }
    }

    public void getTime() {
        System.out.println("Heure Virtuelle : " + time.getDate());
        System.out.println("--------");
    }

    public void removeClient(SocketThread _st) {
        try {
            String line = "<deconnexion><char id='" + _st.id + "'/></deconnexion> ";
            //is.updateDocPlayer(_st);
            //is.removePlayer(_st);
            clientsSocket.remove(_st.socket);
            clientsThread.remove(_st);
            sendAll(line);
        } catch (Exception e) {
            System.out.println("Probleme dans Serveur : RemoveClient");
            System.out.println(e);
        }
        System.out.println("Le client " + _st.socket.getInetAddress().toString() + " s'est déconnecté");
        System.out.println("--------");
    }

    public void forceRemoveClient(SocketThread _st) {
        try {
            String line = "<deconnexion><char id='" + _st.id + "'/></deconnexion> ";
            //is.updateDocPlayer(_st);
            //is.removePlayer(_st);
            clientsSocket.remove(_st.socket);
            clientsThread.remove(_st);
            sendAll(line);
        } catch (Exception e) {
            System.out.println("Probleme dans Serveur : forceRemoveClient");
            System.out.println(e);
        }
        System.out.println("Déconnection sauvage du client " + _st.socket.getInetAddress().toString());
        System.out.println("--------");
    }

    public void closeServeur() {
        try {
            String line = "";
            //is.saveDocPlayer();
            for (int i = 0; i < clientsThread.size(); i++) {
                line = "<deconnexion><char id='" + ((SocketThread) clientsThread.elementAt(i)).id + "'/></deconnexion> ";
                sendAll(line);
                stopThread = true;
                receptionniste.close();
            }
            line = "<serverClose></serverClose>";
            sendAll(line);
        } catch (Exception e) {
            System.out.println("Probleme dans Serveur : closeServeur");
            System.out.println(e);
        }
    }

    public void addClientSocket(Socket s) {
        clientsSocket.add(s);
        System.out.println("Le client " + s.getInetAddress().toString() + " s'est connecté");
        System.out.println("--------");
    }

    public void addClientThread(SocketThread st) {
        clientsThread.add(st);
    }

    public void sendAll(String line) {
        for (int i = 0; i < clientsSocket.size(); i++) {
            try {
                if (((Socket) clientsSocket.elementAt(i)).isConnected()) {
                    PrintStream out = new PrintStream(((Socket) clientsSocket.elementAt(i)).getOutputStream(), true);
                    out.println(line.trim() + (char) 0x00);
                } else {
                    removeClient((SocketThread) clientsThread.elementAt(i));
                }
            } catch (Exception e) {
                System.out.println("Problème dans serveur : sendAll");
                System.out.println(e);
            }
        }
    }

    public void sendAllOthers(String line, Socket s) {
        for (int i = 0; i < clientsSocket.size(); i++) {
            try {
                if (((Socket) clientsSocket.elementAt(i)).isConnected()) {
                    if (((Socket) clientsSocket.elementAt(i)) != s) {
                        PrintStream out = new PrintStream(((Socket) clientsSocket.elementAt(i)).getOutputStream(), true);
                        out.println(line.trim() + (char) 0x00);
                    }
                } else {
                    removeClient((SocketThread) clientsThread.elementAt(i));
                }
            } catch (Exception e) {
                System.out.println("Problème dans serveur : sendAll");
                System.out.println(e);
            }
        }
    }

    public void getAllPlayer(SocketThread _st) {
        try {
            String line = is.getAllPlayer(_st);
            if (line != null) {
                PrintStream out = new PrintStream(_st.socket.getOutputStream(), true);
                out.println(line.trim() + (char) 0x00);
            }
        } catch (Exception e) {
            System.out.println("Problème dans serveur : getAllPlayer");
            System.out.println(e);
        }
    }

    public Document checkPlayer(SocketThread _st, String _login, String _password) {
        Document result = null;
        try {
            result = is.checkPlayer(_st, _login, _password);
        } catch (Exception e) {
            System.out.println("Problème dans serveur : checkPlayer");
            System.out.println(e);
        }
        return result;
    }

    public void mainLoop(int port) {
        try {
            stopThread = false;
            Socket client;
            SocketThread st;
            clientsSocket = new Vector();
            clientsThread = new Vector();
            this.ip = InetAddress.getLocalHost().getHostAddress();
            this.port = port;
            receptionniste = new ServerSocket(port);
            Command cmd = new Command(this);
            time = new Isotime();
            is = new Isoplayer();
            while (!stopThread) {
                try {
                    client = receptionniste.accept();
                    addClientSocket(client);
                    st = new SocketThread(client, this, String.valueOf(id));
                    addClientThread(st);
                    id++;
                } catch (Exception e) {
                    System.out.println("Problème de connexion dans serveur: mainLoop");
                    System.out.println(e);
                }
            }
        } catch (IOException e) {
            System.out.println("Problème de creation receptionniste dans serveur: mainLoop");
            System.out.println(e);
        }
    }
}

