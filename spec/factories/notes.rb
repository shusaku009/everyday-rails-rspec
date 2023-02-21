FactoryBot.define do
  factory :note do
    message { "My important ntoe." }
    association :project
    user { project.owner }
  end
end
