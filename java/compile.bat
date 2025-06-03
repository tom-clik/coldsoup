javac -cp .;c:/dev/java/jsoup-1.18.1.jar -d out src/org/coldsoup/RemoveCommentsVisitor.java
javac -cp .;c:/dev/java/jsoup-1.18.1.jar -d out src/org/coldsoup/testClass.java
javac -cp .;c:/dev/java/jsoup-1.18.1.jar;out/src/org/coldsoup -d out src/org/coldsoup/CommentRemover.java
cd out
jar cf org/coldsoup/coldsoup.jar org/coldsoup/*.class
REM jar tf org/coldsoup/coldsoup.jar
cd ..
