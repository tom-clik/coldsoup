<cfscript>

/* 

textBox suite for ColdSoup

## Usage

Run as per your normal method for running test suites

## History

| Date       | Author   | Notes
|------------|----------|---------------------------------------
| 2021-09-09 | Tom Peer | Created

*/

component extends="testbox.system.BaseSpec"{
	function beforeTests(){
		variables.dodgyHTML = FileRead("dodgy.html");
		variables.rubbishHTML = FileRead("rubbish.html");
		variables.someXML = FileRead("someXML.xml");
		variables.coldSoup = new coldsoup.coldSoup();
	}

	function afterTests(){}

	function setup( currentMethod ){}

	function teardown( currentMethod ){}

	/**
	* @test
	*/
	function parseHTML(){
		try {
			doc = variables.coldSoup.parse(variables.rubbishHTML);
		}
		catch (Any e) {
			$assert.fail( "Failed to parse document");
		}

		$assert.assert(doc.body().children().len() eq 2,"Children should be 2");
		local.text = Trim(doc.body().children().first().html());
		$assert.assert(local.text eq "This is a para","First paragraph wrong [#local.text#]");

	}

	/**
	* @test
	*/
	function parseXML(){
		try {
			local.doc = variables.coldSoup.parseXML(variables.someXML);
		}
		catch (Any e) {
			$assert.fail( "Failed to parse XML document");
		}

		
		local.data = variables.coldSoup.XMLNode2Struct(local.doc);
		$assert.assert(IsStruct(local.data),"Data returned form XML is not struct");
		$assert.assert(IsArray(local.data.settings.viewport),"Viewport key is not array");

	}
	/**
	* @test
	*/
	function createNode(){
		try {
			local.node = variables.coldSoup.createNode(
				tagName="h2",
				text = "my heading",
				id = "testid",
				classes = "testclass");
		}
		catch (Any e) {
			writeDump(e);
			$assert.fail( "Failed to create Node");
		}
		
		$assert.assert(local.node.attr("id") eq "testid","Id incorrect for created node");

		local.nodeInfo = variables.coldSoup.nodeInfo(local.node);
		$assert.assert(local.nodeInfo.type eq "Element","Element incorrect for created node");
		$assert.assert(local.nodeInfo.tagname eq "h2","tagname incorrect for created node");

	}




}

</cfscript>
