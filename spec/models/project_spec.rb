require "rails_helper"

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "dose not allow duplicate project names per user" do
    user = FactoryBot.create(:user) 
    # User.create(
    #   first_name: "Joe",
    #   last_name: "Tester",
    #   email: "joeester@example.com",
    #   password: "dottle-nouveau-pavilion-tights-furze",
    # )

    user.projects.create(
      name: "Test Project",
    )
    new_project = user.projects.build(
      name: "Test Project", 
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to 
  share a project name" do
  user = FactoryBot.create(:user)
  # user = User.create(
  #   first_name: "Joe",
  #   last_name: "Tester",
  #   email: "Joetester@example.com",
  #   password: "dottle-nouveau-pavilion-tights-furze",
  # )

  user.projects.create(
    name: "Test Project",
  )

  other_user = FactoryBot.create(:user)
  # User.create(
  #   first_name: "jane",
  #   last_name: "Tester",
  #   email: "janetester@example.com",
  #   password: "dottle-nouveau-pavilion-tights-furze"
  # )

  other_project = other_user.projects.build(
    name: "Test Project",
  )

  expect(other_project).to be_valid
  end

  # 遅延ステータス
  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end
    
    # 締め切り日が今日ならスケジュールどおりであること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end
    
    # 締め切り日が未来ならスケジュールどおりであること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end

    # たくさんのメモが付いていること
    it "can have many notes" do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end
  end
end
