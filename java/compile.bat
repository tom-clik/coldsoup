javac -cp .;c:/dev/java_library/jsoup-1.20.1.jar -d out src/org/coldsoup/*.java
rem javac -cp .;c:/dev/java/jsoup-1.20.1.jar;out/src/org/coldsoup -d out src/org/coldsoup/CommentRemover.java
cd out
jar cf org/coldsoup/coldsoup.jar org/coldsoup/*.class
REM jar tf org/coldsoup/coldsoup.jar
cd ..
