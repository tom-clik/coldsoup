import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.coldsoup.CommentRemover;

public class TestRemoveComments {
    public static void main(String[] args) {
        String html = "<!-- this is a comment -->\n<p>This is a para\n\n<ul>\n<li>This is  alist\n    <p>This is para 2 inside list<!-- this is a comment2 -->\n<li> This is a list\n    <ul>\n        <li>This is another list\n            <p>This is para 3\n        <li>This is another list\n\n<!-- this is a comment3 -->\n\n";

        Document doc = Jsoup.parse(html);

        System.out.println("Before:");
        System.out.println(doc.html());

        CommentRemover remover = new CommentRemover();
        remover.removeComments(doc);

        System.out.println("\nAfter:");
        System.out.println(doc.html());
    }

}