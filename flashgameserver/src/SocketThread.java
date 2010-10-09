
import java.net.*;
import java.io.*;
import java.util.StringTokenizer;
import org.jdom.*;

class SocketThread extends Thread {

    public Socket socket;
    public Server server;
    public BufferedReader entree;
    public PrintStream out;
    public String line;
    public String id;
    public Isoworld isoworld;
    public Isochar isochar;
    public Isotile isotile;
    public Traitement traitement;

    public SocketThread(Socket _socket, Server _server, String _id) {
        this.socket = _socket;
        this.server = _server;
        this.id = _id;
        this.traitement = new Traitement();
        start();
    }

    synchronized public void forward(String message) {
        StringTokenizer tokenizer = new StringTokenizer(message, " ");
        while (tokenizer.hasMoreTokens()) {
            message = tokenizer.nextToken();
        }
        try {
            traitement.analyseLine(message, this);
        } catch (Exception e) {
            System.out.println("Problème dans socketThread : forward");
            System.out.println(e);
        }
    }

    synchronized public void send(String message) {
        try {
            PrintStream out = new PrintStream(socket.getOutputStream(), true);
            out.println(message.trim() + (char) 0x00);
        } catch (Exception e) {
            System.out.println("Problème dans socketThread : send");
            System.out.println(e);
        }
    }

    synchronized public void sendTime() {
        try {
            this.send(this.server.time.getTimeXML());
        } catch (Exception e) {
            System.out.println("Problème dans socketThread : sendTime");
            System.out.println(e);
        }
    }

     synchronized public void sendWrongLogin() {
        try {
            this.send("<wrongLogin></wrongLogin>");
        } catch (Exception e) {
            System.out.println("Problème dans socketThread : sendTime");
            System.out.println(e);
        }
    }

    synchronized public void checkPlayer(String _login, String _password) {
        try {
        Document result = server.checkPlayer(this, _login, _password);    
            if (result != null){
                this.sendTime();
                this.isoworld = new Isoworld(this);    
                this.isotile = new Isotile(this);
                this.isochar = new Isochar(this,result);
            } else {
                this.sendWrongLogin();
            }
        } catch (Exception e) {
            System.out.println("Probleme dans SocketThread : checkLogin");
            System.out.println(e);
        }
    }

    public void run() {
        try {
            entree = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            while (this.socket.isConnected() && (line = entree.readLine()) != null ) {
                if (line.equalsIgnoreCase(" ")) {
                    entree.close();
                    out.close();
                    socket.close();
                    break;
                } else {
                    forward(line);
                }
            }
        } catch (Exception e) {
            this.server.forceRemoveClient(this);
            
        }
    }
}


