class User < ApplicationRecord
    validates :name, presence: true, length: { minimum: 2, maximum: 50 }
    validates :age, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 150 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
