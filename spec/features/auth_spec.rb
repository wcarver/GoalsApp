# spec/features/auth_spec.rb

require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
      visit new_user_url
      expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in "Username", :with => "Will"
      fill_in "Password", :with => "asdfghjjk"
      click_on "Submit"
    end
    scenario "shows username on the homepage after signup" do
      expect(page).to have_content "Will"
    end
  end



  feature "logging in" do


    scenario "shows username on the homepage after login" do
      User.create!(username: "lol", password: "qwertyt")
      visit new_session_url
      fill_in "Username", :with => "lol"
      fill_in "Password", :with => "qwertyt"
      click_on "Log in"

      expect(page).to have_content "lol"
    end
  end

  feature "logging out" do
    scenario "begins with a logged out state" do
      visit new_session_url
      expect(page).to_not have_content('Sign Out')
    end

    scenario "doesn't show username on the homepage after logout" do
      User.create!(username: "lol", password: "qwertyt")
      visit new_session_url
      fill_in "Username", :with => "lol"
      fill_in "Password", :with => "qwertyt"
      click_on "Log in"

      click_on "Log Out"
      expect(page).to_not have_content('lol')
    end
  end
end
