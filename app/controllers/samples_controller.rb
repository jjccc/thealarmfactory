#encoding: utf-8
class SamplesController < ApplicationController
  before_filter :authenticate_user!
  
  decorates_assigned :sample
  
  # GET /alarms/:alarm_id/samples
  def index
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @samples = @alarm.samples.order("created_at desc, id desc").page(params[:page])
    @samples_page = params[:page].present? ? params[:page].to_i : 1
  end

  # GET /alarms/:alarm_id/samples/new
  def new
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @sample = Sample.new
    @sample.alarm_id = @alarm.id
    @url = alarm_samples_path(@alarm, {:show => true})
  end

  # GET /alarms/:alarm_id/samples/1/edit
  def edit
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @sample = @alarm.samples.find_by_id(params[:id]) || not_found
    @url = alarm_sample_path(@alarm, @sample, { :page => params[:page] })
  end

  # POST /alarms/:alarm_id/samples
  def create
    @from_alarm_show = params[:show].present?
    @samples_page = params[:page].present? ? params[:page].to_i : 1
    
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found    
    begin
      @sample = Sample.new(params[:sample])     
      @alarm.samples << @sample
      if @sample.errors.blank?        
        @alarm = Alarm.find(params[:alarm_id])      
        if @sample.has_triggered_alarm
          @notifications = @alarm.notifications.order("created_at desc, id desc").page(1)
          @notifications_page = 1
        end
        @samples = @alarm.samples.order("created_at desc, id desc").page(@samples_page)
        @message = "Se ha añadido una muestra a la alarma <b>#{@alarm.name}</b>"
        @status = :created
      else
        @message = "#{@sample.errors.first[1]}.<br><br>No se ha podido añadir una muestra a la alarma <b>#{@alarm.name}</b>"
        @status = :unprocessable_entity
      end
    rescue
      @message = "No se ha podido añadir una muestra a la alarma <b>#{@alarm.name}</b>"
      @status = :unprocessable_entity
    end
    
    respond_to do |format|
      format.js
      format.html {
        if @status == :created
          redirect_to @alarm, notice: @message
        else
          render action: "new"
        end
      } 
    end
  end

  # PUT /alarms/:alarm_id/samples/1
  def update
    @samples_page = params[:page].present? ? params[:page].to_i : 1
     
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found  
    @sample = @alarm.samples.find_by_id(params[:id]) || not_found 
    begin      
      result = @sample.update_attributes(params[:sample])
      @samples = @alarm.samples.order("created_at desc, id desc").page(@samples_page)      
      @message = "Se ha modificado la muestra <b>#{sample.value}</b> creada el <b>#{sample.created_at}</b> correctamente."      
      @status = :ok
    rescue
      result = false
      @message = "¡Vaya! No se ha podido eliminar la muestra <b>#{@sample.name}</b> creada el <b>#{sample.created_at}</b>."
      @status = :unprocessable_entity
    end

    respond_to do |format|
      if result
        format.js
        format.html { redirect_to @sample, notice: @message }
      else
        format.js
        format.html { render action: "edit" }        
      end
    end
  end

  # DELETE /alarms/:alarm_id/samples/1
  def destroy
    @samples_page = params[:page].present? ? params[:page].to_i : 1
    
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found  
    @sample = @alarm.samples.find_by_id(params[:id]) || not_found 
    begin
      @sample.destroy      
      @alarm = Alarm.find(params[:alarm_id])
      @samples = @alarm.samples.order("created_at desc, id desc").page(@samples_page)
      
      # Si en la página sólo había una muestra y la hemos borrado debemos irnos a la página anterior
      if @samples_page > 1 && @samples.blank?
        @samples_page -= 1        
        @samples = @alarm.samples.order("created_at desc, id desc").page(@samples_page)
      end
      
      @message = "Se ha eliminado la muestra <b>#{sample.value}</b> creada el <b>#{sample.created_at}</b> correctamente."      
      @status = :ok
    rescue
      @message = "¡Vaya! No se ha podido eliminar la muestra <b>#{sample.value}</b> creada el <b>#{sample.created_at}</b>."       
      @status = :unprocessable_entity
    end

    respond_to do |format|
      format.js
      format.html { redirect_to alarm_samples_url(@alarm) }
    end       
  end  

end
