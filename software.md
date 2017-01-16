---
layout: page
title: "Open-source Software"
---

I write R/C++/Python/MATLAB software, mainly for statistical computing, and you can find an overview of my projects below.

-----

## R

#### [gamCopula: generalized additive models for bivariate and vine copulas](https://github.com/tvatter/gamCopula) [![CRAN ](http://www.r-pkg.org/badges/version/gamCopula)](https://cran.r-project.org/package=gamCopula) 

Implementation of various inference and simulation tools to apply generalized additive models to bivariate dependence structures and non-simplified vine copulas. See [Vatter and Chavez-Demoulin, 2015](http://www.sciencedirect.com/science/article/pii/S0047259X15001633) and [Vatter and Nagler, 2016](https://arxiv.org/abs/1608.01593).

#### [VineCopula: statistical inference of vine copulas](https://github.com/tnagler/VineCopula) [![CRAN ](http://www.r-pkg.org/badges/version/VineCopula)](https://cran.r-project.org/package=VineCopula) 

Provides tools for the statistical analysis of vine copula models. The package includes tools for parameter estimation, model selection, simulation, goodness-of-fit tests, and visualization. Tools for estimation, selection and exploratory data analysis of bivariate copula models are also provided.

-----

## C++

#### [vinecopulib: a C++ library for vine copulas](https://github.com/tvatter/vinecopulib) [![Travis CI ](https://travis-ci.org/tvatter/vinecopulib.svg?branch=master)](https://travis-ci.org/tvatter/vinecopulib)

A C++ implementation of inference algorithms for bivariate and vine copula models. Under construction.

-----

## Python

#### [mgpancestry: scraping the mathematical genealogy project for a scholar's ancestry.](https://github.com/tvatter/mgpancestry)

A small scrapy project to scrap the [mathematical genealogy project](https://genealogy.math.ndsu.nodak.edu/) for a scholar's ancestry. See [the related blog post](https://tvatter.github.io/2017/01/10/my-mathematics-genealogy/) for more details.

-----

## MATLAB

#### [intradaySST: companion code of the paper by Vatter et al. (2015)](https://github.com/tvatter/intradaySST)

This is the code which accompanies the paper [Non-Parametric Estimation of Intraday Spot Volatility: Disentangling Instantaneous Trend and Seasonality](http://www.mdpi.com/2225-1146/3/4/864/pdf)
by myself, Hau-Tieng Wu, Valérie Chavez-Demoulin and Bin Yu. It provides functions to clean intraday FX prices and apply the Synchrosqueezing transform to extract the trend and seasonality from the returns volatilities.