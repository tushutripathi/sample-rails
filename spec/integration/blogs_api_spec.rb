require "swagger_helper"

describe "Blogs API" do
  let(:Authorization) { auth_token }
  before do
    @blog_params = {title: "test", content: "blog content"}
    @fake_blog = Blog.create!(@blog_params)
    @blog_params2 = {title: "test2", content: "blog content2"}
    @fake_blog2 = Blog.create!(@blog_params2)
  end

  properties_common = {
      id: {type: :string},
      type: {type: :string},
      attributes: {type: :object,
                   required: %w[title content],
                   properties: {
                       title: {type: :string},
                       content: {type: :string}
                   }
      }
  }

  single_resp_schema = {
      type: :object,
      required: ["data"],
      properties: {
          data: {
              type: :object,
              required: %w[id type attributes],
              properties: properties_common
          }
      }
  }

  index_resp_schema = {
      type: :object,
      required: ["data"],
      properties: {
          data: {
              type: :array,
              items: {
                  type: :object,
                  required: %w[id type attributes],
                  properties: properties_common
              }
          }
      }
  }

  # for create or update
  req_schema = {
      type: :object,
      required: ["data"],
      properties: {
          data: {
              type: :object,
              properties: {
                  title: {type: :string, example: "My Pretty Blog"},
                  content: {type: :string, example: "Welcome to my blog."}
              }
          }
      }
  }

  path "/api/v1/blogs" do
    get "Fetch all blogs on basis of filters" do
      tags "Blogs"
      produces "application/json"
      parameter name: :search, in: :query, type: :string, required: false
      parameter name: :page, in: :query, type: :string, required: false
      parameter name: :per_page, in: :query, type: :string, required: false
      parameter name: :from, in: :query, type: :string,
                format: "date", description: "dd/mm/yyyy", required: false
      parameter name: :to, in: :query, type: :string,
                format: "date", description: "dd/mm/yyyy", required: false
      # security [api_token: []]

      response "200", "All the blogs" do
        schema index_resp_schema
        let(:search) { nil }
        let(:page) { nil }
        let(:per_page) { nil }

        context "only page provided" do
          let(:page) { 1 }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["data"].length).to eq(2)
          end
        end
        context "search term provided" do
          let(:search) { "content2" }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["data"].length).to eq(1)
          end
        end
        context "no results search" do
          let(:search) { "lol" }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["data"].length).to eq(0)
          end
        end
        context "time" do
          let(:from) { Time.zone.today.strftime("%d/%m/%Y") }
          context "'to' has sth" do
            let(:to) { Time.zone.today.strftime("%d/%m/%Y") }
            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data["data"].length).to eq(2)
            end
          end
          context "'to' is wrongly formatter" do
            let(:to) { "tushar" }
            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data["data"].length).to eq(2)
            end
          end
          context "empty result" do
            let(:to) { Time.zone.yesterday.strftime("%d/%m/%Y") }
            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data["data"].length).to eq(0)
            end
          end
        end
      end

      # response "401", "Unauthorized, wrong api token" do
      #   schema err_schema_common
      #   let(:Authorization) { nil }
      #   run_test!
      # end
    end

    post "Make a new blog" do
      tags "Blogs"
      consumes "application/json"
      produces "application/json"
      parameter name: :new_blog, in: :body, schema: req_schema

      let(:new_blog) { {data: {title: "hello", content: "world"}} }
      response "201", "Blog created" do
        schema single_resp_schema
        run_test! do |response|
          data = JSON.parse(response.body)["data"]
          expect(data["id"]).not_to eq(nil)
          expect(data["attributes"]["title"]).to eq(new_blog[:data][:title])
          expect(data["attributes"]["content"]).to eq(new_blog[:data][:content])
        end
      end

      response "422", "Unprocessable entity" do
        schema err_schema_common
        context "Title not present" do
          let(:new_blog) { {data: {content: "world"}} }
          run_test!
        end
        context "Content not present" do
          let(:new_blog) { {data: {title: "hello"}} }
          run_test!
        end
      end
    end
  end

  path "/api/v1/blogs/{blog_id}" do
    let(:blog_id) { @fake_blog.slug }

    get "Fetch a specific blog by id" do
      tags "Blogs"
      produces "application/json"
      parameter name: :blog_id, in: :path, type: :string
      security [api_token: []]

      response "200", "Blog fetched" do
        schema single_resp_schema
        run_test! do |response|
          data = JSON.parse(response.body)["data"]
          expect(data["attributes"]["title"]).to eq(@fake_blog.title)
          expect(data["attributes"]["content"]).to eq(@fake_blog.content)
        end
      end

      response "404", "Blog not found" do
        schema err_schema_common
        let(:blog_id) { "wrong" }
        run_test!
      end
    end

    put "Update blog" do
      tags "Blogs"
      consumes "application/json"
      produces "application/json"
      parameter name: :blog_id, in: :path, type: :string
      parameter name: :updated_blog, in: :body, schema: req_schema

      let(:updated_blog) { {data: {title: "hello2", content: "world2"}} }
      response "200", "Blog updated" do
        schema single_resp_schema
        run_test! do |response|
          data = JSON.parse(response.body)["data"]
          expect(data["id"]).to eq(blog_id)
          expect(data["attributes"]["title"]).to eq(updated_blog[:data][:title])
          expect(data["attributes"]["content"]).to eq(updated_blog[:data][:content])
        end
      end

      response "404", "Blog not found" do
        schema err_schema_common
        let(:blog_id) { "wrong" }
        run_test!
      end
    end

    delete "Delete blog" do
      tags "Blogs"
      consumes "application/json"
      produces "application/json"
      parameter name: :blog_id, in: :path, type: :string

      response "204", "Blog deleted" do
        run_test! do
          expect(Blog.all.size).to eq(1)
        end
      end

      response "404", "Blog not found" do
        schema err_schema_common
        let(:blog_id) { "wrong" }
        run_test!
      end
    end
  end
end
