require 'rails_helper'

RSpec.describe Band, :type => :model do
  let(:valid_attributes){ {
    name: "The squeekers"
  } }

  context "validations" do
    let(:band) { Band.new(valid_attributes) }
    
    before do
      Band.create(valid_attributes)
    end

    it "requires a name" do
      expect(band).to validate_presence_of(:name)
    end

    it "requires a unique name" do
      expect(band).to validate_uniqueness_of(:name)
    end

    describe "#delete_empty_bands" do
      it "deletes all bands without any users" do
        band = Band.create(valid_attributes)
        expect{ Band.all.should be_nil }
      end
    end

  end
end
