class User < ApplicationRecord
  has_many :task_assignees, dependent: :destroy
  has_many :tasks, through: :task_assignees

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
