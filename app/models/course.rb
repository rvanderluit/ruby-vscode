class Course < ApplicationRecord
    validates :title, :short_description, :language, :price, :level, presence: true
    validates :description, presence: true, length: { :minimum => 5}

    belongs_to :user, counter_cache: true
    #User.find_each { |user| User.reset_counters(user.id, :courses)}
    has_many :lessons, dependent: :destroy
    has_many :enrollments

    validates :title, uniqueness: true

    scope :latest_courses, -> { limit(3).order(created_at: :desc)}
    scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc)}
    scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc)}


    def to_s
        title
        #puts "Username: #{course.user.username}"
    end
    def self.ransackable_attributes(auth_object = nil)
        #%w[title short_description language level user_email user_id] # add any other attributes you want to allowlist for searching
        %w[title short_description language level price] + _ransackers.keys
    end
    def self.ransackable_associations(auth_object = nil)
        #["email", "short_description", "user_id", "user_email"] 
        %w[user course]
    end
    has_rich_text :description

    extend FriendlyId
    friendly_id :title, use: :slugged

    LANGUAGES = [:"English", :"Mexican", :"Cheese", :"Fart"]
    def self.languages
        LANGUAGES.map {|language| [language, language]}
    end

    LEVELS = [:"Beginner", :"Intermediate", :"Advanced", :"Wizard"]
    def self.levels
        LEVELS.map {|level| [level, level]}
    end

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user}

    def bought(user)
        self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
    end

    def update_rating
        if enrollments.any? && enrollments.where.not(rating: nil).any?
            update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
        else
            update_column :average_rating, (0)
        end
    end

end