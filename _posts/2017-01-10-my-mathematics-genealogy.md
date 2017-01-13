---
layout: post
title:  My Mathematics Genealogy
date: 2017-01-10
published: true
tags: [python, R, scrapy, igraph, genealogy]
---

OK, so the first post on this blog is about my (mathematics) genealogy, how narcissistic of me. 
Anyway, I was looking at various ways to crawl and harvest data from websites (i.e., web crawling and scraping), and I thought that it could be fun to learn about it by extracting my ancestry from the 
[Mathematics Genealogy Project](https://genealogy.math.ndsu.nodak.edu/) (thereafter [MGP](https://genealogy.math.ndsu.nodak.edu/)). 

Since, to the best of my knowledge, there is no good web crawling and scraping framework in R, I choose to use `scrapy` for Python, which is both comprehensive, easy to use and fast. After installing the package 
(e.g., via `pip install scrapy`), setting-up a `scrapy` directory  with the 
proper content for the mathematical genealogy project is done by simply running:

```bash
scrapy startproject mgp_spider 
```
To scrap the data for a single scholar, I define the class `ScholarItem` and 
add it to `items.py`:

```python
class ScholarItem(scrapy.Item):
    name = scrapy.Field()
    id = scrapy.Field()
    children = scrapy.Field()
```
Note that an `advisor` field could also be included, but the information is somewhat redundant.

Following the [tutorial](https://doc.scrapy.org/en/latest/intro/tutorial.html), a spider
to crawl my ancestry in the [MGP](https://genealogy.math.ndsu.nodak.edu/) by sub-classing `scrapy.Spider` in the following way:

```python
class MgpSpider(scrapy.Spider):
  name = 'mgpspider'

  def __init__(self, root='202169', *args, **kargs):
    super(MgpSpider, self).__init__(*args, **kargs)
    self.start_urls = [
        'https://www.genealogy.math.ndsu.nodak.edu/id.php?id=' + root
      ]

  def url_to_id(self, url):
    tokens = url.split('=')
    if len(tokens) != 2:
      return None
    else:
      return int(tokens[1])

  def parse(self, response):
    item = ScholarItem()
    item['name'] = response.css('h2::text').extract_first().strip()
    item['id'] = self.url_to_id(response.url)
    children_urls = response.css('table').re('id\.php\?id=\d*')
    item['children'] = [self.url_to_id(url) for url in children_urls]
    yield item

    for href in response.xpath('//div[@id="mainContent"]').re('id\.php\?id=\d*'):
          if href not in children_urls:
            yield scrapy.Request(response.urljoin(href), callback=self.parse)
```
Apart from the spider's name, the three functions are as follow:

  * `__init__` is the constructor, which defines the spider's starting URL. Note that,
  by default, root is set as my [MGP](https://genealogy.math.ndsu.nodak.edu/) id number.
  * `url_to_id` converts an URL into an [MGP](https://genealogy.math.ndsu.nodak.edu/) id number.
  * `parse` does two things:
    * First, it scraps the current scholar and saves it using `scrapy`'s `yield`.
    * Second, it crawls the advisors of the scholar by recursively calling itself.

And that's it, the result is then obtained by running:

```bash
scrapy crawl mgpspider -o output.json
```
Note that, to crawl the ancestry of my own advisor, I can simply pass its [MGP](https://genealogy.math.ndsu.nodak.edu/)
id number to the spider by running:

```bash
scrapy crawl mgpspider -a root=86905 -o output.json
```
To leverage `igraph`'s nice layouts, the next step is loading the data in `R` by running:

```r
data <- jsonlite::fromJSON("output.JSON")
```
Then, to build an `igraph` graph, the easiest way is often to construct the graph's
adjacency matrix:

```r
library(igraph)
ancestry_adj_mat <- sapply(data$children, function(x) is.element(data$id, x))
ancestry_graph <- graph_from_adjacency_matrix(ancestry_adj_mat)
V(ancestry_graph)$name <- data$name
```
Because the full ancestry is a rather messy graph, the following plot is obtained by 
selecting the sub-graph corresponding to my neighborhood of order 18 using `igraph`'s `make_ego_graph` 
function (i.e., selecting ancestors with a degree of separation less than or equal to 18):
![plot of chunk ancestry_graph](/figure/source/my-mathematics-genealogy/2017-01-10-my-mathematics-genealogy/ancestry_graph-1.png)
