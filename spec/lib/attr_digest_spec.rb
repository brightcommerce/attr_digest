require 'spec_helper'

describe ModelWithUsername do
  it 'responds to :password' do
    respond_to(:password)
  end

  it 'responds to :password=' do
    respond_to(:password=)
  end

  it 'responds to :authenticate_password' do
    respond_to(:authenticate_password)
  end

  it 'raises NoDigestException when digest is non-existent' do
    model = FactoryGirl.create(:model_with_username, username: 'Bam Bam')
    expect(lambda do
      model.authenticate_password('abc')
    end).to raise_error(AttrDigest::NoDigestException)
  end

  it 'returns true if authenticate_password is passed an empty string' do
    model = FactoryGirl.create(:model_with_username, username: 'Fred', password: '')
    expect(model.authenticate_password('')).to be(true)
  end

  it 'returns true if authenticate_password is passed a nil' do
    model = FactoryGirl.create(:model_with_username, username: 'Barney', password: '')
    expect(model.authenticate_password(nil)).to be(true)
  end
end

describe ModelWithFormatOption do
  it 'fails validation if password does not meet format conditions' do
    model = FactoryGirl.create(:model_with_format_option)
    model.password = "p455w0rd"
    expect(model.valid?).to be(false)
    expect(model.errors[:password]).to include("only allows letters")
  end

  it 'passes validation if password meets format conditions' do
    model = FactoryGirl.create(:model_with_format_option, username: 'Rocky Snr')
    model.password = "password"
    expect(model.valid?).to be(true)
  end
end

describe ModelWithMinimumLengthOption do
  it 'fails validation if password does not meet minimum length condition' do
    model = FactoryGirl.create(:model_with_minimum_length_option)
    model.password = "pass"
    expect(model.valid?).to be(false)
    expect(model.errors[:password]).to include("is too short (minimum is 5 characters)")
  end

  it 'passes validation if password meets minimum length condition' do
    model = FactoryGirl.create(:model_with_minimum_length_option, username: 'Pebbles Jnr')
    model.password = "password"
    expect(model.valid?).to be(true)
  end
end

describe ModelWithMaximumLengthOption do
  it 'fails validation if password does not meet maximum length condition' do
    model = FactoryGirl.create(:model_with_maximum_length_option)
    model.password = "extra-long-password"
    expect(model.valid?).to be(false)
    expect(model.errors[:password]).to include("is too long (maximum is 10 characters)")
  end

  it 'passes validation if password meets maximum length condition' do
    model = FactoryGirl.create(:model_with_maximum_length_option, username: 'The late Mr Slate')
    model.password = "password"
    expect(model.valid?).to be(true)
  end
end

describe ModelWithLengthRangeOption do
  it 'fails validation if password does not meet ranged length condition (too long)' do
    model = FactoryGirl.create(:model_with_length_range_option)
    model.password = "extra-long-password"
    expect(model.valid?).to be(false)
    expect(model.errors[:password]).to include("is too long (maximum is 10 characters)")
  end

  it 'fails validation if password does not meet ranged length condition (too short)' do
    model = FactoryGirl.create(:model_with_length_range_option, username: 'Arnold Jnr')
    model.password = "pass"
    expect(model.valid?).to be(false)
    expect(model.errors[:password]).to include("is too short (minimum is 5 characters)")
  end

  it 'passes validation if password meets ranged length condition' do
    model = FactoryGirl.create(:model_with_length_range_option, username: 'Arnold Snr')
    model.password = "password"
    expect(model.valid?).to be(true)
  end
end

describe ModelWithExactLengthOption do
  it 'fails validation if password does not meet exact length condition' do
    model = FactoryGirl.create(:model_with_exact_length_option)
    model.password = "short"
    expect(model.valid?).to be(false)
    expect(model.errors[:password]).to include("is the wrong length (should be 8 characters)")
  end

  it 'passes validation if password meets exact length condition' do
    model = FactoryGirl.create(:model_with_exact_length_option, username: 'The late Grand Poobah')
    model.password = "password"
    expect(model.valid?).to be(true)
  end
end

describe ModelWithTimeAndMemoryCostOptions do
  it 'creates a digest with alternative time and memory costs' do
    model = FactoryGirl.create(:model_with_time_and_memory_cost_options, username: 'Wilma', password: 'abc')
    expect(model.authenticate_password('abc')).to be(true)
    expect(model.password_digest).to match(/m=4096,t=3/)
  end
end

describe ModelWithInvalidMemoryCostOption do
  it 'raises InvalidMemoryCost' do
    model = FactoryGirl.create(:model_with_invalid_memory_cost_option, username: 'Betty')
    expect(lambda do
      model.password = "abc"
    end).to raise_error(AttrDigest::InvalidMemoryCost)
  end
end

describe ModelWithInvalidTimeCostOption do
  it 'raises InvalidTimeCost' do
    model = FactoryGirl.create(:model_with_invalid_time_cost_option, username: 'Dino')
    expect(lambda do
      model.password = "abc"
    end).to raise_error(AttrDigest::InvalidTimeCost)
  end
end

describe ModelWithAttrDigestSecretOption do
  it 'permits setting the secret option' do
    model = FactoryGirl.create(:model_with_attr_digest_secret_option)
    expect(model.authenticate_password('password')).to be(true)
  end
end

describe ModelWithAttrDigest do
  it 'responds to :security_answer' do
    respond_to(:security_answer)
  end

  it 'responds to :security_answer=' do
    respond_to(:security_answer=)
  end

  it 'responds to :security_answer_confirmation' do
    respond_to(:security_answer_confirmation)
  end

  it 'responds to :security_answer_confirmation=' do
    respond_to(:security_answer_confirmation=)
  end

  it 'responds to :authenticate_security_answer' do
    respond_to(:authenticate_security_answer)
  end

  it 'confirms :security_answer' do
    subject.security_answer = 'hello there'
    subject.security_answer_confirmation = 'there hello'
    subject.valid?
    expect(subject.errors[:security_answer_confirmation]).to include("doesn't match Security answer")
  end

  it 'does not confirm :security_answer if not given' do
    subject.security_answer = nil
    subject.security_answer_confirmation = 'there hello'
    subject.valid?
    expect(subject.errors[:security_answer_confirmation]).to be_blank
  end

  it 'requires :security_answer on create' do
    expect(subject).to be_new_record
    subject.security_answer = nil
    subject.valid?
    expect(subject.errors[:security_answer]).to include("can't be blank")
  end

  it 'requires :security_answer_confirmation if :security_answer given' do
    subject.security_answer = 'hello there'
    subject.valid?
    expect(subject.errors[:security_answer_confirmation]).to include("can't be blank")
  end

  it 'does not require :security_answer_confirmation if :security_answer is not given' do
    subject.security_answer = ''
    subject.valid?
    expect(subject.errors[:security_answer_confirmation]).to be_blank
  end

  it 'requires :security_answer_digest on create' do
    subject = FactoryGirl.build(:model_with_attr_digest)
    expect(subject).to be_new_record
    # change the security_answer_digest to verify the test
    subject.security_answer_digest = ''
    expect(lambda do
      begin
        subject.save!
      rescue Exception => exception
        expect(exception.message).to include("security_answer_digest missing on new record")
        raise
      end
    end).to raise_error(RuntimeError)
  end

  it 'does not require :security_answer_digest on update' do
    subject = FactoryGirl.build(:model_with_attr_digest)
    expect(subject).to be_new_record
    subject.save!
    # change the security_answer_digest to verify the test
    subject.security_answer_digest = ''
    subject.save!
    subject.reload
    expect(subject.security_answer_digest).to be_blank
  end

  it 'allows to call :security_answer_digest directly if :protect_setter_for_digest is not given as option' do
    lambda do
      subject.security_answer_digest = 'hello'
      expect(subject.security_answer_digest).to eq('hello')
    end
  end

  describe "#security_answer=" do
    it 'sets the :security_answer and saves the digest' do
      model = FactoryGirl.create(:model_with_attr_digest, security_answer: 'old answer', security_answer_confirmation: 'old answer')
      expect(model.security_answer_digest).to_not be_blank
      old_security_answer_digest = model.security_answer_digest
      model.security_answer = 'new answer'
      model.security_answer_confirmation = 'new answer'
      expect(model.instance_variable_get(:@security_answer)).to eq('new answer')
      model.save!
      expect(model.security_answer_digest).to_not be_blank
      expect(model.security_answer_digest).to_not eq(old_security_answer_digest)
    end
  end

  describe '#authenticate_security_answer' do
    it 'returns true if :security_answer given matches the one stored' do
      model = FactoryGirl.create(:model_with_attr_digest, security_answer: 'some answer', security_answer_confirmation: 'some answer')
      expect(model.authenticate_security_answer('some answer')).to be(true)
    end

    it 'returns false if :security_answer given does not match the one stored' do
      model = FactoryGirl.create(:model_with_attr_digest, security_answer: 'some answer', security_answer_confirmation: 'some answer')
      expect(model.authenticate_security_answer('some other answer')).to be(false)
    end
  end
end

describe ModelWithAttrDigestAndValidationsOption do
  it 'responds to :security_answer' do
    respond_to(:security_answer)
  end

  it 'responds to :security_answer=' do
    respond_to(:security_answer=)
  end

  it 'responds to :security_answer_confirmation' do
    respond_to(:security_answer_confirmation)
  end

  it 'responds to :security_answer_confirmation=' do
    respond_to(:security_answer_confirmation=)
  end

  it 'responds to :authenticate_security_answer' do
    respond_to(:authenticate_security_answer)
  end

  it 'does not require :security_answer on create' do
    expect(subject).to be_new_record
    subject.security_answer = nil
    subject.valid?
    expect(subject.errors[:security_answer]).to be_blank
  end

  it 'does not require :security_answer_confirmation if :security_answer given' do
    subject.security_answer = 'hello there'
    subject.valid?
    expect(subject.errors[:security_answer_confirmation]).to be_blank
  end

  it 'does not require :security_answer_confirmation if :security_answer is not given' do
    subject.security_answer = ''
    subject.valid?
    expect(subject.errors[:security_answer_confirmation]).to be_blank
  end

  it 'does not require :security_answer_digest on create' do
    subject = FactoryGirl.build(:model_with_attr_digest_and_validations_option)
    expect(subject).to be_new_record
    # change the security_answer_digest to verify the test
    subject.security_answer_digest = ''
    subject.save!
  end

  it 'does not require :security_answer_digest on update' do
    subject = FactoryGirl.build(:model_with_attr_digest_and_validations_option)
    expect(subject).to be_new_record
    subject.save!
    # change the :security_answer_digest to verify the test
    subject.send(:security_answer_digest=, '')
    subject.save!
    subject.reload
    expect(subject.security_answer_digest).to be_blank
  end
end

describe ModelWithAttrDigestAndProtectedOption do
  it 'does not allow to call to protected setter for :security_answer_digest' do
    model = FactoryGirl.create(:model_with_attr_digest_and_protected_option, security_answer: 'Answer', security_answer_confirmation: 'Answer')
    expect(lambda do
      model.security_answer_digest = 'hello'
    end).to raise_error(NoMethodError)
  end
end

describe ModelWithAttrDigestAndCaseSensitiveOption do
  it 'authenticates even if :security_answer is of different case' do
    model = FactoryGirl.create(:model_with_attr_digest_and_case_sensitive_option, security_answer: 'Answer', security_answer_confirmation: 'Answer')
    expect(model.authenticate_security_answer('answer')).to eq(true)
  end
end

describe ModelWithAttrDigestAndConfirmationOption do
  it 'does not respond to :security_answer_confirmation' do
    respond_to(:security_answer_confirmation) == false
  end

  it 'does not respond to :security_answer_confirmation=' do
    respond_to(:security_answer_confirmation=) == false
  end

  it 'allows to create and save without any confirmation on :security_answer' do
    model = FactoryGirl.create(:model_with_attr_digest_and_confirmation_option, security_answer: 'Answer')
    model.save!
    expect(model.authenticate_security_answer('another answer')).to be(false)
    expect(model.authenticate_security_answer('Answer')).to be(true)
  end
end
