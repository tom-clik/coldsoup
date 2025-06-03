package org.coldsoup;

import org.jsoup.nodes.Node;
import org.jsoup.nodes.Comment;
import org.jsoup.select.NodeVisitor;

public class RemoveCommentsVisitor implements NodeVisitor {
    public void head(Node node, int depth) {
        if (node != null && node instanceof Comment) {
            node.remove();
        }
    }

    public void tail(Node node, int depth) {
        // no-op
    }
}