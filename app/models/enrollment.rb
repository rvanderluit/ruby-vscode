class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :enrollments)} # this updates the counter cache number of enrollments
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :enrollments)}

  validates :user, :course, presence: true

  validates_presence_of :rating, if: :review? #you have to leave both a rating and a review
  validates_presence_of :review, if: :rating?

  validates_uniqueness_of :user_id, scope: :course_id #so user can't subscribe twice
  validates_uniqueness_of :course_id, scope: :user_id

  scope :pending_review, -> {where(rating: [0, nil, ""], review: [0, nil, ""])}
  scope :reviewed, -> {where.not(review: [0, nil, ""])}
  scope :latest_good_reviews, -> { order(rating: :desc, created_at: :desc).limit(3)}

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def self.ransackable_attributes(auth_object = nil)
    %w[review rating price] + _ransackers.keys # add any other attributes you want to allowlist for searching
  end
  def self.ransackable_associations(auth_object = nil)
    %w[user course]
  end

  def to_s
    user.to_s + " " + course.to_s
  end

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do
    course.update_rating
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
