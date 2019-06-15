# Disabling some dangerous tasks
DISABLED_TASKS = %w[db:drop db:migrate:reset db:schema:load db:seed db:truncate].freeze

namespace :db do
  desc "Disable a task in production environment"
  task :guard_for_production do
    if Rails.env.production? or Rails.env.development? or Rails.env.staging?
      # Add this environment variable to use a disabled task
      # This acknowledges that the person exactly what is being done.
      # Take backup before if needed
      if ENV["I_KNOW_THIS_MAY_SCREW_THE_DB"] != "1"
        logger.warn("This task is disabled in production.")
        logger.info("If you really want to run it,")
        logger.info("call it again with `I_KNOW_THIS_MAY_SCREW_THE_DB=1`")
        exit # rubocop:disable Rails/Exit
      end
    end
  end
end

DISABLED_TASKS.each do |task|
  Rake::Task[task].enhance ["db:guard_for_production"]
end
