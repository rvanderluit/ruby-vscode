class Course < ApplicationRecord
    validates :title, :short_description, :language, :price, :level, presence: true
    validates :description, presence: true, length: { :minimum => 5}

    belongs_to :user
    def to_s
        title
    end
    def self.ransackable_attributes(auth_object = nil)
        %w[title short_description language level user_email] # add any other attributes you want to allowlist for searching
    end
    def self.ransackable_associations(auth_object = nil)
        ["email", "short_description"]
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
end