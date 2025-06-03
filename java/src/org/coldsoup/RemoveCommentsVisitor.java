package org.coldsoup;

import org.jsoup.nodes.Node;
import org.jsoup.nodes.Comment;
import org.jsoup.select.NodeVisitor;

import java.util.ArrayList;
import java.util.List;

public class RemoveCommentsVisitor implements NodeVisitor {

    public final List<Comment> commentsToRemove = new ArrayList<>();

    public void head(Node node, int depth) {
        if (node instanceof Comment) {
            commentsToRemove.add((Comment) node);
        }
    }

    public void tail(Node node, int depth) {
        // no-op
    }

    public void removeCollected() {
        for (Comment comment : commentsToRemove) {
            comment.remove();
        }
        commentsToRemove.clear(); // good hygiene
    }

}