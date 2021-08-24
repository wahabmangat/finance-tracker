# frozen_string_literal: true

# user_stocks model
class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
end
