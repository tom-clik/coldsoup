import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.coldsoup.RemoveCommentsVisitor;

public class TestRemoveComments {
    public static void main(String[] args) {
        String html = "<html><body><!-- test comment --><p>Hello <b>World</b></p><!-- another comment --></body></html>";

        Document doc = Jsoup.parse(html);

        System.out.println("Before:");
        System.out.println(doc.html());

        // Use your custom visitor
        RemoveCommentsVisitor visitor = new RemoveCommentsVisitor();
        doc.traverse(visitor);

        System.out.println("\nAfter:");
        System.out.println(doc.html());
    }
}