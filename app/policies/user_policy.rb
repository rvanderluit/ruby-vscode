class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
  def index?
    puts "partyyyyyyy"
    puts @user.has_role?(:admin)
    puts "partyyyyyyy"
    @user.has_role?(:admin)
  end

  def edit?
    @user.has_role?:admin
    puts "EEEpartyyyyyyy"
    puts @user.has_role?(:admin)
    puts "EEEpartyyyyyyy"
    @user.has_role?(:admin)
  end

  def update?
    #@user.has_role?:admin
    @user.has_role?(:admin)
  end

end
