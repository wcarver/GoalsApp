# spec/features/auth_spec.rb

require 'spec_helper'
require 'rails_helper'

feature "the goal crud" do
  before(:each) do
    User.create!(username: "interesting", password: "qwertyt")
    visit new_session_url
    fill_in "Username", :with => "interesting"
    fill_in "Password", :with => "qwertyt"
    click_on "Log in"
  end

  scenario "has a new goal page" do
      visit new_goal_url
      expect(page).to have_content "Create Goal"
  end

  feature "creating a new goal" do

    before(:each) do
      visit new_goal_url
      fill_in "Goal", :with => "learn spanish"
      click_on "Create Goal"
    end

    scenario "redirects to user page after new goal" do
      expect(page).to have_content("interesting")
    end

    scenario "displays newly created goal" do
      expect(page).to have_content("learn spanish")
    end

  end

  feature "editing a goal" do
    before(:each) do
      user = User.find_by_credentials("interesting", "qwertyt")
      Goal.create!(body: "Have fun", user_id: user.id)
      visit user_url(id: user.id)
      click_on "Edit Goal"

      fill_in "Goal", :with => "learn spanish"
      click_on "Edit Goal"
    end

    scenario "redirects to user page after editting goal" do
      expect(page).to have_content("interesting")
    end

    scenario "displays newly created goal" do
      expect(page).to have_content("learn spanish")
    end

    scenario "cannot edit someone else's goal" do
      boring = User.create!(username: "boring", password: "qwertyt")
      Goal.create!(body: "asdgasd", user_id: boring.id)
      visit user_url(id: boring.id)
      expect(page.has_no_link?("Edit Goal")).to be true
    end

  end

  feature "deleting a goal" do
    before(:each) do
      user = User.find_by_credentials("interesting", "qwertyt")
      Goal.create!(body: "Have fun", user_id: user.id)
      visit user_url(id: user.id)
      click_on "Delete Goal"
    end

    scenario "redirects to user page after deleting goal" do
      expect(page).to have_content("interesting")
    end

    scenario "doesn't display deleted goal" do
      expect(page).to_not have_content("Have fun")
    end

    scenario "cannot delete someone else's goal" do
      boring = User.create!(username: "boring", password: "qwertyt")
      Goal.create!(body: "asdgasd", user_id: boring.id)
      visit user_url(id: boring.id)
      expect(page.has_no_link?("Delete Goal")).to be true
    end

  end

end
