# frozen_string_literal: true

# namespace for validations on meta.yml
module HathiTrust::Validation::MetaYml
end

require "ht_sip_validator/validation/meta_yml/exists"
require "ht_sip_validator/validation/meta_yml/required_keys"
require "ht_sip_validator/validation/meta_yml/well_formed"
require "ht_sip_validator/validation/meta_yml/unknown_keys"
require "ht_sip_validator/validation/meta_yml/pagedata"
require "ht_sip_validator/validation/meta_yml/page_order"
