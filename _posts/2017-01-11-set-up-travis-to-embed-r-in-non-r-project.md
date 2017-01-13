---
layout: post
title:  Set up Travis to embed R in a non-R project
date: 2017-01-11
published: true
tags: [R, travis]
---

[Continuous integration](https://en.wikipedia.org/wiki/Continuous_integration) 
([CI](https://en.wikipedia.org/wiki/Continuous_integration)) is great way of ensuring that code working in your 
local environment will also work with other configurations. If, like me, you're using [GitHub](https://github.com/), then a neat solution to implement [CI](https://en.wikipedia.org/wiki/Continuous_integration) principles within a new project is [Travis CI](https://travis-ci.org):

> Travis CI is a hosted, distributed continuous integration service used to build and 
test software projects hosted at GitHub.
>
> ---<cite>Wikipedia</cite>

However, it is well known that the default environment provided in [Travis CI](https://travis-ci.org) 
is somewhat outdated. For instance, while implementing a [C++ library for vine copulas](https://github.com/tvatter/vinecopulib), I 
wanted to unit-test the C++ library by comparing its output to the [VineCopula  R package](https://cran.r-project.org/web/packages/VineCopula/index.html), which 
itself depends on the [copula R package](https://cran.r-project.org/web/packages/copula/index.html). 
Very naively, I then tried to write a `.travis.yml` that started with:


```bash
language: cpp
matrix:
  include:
    - os: linux
      dist: trusty
      sudo: required

install:
  - sudo apt-get install r-base
  - sudo apt-get install libgsl0-dev
  - sudo Rscript -e 'install.packages("copula", repos="https://cran.rstudio.com/", lib="/usr/lib/R/library")'
```
Note that `sudo apt-get install libgsl0-dev gsl-bin` is used because the 
the [copula R package](https://cran.r-project.org/web/packages/copula/index.html) depends on 
the [gsl R package](https://cran.r-project.org/web/packages/gsl/index.html), which requires an install 
of the [Gnu Scientific Library](http://www.gnu.org/software/gsl/).

Obviously, the `.travis.yml` above didn't work, as the [Travis CI](https://travis-ci.org) log showed:

```bash
Warning message: package ‘copula’ is not available (for R version 3.0.2) 
```
Version 3.0.2? In 2017? Alright, not a big deal, but since it took me a while to fix this issue, I though that 
someone else might be interested in the solution, which is in fact extremely simple. 
One just needs to start the `.travis.yml` file with:

```bash
language: cpp
matrix:
  include:
    - os: linux
      dist: trusty
      sudo: required
      
before_install:
  - sudo sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
  - sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
  - sudo apt-get update

install:
  - sudo apt-get install r-base
  - sudo apt-get install libgsl0-dev
  - sudo Rscript -e 'install.packages("copula", repos="https://cran.rstudio.com/", lib="/usr/lib/R/library")'
```
To obtain the latest R packages, in `before_install`, one does the following:

* Add the R repository to the `/etc/apt/sources.list` file
* Add the R key to Ubuntu's key-ring since 

> The Ubuntu archives on CRAN are signed with the key of "Michael Rutter [marutter@gmail.com](marutter@gmail.com)" with key ID E084DAB9. ---<cite>[https://cran.r-project.org/bin/linux/ubuntu/](https://cran.r-project.org/bin/linux/ubuntu/)</cite>

* Update the package lists using the repositories to get information on the newest versions of packages and their dependencies

And that's it! Note that, for a C++ project embedding some R code, one might be interested in 
the R packages [Rcpp](https://cran.r-project.org/web/packages/Rcpp/index.html) (for seamless R and C++ Integration) and
[RInside](https://cran.r-project.org/web/packages/RInside/index.html) (to Embed R in C++ Applications), as we did 
in [vinecopulib](https://github.com/tvatter/vinecopulib).
