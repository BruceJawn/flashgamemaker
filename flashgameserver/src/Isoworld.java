
import java.io.*;
import org.jdom.*;
import org.jdom.output.*;
import org.jdom.input.*;

public class Isoworld {

    String xml;
    Document doc;
    String fichier = "xml/isoworld.xml";

    public Isoworld(SocketThread _st) {
      try {
            doc = loadXml(fichier);
            xml = xmlToString(doc);
            _st.send(xml);
        } catch (Exception e) {
            System.out.println("Probleme dans Isoworld: Isoworld");
            System.out.println(e);
        }
    }

    public Document loadXml(String src) {
        SAXBuilder sax = new SAXBuilder();
        Document _doc = new Document();
        try {
            _doc = sax.build(new File(src));
        } catch (Exception e) {
            System.out.println("Probleme dans Isoworld : loadXml");
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
