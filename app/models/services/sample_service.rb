module SampleService
  class << self
    def hello
      fetch_hello
    end

    private

    def fetch_hello
      "Hello World!"
    end
  end
end
