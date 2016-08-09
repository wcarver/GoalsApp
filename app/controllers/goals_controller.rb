class GoalsController < ApplicationController


  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user
    @goal.completed = false
    if @goal.save
      redirect_to user_url(current_user)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def new
    @goal = Goal.new
  end

  def edit
    find_goal
  end

  def update
    find_goal
    return unless owns_goal?
    if @goal.update_attributes(goal_params)
      redirect_to user_url(@goal.user)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    find_goal
    return unless owns_goal?
    @goal.destroy
    redirect_to user_url(current_user)
  end


  private

  def find_goal
    @goal ||= Goal.find(params[:id].to_i)
  end

  def owns_goal?
    unless find_goal.user_id == current_user.id
      render text: "get out", status: :forbidden
      return false
    end
    true
  end


  def goal_params
    params.require(:goal).permit(:body, :private, :completed)
  end


end
