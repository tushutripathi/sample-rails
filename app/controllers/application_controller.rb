class ApplicationController < ActionController::API
  include ControllerCommon
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from StandardError do |exception|
    if exception.class == ActiveRecord::RecordNotFound
      render_not_found("resource")
    else
      logger.error("Internal server error happened")
      logger.error(exception.message)
      logger.error(exception.backtrace)
      render_error(:internal_error, "internal server error")
    end
  end
end
