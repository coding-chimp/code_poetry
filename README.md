# Code Poetry

[![Gem Version][rgb]][rgl] [![Build Status][trb]][trl] [![Code Climate][ccb]][ccl] [![Code Climate][ccc]][ccl]

The poor men's [Code Climate][cc].

Analyzes the code of your Rails app and generates a straightforward HTML report.

Currently it uses the following metrics:

* Lines of Code
* Churns
* Code Complexity [[Flog][flog]]
* Duplication [[Flay][flay]]

## Installation

Add this line to your application's Gemfile:

    gem 'code_poetry'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install code-poetry

## Usage

Excecute from your application root:

    $ rake metrics

This will generate a HTML report to ```metrics/index.html```.

Or if you installed the gem globally use:

    $ code_poetry

This will display your smells in the command line.

You can also give a path to a file or subdirectory if you only want metrics for
those files:

    $ code_poetry app/models

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[rgb]: https://badge.fury.io/rb/code_poetry.svg
[rgl]: http://badge.fury.io/rb/code_poetry
[trb]: https://travis-ci.org/coding-chimp/code_poetry.svg?branch=master
[trl]: https://travis-ci.org/coding-chimp/code_poetry
[ccb]: https://codeclimate.com/github/coding-chimp/code_poetry/badges/gpa.svg
[ccl]: https://codeclimate.com/github/coding-chimp/code_poetry
[ccc]: https://codeclimate.com/github/coding-chimp/code_poetry/badges/coverage.svg

[cc]: https://codeclimate.com
[flog]: https://github.com/seattlerb/flog
[flay]: https://github.com/seattlerb/flay
