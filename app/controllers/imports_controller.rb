class ImportsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /alarms/:alarm_id/imports/new
  def new    
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found
    @import = Import.new({:type => nil,
                          :value => nil,
                          :from => "file",
                          :file => nil,
                          :alarm_id => @alarm.id,
                          :from_index => params[:from_index]})   
    render layout: false                                               
  end
  
  # POST /alarms/:alarm_id/imports
  def create
    @samples_page = params[:page].present? ? params[:page].to_i : 1
    @alarm = current_user.alarms.find_by_id(params[:alarm_id]) || not_found   
    @import = Import.new(params[:import])  
    
    if @import.to_sample
      @alarm = Alarm.find(@alarm.id)
      @samples = @alarm.samples.order("created_at desc, id desc").page(@samples_page)
      @message = "Se ha importado correctamente la muestra de <b>#{@alarm.name}</b>"
      @status = :created
    else
      @message = "No se ha podido importar la muestra de la alarma <b>#{@alarm.name}</b>"
      @status = :unprocessable_entity
    end 
  end
  
end
