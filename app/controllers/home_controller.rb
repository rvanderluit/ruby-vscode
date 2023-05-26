class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @courses= Course.all.limit(3)
    @latest_courses = Course.latest_courses
    @latest_good_reviews = Enrollment.reviewed.latest_good_reviews

    @top_rated_courses = Course.top_rated
    @popular_courses = Course.popular
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)
  end

  def activity
    if current_user.has_role?(:admin)
      @activities = PublicActivity::Activity.all
    else 
      redirect_to root_path, alert: "you aren't authorized brug"
    end
  end

  def analytics
    if current_user.has_role?(:admin)
      #@users = User.all
      #@enrollments = Enrollment.all
      #@courses = Course.all
    else 
      redirect_to root_path, alert: "you aren't authorized brug"
    end
  end

end
