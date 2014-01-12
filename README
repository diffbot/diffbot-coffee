# Diffbot API CoffeeScript client

## Preface

Through this Readme I use `diffbot` as a Client name. This however might be an issue in the future, since there is already a third-party gem with the same name. 

## Installation

Library can be installed from npm
    
    npm install diffbot-coffee

## Configuration

Obtaining CoffeeScript Diffbot client is simple as that:

```coffeescript
diffbot = require 'diffbot-coffee'
client = diffbot.Client '<your_key>'
```

## Usage

### Article API

Assume that we have our `client` configured. In order to use Automatic Article API we need to instantiate Article API instance first:

```coffeescript
article = client.article 'http://someurl.com', ['title']
console.log article.url
console.log article.relative_url
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

Calling Crawlbot API is similar to calling Article API. One thing worth to notice is that Crawlbot API Version 2 requires `apiUrl` which will be used to perform crawling. Ruby client makes possible to avoid using urls here. Instead we will use Ruby API described above:

```coffeescript
crawler = client.crawlbot 'my-bot', ['http://someurl.com', 'http://foo.com'], client.article('', ['title']).url
```

`client.article` returns object of type `Diffbot::APIClient::Article` which contains all data necessary to build required `apiUrl`. Once we have `crawler` object we can perform various operations on it:

```coffeescript
crawler.create
crawler.pause
crawler.restart
crawler.delete
crawler.data
crawler.status
```