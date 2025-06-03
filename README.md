# Coldsoup

CFML wrapper for [JSoup](https://www.jsoup.org).

## Introduction

Working with JSoup in CFML often requires JavaCasting variables and quite cumbersome syntax. This component provides some simpler CFML methods.

## Important Note

JSOUP has become incredibly popular and many other Java Libraries now bundle it, including the ever popular Flexmark. To ensure we load the library we want, we have to use the OSGI system in Lucee. This is very simple, but we need to know the path to the JSOUP Jar. In many ways this is better than loading through the class path.

## Usage


1. Instantiate the component as a singleton in a shared scope, e.g. application
	```cfml
	application.coldsoup = new coldSoup(pathtoJAR);
	```

2. Call static methods as required, e.g.
	```cfml
	myDoc = application.coldsoup.parse(html);
	```

3. Return type from `parse()` is a [Jsoup Document](https://jsoup.org/apidocs/org/jsoup/nodes/Document.html).

	These can be searched with `select(selector)` where selector is a JQuery-like selector, e.g. `p.class`. The return value is sufficiently like a CF array to be used as one. Each element is a [Jsoup Node](https://jsoup.org/apidocs/org/jsoup/nodes/Node.html). Modern versions of Jsoup should return an empty array if none are found. If you get null values, upgrade.

## Examples

### Parse html into a document for searching/updating

```cfml
doc = coldSoup.parse(htmlDocument);
headings = doc.select("h2");
for (heading in headings) {...}
```

### Return cleaned html

```cfml
html = coldSoup.clean(html="<script>bad code</script> text", whitelist="basic" );
```

### create JSoup node without having to JavaCast everything.

```cfml
node = coldSoup.createNode("h2","my heading");
```

For further examples, see samples.
