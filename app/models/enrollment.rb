class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  validates_uniqueness_of :user_id, scope: :course_id #so user can't subscribe twice
  validates_uniqueness_of :course_id, scope: :user_id


  def to_s
    user.to_s + " " + course.to_s
  end
  validate :cant_subscribe_to_own_course
  protected
  def cant_subscribe_to_own_course
    if self.new_record?
      if user_id == course.user_id
        errors.add(:base, "you can't subscribe to your own course")
      end
    end
  end



end
