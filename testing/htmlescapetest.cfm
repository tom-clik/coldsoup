<cfscript>

/* Test htmlEscape


## Usage

## History

| Date       | Author   | Notes
|------------|----------|---------------------------------------
| 2021-09-09 | Tom Peer | created this test

*/

setUpTests();

// new style instantiation. Will call init()!.
coldSoup = new coldSoup();


doc = coldSoup.HTMLEscapeTag(doc=request.prc.dodgyHTML, tag="script,style,meta",wrap="pre");

WriteOutput(doc);

function setUpTests() {
	request.prc = {};
	request.prc.dodgyHTML = FileRead(ExpandPath("../testing/dodgy.html"));
}

</cfscript>