require 'spec_helper'
require 'pry-debugger' 

describe Api::QuestionResultsController do
  describe "POST batch_create" do
    before(:all) do
      user = User.create(token: "testtoken", provider: "facebook", name: "test", uuid: "222")
    end

    describe "should except correct params" do
    end

    describe "should upgrade to new degree" do
    end

    describe "should downgrade to new degree" do
    end

    describe "should stay same degree" do
    end
  end
end
