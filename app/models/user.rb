class User < ApplicationRecord
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, :rememberable,
         :trackable, :timeoutable, :validatable, :lockable
end
