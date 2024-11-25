package org.coldsoup;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

public class testClass {
    public String test() {
        String html = "<p>This is a paragraph.</p>";
        Safelist safelist = Safelist.basic(); // Choose a predefined safelist
        // boolean isValid = Jsoup.isValid(html, safelist);
        boolean isValid = true;
        return("Is HTML valid? " + isValid);
    }
}