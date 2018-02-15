module AttrDigest
  module VERSION
    MAJOR = 2
    MINOR = 1
    TINY  = 1
    PRE   = nil
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
    SUMMARY = "AttrDigest v#{STRING}"
    DESCRIPTION = "Provides functionality to store a hash digest of an attribute using Argon2"
  end
end
