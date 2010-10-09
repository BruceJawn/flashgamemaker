
import org.jdom.*;
import org.jdom.output.*;

public class Isochar {

    String id;
    String login;
    String xml;
    Document doc;

    public Isochar(SocketThread _st, Document _doc) {
        try {
            this.id = _st.id;  
            this.doc = _doc;
            this.login = getLogin();
            this.xml = xmlToString(doc);
            _st.server.sendAll(xml);
            _st.server.getAllPlayer(_st);
        } catch (Exception e) {
            System.out.println("Probleme dans Isochar: Isochar");
            System.out.println(e);
        }
    }

    public String getLogin() {
        String _login = doc.getRootElement().getChild("char").getAttributeValue("login");
        return _login;
    }

    public Element getNode() {
        Element _node = doc.getRootElement().getChild("char");
        return (Element)_node.clone();
    }

    public String xmlToString(Document doc) {
        String xml;
        XMLOutputter out = new XMLOutputter(Format.getPrettyFormat());
        xml = out.outputString(doc);
        return xml;
    }
}
