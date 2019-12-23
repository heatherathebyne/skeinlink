class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :trackable, :timeoutable, :validatable

  has_many :projects
end
