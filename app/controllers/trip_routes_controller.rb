class TripRoutesController < ApplicationController
  def show
    @trip_route = TripRoute.find params[:id]
    @trip_route_activity = TripRouteActivity.new
    @trip_route_activities = @trip_route.trip_route_activities
    @hash = Gmaps4rails.build_markers(@trip_route_activities) do |trip_route, marker|
      marker.lat trip_route.activity.latitude
      marker.lng trip_route.activity.longitude
      marker.infowindow trip_route.activity.title.capitalize
    end

    if current_user.address.present?
      @activities = Activity.near([current_user.latitude, current_user.longitude], @trip_route.transport, units: :km)
    else
      @activities = Activity.all
    end
  end

  def new
    @trip_route = TripRoute.new
    @activities = Activity.all
  end

  def create
    @trip_route = TripRoute.new trip_route_params

    if @trip_route.save
      flash[:success] = t ".success"
    else
      flash[:error] = @trip_route.errors.full_messages.to_sentence
    end

    redirect_to @trip_route
  end

  def update
    @trip_route = TripRoute.find params[:id]
    @trip_route.update trip_route_params
    redirect_to @trip_route
  end

  private

  def trip_route_params
    params.require(:trip_route).permit(:transport, :trip_route_activities, :active).merge(user: current_user)
  end
end
