
import java.io.*;
import org.jdom.*;
import org.jdom.output.*;
import org.jdom.input.*;

public class Isoplayer {

    String xml;
    String xmlPlayer;
    public Document doc;
    public Document docPlayer;
    String fichier = "xml/isoplayer.xml";

    public Isoplayer() {
        try {
            doc = loadXml(fichier);
            xml = xmlToString(doc);
            docPlayer = initDocPlayer(docPlayer);
            xmlPlayer = xmlToString(docPlayer);
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer: Isoplayer");
            System.out.println(e);
        }
    }

    public Document loadXml(String src) {
        SAXBuilder sax = new SAXBuilder();
        Document _doc = new Document();
        try {
            _doc = sax.build(new File(src));
        } catch (Exception e) {
            System.out.println("Probleme dans Isotile : loadXml");
        }
        return _doc;
    }

    public String xmlToString(Document _doc) {
        String _xml;
        XMLOutputter out = new XMLOutputter(Format.getPrettyFormat());
        _xml = out.outputString(_doc);
        return _xml;
    }

    public Document checkPlayer(SocketThread _st, String _login, String _password) {
        //l'element root du document xml
        try {
            Element root = doc.getRootElement();
            Element node;
            String xmlLogin, xmlPassword;
            for (int i = 0; i < root.getChildren("char").size(); i++) {
                node = (Element) (root.getChildren("char").get(i));
                xmlLogin = node.getAttributeValue("login");
                xmlPassword = node.getAttributeValue("password");
                if (_login.equals(xmlLogin) && _password.equals(xmlPassword)) {
                    node = setId((Element) node.clone(), _st.id);
                    docPlayer.getRootElement().addContent(node);
                    xmlPlayer = xmlToString(docPlayer);
                    return getChar((Element) node.clone());
                }
            }
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : checkPlayer");
            System.out.println(e);
        }
        return null;
    }

    public String getAllPlayer(SocketThread _st) {
        try {
            //l'element root du document xml
            Element root = docPlayer.getRootElement();
            Element node;
            String xmlId;
            for (int i = 0; i < root.getChildren("char").size(); i++) {
                node = (Element) (root.getChildren("char").get(i));
                xmlId = node.getAttributeValue("id");
                if (_st.id.equals(xmlId)) {
                    Document tmp = (Document) docPlayer.clone();
                    tmp.getRootElement().getChildren().remove(i);
                    if (tmp.getRootElement().getChildren().size() != 0) {
                        return xmlToString(tmp);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : getAllPlayer");
            System.out.println(e);
        }
        return null;
    }

    public void updatePlayer(Document _doc) {
        try {
            Element newRoot = _doc.getRootElement();
            Element newNode = newRoot.getChild("char");
            Element root = docPlayer.getRootElement();
            Element node;
            String xmlId;
            for (int i = 0; i < root.getChildren("char").size(); i++) {
                node = (Element) (root.getChildren("char").get(i));
                xmlId = node.getAttributeValue("id");
                if (newNode.getAttributeValue("id").equals(xmlId)) {
                    docPlayer.getRootElement().setContent(i, (Element) newNode.clone());
                    xmlPlayer = xmlToString(docPlayer);
                }
            }
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : updatePlayer");
            System.out.println(e);
        }
    }

    public void saveDocPlayer() {
        try {
            Element newRoot = docPlayer.getRootElement();
            Element newNode = newRoot.getChild("char");
            Element root = doc.getRootElement();
            Element node = root.getChild("char");
            String newId;
            String id;
            for (int i = 0; i < newRoot.getChildren("char").size(); i++) {
                for (int j = 0; j < root.getChildren("char").size(); j++) {
                    newNode = (Element) (newRoot.getChildren("char").get(i));
                    node = (Element) (root.getChildren("char").get(j));
                    newId = newNode.getAttributeValue("id");
                    id = newNode.getAttributeValue("id");
                    if (newId.equals(id)) {
                        root.setContent(i, (Element) newNode.clone());
                    }
                }
            }
         saveDoc();
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : saveDocPlayer");
            System.out.println(e);
        }
    }

    public void updateDocPlayer(SocketThread _st) {
        try {
            Element root = doc.getRootElement();
            Element node = root.getChild("char");
            String login;
            for (int i = 0; i < root.getChildren("char").size(); i++) {
                node = (Element) (root.getChildren("char").get(i));
                login = node.getAttributeValue("login");
                if (login.equals(_st.isochar.login)) {
                    root.getChildren().remove(i);
                    root.addContent(i, removeNodeId(_st.isochar.getNode()));

                }
            }
        saveDoc();
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : updateDocPlayer");
            System.out.println(e);
        }
    }

    public void saveDoc() {
        try {
            XMLOutputter sortie = new XMLOutputter(Format.getPrettyFormat());
            sortie.output(doc, new FileOutputStream("isoplayer.xml"));
            System.out.println("--Auto save---");
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : savePlayer");
            System.out.println(e);
        }
    }

    public String removePlayer(SocketThread _st) {
        //l'element root du document xml
        try {
            Element root = docPlayer.getRootElement();
            Element node;
            String xmlId;

            for (int i = 0; i < root.getChildren("char").size(); i++) {
                node = (Element) (root.getChildren("char").get(i));
                xmlId = node.getAttributeValue("id");
                if (_st.id.equals(xmlId)) {
                    docPlayer.getRootElement().getChildren().remove(i);
                }
            }
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : removePlayer");
            System.out.println(e);
        }
        return null;
    }

    public Element removeNodeId(Element _node) {
        try {
            _node.removeAttribute("id");
        } catch (Exception e) {
            System.out.println("Probleme dans Isoplayer : removeNodeId");
            System.out.println(e);
        }
        return _node;
    }

    public Document initDocPlayer(Document _docPlayer) {
        Element root = new Element("isoplayer");
        _docPlayer = new Document(root);
        return _docPlayer;
    }

    public Document getChar(Element node) {
        Element root = new Element("isochar");
        Document _doc = new Document(root);
        root.addContent(node);
        return _doc;
    }

    public Element setId(Element node, String id) {
        node.setAttribute("id", id);
        return node;
    }
}