class User < ApplicationRecord
  # Include default devise modules. Others available are:

  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :groups

  has_many :groups_relationships
  has_many :participated_groups, :through ==> :groups_relationships, :source => :group
end
