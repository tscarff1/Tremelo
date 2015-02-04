require 'rails_helper'

RSpec.describe VideosController, :type => :controller do

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    it "returns http success" do
      video = FactoryGirl.create(:video)
      get :show, id: video
      response.should render_template :show
    end
  end

end
