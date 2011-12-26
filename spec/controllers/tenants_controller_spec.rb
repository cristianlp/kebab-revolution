require 'spec_helper'

describe TenantsController do

  describe "Register valid client" do

    before(:each) do
      @valid_tenant = Factory.create(:tenant)
    end

    it "should eql to expected_response_json" do
      get "/tenants/register", {}, {"HTTP_HOST" => "#{@valid_tenant.host}"}

      body_parsed = JSON.parse(last_response.body)
      expected_response_json = {"success" => true}
      expected_response_json["authenticity_token"] = body_parsed['authenticity_token']
      expected_response_json["tenant"] = Tenant.select('id, host').find_by_host!(last_request.host)

      last_response.body.should eql(expected_response_json.to_json)
    end

    it "status should be eql 200" do
      get "/tenants/register", {}, {"HTTP_HOST" => "#{@valid_tenant.host}"}
      last_response.status.should eql(200)
    end
  end

  describe "Register invalid client" do

    it "should eql to expected_response_json" do
      get "/tenants/register", {}, {"HTTP_HOST" => "#{invalid_tenant_host}"}

      expected_response_json = {"success" => false}
      expected_response_json["notice"] = ["type" => 'ERR', "message" => "Invalid tenant"]

      last_response.body.should eql(expected_response_json.to_json)
    end

    it "status should be eql 404" do
      get "/tenants/register", {}, {"HTTP_HOST" => "#{invalid_tenant_host}"}
      last_response.status.should eql(404)
    end
  end

end