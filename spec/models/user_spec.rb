require 'spec_helper'
RSpec.describe User, :type => :model do
  subject(:user) do
    User.create!(username: "jonathan",
      password: "good_password")
  end
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }

  it { should validate_uniqueness_of(:username)}
  it { should validate_uniqueness_of(:session_token)}
  it { should validate_uniqueness_of(:password_digest)}

  # it { should have_many(:subs) }
  # it { should have_many(:user_votes) }
  # it { should have_many(:comments) }

  it "creates a password digest when a password is given" do
      expect(user.password_digest).not_to be_nil
  end

  it "creates a session token before validation" do
    user.valid?
    expect(user.session_token).not_to be_nil
  end

  describe "#reset_session_token!" do
    it "sets a new session token on the user" do
      user.valid?
      prev = user.session_token
      user.reset_session_token!
      expect(prev).not_to eq(user.session_token)
    end

    it "returns the new session token" do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe "#is_password?" do
    it "verifies a correct password" do
      expect(user.is_password?("good_password")).to be true
    end

    it "rejects a bad password" do
      expect(user.is_password?("goood_password")).to be false
    end
  end

  describe "#find_by_credentials" do
    it "Finds users with valid creds" do
      user
      expect(User.find_by_credentials("jonathan", "good_password")).to eq(user)
    end

    it "Does not find users with bad creds" do
      expect(User.find_by_credentials("jonadfthan", "good_password")).to be nil
    end
  end
end
