require 'rails_helper'

RSpec.describe "Projects", type: :system do
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    # この章で独自に定義したログインヘルパーを使う場合
    # sign_in_ad user
    # もしくはDeviseが提供しているヘルパーを使う場合
    sign_in user
    
    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
  
  # ログインしていないためテストは失敗する
  # scenario "guest adds a project" do
  #   visit projects_path
  #   click_link "New Project"
  # end
end
