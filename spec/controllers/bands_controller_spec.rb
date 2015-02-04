require 'rails_helper'

RSpec.describe BandsController, :type => :controller do

  before :each do
    band = FactoryGirl.create(:band)
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    it "returns http success" do
      band = FactoryGirl.create(:band)
      get :edit, id: band
      response.should render_template :edit
    end
  end

  describe "GET show" do
    it "returns http success" do
       band = FactoryGirl.create(:band)
      get :show, id: band
      response.should render_template :show
    end
  end

end
