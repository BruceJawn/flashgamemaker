
import java.io.*;
import org.jdom.*;
import org.jdom.output.*;
import org.jdom.input.*;

public class Isotile {

    String xml;
    Document doc;
    String fichier = "xml/isotile.xml";

    public Isotile(SocketThread _st) {
        try {
            doc = loadXml(fichier);
            xml = xmlToString(doc);
            _st.send(xml);
        } catch (Exception e) {
            System.out.println("Probleme dans Isotile: Isotile");
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
        String xml;
        XMLOutputter out = new XMLOutputter(Format.getPrettyFormat());
        xml = out.outputString(_doc);
        return xml;
    }
}


