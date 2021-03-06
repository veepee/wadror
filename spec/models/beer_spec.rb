require 'spec_helper'

describe Beer do
  describe "is created and saved succesfully" do
    it "if it has name and style set" do
      style = Style.create name:"Lager"
      beer = Beer.create name:"Test", style:style

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
  describe "is neither created nor saved" do
    it "if it has an invalid name" do
      style = Style.create name:"Lager"
      beer = Beer.create style:style

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
    
    it "if the style has not been specified" do
      beer = Beer.create name:"Test"
      
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

end
