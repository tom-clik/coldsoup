<cfscript>

/* 


## Usage


## History

| Date       | Author   | Notes
|------------|----------|---------------------------------------
| 2021-09-09 | Tom Peer | tidied up a little bit

*/

component extends="testbox.system.BaseSpec"{
     function beforeTests(){
     	variables.dodgyHTML = FileRead("dodgy.html");
     	variables.rubbishHTML = FileRead("rubbish.html");
	}
     
    function afterTests(){}

    function setup( currentMethod ){}
     
    function teardown( currentMethod ){}

    /**
	* @test
	*/
	function createComponent(){
		try {
			local.coldSoup = new coldsoup.coldSoup();
		}
		catch (Any e) {
				$assert.fail( "Failed to create coldSoup component");
		}
	}

	/**
	* @test
	*/
	function createComponent(){
		try {
			local.coldSoup = new coldsoup.coldSoup();
			doc = coldSoup.parse(variables.rubbishHTML);
		}
		catch (Any e) {
			$assert.fail( "Failed to parse document");
		}

		$assert.assert(doc.body().children().len() eq 2,"Children should be 2");
		local.text = Trim(doc.body().children().first().html());
		$assert.assert(local.text eq "This is a para","First paragraph wrong [#local.text#]");

	}

}


/*

// Test 1.
// Parse some bad HTML

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));
displayCode(coldsoup.getHTML(doc));

// Test 2.
// Parse some XML and display using prettyXML.

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
displayCode(coldsoup.getPrettyXML(doc));

// test 3.
// Convert an XML node into a struct
test = coldSoup.XMLNode2Struct(doc.select("viewport").first());

WriteDump(test);

// test 4.
// Create a simple node
tag = coldSoup.createNode(tagName="h2",text="sub heading",id="myID",classes="big bold");
displayCode(tag.outerHtml());

textNode = coldSoup.createTextNode("My testing");
displayCode(textNode.outerHtml());

// test5
ok = coldSoup.isValidHTML(request.prc.dodgyHTML);
WriteOutput("Dodgy html is ok? " & yesNoFormat(ok));

// test6
// clean dodgy html. Default safeList is basic. Relaxed will allow h2 tags.
okText = coldSoup.clean(request.prc.dodgyHTML);
displayCode(okText);
okHTML = coldSoup.clean(html=request.prc.dodgyHTML,whitelist="relaxed");
displayCode(okHTML);

// test7
// Create our own safeList
safeList = coldSoup.getWhitelist("none");
// see the methods if you like
// writeDump(safeList);
safeList.addTags(javacast("String[]",  ["h1","h2"]));
safeList.addAttributes(javacast("String","h2"),javacast("String[]",  ["id"]));
safeList.addEnforcedAttribute(javacast("String","h2"),javacast("String","data-checked"),javacast("String","true"));

coldSoup.addWhiteList("test", safeList)
okHTML = coldSoup.clean(html=request.prc.dodgyHTML,whitelist="test");
displayCode(okHTML);

// test 8.
// Get attributes from tag. Note we treat data as a struct.
tag = coldSoup.createNode(tagName="h2",text="sub heading",id="myID",classes="big bold");
tag.attr("title","tag has title");
tag.attr("data-test","Data test");
WriteDump(coldSoup.getAttributes(tag));

function displayCode(html) {
	WriteOutput("<pre>" & HtmlEditFormat(arguments.html) & "<pre>");
}

*/

</cfscript>
