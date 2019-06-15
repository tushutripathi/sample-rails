# Sample React + Rails App

### User's zone
- API Docs at - /api-docs/v3/index.html
- Suggestions/bugs - add to issue tracker

### Developer's zone

Ruby  ~> 2.6.3

Rails ~> 6.0.0rc1

Install Redis as well and ensure redis server is running for sidekiq.

To run- 

Enter db configuration in database.yml

Then,

```console
$ bundle install
$ sudo npm install
$ rake db:create
$ rake db:migrate
$ rake db:seed
$ rails server
$ bundle exec sidekiq 1 -q fetch_response, 1 -q async_get, 1 -q default
$ cd frontend & npm start
```

Note: Environments variables are initialized in initializers/dev_configmap.rb

### For production
Make build of ui and save it to public
directory in rails. Then that will be directly
accessible from the url.
```console
$ npm install
or if the above didn't work-
$ sudo npm install --unsafe-perm
```

### To run rubocop
Follow the style guides as per .rubocop.yml
Ensure everything is good by running rubocop before every commit.
```console
$ rubocop
```

### To run tests
```console
$ rspec
```

Then see the coverage report with -

```console
$ xdg-open coverage/index.html (linux)
$ open coverage/index.html (mac)
```

### Generating swagger docs from api_spec
This doesn't run the tests, run rspec separately
before this.

```console
$ rake rswag:specs:swaggerize
```

After running server, api-docs will be at 
- /api-docs/v3/index.html

### For application documentation use yard
```console
$ gem install yard
$ yardoc
$ yard server --reload
```

The above will start a server which will show you the project's documentation generated using doc comments present in the source.

To check undocumented methods

```console
$ yard stats --list-undoc --exclude "app/controllers/"
```
