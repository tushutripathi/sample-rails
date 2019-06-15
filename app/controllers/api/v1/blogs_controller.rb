class Api::V1::BlogsController < ApplicationController
  include ControllerCommon
  before_action :filter_blogs, only: %i[index]
  before_action :set_blog, only: %i[show update destroy]

  def index
    render(json: jsonify(@blogs))
  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      render(json: jsonify(@blog))
    else
      render_error(:unprocessable_entity, @blog)
    end
  end

  def show
    render(json: jsonify(@blog))
  end

  def update
    if @blog.update(blog_params)
      render(json: jsonify(@blog))
    else
      render_error(:unprocessable_entity, @blog)
    end
  end

  def destroy
    @blog.destroy!
  end

  private

  def set_blog
    @blog = Blog.find_by!(slug: params[:slug])
  end

  def blog_params
    params.permit(:title, :content)
  end

  def filter_blogs
    @blogs = Blog.all
  end

  def jsonify(obj)
    BlogSerializer.new(obj).serialized_json
  end
end
