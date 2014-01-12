request = require 'request'
querystring = require 'querystring'

# Base Job class
# 
# Provides common methods for Article, Frontpage, Image, Product and PageClassifier classes
# Useless as standalone class
#
class Job
	get = (props) => @::__defineGetter__ name, getter for name, getter of props
	set = (props) => @::__defineSetter__ name, setter for name, setter of props

	# Job constrictor stub
	constructor: () ->

	# Load API function 
	#
	# @property callback [Function] callback function that is called after request to API
	#
	load: (callback) =>
		@api.request @http_method, @api_method, @data, (error, result) =>
			@load_result = result
			if callback?
				callback error, result

	# Send API function
	#
	# @property content [String]
	# @property callback [Function]
	#
	send: (content, callback) =>
		@api.r.post
			url: @.url
			body: content
			headers:
				'content-type': 'text/plain'
		, (error, response, body) =>
			#console.log response
			if error?
				if callback?
					callback error, null
			else
				if callback?
					callback null, JSON.parse body


	# @property [String] Full URL to call current object
	get url: () ->
		data = @data
		data['token'] = @api.token
		return @api.apiHost + @api_method + '?' + querystring.stringify(@data)

	get relative_url: () ->
		data = @data
		data['token'] = @api.token
		return '/v' + @api.version + '/' + @api_method + '?' + querystring.stringify(data)

	# @property [Object] Job object from current object
	get job: () ->
		data = @data
		data['token'] = @api.token
		job = 
			method: @http_method
			relative_url: '/v' + @api.version + '/' + @api_method + '?' + querystring.stringify(data)
		return job

	# @property [Object] Result of `load` function call or false if `load` wasn't called before
	get result: () ->
		if @load_result?
			return @load_result
		else
			return false

# Article class provides access to [Article API](http://www.diffbot.com/dev/docs/article/)
#
# The Article API is used to extract clean article text from news article, blog post and similar text-heavy web pages.
#
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   article = api.article 'http://diffbot.com', ['*'], 10000
#   article.load (result) ->
#     console.log article.url
#     console.log article.job
#     console.log article.result
#
class Article extends Job
	# Constructor
	#
	# @param api [Object] Client instance
	# @param url [String] article URL to process
	# @param fields [Array] used to control which fields are returned by the API (optional)
	# @param timeout [Number] set a value in milliseconds to terminate the response (optional)
	#
	constructor: (@api, url, fields, timeout) ->
		@http_method = 'get'
		@api_method = 'article'

		@data = {}

		if typeof url == 'object'
			@data = url
		else
			if url?
				@data = 
					url: url

				if fields?
					@data['fields'] = fields.join(',')

				if timeout?
					@data['timeout'] = timeout
			else
				throw new Error 'URL parameter is requered!'

# Frontpage class provides access to [Frontpage API](http://www.diffbot.com/dev/docs/frontpage/)
#
# The Frontpage API takes in a multifaceted "homepage" and returns individual page elements.
#
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   frontpage = new Frontpage api, 'http://diffbot.com', 10000, 'json', 1
#   frontpage.load (result) ->
#     console.log frontpage.url
#     console.log frontpage.job
#     console.log frontpage.result
#
class Frontpage extends Job
	# Constructor
	#
	# @param api [Object] Client instance
	# @param url [String] Frontpage URL from which to extract items
	# @param timeout [Number] Specify a value in milliseconds to override the default API timeout of 5000ms (optional)
	# @param format [String] Format the response output in `xml` (default) or `json` (optional)	
	# @param all [Integer] Returns all content from page, including navigation and similar links that the Diffbot visual processing engine considers less important / non-core. (optional)	
	#
	constructor: (@api, url, timeout, format, all) ->
		@http_method = 'get'
		@api_method = 'frontpage'
		
		@data = {}
		if typeof url == 'object'
			@data = url
		else
			if url?
				@data =
					url: url

				if timeout?
					@data['timeout'] = timeout

				if format?
					@data['format'] = format

				if all?
					@data['all'] = all
			else
				throw new Error 'URL parameter is requered!'

# Image class provides access to [Image API](http://www.diffbot.com/dev/docs/image/)
#
# The Image API analyzes a web page and returns its primary image(s).
#
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   image = new Image api, 'http://diffbot.com', ['*'], 10000
#   image.load (result) ->
#     console.log image.url
#     console.log image.job
#     console.log image.result
#
class Image extends Job
	# Constructor
	#
	# @param api [Object] Client instance
	# @param url [String] Page URL from which to extract items
	# @param fields [Array] Used to control which fields are returned by the API.
	# @param timeout [Number] Set a value in milliseconds to terminate the response. By default the Image API has no timeout.
	#
	constructor: (@api, url, fields, timeout) ->
		@http_method = 'get'
		@api_method = 'image'
		
		@data = {}
		if typeof url == 'object'
			@data = url
		else
			if url?
				@data =
					url: url

				if fields?
					@data['fields'] = fields

				if timeout?
					@data['timeout'] = timeout
			else
				throw new Error 'URL parameter is requered!'

# Product class provides access to [Product API](http://www.diffbot.com/dev/docs/product/)
#
# The Product API analyzes a shopping or e-commerce product page and returns information on the product.
# 
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   product = new Product api, 'http://diffbot.com', ['*'], 10000
#   product.load (result) ->
#     console.log image.url
#     console.log image.job
#     console.log image.result
#
class Product extends Job
	# Constructor
	#
	# @param api [Object] Client instalce
	# @param url [String] Product URL to process
	# @param fields [Array] Used to control which fields are returned by the API (optional)
	# @param timeout [String] Set a value in milliseconds to terminate the response. By default the Product API has no timeout. (optional)
	#
	#
	constructor: (@api, url, fields, timeout) ->
		@http_method = 'get'
		@api_method = 'product'

		@data = {}
		if typeof url == 'object'
			@data = url
		else
			if url?
				@data =
					url: url

				if fields?
					@data['fields'] = fields

				if timeout?
					@data['timeout'] = timeout
			else
				throw new Error 'URL parameter is requered!'


# PageClassifier class provides access to [Page Classifier API](http://www.diffbot.com/dev/docs/analyze/)
#
# The Page Classifier API takes any web link and automatically determines what type of page it is.
# 
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   pageClassifier = new PageClassifier api, 'http://diffbot.com', 'article', ['*'], 1
#   pageClassifier.load (result) ->
#     console.log image.url
#     console.log image.job
#     console.log image.result
#
class PageClassifier extends Job
	# Constructor
	#
	# @param url [String] Product URL to process
	# @param mode [String] By default the Page Classifier API will fully extract pages that match an existing Diffbot Automatic API. Set mode to a specific page-type (e.g., `article`) to extract content only from that particular page-type. All others will simply return the page classification information.
	# @param fields [Array] Used to control which fields are returned by the API (optional)
	# @param stats [Number] Returns statistics on page classification and extraction, including an array of individual page-types and the Diffbot-determined score (likelihood) for each type.
	#
	constructor: (@api, url, mode, fields, stats) ->
		@http_method = 'get'
		@api_method = 'analyze'

		@data = {}
		if typeof url == 'object'
			@data = url
		else
			if url?
				@data =
					url: url

				if mode?
					@data['mode'] = mode

				if fields?
					@data['fields'] = fields

				if stats?
					@data['stats'] = stats
			else
				throw new Error 'URL parameter is requered!'

# Custom class provides access to [Custom APIs](http://www.diffbot.com/dev/docs/custom/)
#
# The Custom API Toolkit allows you to override the default content returned by Diffbot APIs.
#
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   custom = new Custom api, 'myFunction', http://diffbot.com', 10000
#   custom.load (result) ->
#     console.log image.url
#     console.log image.job
#     console.log image.result
class Custom extends Job
	get = (props) => @::__defineGetter__ name, getter for name, getter of props
	set = (props) => @::__defineSetter__ name, setter for name, setter of props

	# Constructor
	#
	# @param apiMethod [String] Name of custom API you've created in the [Custom API Toolkit](http://www.diffbot.com/dev/customize)
	# @param url [String] URL to process	
	# @param timeout [String] Specify a value in milliseconds (e.g., 15000) to override the default API timeout of 5000ms.
	#
	constructor: (@api, @apiMethod, url, timeout) ->
		@http_method = 'get'
		@api_method = @apiMethod

		@data = {}
		if typeof url == 'object'
			@data = url
		else
			if url?
				@data =
					url: url

				if timeout?
					@data['timeout'] = timeout
			else
				throw new Error 'URL parameter is requered!'

	# Load API function 
	#
	# @property callback [Function] callback function that is called after request to API
	#
	load: (callback) =>
		data = @data
		data['token'] = @api.token
		@api.r.get { url: @api.host + '/api/' + @apiMethod + '?' + querystring.stringify(@data) }, (error, response, body) =>
			if callback?
				if !error?
					result = JSON.parse body
					@load_result = result
					callback error, result
				else
					result = 
						error: error
					callback error, result

	# @property [String] Full URL to call current object
	get url: () ->
		data = @data
		data['token'] = @api.token
		return @api.apiHost +'/api/' + @api_method + '?' + querystring.stringify(data)

	# @property [Object] Job object from current object
	get job: () ->
		data = @data
		data['token'] = @api.token
		job = 
			method: @http_method
			relative_url: '/api/' + @api_method + '?' + querystring.stringify(data)
		return job

	# @property [Object] Result of `load` function call or false if `load` wasn't called before
	get result: () ->
		if @load_result?
			return @load_result
		else
			return false

# Bulk class provides access to [Bulk API](http://www.diffbot.com/dev/docs/bulk/)
#
# The Bulk API is built atop [Crawlbot](http://www.diffbot.com/dev/crawlbot), and allows you to submit a large number of URLs for asynchronous processing by a Diffbot API.
#
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   bulk = new Bulk api, 'myBulk', ['http://diffbot.com', 'http://news.ycombinator.com'], new Article(api, '').url, 'user@domain.com'
#   bulk.create (result) ->
#     console.log result
#     bulk.pause (result) ->
#       console.log result
#       bulk.resume (result) ->
#         console.log result
#         bulk.delete (result) ->
#           console.log result
#   
class Bulk
	# Constructs new bulk job
	#
	# @param name [String] Job name. This should be a unique identifier and will be used to modify your bulk job and retrieve its output.
	# @param urls [Array<String>] Array of URLs to process. (optional)
	# @param apiUrl [String] The full Diffbot API to be used for each URL. For instance, to process each URL via the article API, supply http://api.diffbot.com/v2/article. You may also include API parameters, e.g. http://api.diffbot.com/v2/article?fields=meta,tags. (optional)
	# @param notifyEmail [String] Send a message to this email address when the bulk job completes. (optional)
	# @param notifyWebHook [String] Pass a URL to be notified when the bulk job completes. You will receive a POST with the full JSON response in the POST body. (optional)
	# @param repeat [Number] Specify the number of days as a floating-point (e.g. 7.0) to repeat this job. By default bulk jobs will not be repeated. (optional)
	# @param maxRounds [Number] Specify the maximum number of repeats. Use maxRounds=-1 to continually repeat. (optional)
	# @param pageProcessPattern [Array] Enter strings array to limit pages processed to those whose HTML contains any of the content strings. If a page does not contain at least one of the strings, it will be ignored. (optional)
	#
	constructor: (@api, @name, urls, apiUrl, notifyEmail, notifyWebHook, repeat, maxRounds, pageProcessPattern) ->
		@http_method = 'get'
		@api_method = 'bulk'

		@data = {}
		if typeof urls == 'object' and !apiUrl?
			@data = urls
			@data['name'] = @name
		else
			@data =
				name: @name
				urls: urls.join(' ')
				apiUrl: apiUrl

			if notifyEmail?
				@data['notifyEmail'] = notifyEmail

			if notifyWebHook?
				@data['notifyWebHook'] = notifyWebHook

			if repeat?
				@data['repeat'] = repeat

			if maxRounds?
				@data['maxRounds'] = maxRounds

			if pageProcessPattern?
				@data['pageProcessPattern'] = pageProcessPattern.join(' || ')

	# Sends bulk job to DiffBot server
	#
	# @param callback [Function] Callback function (optional)
	#
	create: (callback)	 =>
		@api.request 'post', @api_method, @data, (error, result) =>
			if callback?
				callback error, result

	# Pauses bulk job
	#
	# @param callback [Function] Callback function (optional)
	#
	pause: (callback) =>
		@api.request @http_method, @api_method, { name: @name, pause: 1 }, (error, result) =>
			if callback?
				callback error, true

	# Resumes paused bulk job
	#
	# @param callback [Function] Callback function (optional)
	#
	resume: (callback) =>
		@api.request @http_method, @api_method, { name: @name, pause: 0 }, (error, result) =>
			if callback?
				callback error, true

	# Removes bulk job
	#
	# @param callback [Function] Callback function (optional)
	#
	delete: (callback) =>
		@api.request @http_method, @api_method, { name: @name, 'delete': 1 }, (error, result) =>
			if callback?
				callback error, true

	# Returns bulk job data
	#
	# @param callback [Function] Callback function (optional)
	#
	data: (callback) =>
		urls = []
		data = {}

		dataUrl = @api.apiHost + 'bulk/download/' + @api.token + '-' + @name + '_data.json'
		urlsUrl = @api.apiHost + 'bulk/download/' + @api.token + '-' + @name + '_urls.csv'

		@api.r.get { url: dataUrl }, (error, response, body) =>
			if !error?
				data = JSON.parse body
				@api.r.get { url: urlsUrl }, (error, response, body) =>
					if !error?
						urls = body
						if callback?
							callback null, { urls: urls, data: data }
					else
						if callback?
							callback error, null
			else
				if callback?
					callback error, null

	# Returns bulk job status
	#
	# @param callback [Function] Callback function (optional)
	#
	status: (callback) =>
		@request @http_method, @api_method, { name: @name }, (result) =>
			if callback?
				callback null, result

# Crawlbot class provides access to [Crawlbot API](http://www.diffbot.com/dev/docs/crawl/)
#
# The Crawlbot API allows you to programmatically manage [Crawlbot](http://www.diffbot.com/dev/crawl/v2) crawls and retrieve output.
#
# @example Basic usage
#   api = new Client '81823ff5c8132920a424405fed92745e'
#   crawl = new Crawlbot api, 'myBulk', ['http://diffbot.com'], new Article(api, '').url
#   crawl.create (result) ->
#     console.log result
#     crawl.pause (result) ->
#       console.log result
#       crawl.resume (result) ->
#         console.log result
#         crawl.delete (result) ->
#           console.log result
#
class Crawlbot
	# Constructs new Crawlbot
	#
	# @overload create(params, callback)
	#   Creates new crawlbot from parameters set
	#   @param api [Client] Client instance
	#   @param name [String] New crawlbot name
	#   @param options [Object] Parameters
	#   @option options [Array<String>] seeds Seed URL(s). Must be URL encoded. By default Crawlbot will spider subdomains (e.g., a seed URL of "http://www.diffbot.com" will include URLs at "http://blog.diffbot.com").
	#   @option options [String] apiUrl Full Diffbot API URL through which to process pages. E.g., `http://api.diffbot.com/v2/article` to process matching links via the Article API.
	#   @option options [Array<String>] urlCrawlPattern Array of strings to limit pages crawled to those whose URLs contain any of the content strings. You can use the exclamation point to specify a negative string, e.g. `!product` to exclude URLs containing the string "product." (optional)
	#   @option options [String] urlCrawlRegEx Specify a regular expression to limit pages crawled to those URLs that match your expression. This will override any `urlCrawlPattern` value. (optional)
	#   @option options [Array<String>] urlProcessPattern Array of strings to limit pages processed to those whose URLs contain any of the content strings. You can use the exclamation point to specify a negative string, e.g. !/category to exclude URLs containing the string "/category." (optional)
	#   @option options [String] urlProcessRegEx Specify a regular expression to limit pages processed to those URLs that match your expression. This will override any urlProcessPattern value. (optional)
	#   @option options [Array<String>] pageProcessPattern Array of strings to limit pages processed to those whose HTML contains any of the content strings. (optional)
	#   @option options [Number] maxToCrawl Specify max pages to spider. (optional)
	#   @option options [Number] maxToProcess Specify max pages to process through Diffbot APIs. Default: 10,000. (optional)
	#   @option options [Number] @param restrictDomain By default crawls will restrict to subdomains within the seed URL domain. Specify `restrictDomain=0` to follow all links regardless of domain. (optional)
	#   @option options [String] notifyEmail Send a message to this email address when the crawl hits the `maxToCrawl` or `maxToProcess` limit, or when the crawl completes. (optional)
	#   @option options [String] notifyWebHook Pass a URL to be notified when the crawl hits the `maxToCrawl` or `maxToProcess` limit, or when the crawl completes. You will receive a POST with `X-Crawl-Name` and `X-Crawl-Status` in the headers, and the full JSON response in the POST body. (optional)
	#   @option options [Number] crawlDelay Wait this many seconds between each URL crawled from a single IP address. Specify the number of seconds as an integer or floating-point number (e.g., 0.25). (optional)
	#   @option options [Number] repeat Specify the number of days as a floating-point (e.g. `7.0`) to repeat this crawl. By default crawls will not be repeated. (optional)
	#   @option options [Number] onlyProcessIfNew By default repeat crawls will only process new (previously unprocessed) pages. Set to 0 (`onlyProcessIfNew=0`) to process all content on repeat crawls. (optional)
	#   @option options [Number] maxRounds Specify the maximum number of crawl repeats. Use `maxRounds=-1` to continually repeat. (optional)
	#
	# @overload create (seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds, callback)
	#   Creates new crawlbot from passed parameters
	#   @param seeds [Array] Seed URL(s). Must be URL encoded. By default Crawlbot will spider subdomains (e.g., a seed URL of "http://www.diffbot.com" will include URLs at "http://blog.diffbot.com").
	#   @param apiUrl [String] Full Diffbot API URL through which to process pages. E.g., `http://api.diffbot.com/v2/article` to process matching links via the Article API.
	#   @param urlCrawlPattern [Array] Array of strings to limit pages crawled to those whose URLs contain any of the content strings. You can use the exclamation point to specify a negative string, e.g. `!product` to exclude URLs containing the string "product." (optional)
	#   @param urlCrawlRegEx [String] Specify a regular expression to limit pages crawled to those URLs that match your expression. This will override any `urlCrawlPattern` value. (optional)
	#   @param urlProcessPattern [Array] Array of strings to limit pages processed to those whose URLs contain any of the content strings. You can use the exclamation point to specify a negative string, e.g. !/category to exclude URLs containing the string "/category." (optional)
	#   @param urlProcessRegEx [String] Specify a regular expression to limit pages processed to those URLs that match your expression. This will override any urlProcessPattern value. (optional)
	#   @param pageProcessPattern [Array] Array of strings to limit pages processed to those whose HTML contains any of the content strings. (optional)
	#   @param maxToCrawl [Number] Specify max pages to spider. (optional)
	#   @param maxToProcess [Number] Specify max pages to process through Diffbot APIs. Default: 10,000. (optional)
	#   @param restrictDomain [Number] By default crawls will restrict to subdomains within the seed URL domain. Specify `restrictDomain=0` to follow all links regardless of domain. (optional)
	#   @param notifyEmail [String] Send a message to this email address when the crawl hits the `maxToCrawl` or `maxToProcess` limit, or when the crawl completes. (optional)
	#   @param notifyWebHook [String] Pass a URL to be notified when the crawl hits the `maxToCrawl` or `maxToProcess` limit, or when the crawl completes. You will receive a POST with `X-Crawl-Name` and `X-Crawl-Status` in the headers, and the full JSON response in the POST body. (optional)
	#   @param crawlDelay [Number] Wait this many seconds between each URL crawled from a single IP address. Specify the number of seconds as an integer or floating-point number (e.g., 0.25). (optional)
	#   @param repeat [Number] Specify the number of days as a floating-point (e.g. `7.0`) to repeat this crawl. By default crawls will not be repeated. (optional)
	#   @param onlyProcessIfNew [Number] By default repeat crawls will only process new (previously unprocessed) pages. Set to 0 (`onlyProcessIfNew=0`) to process all content on repeat crawls. (optional)
	#   @param maxRounds [Number] Specify the maximum number of crawl repeats. Use `maxRounds=-1` to continually repeat. (optional)
	#
	# @example Basic call
	#   api = new Client 'a1b2c3d4e5f6'
	#   bot = new Crawlbot api, 'fooBot', ['http://diffbot.com', 'http://news.ycombinator.com'], new Article(api, '').url
	#   bot.create (result) ->
	#     console.log result
	#     bot.pause (result) ->
	#       console.log result
	#       bot.resume()
	#
	constructor: (@api, @name, seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds) ->
		@http_method = 'get'
		@api_method = 'crawl'
		if !@name?
			throw new Error 'Name parameter is required!'
		else
			@data = {}
			if typeof seeds == 'object' and !apiUrl?
				@data = seeds
				@data['name'] = @name
			else
				@data =
					name: @name
					
				if seeds?
					@data['seeds'] = seeds.join(' ')
				
				if apiUrl? 
					@data['apiUrl'] = apiUrl

				if urlCrawlPattern?
					@data['urlCrawlPattern'] = urlCrawlPattern.join(' || ')

				if urlCrawlRegEx? 
					@data['urlCrawlRegEx'] = urlCrawlRegEx

				if urlProcessPattern?
					@data['urlProcessPattern'] = urlProcessPattern.join(' || ')

				if urlProcessRegEx?
					@data['urlProcessRegEx'] = urlProcessRegEx

				if pageProcessPattern?
					@data['pageProcessPattern'] = pageProcessPattern.join(' || ')

				if maxToCrawl?
					@data['maxToCrawl'] = maxToCrawl

				if maxToProcess?
					@data['maxToProcess'] = maxToProcess

				if restrictDomain?
					@data['restrictDomain'] = restrictDomain

				if notifyEmail?
					@data['notifyEmail'] = notifyEmail

				if notifyWebHook?
					@data['notifyWebHook'] = notifyWebHook

				if crawlDelay?
					@data['crawlDelay'] = crawlDelay

				if repeat?
					@data['repeat'] = repeat

				if onlyProcessIfNew?
					@data['onlyProcessIfNew'] = onlyProcessIfNew

				if maxRounds?
					@data['maxRounds'] = maxRounds
	
	# Creates new crawlbot information to DiffBot server
	#
	# @param callback [Function] Callback function (optional)
	#
	create: (callback) =>
		@api.request @http_method, @api_method, @data, (error, result) =>
			if callback?
				callback error, result

	# Pauses crawlbot job
	#
	# @param callback [Function] Callback function (optional)
	#
	pause: (callback) =>
		@api.request @http_method, @api_method, { name: @name, pause: 1 }, (error, result) =>
			if callback?
				callback error, true

	# Resumes paused crawlbot job
	#
	# @param callback [Function] Callback function (optional)
	#
	resume: (callback) =>
		@api.request @http_method, @api_method, { name: @name, pause: 0 }, (error, result) =>
			if callback?
				callback error, true

	# Removes all crawled data while maintaining crawl settings
	#
	# @param callback [Function] Callback function (optional)
	#
	restart: (callback) =>
		@api.request @http_method, @api_method, { name: @name, restart: 1 }, (error, result) =>
			if callback?
				callback error, true

	# Deletes a crawl, and all associated data, completely.
	#
	# @param callback [Function] Callback function (optional)
	#
	delete: (callback) =>
		@api.request @http_method, @api_method, { name: @name, 'delete': 1 }, (error, result) =>
			if callback?
				callback error, true

	# Returns crawlbot job data
	#
	# @param callback [Function] Callback function (optional)
	#
	data: (callback) =>
		urls = []
		data = {}

		dataUrl = @api.apiHost + 'crawl/download/' + @api.token + '-' + @name + '_data.json'
		urlsUrl = @api.apiHost + 'crawl/download/' + @api.token + '-' + @name + '_urls.csv'

		@api.r.get { url: dataUrl }, (error, response, body) =>
			if !error?
				data = JSON.parse body
				@api.r.get { url: urlsUrl }, (error, response, body) =>
					if !error?
						urls = body
						if callback?
							callback error, { urls: urls, data: data }
					else
						if callback?
							callback error, null
			else
				if callback?
					callback error, null

	# Returns crawlbot job status
	#
	# @param callback [Function] Callback function (optional)
	#
	status: (callback) =>
		@api.request @http_method, @api_method, { name: @name }, (error, result) =>
			if callback?
				callback error, result

# DiffBot API class
#
# Provides basic API calls support which could be used for non-implemented functions
#
# @example Basic usage
#   api = new Client '<your_developer_token>'
#
class Client
	# API client constructor
	#
	# @param token [String] developer token
	# @param host [String] API host URL (optional)
	# @param version [Number] API version (optional)
	#
	constructor: (@token, @host = 'http://api.diffbot.com', @version = 2) ->
		@apiHost = @host + '/v' + @version + '/'
		@r = request.defaults {}

	# Article API constructor
	#
	# @param url [String] article URL to process
	# @param fields [Array] used to control which fields are returned by the API (optional)
	# @param timeout [Number] set a value in milliseconds to terminate the response (optional)
	#
	article: (url, fields, timeout) =>
		return new Article @, url, fields, timeout

	# Frontpage API constructor
	#
	# @param url [String] Frontpage URL from which to extract items
	# @param timeout [Number] Specify a value in milliseconds to override the default API timeout of 5000ms (optional)
	# @param format [String] Format the response output in `xml` (default) or `json` (optional)	
	# @param all [Integer] Returns all content from page, including navigation and similar links that the Diffbot visual processing engine considers less important / non-core. (optional)	
	#
	frontpage: (url, timeout, format, all) =>
		return new Frontpage @, url, timeout, format, all

	# Page Classifier API constructor
	#
	# @param url [String] Product URL to process
	# @param mode [String] By default the Page Classifier API will fully extract pages that match an existing Diffbot Automatic API. Set mode to a specific page-type (e.g., `article`) to extract content only from that particular page-type. All others will simply return the page classification information.
	# @param fields [Array] Used to control which fields are returned by the API (optional)
	# @param stats [Number] Returns statistics on page classification and extraction, including an array of individual page-types and the Diffbot-determined score (likelihood) for each type.
	#
	pageclassifier: (url, mode, fields, stats) =>
		return new PageClassifier @, url, mode, fields, stats

	# Image API constructor
	#
	# @param url [String] Page URL from which to extract items
	# @param fields [Array] Used to control which fields are returned by the API.
	# @param timeout [Number] Set a value in milliseconds to terminate the response. By default the Image API has no timeout.
	#
	image: (url, fields, timeout) =>
		return new Image @, url, fields, timeout

	# Product API constructor
	#
	# @param url [String] Product URL to process
	# @param fields [Array] Used to control which fields are returned by the API (optional)
	# @param timeout [String] Set a value in milliseconds to terminate the response. By default the Product API has no timeout. (optional)
	#
	product: (url, fields, timeout) =>
		return new Product @, url, fields, timeout

	# Custom API constructor
	#
	# @param apiMethod [String] Name of custom API you've created in the [Custom API Toolkit](http://www.diffbot.com/dev/customize)
	# @param url [String] URL to process	
	# @param timeout [String] Specify a value in milliseconds (e.g., 15000) to override the default API timeout of 5000ms.
	#
	custom: (apiMethod, url, timeout) =>
		return new Custom @, apiMethod, url, timeout

	# Bulk job constructor
	#
	# @param name [String] Job name. This should be a unique identifier and will be used to modify your bulk job and retrieve its output.
	# @param urls [Array<String>] Array of URLs to process. (optional)
	# @param apiUrl [String] The full Diffbot API to be used for each URL. For instance, to process each URL via the article API, supply http://api.diffbot.com/v2/article. You may also include API parameters, e.g. http://api.diffbot.com/v2/article?fields=meta,tags. (optional)
	# @param notifyEmail [String] Send a message to this email address when the bulk job completes. (optional)
	# @param notifyWebHook [String] Pass a URL to be notified when the bulk job completes. You will receive a POST with the full JSON response in the POST body. (optional)
	# @param repeat [Number] Specify the number of days as a floating-point (e.g. 7.0) to repeat this job. By default bulk jobs will not be repeated. (optional)
	# @param maxRounds [Number] Specify the maximum number of repeats. Use maxRounds=-1 to continually repeat. (optional)
	# @param pageProcessPattern [Array] Enter strings array to limit pages processed to those whose HTML contains any of the content strings. If a page does not contain at least one of the strings, it will be ignored. (optional)
	#
	bulk: (name, urls, apiUrl, notifyEmail, notifyWebHook, repeat, maxRounds, pageProcessPattern) =>
		return new Bulk @, name, urls, apiUrl, notifyEmail, notifyWebHook, repeat, maxRounds, pageProcessPattern

	# Crawlbot constructor
	#
	# @param name [String] crawlbot unique name
	# @param seeds [Array] Seed URL(s). Must be URL encoded. By default Crawlbot will spider subdomains (e.g., a seed URL of "http://www.diffbot.com" will include URLs at "http://blog.diffbot.com") (optional)
	# @param apiUrl [String] Full Diffbot API URL through which to process pages. E.g., `http://api.diffbot.com/v2/article` to process matching links via the Article API (optional)
	# @param urlCrawlPattern [Array] Array of strings to limit pages crawled to those whose URLs contain any of the content strings. You can use the exclamation point to specify a negative string, e.g. `!product` to exclude URLs containing the string "product." (optional)
	# @param urlCrawlRegEx [String] Specify a regular expression to limit pages crawled to those URLs that match your expression. This will override any `urlCrawlPattern` value. (optional)
	# @param urlProcessPattern [Array] Array of strings to limit pages processed to those whose URLs contain any of the content strings. You can use the exclamation point to specify a negative string, e.g. !/category to exclude URLs containing the string "/category." (optional)
	# @param urlProcessRegEx [String] Specify a regular expression to limit pages processed to those URLs that match your expression. This will override any urlProcessPattern value. (optional)
	# @param pageProcessPattern [Array] Array of strings to limit pages processed to those whose HTML contains any of the content strings. (optional)
	# @param maxToCrawl [Number] Specify max pages to spider. (optional)
	# @param maxToProcess [Number] Specify max pages to process through Diffbot APIs. Default: 10,000. (optional)
	# @param restrictDomain [Number] By default crawls will restrict to subdomains within the seed URL domain. Specify `restrictDomain=0` to follow all links regardless of domain. (optional)
	# @param notifyEmail [String] Send a message to this email address when the crawl hits the `maxToCrawl` or `maxToProcess` limit, or when the crawl completes. (optional)
	# @param notifyWebHook [String] Pass a URL to be notified when the crawl hits the `maxToCrawl` or `maxToProcess` limit, or when the crawl completes. You will receive a POST with `X-Crawl-Name` and `X-Crawl-Status` in the headers, and the full JSON response in the POST body. (optional)
	# @param crawlDelay [Number] Wait this many seconds between each URL crawled from a single IP address. Specify the number of seconds as an integer or floating-point number (e.g., 0.25). (optional)
	# @param repeat [Number] Specify the number of days as a floating-point (e.g. `7.0`) to repeat this crawl. By default crawls will not be repeated. (optional)
	# @param onlyProcessIfNew [Number] By default repeat crawls will only process new (previously unprocessed) pages. Set to 0 (`onlyProcessIfNew=0`) to process all content on repeat crawls. (optional)
	# @param maxRounds [Number] Specify the maximum number of crawl repeats. Use `maxRounds=-1` to continually repeat. (optional)
	#
	crawlbot: (name, seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds) =>
		return new Crawlbot @, name, seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds

	# Method for raw API calls
	#
	# @param httpMethod [String] HTTP method - 'get', 'post', 'put', etc.
	# @param apiMethod [String] API methods - 'article', 'frontpage', etc.
	# @param data [Object] API call paramerters
	# @param callback [Function] callback function
	#
	# @example Basic call
	#   api.request 'get', 'article', { url: 'http://diffbot.com' }, (result) ->
	#     callback.log result
	#
	request: (httpMethod, apiMethod, data = {}, callback) =>
		data['token'] = @token

		params = 
			url: @apiHost + apiMethod
			method: httpMethod

		if httpMethod.toLowerCase() == 'get'
			params['qs'] = data
		else
			params['form'] = data

		@r.get params, (error, response, body) =>
			if error?
				callback error, null
			else
				if response.statusCode == 200
					callback null, JSON.parse body
				else
					callback body, null

exports.Client = Client
exports.Article = Article #
exports.Job = Job #
exports.Frontpage = Frontpage #
exports.Image = Image
exports.Product = Product
exports.PageClassifier = PageClassifier #
exports.Custom = Custom
exports.Bulk = Bulk
exports.Crawlbot = Crawlbot