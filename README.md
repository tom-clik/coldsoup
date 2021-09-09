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

3. Return type from `parse()` or `createNode()` is a [Jsoup Node](https://jsoup.org/apidocs/org/jsoup/nodes/Node.html).

These can be searched with `select(selector)` where selector is a JQuery-like selector. The return value is sufficiently like a CF array to be used as one. For further info, see the JSoup documentation.

## Examples

```ColdFusion
// Parse some bad HTML

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));
displayCode(coldsoup.getHTML(doc));


html = coldSoup.clean(html="<script>bad code</script> text", whitelist="basic" );
node = coldSoup.createNode("h2","my heading");

```

For further examples, see `testing/coldsouptest.cfm`.
