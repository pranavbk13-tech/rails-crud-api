class Task < ApplicationRecord
  has_many :task_assignees, dependent: :destroy
  has_many :users, through: :task_assignees

  validates :title, presence: true
  validates :description, presence: true
  validates :completed, inclusion: { in: [ true, false ] }
end
