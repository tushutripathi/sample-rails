class ApplicationController < ActionController::API
  include ControllerCommon
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::MimeResponds

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
end
