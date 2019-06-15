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
    page_no = params[:page] || 1
    per_page = params[:per_page] || 15
    @blogs = @blogs.order(created_at: :desc)
    if params[:search].present?
      @blogs = @blogs.where("title ILIKE :search OR content ILIKE :search",
                            search: "%#{params[:search]}%")
    end
    handle_date_stuff
    @blogs = @blogs.page(page_no).per(per_page).without_count
  end

  def handle_date_stuff
    if params[:from].present?
      date = valid_date(params[:from])
      @blogs = @blogs.from_date(date) if date.present?
    end
    if params[:to].present?
      date = valid_date(params[:to])
      @blogs = @blogs.to_date(date) if date.present?
    end
  end

  def valid_date(date)
    Date.parse(date)
  rescue ArgumentError
    nil
  end

  def jsonify(obj)
    BlogSerializer.new(obj).serialized_json
  end
end
