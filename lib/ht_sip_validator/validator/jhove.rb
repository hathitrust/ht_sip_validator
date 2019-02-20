# frozen_string_literal: true

# Validators for image filenames & structure
module HathiTrust::Validator::JHOVE
  NAMESPACES= {
    'jhove' => 'http://hul.harvard.edu/ois/xml/ns/jhove'
  }
end

require "ht_sip_validator/validator/jhove/well_formed_and_valid"
