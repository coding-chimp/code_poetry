# Code Poetry

[![Gem Version][rgb]][rgl] [![Build Status][trb]][trl] [![Code Climate][ccb]][ccl]

The poor men's [Code Climate][cc].

Analyzes the code of your Rails app and generates a straightforward HTML report.

Currently it uses the following metrics:

* Lines of Code
* Churns [[Churn][ch]]
* Code Complexity [[Flog][fl]]

## Installation

Add this line to your application's Gemfile:

    gem 'code_poetry'

And then execute:

    $ bundle

## Usage

Excecute from your application root:

    $ rake metrics

This will generate a HTML report to ```metrics/index.html```.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[rgb]: https://badge.fury.io/rb/code_poetry.png
[rgl]: http://badge.fury.io/rb/code_poetry
[trb]: https://travis-ci.org/coding-chimp/code_poetry.png?branch=master
[trl]: https://travis-ci.org/coding-chimp/code_poetry
[ccb]: https://codeclimate.com/github/coding-chimp/code_poetry.png
[ccl]: https://codeclimate.com/github/coding-chimp/code_poetry

[cc]: https://codeclimate.com
[ch]: https://github.com/danmayer/churn
[fl]: https://github.com/seattlerb/flog
