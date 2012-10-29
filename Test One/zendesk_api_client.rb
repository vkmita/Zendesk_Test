# If I couldn't use your zendesk_api_client_rb :D

require "rubygems"
require "faraday"
require "yajl"

class Zendesk_Client

  def initialize(username,password,subdomain)

    # establishes the connection

    @conn = Faraday.new(:url => 'https://'+ subdomain + '.zendesk.com') do |faraday|
      faraday.request  :basic_auth, username, password
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  # utility method that creates Ruby hash from a json string
  def hash_it(json)
    json_io = StringIO.new(json)
    parser = Yajl::Parser.new
    @hash = parser.parse(json_io)
  end

  def create_user(name,email)
    response = @conn.post do |req|
      req.url '/api/v2/users.json'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = "{\"user\":{\"name\":\"" + name + "\",\"email\":\"" + email + "\", \"verified\": true}}"
    end
    #puts response.body

    json_hash = hash_it(response.body)

    # If user already added we puts this notification
    puts "Already added this user (" + json_hash["details"]["email"][0]["description"] + ")" if json_hash["error"] == "RecordInvalid"

    # Either way we want to create a ticket with this dude
    @user = Hash[:name => name, :email => email]
  end

  def create_ticket_as_requester(name, email, subject, comment)
    puts "START CREATE TICKET"
    response = @conn.post do |req|
      req.url '/api/v2/tickets.json'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = "{\"ticket\": {
          \"subject\": \"" + subject + "\",
          \"comment\": { \"body\": \"" + comment + "\" },
          \"requester\": { \"name\": \"" + name + "\", \"email\": \"" + email + "\" }
          }}"
    end
    #puts response.body

    json_hash = hash_it(response.body)

    @ticket_id = json_hash["ticket"]["id"]
  end

  def mark_ticket_as_solved(ticket_id)
    response = @conn.put do |req|
      req.url '/api/v2/tickets/' + ticket_id.to_s + '.json'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = "{\"ticket\": {
          \"status\": \"solved\"}}"
    end
    #puts response.body
  end
end

client = Zendesk_Client.new("vkmita@berkeley.edu","password1","vkmita")

name = "Example Name"
email = "example@example.com"

user = client.create_user(name, email)

subject = "Ticket"
comment = "I don't know what I'm doing"

ticket_id = client.create_ticket_as_requester(user[:name],user[:email],subject,comment)

client.mark_ticket_as_solved(ticket_id)



