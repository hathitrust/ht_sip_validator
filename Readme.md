# ht_sip_validator [![Build Status](https://travis-ci.org/hathitrust/ht_sip_validator.svg?branch=master)](https://travis-ci.org/hathitrust/ht_sip_validator)

# HathiTrust Submission Ingest Package Validator

A locally runnable submission package validator with human readable and useful messages.

# Usage

```bash
git clone https://github.com/hathitrust/ht_sip_validator
cd ht_sip_validator
bundle install
ruby bin/validate_sip -c config/default.yml -s /path/to/sip.zip
```
