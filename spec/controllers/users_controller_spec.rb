require 'rails_helper'
require 'byebug'
RSpec.describe UsersController, :type => :controller do
  let(:user) { User.create!({username: "jill_bruce", password: "password"}) }

  describe "#GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#GET show" do
    it "renders the show template" do
      get :show, id: user.id
      expect(response).to render_template("show")
    end
  end

  describe "#POST create" do
    context "with invalid params" do
      it "validates presence of username and password" do
        post :create, user: {username: "jill_bruce", password: ""}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do
      it "creates user" do
        post :create, user: {username: "jill_bruce", password: "actualpassword"}
        testuser = User.find_by_credentials("jill_bruce","actualpassword")
        expect(testuser).not_to be nil
        expect(response).to redirect_to(user_url(testuser))
      end
    end

  end


end
