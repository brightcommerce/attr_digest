FactoryGirl.define do
  factory :model_with_username do
    username 'username'
  end

  factory :model_with_format_option do
    username 'Rocky'
  end

  factory :model_with_minimum_length_option do
    username 'Pebbles'
  end

  factory :model_with_maximum_length_option do
    username 'Mr Slate'
  end

  factory :model_with_length_range_option do
    username 'Arnold'
  end

  factory :model_with_exact_length_option do
    username 'Grand Poobah'
  end

  factory :model_with_time_and_memory_cost_options do
    username 'username'
  end

  factory :model_with_invalid_memory_cost_option do
    username 'username'
  end

  factory :model_with_invalid_time_cost_option do
    username 'username'
  end

  factory :model_with_attr_digest_secret_option do
    username 'username'
    password 'password'
    password_confirmation 'password'
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
