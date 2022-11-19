<cfscript>

// @title Create a simple node
// @description  Three different methods to create a node.
// 
tag = coldSoup.createNode(tagName="h2",text="sub heading",id="myID",classes="big bold");
WriteDump(coldSoup.tagInfo(tag));

textNode = coldSoup.createTextNode("My testing");
WriteDump(coldSoup.tagInfo(textNode));

dodgyHTML = "<cftag image anotheratt= ' single never' another=abcfeg oneattr = ""'quote yeah yea'h'"" >Testing</cfatg>";
node = coldSoup.parseNode(html=dodgyHTML);
WriteDump(coldSoup.tagInfo(node));



</cfscript>