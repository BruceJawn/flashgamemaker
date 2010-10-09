
import org.jdom.*;
import org.jdom.output.*;
import org.jdom.input.*;
import java.io.StringReader;

public class Traitement {

    public void analyseLine(String line, SocketThread st) {
        Document doc = stringToXml(line);
        decodeDoc(doc, line , st);
    }

    public void decodeDoc(Document doc,String line, SocketThread st) {
       /* Element racine = doc.getRootElement();
        if (racine.getName().equals("login")) {//Send to All
            String _id = racine.getChild("char").getAttributeValue("id");
            String _password = racine.getChild("char").getAttributeValue("password");
            st.checkPlayer(_id,_password);
        }
        else if (racine.getName().equals("updatechar")) {//Send to All
            st.server.sendAllOthers(line,st.socket);
            st.server.is.updatePlayer(doc);
            st.isochar.doc =doc;
        }
        else{*/
            st.server.sendAll(line);
            //st.server.is.updatePlayer(doc);
        //}
    }

    public Document stringToXml(String line)  {
        SAXBuilder builder = new SAXBuilder();
        Document _doc=null;
        try{
        _doc = builder.build(new StringReader(line));
        }
        catch (Exception e) {
            System.out.println("Problème dans Traitement : stringToXml");
            System.out.println(e);
        }
        return _doc;
    }

    public void xmlToString(Document doc)  {
        String xml;
        XMLOutputter out = new XMLOutputter(Format.getPrettyFormat());
        xml = out.outputString(doc);
    }
}
