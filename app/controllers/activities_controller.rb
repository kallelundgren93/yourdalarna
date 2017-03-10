class ActivitiesController < ApplicationController
  def show
    @activity = Activity.find params[:id]
    @trivium = @activity.trivia
    @questions = @activity.questions.order("RANDOM()").first(3)
    @images = @activity.activity_images.paginate(:page => params[:page], :per_page => 6)
    @activity_image = ActivityImage.new
    @feedbacks = @activity.feedbacks.first_four_by_date
    @feedback = Feedback.new
  end
end
