class ModelWithUsername < ActiveRecord::Base
  attr_digest :password, validations: false

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end

class ModelWithAttrDigest < ActiveRecord::Base
  attr_digest :password
  attr_digest :security_answer

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :security_question, presence: true
end

class ModelWithAttrDigestAndCaseSensitiveOption < ActiveRecord::Base
  self.table_name = "model_with_attr_digests"

  attr_digest :password
  attr_digest :security_answer, case_sensitive: false

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :security_question, presence: true
end

class ModelWithAttrDigestAndProtectedOption < ActiveRecord::Base
  self.table_name = "model_with_attr_digests"

  attr_digest :password
  attr_digest :security_answer, protected: true

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :security_question, presence: true
end

class ModelWithAttrDigestAndValidationsOption < ActiveRecord::Base
  self.table_name = "model_with_attr_digests"

  attr_digest :password
  attr_digest :security_answer, validations: false

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :security_question, presence: true
end

class ModelWithAttrDigestAndConfirmationOption < ActiveRecord::Base
  self.table_name = "model_with_attr_digests"

  attr_digest :password
  attr_digest :security_answer, confirmation: false

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :security_question, presence: true
end
