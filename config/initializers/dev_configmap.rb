if Rails.env.development? or Rails.env.test?
  # Set the required variables added in kube/configmaps here to
  # auto load at server start.
  ENV["USER_ADMIN"] = "test"
  ENV["USER_ADMIN_PWD"] = "test"
  ENV["SELF_API_TOKEN"] = "test"
end
