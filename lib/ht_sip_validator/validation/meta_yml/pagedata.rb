# frozen_string_literal: true

# namespace for validations of the pagedata: section in meta.yml
module HathiTrust::Validation::MetaYml::PageData
end

require "ht_sip_validator/validation/meta_yml/page_data/presence"
require "ht_sip_validator/validation/meta_yml/page_data/keys"
require "ht_sip_validator/validation/meta_yml/page_data/values"
require "ht_sip_validator/validation/meta_yml/page_data/files"
require "ht_sip_validator/validation/meta_yml/page_data/page_tags"
