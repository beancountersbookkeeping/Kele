require 'httparty'

class Kele
  include HTTParty

  def initialize(username, password)
    response = self.class.post(api_url("sessions"), body: {"username": username, "password": password})
    @auth_token = response["auth_token"]
  end

  private

  def api_url(url)
    "https://www.bloc.io/api/v1/#{url}"
  end
end
