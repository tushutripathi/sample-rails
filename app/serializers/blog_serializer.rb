class BlogSerializer
  include FastJsonapi::ObjectSerializer
  set_type :blog
  set_id :slug
  attributes :title, :content

  attribute :created_at do |blog|
    SerializerCommon.format_date(blog.created_at)
  end

  attribute :updated_at do |blog|
    SerializerCommon.format_date(blog.updated_at)
  end
end
