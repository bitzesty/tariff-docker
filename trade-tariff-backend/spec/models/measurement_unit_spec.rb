require 'spec_helper'

describe MeasurementUnit do
  let(:measurement_unit) { create :measurement_unit, :with_description }

  describe '#to_s' do
    it 'is an alias for description' do
      measurement_unit.to_s.should eq measurement_unit.description
    end
  end

  describe 'validations' do
    # MU1 The measurement unit code must be unique.
    it { should validate_uniqueness.of(:measurement_unit_code) }
    # MU2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
  end

  describe "#abbreviation" do
    before {
      measurement_unit.stub(:measurement_unit_abbreviation) { raise Sequel::RecordNotFound }
    }
    it {
      expect(measurement_unit.abbreviation).to eq(measurement_unit.description)
    }
  end

  describe "#measurement_unit_abbreviation" do
    context "without measurement_unit_abbreviation" do
      it {
        expect {
          measurement_unit.measurement_unit_abbreviation
        }.to raise_error(Sequel::RecordNotFound)
      }
    end

    context "with measurement_unit_abbreviation" do
      let!(:measurement_unit_abbreviation) {
        create(:measurement_unit_abbreviation, measurement_unit_code: measurement_unit.measurement_unit_code)
      }
      it {
        expect(measurement_unit.measurement_unit_abbreviation).to eq(measurement_unit_abbreviation)
      }
    end
  end
end
