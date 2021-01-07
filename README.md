# Coldsoup

CFML wrapper for JSoup

## Introduction

Convenient component with methods for calling [JSoup](https://www.jsoup.org).

## Usage

Assumes Jsoup is installed in your server class path.

1. Instantiate the component as a singleton in a shared scope, e.g. application

```cfml
coldsoup = createObject("component", "coldsoup.coldSoup").init();
```

2. Call static methods as required.

3. Return type from `parse()` or `createNode()` is a JsoupNode.

These can be searched with `select(selector)` where selector is a JQuery-like selector. The return value is sufficiently
like a CF array to be used as one. For further info, see the JSoup documentation.

## Examples

```ColdFusion
// Parse some bad HTML

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));
displayCode(coldsoup.gethtml(doc,true));


html = coldSoup.clean(html="<script>bad code</script> text", whitelist="basic" );
node = coldSoup.createNode("h2","my heading");

```

