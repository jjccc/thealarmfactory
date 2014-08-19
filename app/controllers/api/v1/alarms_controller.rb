module Api
  module V1
    class AlarmsController < ApplicationController
      respond_to :json
      
      before_filter :api_authenticate
      
      # GET /api/v1/alarms.json     
      def index
        alarms = @api_user.alarms.order("has_notifications desc, created_at desc").page(params[:page])
        respond_with AlarmDecorator.decorate_collection(alarms).as_json( :from_api => true ), status: :ok 
      end
      
      # GET /api/v1/alarms/:id.json
      def show
        alarm = @api_user.alarms.find_by_id(params[:id])
        if alarm.nil?
          render :json => {}.as_json, status: :unauthorized
        else
          render :json => AlarmDecorator.decorate(alarm).as_json( :from_api => true ), status: :ok
        end
      end
      
    end
  end
end