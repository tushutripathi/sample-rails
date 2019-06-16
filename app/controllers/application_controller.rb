class ApplicationController < ActionController::API
  include ControllerCommon
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::MimeResponds
  # before_action :authenticate_user, except: :fallback_index_html

  # send other than API routes stuff to react router
  def fallback_index_html
    # render(file: Rails.root.join("public/index.html"))
    respond_to do |format|
      format.html { render body: Rails.root.join("public/index.html").read }
    end
  end

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

  private

  def authenticate_user
    logger.info("Authentication requested by ip: #{request.ip}")
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      token == ENV["SELF_API_TOKEN"]
    end
  end

  def render_unauthorized
    # This header tells authentication method to be used to access the resource
    headers["WWW-Authenticate"] = 'Token realm="Application"'
    render(json: {status: "unauthorized", error: "incorrect api token"},
           status: :unauthorized)
  end
end
