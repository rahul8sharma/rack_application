require_relative './user'
require_relative './setup_db'
require 'json'

# Authentication
use Rack::Auth::Basic, "UserController" do |username, password|
  username == 'admin' && password == 'admin'
end

require 'rack/cache'

# Caching
use Rack::Cache,
  metastore:   'file:/var/cache/rack/meta',
  entitystore: 'file:/var/cache/rack/body',
  verbose:     true

class UserController
  attr_reader :headers, :body, :request

  def initialize(&block)
    @block = block
    @status = 200
    @headers = { "Content-Type" => "application/json"}
    @body = ""
    SetupDB.setup_db
  end

  def status(value = nil)
    value ? @status = value : @status
  end

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.get? && req.path == '/users/search'
      users = User.where('name LIKE ?', "%#{req.params['name']}%")

      return [status, headers, [ { users: users }.to_json ]]
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end
end

run UserController.new