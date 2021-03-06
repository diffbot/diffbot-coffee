// Generated by CoffeeScript 1.6.3
var Article, Bulk, Client, Crawlbot, Custom, Frontpage, Image, Job, PageClassifier, Product, querystring, request,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

request = require('request');

querystring = require('querystring');

Job = (function() {
  var get, set,
    _this = this;

  get = function(props) {
    var getter, name, _results;
    _results = [];
    for (name in props) {
      getter = props[name];
      _results.push(Job.prototype.__defineGetter__(name, getter));
    }
    return _results;
  };

  set = function(props) {
    var name, setter, _results;
    _results = [];
    for (name in props) {
      setter = props[name];
      _results.push(Job.prototype.__defineSetter__(name, setter));
    }
    return _results;
  };

  function Job() {
    this.send = __bind(this.send, this);
    this.load = __bind(this.load, this);
  }

  Job.prototype.load = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, this.data, function(error, result) {
      _this.load_result = result;
      if (callback != null) {
        return callback(error, result);
      }
    });
  };

  Job.prototype.send = function(content, callback) {
    var _this = this;
    return this.api.r.post({
      url: this.url,
      body: content,
      headers: {
        'content-type': 'text/plain'
      }
    }, function(error, response, body) {
      if (error != null) {
        if (callback != null) {
          return callback(error, null);
        }
      } else {
        if (callback != null) {
          return callback(null, JSON.parse(body));
        }
      }
    });
  };

  get({
    url: function() {
      var data;
      data = this.data;
      data['token'] = this.api.token;
      return this.api.apiHost + this.api_method + '?' + querystring.stringify(this.data);
    }
  });

  get({
    relative_url: function() {
      var data;
      data = this.data;
      data['token'] = this.api.token;
      return '/v' + this.api.version + '/' + this.api_method + '?' + querystring.stringify(data);
    }
  });

  get({
    job: function() {
      var data, job;
      data = this.data;
      data['token'] = this.api.token;
      job = {
        method: this.http_method,
        relative_url: '/v' + this.api.version + '/' + this.api_method + '?' + querystring.stringify(data)
      };
      return job;
    }
  });

  get({
    result: function() {
      if (this.load_result != null) {
        return this.load_result;
      } else {
        return false;
      }
    }
  });

  return Job;

}).call(this);

Article = (function(_super) {
  __extends(Article, _super);

  function Article(api, url, fields, timeout) {
    this.api = api;
    this.http_method = 'get';
    this.api_method = 'article';
    this.data = {};
    if (typeof url === 'object') {
      this.data = url;
    } else {
      if (url != null) {
        this.data = {
          url: url
        };
        if (fields != null) {
          this.data['fields'] = fields.join(',');
        }
        if (timeout != null) {
          this.data['timeout'] = timeout;
        }
      } else {
        throw new Error('URL parameter is requered!');
      }
    }
  }

  return Article;

})(Job);

Frontpage = (function(_super) {
  __extends(Frontpage, _super);

  function Frontpage(api, url, timeout, format, all) {
    this.api = api;
    this.http_method = 'get';
    this.api_method = 'frontpage';
    this.data = {};
    if (typeof url === 'object') {
      this.data = url;
    } else {
      if (url != null) {
        this.data = {
          url: url
        };
        if (timeout != null) {
          this.data['timeout'] = timeout;
        }
        if (format != null) {
          this.data['format'] = format;
        }
        if (all != null) {
          this.data['all'] = all;
        }
      } else {
        throw new Error('URL parameter is requered!');
      }
    }
  }

  return Frontpage;

})(Job);

Image = (function(_super) {
  __extends(Image, _super);

  function Image(api, url, fields, timeout) {
    this.api = api;
    this.http_method = 'get';
    this.api_method = 'image';
    this.data = {};
    if (typeof url === 'object') {
      this.data = url;
    } else {
      if (url != null) {
        this.data = {
          url: url
        };
        if (fields != null) {
          this.data['fields'] = fields;
        }
        if (timeout != null) {
          this.data['timeout'] = timeout;
        }
      } else {
        throw new Error('URL parameter is requered!');
      }
    }
  }

  return Image;

})(Job);

Product = (function(_super) {
  __extends(Product, _super);

  function Product(api, url, fields, timeout) {
    this.api = api;
    this.http_method = 'get';
    this.api_method = 'product';
    this.data = {};
    if (typeof url === 'object') {
      this.data = url;
    } else {
      if (url != null) {
        this.data = {
          url: url
        };
        if (fields != null) {
          this.data['fields'] = fields;
        }
        if (timeout != null) {
          this.data['timeout'] = timeout;
        }
      } else {
        throw new Error('URL parameter is requered!');
      }
    }
  }

  return Product;

})(Job);

PageClassifier = (function(_super) {
  __extends(PageClassifier, _super);

  function PageClassifier(api, url, mode, fields, stats) {
    this.api = api;
    this.http_method = 'get';
    this.api_method = 'analyze';
    this.data = {};
    if (typeof url === 'object') {
      this.data = url;
    } else {
      if (url != null) {
        this.data = {
          url: url
        };
        if (mode != null) {
          this.data['mode'] = mode;
        }
        if (fields != null) {
          this.data['fields'] = fields;
        }
        if (stats != null) {
          this.data['stats'] = stats;
        }
      } else {
        throw new Error('URL parameter is requered!');
      }
    }
  }

  return PageClassifier;

})(Job);

Custom = (function(_super) {
  var get, set,
    _this = this;

  __extends(Custom, _super);

  get = function(props) {
    var getter, name, _results;
    _results = [];
    for (name in props) {
      getter = props[name];
      _results.push(Custom.prototype.__defineGetter__(name, getter));
    }
    return _results;
  };

  set = function(props) {
    var name, setter, _results;
    _results = [];
    for (name in props) {
      setter = props[name];
      _results.push(Custom.prototype.__defineSetter__(name, setter));
    }
    return _results;
  };

  function Custom(api, apiMethod, url, timeout) {
    this.api = api;
    this.apiMethod = apiMethod;
    this.load = __bind(this.load, this);
    this.http_method = 'get';
    this.api_method = this.apiMethod;
    this.data = {};
    if (typeof url === 'object') {
      this.data = url;
    } else {
      if (url != null) {
        this.data = {
          url: url
        };
        if (timeout != null) {
          this.data['timeout'] = timeout;
        }
      } else {
        throw new Error('URL parameter is requered!');
      }
    }
  }

  Custom.prototype.load = function(callback) {
    var data,
      _this = this;
    data = this.data;
    data['token'] = this.api.token;
    return this.api.r.get({
      url: this.api.host + '/api/' + this.apiMethod + '?' + querystring.stringify(this.data)
    }, function(error, response, body) {
      var result;
      if (callback != null) {
        if (error == null) {
          result = JSON.parse(body);
          _this.load_result = result;
          return callback(error, result);
        } else {
          result = {
            error: error
          };
          return callback(error, result);
        }
      }
    });
  };

  get({
    relative_url: function() {
      var data;
      data = this.data;
      data['token'] = this.api.token;
      return '/api/' + this.api_method + '?' + querystring.stringify(data);
    }
  });

  get({
    url: function() {
      var data;
      data = this.data;
      data['token'] = this.api.token;
      return this.api.apiHost(+'/api/' + this.api_method + '?' + querystring.stringify(data));
    }
  });

  get({
    job: function() {
      var data, job;
      data = this.data;
      data['token'] = this.api.token;
      job = {
        method: this.http_method,
        relative_url: '/api/' + this.api_method + '?' + querystring.stringify(data)
      };
      return job;
    }
  });

  get({
    result: function() {
      if (this.load_result != null) {
        return this.load_result;
      } else {
        return false;
      }
    }
  });

  return Custom;

}).call(this, Job);

Bulk = (function() {
  function Bulk(api, name, urls, apiUrl, notifyEmail, notifyWebHook, repeat, maxRounds, pageProcessPattern) {
    this.api = api;
    this.name = name;
    this.status = __bind(this.status, this);
    this.data = __bind(this.data, this);
    this["delete"] = __bind(this["delete"], this);
    this.resume = __bind(this.resume, this);
    this.pause = __bind(this.pause, this);
    this.create = __bind(this.create, this);
    this.http_method = 'get';
    this.api_method = 'bulk';
    this.data = {};
    if (typeof urls === 'object' && (apiUrl == null)) {
      this.data = urls;
      this.data['name'] = this.name;
    } else {
      this.data = {
        name: this.name,
        urls: urls.join(' '),
        apiUrl: apiUrl
      };
      if (notifyEmail != null) {
        this.data['notifyEmail'] = notifyEmail;
      }
      if (notifyWebHook != null) {
        this.data['notifyWebHook'] = notifyWebHook;
      }
      if (repeat != null) {
        this.data['repeat'] = repeat;
      }
      if (maxRounds != null) {
        this.data['maxRounds'] = maxRounds;
      }
      if (pageProcessPattern != null) {
        this.data['pageProcessPattern'] = pageProcessPattern.join(' || ');
      }
    }
  }

  Bulk.prototype.create = function(callback) {
    var _this = this;
    return this.api.request('post', this.api_method, this.data, function(error, result) {
      if (callback != null) {
        return callback(error, result);
      }
    });
  };

  Bulk.prototype.pause = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      pause: 1
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Bulk.prototype.resume = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      pause: 0
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Bulk.prototype["delete"] = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      'delete': 1
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Bulk.prototype.data = function(callback) {
    var data, dataUrl, urls, urlsUrl,
      _this = this;
    urls = [];
    data = {};
    dataUrl = this.api.apiHost + 'bulk/download/' + this.api.token + '-' + this.name + '_data.json';
    urlsUrl = this.api.apiHost + 'bulk/download/' + this.api.token + '-' + this.name + '_urls.csv';
    return this.api.r.get({
      url: dataUrl
    }, function(error, response, body) {
      if (error == null) {
        data = JSON.parse(body);
        return _this.api.r.get({
          url: urlsUrl
        }, function(error, response, body) {
          if (error == null) {
            urls = body;
            if (callback != null) {
              return callback(null, {
                urls: urls,
                data: data
              });
            }
          } else {
            if (callback != null) {
              return callback(error, null);
            }
          }
        });
      } else {
        if (callback != null) {
          return callback(error, null);
        }
      }
    });
  };

  Bulk.prototype.status = function(callback) {
    var _this = this;
    return this.request(this.http_method, this.api_method, {
      name: this.name
    }, function(result) {
      if (callback != null) {
        return callback(null, result);
      }
    });
  };

  return Bulk;

})();

Crawlbot = (function() {
  function Crawlbot(api, name, seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds) {
    this.api = api;
    this.name = name;
    this.status = __bind(this.status, this);
    this.data = __bind(this.data, this);
    this["delete"] = __bind(this["delete"], this);
    this.restart = __bind(this.restart, this);
    this.resume = __bind(this.resume, this);
    this.pause = __bind(this.pause, this);
    this.create = __bind(this.create, this);
    this.http_method = 'get';
    this.api_method = 'crawl';
    if (this.name == null) {
      throw new Error('Name parameter is required!');
    } else {
      this.data = {};
      if (typeof seeds === 'object' && (apiUrl == null)) {
        this.data = seeds;
        this.data['name'] = this.name;
      } else {
        this.data = {
          name: this.name
        };
        if (seeds != null) {
          this.data['seeds'] = seeds.join(' ');
        }
        if (apiUrl != null) {
          this.data['apiUrl'] = apiUrl;
        }
        if (urlCrawlPattern != null) {
          this.data['urlCrawlPattern'] = urlCrawlPattern.join(' || ');
        }
        if (urlCrawlRegEx != null) {
          this.data['urlCrawlRegEx'] = urlCrawlRegEx;
        }
        if (urlProcessPattern != null) {
          this.data['urlProcessPattern'] = urlProcessPattern.join(' || ');
        }
        if (urlProcessRegEx != null) {
          this.data['urlProcessRegEx'] = urlProcessRegEx;
        }
        if (pageProcessPattern != null) {
          this.data['pageProcessPattern'] = pageProcessPattern.join(' || ');
        }
        if (maxToCrawl != null) {
          this.data['maxToCrawl'] = maxToCrawl;
        }
        if (maxToProcess != null) {
          this.data['maxToProcess'] = maxToProcess;
        }
        if (restrictDomain != null) {
          this.data['restrictDomain'] = restrictDomain;
        }
        if (notifyEmail != null) {
          this.data['notifyEmail'] = notifyEmail;
        }
        if (notifyWebHook != null) {
          this.data['notifyWebHook'] = notifyWebHook;
        }
        if (crawlDelay != null) {
          this.data['crawlDelay'] = crawlDelay;
        }
        if (repeat != null) {
          this.data['repeat'] = repeat;
        }
        if (onlyProcessIfNew != null) {
          this.data['onlyProcessIfNew'] = onlyProcessIfNew;
        }
        if (maxRounds != null) {
          this.data['maxRounds'] = maxRounds;
        }
      }
    }
  }

  Crawlbot.prototype.create = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, this.data, function(error, result) {
      if (callback != null) {
        return callback(error, result);
      }
    });
  };

  Crawlbot.prototype.pause = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      pause: 1
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Crawlbot.prototype.resume = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      pause: 0
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Crawlbot.prototype.restart = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      restart: 1
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Crawlbot.prototype["delete"] = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name,
      'delete': 1
    }, function(error, result) {
      if (callback != null) {
        return callback(error, true);
      }
    });
  };

  Crawlbot.prototype.data = function(callback) {
    var data, dataUrl, urls, urlsUrl,
      _this = this;
    urls = [];
    data = {};
    dataUrl = this.api.apiHost + 'crawl/download/' + this.api.token + '-' + this.name + '_data.json';
    urlsUrl = this.api.apiHost + 'crawl/download/' + this.api.token + '-' + this.name + '_urls.csv';
    return this.api.r.get({
      url: dataUrl
    }, function(error, response, body) {
      if (error == null) {
        data = JSON.parse(body);
        return _this.api.r.get({
          url: urlsUrl
        }, function(error, response, body) {
          if (error == null) {
            urls = body;
            if (callback != null) {
              return callback(error, {
                urls: urls,
                data: data
              });
            }
          } else {
            if (callback != null) {
              return callback(error, null);
            }
          }
        });
      } else {
        if (callback != null) {
          return callback(error, null);
        }
      }
    });
  };

  Crawlbot.prototype.status = function(callback) {
    var _this = this;
    return this.api.request(this.http_method, this.api_method, {
      name: this.name
    }, function(error, result) {
      if (callback != null) {
        return callback(error, result);
      }
    });
  };

  return Crawlbot;

})();

Client = (function() {
  function Client(token, host, version) {
    this.token = token;
    this.host = host != null ? host : 'http://api.diffbot.com';
    this.version = version != null ? version : 2;
    this.request = __bind(this.request, this);
    this.crawlbot = __bind(this.crawlbot, this);
    this.bulk = __bind(this.bulk, this);
    this.custom = __bind(this.custom, this);
    this.product = __bind(this.product, this);
    this.image = __bind(this.image, this);
    this.pageclassifier = __bind(this.pageclassifier, this);
    this.frontpage = __bind(this.frontpage, this);
    this.article = __bind(this.article, this);
    this.apiHost = this.host + '/v' + this.version + '/';
    this.r = request.defaults({});
  }

  Client.prototype.article = function(url, fields, timeout) {
    return new Article(this, url, fields, timeout);
  };

  Client.prototype.frontpage = function(url, timeout, format, all) {
    return new Frontpage(this, url, timeout, format, all);
  };

  Client.prototype.pageclassifier = function(url, mode, fields, stats) {
    return new PageClassifier(this, url, mode, fields, stats);
  };

  Client.prototype.image = function(url, fields, timeout) {
    return new Image(this, url, fields, timeout);
  };

  Client.prototype.product = function(url, fields, timeout) {
    return new Product(this, url, fields, timeout);
  };

  Client.prototype.custom = function(apiMethod, url, timeout) {
    return new Custom(this, apiMethod, url, timeout);
  };

  Client.prototype.bulk = function(name, urls, apiUrl, notifyEmail, notifyWebHook, repeat, maxRounds, pageProcessPattern) {
    return new Bulk(this, name, urls, apiUrl, notifyEmail, notifyWebHook, repeat, maxRounds, pageProcessPattern);
  };

  Client.prototype.crawlbot = function(name, seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds) {
    return new Crawlbot(this, name, seeds, apiUrl, urlCrawlPattern, urlCrawlRegEx, urlProcessPattern, urlProcessRegEx, pageProcessPattern, maxToCrawl, maxToProcess, restrictDomain, notifyEmail, notifyWebHook, crawlDelay, repeat, onlyProcessIfNew, maxRounds);
  };

  Client.prototype.request = function(httpMethod, apiMethod, data, callback) {
    var params,
      _this = this;
    if (data == null) {
      data = {};
    }
    data['token'] = this.token;
    params = {
      url: this.apiHost + apiMethod,
      method: httpMethod
    };
    if (httpMethod.toLowerCase() === 'get') {
      params['qs'] = data;
    } else {
      params['form'] = data;
    }
    return this.r.get(params, function(error, response, body) {
      if (error != null) {
        return callback(error, null);
      } else {
        if (response.statusCode === 200) {
          return callback(null, JSON.parse(body));
        } else {
          return callback(body, null);
        }
      }
    });
  };

  return Client;

})();

exports.Client = Client;

exports.Article = Article;

exports.Job = Job;

exports.Frontpage = Frontpage;

exports.Image = Image;

exports.Product = Product;

exports.PageClassifier = PageClassifier;

exports.Custom = Custom;

exports.Bulk = Bulk;

exports.Crawlbot = Crawlbot;
