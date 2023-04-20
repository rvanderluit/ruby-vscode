class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  rolify

  def to_s
    email
  end
  def self.ransackable_attributes(auth_object = nil)
    %w[user_email user_id email email_cont sign_in_count] # add any other attributes you want to allowlist for searching
  end
  def self.ransackable_associations(auth_object = nil)
    ["email", "user_id", "user_email"] 
  end
  def username
    self.email.split(/@/).first
  end
  
  has_many :courses


  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher) #if you want any user to be able to create own courses
    end
  end

  validate :must_have_a_role, on: :update
  def online?
    updated_at > 2.minutes.ago
  end
  private



  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end

end
