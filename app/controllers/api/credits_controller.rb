class Api::CreditsController < Api::ApplicationController
  def index
    @credits = Credit.all
  end
end
