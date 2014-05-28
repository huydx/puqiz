require 'spec_helper'
require 'pry-debugger' 

describe Api::QuestionsController do
  describe "User authenticate" do
    it "should return success" do
      get :index
      expect(response).to be_success
    end

    it "should return failed json" do
      get :index
      expected = {status: "unauthenticated token"}.to_json
      response.body.should == expected
    end
    
    it "should return status success with correct params" do
      user = User.create!(token: "testtoken", provider: "facebook", name: "test", uuid: "222")
      get :index, uid: user.id, token: user.token 
      JSON.parse(response.body)["status"].should == true
    end
  end
end
