<cfscript>

/* Examples of using ColdSoup

Use menu to include test from folder

## Usage

Preview as web page to see menu of tests. 

## History

| Date       | Author   | Notes
|------------|----------|---------------------------------------
| 2021-09-09 | Tom Peer | tidied up a little bit

*/

setUpTests();

coldSoup = new coldsoup.coldSoup(request.prc.jar);

param name="request.rc.test" default="";

if (isValid("integer",request.rc.test)) {
	template = "test_" &  request.rc.test & ".cfm";
	local.info = getTestInfo(ExpandPath(template));
	writeOutput("<h2>#local.info.title#</h2>");
	writeOutput("<p>#local.info.description#</p>");
	cfinclude( template=template);
}
else {
    displayMenu();
}

function displayCode(html) {
	WriteOutput("<pre>" & HtmlEditFormat(arguments.html) & "</pre>");
}

function setUpTests() {
	request.prc.dodgyHTML = FileRead(ExpandPath("../testing/dodgy.html"),"utf-8");
}

function displayMenu() localmode=true {
	
	testlist = directoryList(getDirectoryFromPath(getCurrentTemplatePath()),false,"path","test_*");
	tests = {};
	for (test in testlist) {
		info = getTestInfo(test);
		tests[info.num] = info;
	}


	testsOrdered = StructSort( tests, "numeric", "asc", "num" );
	
	writeOutput("<ol>");

	for (num in testsOrdered) {
		test = tests[num];
		writeOutput("<li><h2><a href=""?test=#test.num#"">#test.title#</a></h2>");
		writeOutput("<p>#test.description#</li>");
	}
	writeOutput("</ol>");
}

struct function getTestInfo(filename) {

	local.text = FileRead(arguments.filename);
	local.num = reMatchNoCase("\d+", arguments.filename);
	local.data = {"num"=local.num[1]};
	for (local.field in ['title','description']) {
		local.val = reMatchNoCase("\@#local.field# .*?\r", local.text);
		local.data[local.field] = Trim(replaceNoCase(local.val[1],"@#local.field#",""));
	}
	return local.data;
	
}

</cfscript>