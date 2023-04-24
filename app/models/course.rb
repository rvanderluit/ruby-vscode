class Course < ApplicationRecord
    validates :title, :short_description, :language, :price, :level, presence: true
    validates :description, presence: true, length: { :minimum => 5}

    belongs_to :user
    has_many :lessons, dependent: :destroy
    has_many :enrollments
    def to_s
        title
        #puts "Username: #{course.user.username}"
    end
    def self.ransackable_attributes(auth_object = nil)
        %w[title short_description language level user_email user_email_cont user_id] # add any other attributes you want to allowlist for searching
    end
    def self.ransackable_associations(auth_object = nil)
        ["email", "short_description", "user_id", "user_email", "user_email_cont"] 
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
end