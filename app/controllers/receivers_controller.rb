#encoding: utf-8
class ReceiversController < ApplicationController
  before_filter :authenticate_user!
  
  decorates_assigned :receiver
  
  # GET /alarms/:alarm_id/receivers
  def index
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @receivers = @alarm.receivers.order("created_at desc").page(params[:page])
    @receivers_page = params[:page].present? ? params[:page].to_i : 1  
  end

  # GET /alarms/:alarm_id/receivers/new
  def new
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @receiver = Receiver.new
    @receiver.alarm_id = @alarm.id
    @url = alarm_receivers_path(@alarm, {:show => true})
  end

  # GET /alarms/:alarm_id/receivers/1/edit
  def edit
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @receiver = @alarm.receivers.find_by_id(params[:id]) || not_found
    @url = alarm_receiver_path(@alarm, @receiver, { :page => params[:page] })
  end

  # POST /alarms/:alarm_id/receivers
  def create
    @from_alarm_show = params[:show].present?
    @receivers_page = params[:page].present? ? params[:page].to_i : 1
      
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found  
    begin      
      @receiver = Receiver.new(params[:receiver])    
      @alarm.receivers << @receiver
      @receivers = @alarm.receivers.order("created_at desc").page(@receivers_page)
      @message = "Se ha añadido un destinatario a la alarma <b>#{@alarm.name}</b>"
      @status = :created  
    rescue
      @message = "No se ha podido añadir un destinatario a la alarma <b>#{@alarm.name}</b>"
      @status = :unprocessable_entity
    end
    
    respond_to do |format|
      format.js
      format.html {
        if status == :created
          redirect_to @alarm, notice: @message
        else
          render action: "new"
        end
      }      
    end
  end

  # PUT /alarms/:alarm_id/receivers/1
  def update
    @receivers_page = params[:page].present? ? params[:page].to_i : 1
      
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @receiver = @alarm.receivers.find_by_id(params[:id]) || not_found  
    begin      
      @receivers = @alarm.receivers.order("created_at desc").page(@receivers_page)    
      result = @receiver.update_attributes(params[:receiver])
      @message = "Se ha modificado el destinatario <b>#{@receiver.name}</b> correctamente."      
      @status = :ok
    rescue
      result = false
      @message = "¡Vaya! No se ha podido eliminar el destinatario <b>#{@receiver.name}</b>."
      @status = :unprocessable_entity
    end

    respond_to do |format|
      if result
        format.js
        format.html { redirect_to @receiver, notice: @message }
      else
        format.js
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /alarms/:alarm_id/receivers/1
  def destroy
    @receivers_page = params[:page].present? ? params[:page].to_i : 1
    
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @receiver = @alarm.receivers.find_by_id(params[:id]) || not_found  
    begin
      @receiver.destroy
      @receivers = @alarm.receivers.order("created_at desc").page(@receivers_page)
      
      # Si en la página sólo había un receptor y lo hemos borrado debemos irnos a la página anterior
      if @receivers_page > 1 && @receivers.blank?
        @receivers_page -= 1        
        @receivers = @alarm.receivers.order("created_at desc").page(@receivers_page)
      end
      
      @message = "Se ha eliminado el destinatario <b>#{@receiver.name}</b> correctamente."      
      @status = :ok
    rescue
      @message = "¡Vaya! No se ha podido eliminar el destinatario <b>#{@receiver.name}</b>."       
      @status = :unprocessable_entity
    end

    respond_to do |format|
      format.js
      format.html { redirect_to alarm_receivers_url(@alarm) }
    end
  end
end
