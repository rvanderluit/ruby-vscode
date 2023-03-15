class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  def to_s
    email
  end
  def username
    self.email.split(/@/).first
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name email sign_in_count] # add any other attributes you want to allowlist for searching
  end
  def self.ransackable_associations(auth_object = nil)
    ["email"]
  end
  has_many :courses  

  after_create :assign_default_role

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end
end
