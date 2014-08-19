# encoding: utf-8
class AlarmsController < ApplicationController
  before_filter :authenticate_user!
  
  decorates_assigned :alarm

  # GET /alarms
  def index
    if params[:search].present?      
      @alarms = current_user.alarms.where("name like '%#{params[:search]}%' or description like '%#{params[:search]}%'").
                      order("has_notifications desc, created_at desc").
                      page(params[:page])
    else
      @alarms = current_user.alarms.order("has_notifications desc, created_at desc").
                      page(params[:page])
    end

    @alarms.each{ |a| a.index_page = params[:page] }

    gon.message = flash[:notice].present? ? flash[:notice].html_safe : ""
  end

  # GET /alarms/1
  def show
    @alarm = current_user.alarms.find_by_id(params[:id]) || not_found
    
    @receivers = @alarm.receivers.order("created_at desc").page(params[:page])
    @samples = @alarm.samples.order("created_at desc, id desc").page(params[:page])
    @notifications = @alarm.notifications.order("created_at desc, id desc").page(params[:page])
    
    # Clasificamos los operadores por tipo de operación
    @operator_types = OperatorType.order(:id).all
    @operators = {}
    @operator_types.each do |ot|
      @operators[ot.id] = ot.operators.order(:symbol)
    end
    
    @receivers_page = 1
    @samples_page = 1
    @notifications_page = 1
    
    gon.alarm_id = @alarm.id
    gon.samples = @samples.count 
    gon.receivers = @receivers.count
  end

  # GET /alarms/new
  def new
    @alarm = Alarm.new
    @alarm.user_id = current_user.id
  end

  # GET /alarms/1/edit
  def edit
    @alarm = current_user.alarms.find_by_id(params[:id]) || not_found
  end

  # POST /alarms
  def create
    @alarm = Alarm.new(params[:alarm])
    @alarm.user_id = current_user.id
    
    respond_to do |format|
      if @alarm.save
        format.html { redirect_to alarm_path(@alarm), notice: "Se ha creado la nueva alarma <b>#{@alarm.name}</b>".html_safe }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /alarms/1
  def update
    @alarm = current_user.alarms.find_by_id(params[:id]) || not_found
    begin      
      result = @alarm.update_attributes(params[:alarm])         
      @message = "Se ha modificado la alarma correctamente."      
      @status = :ok               
    rescue
      result = false     
    end 
        
    unless result && @alarm.errors.blank?
      result = false
      @message = "¡Vaya! No se ha podido modificar la alarma. #{@alarm.errors.first[1] unless @alarm.nil? || @alarm.errors.blank?}"
      @status = :unprocessable_entity   
    end     

    respond_to do |format|
      if result
        format.js
        format.html { redirect_to @alarm, notice: @message }
      else
        format.js
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /alarms/1
  def destroy
    @alarms_page = params[:page].present? ? params[:page].to_i : 1
    @alarm = current_user.alarms.find_by_id(params[:id]) || not_found
    begin
      @alarm.destroy
      @message = "Se ha eliminado la alarma <b>#{@alarm.name}</b> correctamente."      
      @status = :ok
    rescue
      @message = "¡Vaya! No se ha podido eliminar la alarma <b>#{@alarm.name unless @alarm.nil?}</b>."       
      @status = :unprocessable_entity
    end
    
    @alarms = Alarm.order("has_notifications desc, created_at desc").page(@alarms_page)
      
    # Si en la página sólo había una muestra y la hemos borrado debemos irnos a la página anterior
    if @alarms_page > 1 && @alarms.blank?
      @alarms_page -= 1        
      @alarms = Alarm.order("has_notifications desc, created_at desc").page(@alarms_page)
    end
    
    @alarms.each{ |a| a.index_page = @alarms_page }

    respond_to do |format|
      format.js
      format.html { redirect_to alarms_url }
    end
  end
  
  # GET /alarms/1/export
  def export
    @alarm = current_user.alarms.find_by_id(params[:id]) || not_found       
    
    if params[:notification_id].present? 
      notification = Notification.find_by_id(params[:notification_id].to_i) || not_found
      samples = @alarm.samples.where("id < ?", notification.sample_id).order(:created_at)
      date = notification.created_at.strftime("%d-%m-%Y")
    else
      samples = @alarm.samples.order(:created_at)
      date = Date.today.strftime("%d-%m-%Y")
    end
    
    file_path = "#{Rails.root}/tmp/downloads/#{@alarm.name.parameterize}-#{date}.csv"   
         
    begin       
      File.open(file_path, "w") do |f|        
        samples.each do |s|
          f.write("#{s.created_at.strftime("%d/%m/%Y %H:%M:%S")}\t#{s.value.to_s}\n")
        end
      end 
      
      send_file file_path, :type=>'text/csv' and return
    rescue
      not_found
    end 
  end
  
end
