# docstat [![Build Status](https://travis-ci.org/kattrali/docstat.svg?branch=master)](https://travis-ci.org/kattrali/docstat)

Documentation metrics for libraries, optimized for Cocoa. `docstat` takes documentation sets (*.docset) generated via `appledoc` and similar tools and extracts general statistics. It also includes a binary for testing that coverage exceeds a given ratio.

## Usage

### Printing token statistics

The included `docstat` binary prints the number of tokens and coverage in a given documentation set

### Testing for coverage

The included `docstat-test` binary tests a given documentation set for a specified coverage level:

    $ docstat-test [docset path] (expected coverage ratio)

If no expected coverage ratio is specified, the default is '0.9'. On failure, the process exits with a status code of 1.

### Processing coverage data

`DocStat.process(docset_path)` returns a Hash containing information about all of the documented tokens in the following structure:

```ruby
{
  'ratio': decimal
  'containers': [
    {
      'name': 'class name',
      'ratio': decimal,
      'tokens': [
        {
          'name': 'name of token',
          'type': 'property or message type',
          'abstract': 'description of token',
          'declaration': 'formal declaration',
          'returns': 'description of return value',
          'documented': boolean
        }, ...
      ]
    }, ...
  ]
}
```

## Installation

Run `gem install docstat` in a terminal. `docstat` depends on the `sqlite3` ruby library.

## Development

`docstat` is tested using [bacon](https://github.com/chneukirchen/bacon).

Install development dependencies via `bundle install`.
