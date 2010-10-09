
import org.jdom.*;
import org.jdom.output.*;

class Isotime extends Thread {

    protected long beginTime;
    protected long secByDay = 86400;
    protected long secByHour = 3600;
    protected long secByMin = 60;
    long acctualTime = 0;

    public Isotime() {
        beginTime = System.currentTimeMillis();
        System.out.println(getDate());
    //start();
    }

    public long getValue() {
        return acctualTime;
    }

    public String getDate() {
        acctualTime = (System.currentTimeMillis() - beginTime) / 1000;
        return "Heure Virtuelle : Jour - " + getDay() + ", Heure - " + getHour() + ":" + getMin() + " (" + getSec() + ")";
    }

    public int getDay() {
        long modulo = acctualTime / secByDay;
        return (int) modulo;
    }

    public int getHour() {
        long modulo = acctualTime % secByDay;
        return (int) (modulo / secByHour);
    }

    public int getMin() {
        long modulo = acctualTime % secByHour;
        return (int) (modulo / secByMin);
    }

    public int getSec() {
        long modulo = acctualTime % secByMin;
        return (int) (modulo);
    }

    public Document getDoc() {
        Element root = new Element("isotime");
        Document doc = new Document(root);
        //un noeud game
        Element node1 = new Element("time");
        node1.setAttribute("beginTime", String.valueOf(beginTime));
        //Actualisation of acctualTime
        node1.setAttribute("day", String.valueOf(getDay()));
        node1.setAttribute("hour", String.valueOf(getHour()));
        node1.setAttribute("min", String.valueOf(getMin()));
        node1.setAttribute("sec", String.valueOf(getSec()));
        root.addContent(node1);
        return doc;
    }

    public String xmlToString(Document doc) {
        String xml;
        XMLOutputter out = new XMLOutputter(Format.getPrettyFormat());
        xml = out.outputString(doc);
        return xml;
    }

    public String getTimeXML() {
        acctualTime = (System.currentTimeMillis() - beginTime) / 1000;
        Document doc = getDoc();
        String xml = xmlToString(doc);
        return xml;
    }

    public void run() {
        try {
            System.out.println(getDate());
            System.out.println("--------");
            while (true) {
            }
        } catch (Exception e) {
            System.out.println("Probleme dans Time: Time");
            System.out.println(e);
        }

    }
}
