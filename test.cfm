<cfscript>

test = create("org.coldsoup.testClass");

writeDump( test.test() );

private any function create( required string className ) {
	return createObject( "java", className );
}

</cfscript>