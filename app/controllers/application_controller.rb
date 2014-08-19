class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
   
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def after_sign_in_path_for(resource_or_scope)
    alarms_path
  end
  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path    
  end  
  
  private 
  
  def api_authenticate    
    authenticate_or_request_with_http_token do |token, options|   
      @api_user = User.find_by_api_token(token) 
    end    
  end
 
end
