<cfscript>

/* 

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
	function parseDoc(){
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


</cfscript>