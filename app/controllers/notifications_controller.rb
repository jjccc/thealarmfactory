class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  
  # # GET /alarms/:alarm_id/notifications
  def index
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @notifications = @alarm.notifications.order("created_at desc").page(params[:page])
    @notifications_page = params[:page].present? ? params[:page].to_i : 1
  end

  # GET /alarms/:alarm_id/notifications/1
  def show
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @notification = @alarm.notifications.find_by_id(params[:id]) || not_found
    @highchart = Highchart.new(@alarm, @notification)
    render layout: false
  end

end
