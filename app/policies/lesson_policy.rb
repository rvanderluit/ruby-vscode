class LessonPolicy < ApplicationPolicy
    class Scope < Scope
      # NOTE: Be explicit about which records you allow access to!
      def resolve
        scope.all
      end
    end
  
    def show?
        @user.has_role?(:admin) || @record.course.user_id == @user.id
    end
        
    def edit?
      @record.course.user_id == @user.id #@record.user is not working
    end
  
    def update?
      @record.course.user_id == @user.id
    end
  
    def new?
      #@user.has_role?:teacher
      #@user.has_role?(:teacher)
    end
  
    def create?
        @record.course.user_id == @user.id
      #@user.has_role?:teacher
      #@user.has_role?(:teacher)
    end
  
    def destroy?
      #@user.has_role?:admin || @record.user = @user
      @record.course.user_id == @user.id
    end
  end
  
  
  
  