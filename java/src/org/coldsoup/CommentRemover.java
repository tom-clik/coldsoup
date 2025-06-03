/**
 * Singleton pattern comment remover
 */
package org.coldsoup;

import org.jsoup.nodes.Node;
import org.jsoup.nodes.Comment;
import org.jsoup.select.NodeVisitor;

public class CommentRemover {
    
    public CommentRemover() {
       
    }

    public void removeComments(org.jsoup.nodes.Node document) {
        RemoveCommentsVisitor visitor  = new RemoveCommentsVisitor();
        document.traverse(visitor);

    }
    
}