require "rails_helper"

RSpec.describe CountyFinder do
  describe ".from_zip_code" do
    it "should find Araphaoe county based on zip_code" do
      expect(described_class.from_zip_code("80046")).to eq "Arapahoe"
    end

    it "should find Pitkin county based on zip_code" do
      expect(described_class.from_zip_code("81611")).to eq "Pitkin"
    end

    it "should return nil if no results can be found" do
      expect(described_class.from_zip_code("00000")).to be_nil
    end
  end
end
