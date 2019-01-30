SET PATH=%PATH%;C:\Program Files (x86)\Inno Setup 5
ocra validate_sip_ocra --output validate_sip.exe --gemfile Gemfile.ocra --gem-all --add-all-core --no-lzma --innosetup ht_sip_validator.iss --chdir-first ../config/default.yml

