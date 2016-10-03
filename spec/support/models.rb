class ModelWithUsername < ActiveRecord::Base
  attr_digest :password, protected: false, validations: false, confirmation: false, case_sensitive: false

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end

class ModelWithTimeAndMemoryCosts < ActiveRecord::Base
  self.table_name = "model_with_usernames"

  attr_digest :password, protected: false, validations: false, confirmation: false, case_sensitive: false, time_cost: 3, memory_cost: 12

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end

class ModelWithInvalidMemoryCost < ActiveRecord::Base
  self.table_name = "model_with_usernames"

  attr_digest :password, protected: false, validations: false, confirmation: false, case_sensitive: false, memory_cost: 32

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end

class ModelWithInvalidTimeCost < ActiveRecord::Base
  self.table_name = "model_with_usernames"

  attr_digest :password, protected: false, validations: false, confirmation: false, case_sensitive: false, time_cost: 0

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
