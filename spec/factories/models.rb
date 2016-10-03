FactoryGirl.define do
  factory :model_with_username do
    username 'username'
  end

  factory :model_with_attr_digest do
    username 'username'
    password 'password'
    password_confirmation 'password'
    security_question 'question'
    security_answer 'answer'
    security_answer_confirmation 'answer'
  end

  factory :model_with_attr_digest_and_validations_option do
    username 'username_no_validation'
    password 'password'
    password_confirmation 'password'
    security_question 'question'
    security_answer 'answer'
  end

  factory :model_with_attr_digest_and_protected_option do
    username 'username_protect'
    password 'password'
    password_confirmation 'password'
    security_question 'question'
    security_answer 'answer'
    security_answer_confirmation 'answer'
  end

  factory :model_with_attr_digest_and_case_sensitive_option do
    username 'username_protect'
    password 'password'
    password_confirmation 'password'
    security_question 'question'
    security_answer 'answer'
    security_answer_confirmation 'answer'
  end

  factory :model_with_attr_digest_and_confirmation_option do
    username 'username_protect'
    password 'password'
    password_confirmation 'password'
    security_question 'question'
    security_answer 'answer'
  end
end
