# Diffbot API for CoffeeScript

## Preface

This brief documentation doesn't include full API methods and parameters. Full library API documentation could be found in `doc` folder.

## Installation

Library can be installed from npm
    
    npm install diffbot-coffee

## Configuration

Obtaining CoffeeScript Diffbot client is simple as that:

```coffeescript
{Client} = require 'diffbot-coffee'
client = new Client '<your_key>'
```

## Usage

### Article API

Assume that we have our `client` configured. In order to use Automatic Article API we need to instantiate Article API instance first:

```coffeescript
article = client.article 'http://someurl.com', ['title']
```

After instantiation we can use our client object to retrieve information

```coffeescript
article.load (error, result) ->
  if error?
    console.error error
  else
    console.log result
```

If your content is not publicly available (e.g., behind a firewall), you can use `send` method or `article` object

```coffeescript
article = client.article 'http://diffbot.com', ['title']
content = '<html><head><title>Test title</title></head><body>Test body</body></html>'
article.send content, (error, result) ->
  if error?
    console.error error
  else
    console.log result
```

There is also alternative syntax for creating `article` objects

```coffeescript
article = client.article
              url: 'http://someurl.com'
              fields: ['title']
console.log article.url
console.log article.relative_url
article.load (error, result) ->  
  if error?
    console.error error
  else
    console.log result.type
```

Similar syntax is available for all objects.

### Page Classifier API

Calling Page Classifier API is also pretty simple:

```coffeescript
pageclassifier = client.pageclassifier 'http://someurl.com'
pageclassifier.load (error, result) ->
  if error?
    console.error error
  else
    console.log result.type
```

### Crawlbot API

Calling Crawlbot API is similar to calling Article API. One thing worth to notice is that Crawlbot API Version 2 requires `apiUrl` which will be used to perform crawling. Library implementation makes possible to avoid using urls here. Instead we will use Article API:

```coffeescript
crawler = client.crawlbot 'my-bot', ['http://someurl.com', 'http://foo.com'], client.article('', ['title']).url
crawler.create (error, result) ->
  if !error?
    console.log result
```

or alternatively we can set optional parameters as object

```coffeescript
crawler = client.crawlbot 'my-bot',
                seeds: ['http://someurl.com', 'http://foo.com']
                apiUrl: client.article('', ['title']).url

crawler.create (error, result) ->
  if !error?
    console.log result
```

Crawler object supports next methods

```coffeescript
crawler.pause
crawler.restart
crawler.delete
crawler.data
crawler.status
```

Usage is pretty simple

or alternatively we can set optional parameters as object

```coffeescript
crawler = client.crawlbot 'my-bot',
                seeds: ['http://someurl.com', 'http://foo.com']
                apiUrl: client.article('', ['title']).url

crawler.create (error, result) =>
  if !error?
    crawler.delete (error, result) =>
      if !error? and result
        console.log 'Crawler successfully deleted'
```