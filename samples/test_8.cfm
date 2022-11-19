<cfscript>

// @title Get attributes from tag.
// @description  Note we treat data as a struct.
tag = coldSoup.createNode(tagName="h2",text="sub heading",id="myID",classes="big bold");
tag.attr("title","tag has title");
tag.attr("data-test","Data test");
tag.attr("data-test2","Another test");

WriteDump(coldSoup.getAttributes(tag));

</cfscript>