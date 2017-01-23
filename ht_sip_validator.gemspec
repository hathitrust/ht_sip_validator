# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name = "ht_sip_validator"
  s.version = "0.1.0"
  s.date = "2017-01-19"
  s.summary = "HathiTrust SIP validator"

  s.description = %( Tools to validate submission information packages for
HathiTrust. HathiTrust is a partnership of academic & research institutions,
offering a collection of millions of titles digitized from libraries around the
world.)

  s.authors = ["Aaron Elkiss"]
  s.email = "aelkiss@umich.edu"
  s.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage = "https://github.com/mlibrary/ht_sip_validator"
  s.license = "APACHE2"
  s.add_dependency "rubyzip"
  s.add_dependency "nokogiri"
  s.required_ruby_version = ">= 2.3"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.4"
end
