> [!IMPORTANT]  
> This tool is not currently developed or maintained and is not recommended for use.
> The production HathiTrust package validation and ingest code is available as a Docker image: https://github.com/hathitrust/feed/pkgs/container/feed.

# ht_sip_validator [![Build Status](https://travis-ci.org/hathitrust/ht_sip_validator.svg?branch=master)](https://travis-ci.org/hathitrust/ht_sip_validator)

# HathiTrust Submission Ingest Package Validator

A locally runnable submission package validator with human readable and useful messages.

## Prerequisites

### Linux and Mac OS X

- [ruby](https://www.ruby-lang.org/en/documentation/installation/) 2.4.x or later
- [bundler](http://bundler.io/) (`gem install bundler` once Ruby is installed)
- [git](https://git-scm.com/) (`apt-get install git` (Debian/Ubuntu) or `yum install git` (Fedora/RedHat/CentOS))
- zlib (`apt-get install zlib1g-dev` (Debian/Ubuntu) or `yum install libzlib-devel` (Fedora/RedHat/CentOS))
- Mac OS X will likely require XCode command-line tools to be installed

We recommend installing ruby via [rbenv](https://github.com/rbenv/rbenv#readme)
with [ruby-build](https://github.com/rbenv/ruby-build#readme) or
[RVM](http://rvm.io/)

### Windows

There is a stand-alone executable as well as an installer available for Windows. Both are available from the
[releases page](https://github.com/hathitrust/ht_sip_validator/releases). No other pre-requisites are required.
These releases have only been tested on 64-bit Windows 10, but are likely to work on earlier versions of Windows as well.

## Installation

For Windows, download a
[release](https://github.com/hathitrust/ht_sip_validator/releases); there is an
installer as well as a stand-alone executable that doesn't require installation.

For Linux and Mac OS X, download and extract a
[release](https://github.com/hathitrust/ht_sip_validator/releases), or `git
clone https://github.com/hathitrust/ht_sip_validator` for the latest
development version. Then:

```bash
cd ht_sip_validator
bundle install
```

## Running

Run the validator by providing a list of SIPs to validate.

Windows (installed version):

```
C:\Program Files (x86)\HathiTrust SIP Validator\validate_sip C:\path\to\sip.zip C:\path\to\another_sip.zip
```

Because of limitations in Windows, you currently must provide the full path to
the SIPs to validate (as well the configuration file, if one is provided; see
below)

Windows (standalone exe)

```
validate_sip sip.zip sip2.zip
```

The standalone executable is slower to start up, but does not require
installation and does not require specifying the complete path to each SIP.

Mac OS X and Linux:

```
bundle exec ruby bin/validate_sip /path/to/sip.zip /path/to/another_sip.zip
```

## Output

By default, `validate_sip` will list all errors and warnings in the given SIP and output a summary with the number of warnings or errors. Errors will cause a SIP to fail ingest into HathiTrust and must be fixed before submission. Warnings point out things that could affect the display of material in HathiTrust, but will not prevent a SIP from being ingested.

Example output:

```
bundle exec ruby bin/validate_sip spec/fixtures/sips/bad_ocr.zip
bad_ocr.zip - WARN: MetaYml::PageOrder - Neither scanning_order or reading_order provided; they will default to left-to-right
bad_ocr.zip - WARN: MetaYml::PageData::Presence - 'pagedata' is not present in meta.yml; users will not have page tags or page numbers to navigate through this book.
bad_ocr.zip - WARN: OCR::CoordinatePresence - plain-text OCR file 00000001.txt has no corresponding coordinate OCR 00000001.{xml,html}
bad_ocr.zip - WARN: OCR::CoordinatePresence - plain-text OCR file 00000002.txt has no corresponding coordinate OCR 00000002.{xml,html}
bad_ocr.zip - ERROR: OCR::ControlChars - File 00000001.txt contains disallowed control characters
bad_ocr.zip - ERROR: OCR::UTF8 - File 00000002.txt is not valid UTF-8: invalid byte "\xC9" found.
bad_ocr.zip - Failure: 2 error(s), 4 warning(s)
```

## Options

```
Usage: validate_sip [options] sip1 sip2 ...
    -c, --config=CONFIGPATH          Path to the configuration.
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
particular use case or set of content. For the installed windows version, you
can find the config at `C:\Program Files (x86)\HathiTrust SIP
Validator\src\config\default.yml`. For the standalone Windows executable,
[download the default
config](https://raw.githubusercontent.com/hathitrust/ht_sip_validator/master/config/default.yml)
and change it as you see fit.

## Limitations

- Does not yet validate any image technical characteristics
- Output is not very configurable

## Related Projects

[meta.yml
generator](https://github.com/ruthtillman/yaml-generator-for-hathitrust) by
Ruth Tillman at the University of Notre Dame assists in generating SIPs which
can then be validated with this tool.

## Feedback

We welcome pull requests as well as feedback to `ingest@hathitrust.org`.
