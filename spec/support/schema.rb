ActiveRecord::Schema.define do
  self.verbose = false

  create_table :model_with_attr_digests, force: true do |t|
    t.string :username,               null: false
    t.string :password_digest,        null: false
    t.string :security_question,      null: false
    t.string :security_answer_digest, null: false
    t.timestamps
  end

  change_table :model_with_attr_digests do |t|
    t.index :username, unique: true
  end
end
