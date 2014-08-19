#encoding: utf-8
module Api
  module V1
    
    class SamplesController < ApplicationController
      respond_to :json
      
      before_filter :api_authenticate
          
      # GET /api/v1/alarms/:alarm_id/samples.json
      def index
        alarm = @api_user.alarms.find_by_id(params[:id])
        samples = alarm.nil? ? [] : alarm.samples.order("created_at desc, id desc").page(params[:page])
        render :json => SampleDecorator.decorate_collection(samples).as_json( :from_api => true ), status: :ok
      end
      
      # GET /api/v1/alarms/:alarm_id/samples/1.json
      def show
        alarm = @api_user.alarms.find_by_id(params[:id])
        sample = alarm.nil? ? nil : alarm.samples.find_by_id(params[:id])
        if sample.nil? || alarm.nil?
          render :json => {}.as_json, status: :unauthorized
        else
          render :json => SampleDecorator.decorate(sample).as_json( :from_api => true ), status: :ok
        end
      end

      # POST /api/v1/alarms/:alarm_id/samples.json
      def create               
        begin
          alarm = @api_user.alarms.find_by_id(params[:id])
          if alarm.nil?
            result = "No se ha podido añadir una muestra a la alarma."
            status = :unauthorized
          else
            sample = Sample.new(params[:sample])     
            alarm.samples << sample
            status = :created          
            result = SampleDecorator.decorate(sample).as_json( :from_api => true )
          end          
        rescue
          result = "No se ha podido añadir una muestra a la alarma."
          status = :unprocessable_entity
        end
        
        render :json => result, status: status        
      end
      
      # PUT /api/v1/alarms/:alarm_id/samples/1.json
      def update                 
        begin
          alarm = @api_user.alarms.find_by_id(params[:id])
          sample = alarm.nil? ? nil : alarm.samples.find_by_id(params[:id]) 
          if sample.nil? || alarm.nil? 
            result = "No se ha podido añadir una muestra a la alarma."
            status = :unauthorized 
          else
            sample.update_attributes(params[:sample])         
            status = :created
            result = SampleDecorator.decorate(sample).as_json( :from_api => true )            
          end
        rescue
          result = "No se ha podido añadir una muestra a la alarma."
          status = :unprocessable_entity
        end
                
        render :json => result, status: status       
      end
      
      # DELETE /api/v1/alarms/:alarm_id/samples/1
      def destroy
        result = nil  
        begin
          alarm = @api_user.alarms.find_by_id(params[:id])
          sample = alarm.nil? ? nil : alarm.samples.find_by_id(params[:id])
          if sample.nil? || alarm.nil?    
            result = "No se ha podido añadir una muestra a la alarma."
            status = :unauthorized
          else
            sample.destroy         
            status = :ok
            result = SampleDecorator.decorate(sample).as_json( :from_api => true )            
          end
        rescue
          result = "No se ha podido añadir una muestra a la alarma."
          status = :unprocessable_entity
        end
        
        render :json => result, status: status
      end
      
    end
  end
end