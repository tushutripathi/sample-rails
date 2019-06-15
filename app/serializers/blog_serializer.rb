class BlogSerializer
  include FastJsonapi::ObjectSerializer
  set_type :blog
  set_id :slug
  attributes :title, :content
end
