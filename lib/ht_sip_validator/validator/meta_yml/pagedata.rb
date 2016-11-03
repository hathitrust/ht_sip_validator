# frozen_string_literal: true

# namespace for validators for the pagedata: section in meta.yml
module HathiTrust::Validator::MetaYml::PageData
end

require "ht_sip_validator/validator/meta_yml/page_data/presence"
require "ht_sip_validator/validator/meta_yml/page_data/keys"
require "ht_sip_validator/validator/meta_yml/page_data/values"
require "ht_sip_validator/validator/meta_yml/page_data/files"
require "ht_sip_validator/validator/meta_yml/page_data/page_tags"
