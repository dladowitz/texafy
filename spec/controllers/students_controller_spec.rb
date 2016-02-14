require 'rails_helper'

describe StudentsController do
  describe "GET index" do
    subject { get :index }

    it "renders the index template" do
      subject
      expect(response).to render_template :index
    end
  end
end
