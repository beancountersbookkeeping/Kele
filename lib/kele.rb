require 'httparty'
require 'json'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: {"email": email, "password": password})
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @auth_token})
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page_id)
    response = self.class.get(api_url("message_threads?page=#{page_id}"), headers: {"authorization" => @auth_token})
    @messages = JSON.parse(response.body)
  end

  def create_messages(sender,recipient_id,token,subject,text)
    response = self.class.post(api_url("messages"),
    body: {
      "sender": sender,
      "recipient_id": recipient_id,
      "token": nil, 
      "subject": subject,
      "stripped_text": text
    },
    headers: {"authorization" => @auth_token})
    puts response
  end

  private

  def api_url(url)
    "https://www.bloc.io/api/v1/#{url}"
  end
end
