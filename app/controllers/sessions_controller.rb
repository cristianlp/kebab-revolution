class SessionsController < ApplicationController
  def register
    @@response[request_forgery_protection_token] = form_authenticity_token
    @@response['tenant'] = Tenant.select('id, host').find_by_host!(request.host)
    render json: @@response, callback: params[:callback]
  end

  def test
    I18n.locale = 'en'
    render json: u.errors.to_json
  end
end