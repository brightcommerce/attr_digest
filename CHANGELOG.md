# Change Log

##v2.1.1
- Encountered FFI v1.9.21 build issue on macOS 10.13.3 (High Sierra) so locked Argon at v1.1.3 until this can be resolved. Gem::Ext::BuildError: ERROR: Failed to build gem native extension when installing FFI 1.9.21 with native extensions. See https://github.com/brightcommerce/attr_digest/issues/5 for updates.

##v2.1.0
- Removed upper limit for ActiveSupport and ActiveRecord dependencies.
- Updated README.

##v2.0.0
- Added Ruby 2.3.1 to Travis CI configuration file.
- Updated README.
- Added length validator option.
- Added format validation option.
- Refactored validation method name.
- Updated Argon2 dependency to V1.1.1.
- Added secret key option.
- Renamed spec classes and factory names.
- Added time_cost and memory_cost to attr_digest class method and AttrDigest constant.
- Coerce values to string, permit blank digest with tests.
- Added NoDigestException and tests.

##v1.2.0
- Updated ActiveSupport and ActiveRecord between 4.2.6 and v5.0.0.

##v1.1.0
- Updated Argon2 dependency to v1.1.0.

##v1.0.0
- Initial release.
