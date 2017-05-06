class Expense < ApplicationRecord
  validates :entry, presence: true
  belongs_to :user

end
