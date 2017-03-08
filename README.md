# ht_sip_validator [![Build Status](https://travis-ci.org/hathitrust/ht_sip_validator.svg?branch=master)](https://travis-ci.org/hathitrust/ht_sip_validator)

# HathiTrust Submission Ingest Package Validator

A locally runnable submission package validator with human readable and useful messages.

## Prerequisites

### Linux and Mac OS X

- [ruby](https://www.ruby-lang.org/en/documentation/installation/) 2.3 or later (earlier versions not tested)
- [bundler](http://bundler.io/) (`gem install bundler` once Ruby is installed)
- [git](https://git-scm.com/) (`apt-get install git` (Debian/Ubuntu) or `yum install git` (Fedora/RedHat/CentOS))
- zlib (`apt-get install zlib1g-dev` (Debian/Ubuntu) or `yum install libzlib-devel` (Fedora/RedHat/CentOS))
- Mac OS X will likely require XCode command-line tools to be installed

We recommend installing ruby via [rbenv](https://github.com/rbenv/rbenv#readme)
with [ruby-build](https://github.com/rbenv/ruby-build#readme) or
[RVM](http://rvm.io/)

### Windows

Currently, the process is somewhat more complicated on Windows, but we hope to
provide a simpler installation method in the future. We have tested this
release on Windows 10 with the following dependencies:

- [Git for Windows](https://git-scm.com/downloads) 2.11.0.3 - select the 'Use Git from the Windows Command Prompt' option when installing.
- [RubyInstaller](http://rubyinstaller.org/downloads) 2.3.3
- [RubyInstaller DevKit](http://rubyinstaller.org/downloads) 4.7.2 (64-bit) - follow [these instructions](https://github.com/oneclick/rubyinstaller/wiki/Development-kit) to install

Once these prerequisites are installed, choose 'Start Command Prompt with Ruby' from the Start menu and run:

```bash
gem install bundler
```

The installation and running instructions are then the same as on Linux and Mac
OS X.


## Installation

Download and extract a [release](https://github.com/hathitrust/ht_sip_validator/releases), or `git clone https://github.com/hathitrust/ht_sip_validator` for the latest development version. Then:

```bash
cd ht_sip_validator
bundle install
```

## Running

```
bundle exec ruby bin/validate_sip -c config/default.yml -s /path/to/sip.zip
```

## Output

By default, `validate_sip` will list all errors and warnings in the given SIP and output a summary with the number of warnings or errors. Errors will cause a SIP to fail ingest into HathiTrust and must be fixed before submission. Warnings point out things that could affect the display of material in HathiTrust, but will not prevent a SIP from being ingested.

Example output:

```
bundle exec ruby bin/validate_sip -c config/default.yml -s spec/fixtures/sips/bad_ocr.zip 
bad_ocr.zip - WARN: MetaYml::PageOrder - Neither scanning_order or reading_order provided; they will default to left-to-right
bad_ocr.zip - WARN: MetaYml::PageData::Presence - 'pagedata' is not present in meta.yml; users will not have page tags or page numbers to navigate through this book.
bad_ocr.zip - WARN: OCR::CoordinatePresence - plain-text OCR file 00000001.txt has no corresponding coordinate OCR 00000001.{xml,html}
bad_ocr.zip - WARN: OCR::CoordinatePresence - plain-text OCR file 00000002.txt has no corresponding coordinate OCR 00000002.{xml,html}
bad_ocr.zip - ERROR: OCR::ControlChars - File 00000001.txt contains disallowed control characters
bad_ocr.zip - ERROR: OCR::UTF8 - File 00000002.txt is not valid UTF-8: invalid byte "\xC9" found.
Failure: 2 error(s), 4 warning(s)
```

## Options

```
Usage: validate_sip [options]
    -c, --config=CONFIGPATH          Path to the configuration.
    -s, --sip=SIP                    Path to the sip.
    -v, --verbose                    Show verbose output; overrides --quiet
    -q, --quiet                      Show errors only (no warnings)
    -h, --help                       Show this message
```

## Configuration

All checks are enabled by default. You might want to turn off some validators
that only produce warnings. You can do that for individual validators by
removing them from the configuration, or turn off warnings globally by using
the `-q` option.

Particular validators you might want to disable:

- `MetaYml::PageData::Presence` - if you are not producing page tag / page
  number data
 
- `OCR::CoordinatePresence` - if you are not producing coordinate OCR (e.g.
  ALTO, hOCR, etc in a .html or .xml file)

- `MetaYml::PageOrder` - if all your material is scanned left-to-right and
  reads left-to-right

You can either edit `config/default.yml` directly or make a copy for your
particular use case or set of content.

## Limitations

- Does not yet validate any image technical characteristics (planned by mid-2017)
- Does not yet validate submissions of born-digital material
- Output is not very configurable

## Related Projects

[meta.yml
generator](https://github.com/ruthtillman/yaml-generator-for-hathitrust) by
Ruth Tillman at the University of Notre Dame assists in generating SIPs which
can then be validated with this tool.

## Feedback

We welcome pull requests as well as feedback to `ingest@hathitrust.org`.
