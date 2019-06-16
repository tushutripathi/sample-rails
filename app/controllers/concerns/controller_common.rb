module ControllerCommon
  extend ActiveSupport::Concern
  include ActionController::Helpers

  included do
    helper_method :render_error, :render_not_found, :public_ids_to_db_ids
  end

  def render_error(error_code, message="")
    if message.is_a?(ActiveRecord::Base)
      message = message.errors.full_messages[0]
    end
    render(json: {error_code: Rack::Utils.status_code(error_code).to_s,
                  message: message}, status: error_code)
  end

  # @param [string] entity
  def render_not_found(entity)
    msg = "#{entity} not found"
    render_error(:not_found, msg)
  end

  # Call this in before action with the fields having public id, and the corresponding
  # model class the public id is for.
  # @param [Array([key_name_for_id, ActiveRecord::Base])] key_model_pairs
  # @example
  #   public_ids_to_db_ids([[:package_id, Package], [:profile_id, Profile]])
  def public_ids_to_db_ids(key_model_pairs)
    key_model_pairs.each do |key_model|
      public_id_to_db_id(key_model[0], key_model[1]) unless performed?
    end
  end

  # @param [Symbol] key
  # @param [ActiveRecord::Base] model
  def public_id_to_db_id(key, model)
    if params[key].present?
      params[key] = model.find_by(public_id: params[key])&.id
      render_not_found(model.name.downcase)
    end
  end
end
