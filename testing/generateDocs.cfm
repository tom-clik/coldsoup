<cfscript>
/*

Generate documentation using [Docbox](https://github.com/Ortus-Solutions/DocBox)

*/


// output folder
outputPath = '../docs';
outputFolder = expandPath(outputPath);

if (! directoryExists(outputFolder)) {
	try {
		directoryCreate(outputFolder);
	}
	catch (Any e) {
		throw(
			 message="Unable to create output folder for documentation"
			,detail=e.message & e.detail
		);
	}
}

// create with HTML strategy
docbox = new docbox.DocBox(
  strategy = "HTML",
  properties = { 
    projectTitle="Coldbox", 
    outputDir=outputFolder
  }
);

//
docbox.generate(
    source  = "#expandPath( '..' )#",
    mapping = "coldsoup"
);

location(outputPath & "/index.html",false);

</cfscript>