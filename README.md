# Coldsoup

CFML wrapper for [JSoup](https://www.jsoup.org).

## Introduction

Working with JSoup in CFML often requires JavaCasting variables and quite cumbersome syntax. This component provides simple CFML methods for working with JSoup.

## Usage

Assumes Jsoup is installed in your server class path.

1. Instantiate the component as a singleton in a shared scope, e.g. application

```cfml
application.coldsoup = new coldSoup();
```

2. Call static methods as required.

3. Return type from `parse()` is a [Jsoup Document](https://jsoup.org/apidocs/org/jsoup/nodes/Document.html).

These can be searched with `select(selector)` where selector is a JQuery-like selector. The return value is sufficiently like a CF array to be used as one. Each element is a [Jsoup Node](https://jsoup.org/apidocs/org/jsoup/nodes/Node.html), but the result might be null and should be tested before use.

## Examples

```cfml
// parse html into a document for searching/updating
doc = coldSoup.parse(htmlDocument);
headings = doc.select("h2");

// return cleaned html
html = coldSoup.clean(html="<script>bad code</script> text", whitelist="basic" );

// create JSoup node without having to JavaCast everything.
node = coldSoup.createNode("h2","my heading");


```

For further examples, see `testing/coldsouptest.cfm`.
