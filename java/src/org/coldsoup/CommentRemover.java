/**
 * Singleton pattern comment remover
 */
package org.coldsoup;

import org.jsoup.nodes.Node;
import org.jsoup.nodes.Comment;
import org.jsoup.select.NodeVisitor;

public class CommentRemover {
    
    // Private static instance of the class (singleton)
    private static CommentRemover instance;
    
    // Private instance variable for the visitor
    private RemoveCommentsVisitor visitor;
   
    private CommentRemover() {
        visitor = new RemoveCommentsVisitor();
    }

    // Public static method to get the instance of the singleton
    public static CommentRemover getInstance() {
        if (instance == null) {
            instance = new CommentRemover();
        }
        return instance;
    }

    public void removeComments(org.jsoup.nodes.Node document) {
         document.traverse(visitor);
    }
    
}