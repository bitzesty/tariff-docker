require 'spec_helper'
require 'duty_expression_formatter'

describe DutyExpressionFormatter do
  describe '.format' do
    let(:measurement_unit) {
      measurement_unit_abbreviation.measurement_unit
    }
    let(:unit) {
      measurement_unit.abbreviation(measurement_unit_qualifier: measurement_unit_qualifier)
    }
    let!(:measurement_unit_abbreviation) {
      create(:measurement_unit_abbreviation, :with_measurement_unit, :include_qualifier)
    }
    let!(:measurement_unit_qualifier) {
      create(:measurement_unit_qualifier, measurement_unit_qualifier_code: measurement_unit_abbreviation.measurement_unit_qualifier)
    }

    context 'for duty expression 99' do
      describe "with qualifier" do
        it 'return the measurement unit' do
          DutyExpressionFormatter.format(duty_expression_id: '99',
                                         measurement_unit: measurement_unit,
                                         measurement_unit_qualifier: measurement_unit_qualifier).should eq unit
        end
      end

      describe "without qualifier" do
        let!(:measurement_unit_abbreviation) {
          create(:measurement_unit_abbreviation, :with_measurement_unit)
        }
        let(:measurement_unit_qualifier) { nil }

        it "returns unit" do
          DutyExpressionFormatter.format(duty_expression_id: "99",
                                         measurement_unit: measurement_unit).should eq unit
        end
      end
    end

    context 'for duty expressions 12 14 37 40 41 42 43 44 21 25 27 29' do
      context 'duty expression abbreviation present' do
        it 'returns duty expression abbreviation' do
          DutyExpressionFormatter.format(duty_expression_id: '12',
                                         duty_expression_abbreviation: 'abc',
                                         duty_expression_description: 'def').should eq 'abc'
        end
      end

      context 'duty expression abbreviation missing' do
        it 'returns duty expression description' do
          DutyExpressionFormatter.format(duty_expression_id: '12',
                                         duty_expression_description: 'def').should eq 'def'
        end
      end
    end

    context 'for duty expressions 15 17 19 20' do
      context 'duty expression abbreviation present' do
        it 'result includes duty expression abbreviation' do
          DutyExpressionFormatter.format(duty_expression_id: '15',
                                         duty_expression_abbreviation: 'def').should =~ /def/
        end
      end

      context 'duty expression abbreviation missing' do
        it 'result includes duty expression abbreviation' do
          DutyExpressionFormatter.format(duty_expression_id: '15',
                                         duty_expression_description: 'abc').should =~ /abc/
        end
      end

      context 'monetary unit present' do
        it 'result includes monetary unit' do
          DutyExpressionFormatter.format(duty_expression_id: '15',
                                         duty_expression_description: 'abc',
                                         monetary_unit: 'EUR').should =~ /EUR/
        end
      end

      context 'monetary unit missing' do
        it 'result includes percent sign' do
          DutyExpressionFormatter.format(duty_expression_id: '15',
                                         duty_expression_description: 'abc').should =~ /%/
        end
      end

      context 'measurement unit and measurement unit qualifier present' do
        it 'result includes measurement unit and measurement unit qualifier' do
          DutyExpressionFormatter.format(duty_expression_id: '15',
                                         measurement_unit: measurement_unit,
                                         measurement_unit_qualifier: measurement_unit_qualifier,
                                         duty_expression_description: 'abc').should =~ Regexp.new(unit)
        end
      end

      context 'just measurement unit present' do
        let!(:measurement_unit_abbreviation) {
          create(:measurement_unit_abbreviation, :with_measurement_unit)
        }
        let(:measurement_unit_qualifier) { nil }

        it 'result includes measurement unit' do
          DutyExpressionFormatter.format(duty_expression_id: '15',
                                         measurement_unit: measurement_unit,
                                         duty_expression_description: 'abc').should =~ Regexp.new(unit)
        end
      end
    end

    context 'for all other duty expression types' do
      context 'duty amount present' do
        it 'result includes duty amount' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         duty_expression_description: 'abc',
                                         duty_amount: '55').should =~ /55/
        end
      end

      context 'duty expression abbreviation present and monetary unit missing' do
        it 'result includes duty expression abbreviation' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         duty_expression_abbreviation: 'abc',
                                         duty_amount: '55').should =~ /abc/
        end
      end

      context 'duty expression description present and monetary unit missing' do
        it 'result includes duty expression abbreviation' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         duty_expression_description: 'abc',
                                         duty_amount: '55').should =~ /abc/
        end
      end

      context 'duty expression description missing' do
        it 'result includes duty expression abbreviation' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         duty_amount: '55').should =~ /%/
        end
      end

      context 'monetary unit present' do
        it 'result includes monetary unit' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         duty_expression_description: 'abc',
                                         monetary_unit: 'EUR').should =~ /EUR/
        end
      end

      context 'measurement unit and measurement unit qualifier present' do
        it 'result includes measurement unit and measurement unit qualifier' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         measurement_unit: measurement_unit,
                                         measurement_unit_qualifier: measurement_unit_qualifier,
                                         duty_expression_description: 'abc').should =~ Regexp.new(unit)
        end
      end

      context 'measurement unit present' do
        let!(:measurement_unit_abbreviation) {
          create(:measurement_unit_abbreviation, :with_measurement_unit)
        }
        let(:measurement_unit_qualifier) { nil }

        it 'result includes measurement unit' do
          DutyExpressionFormatter.format(duty_expression_id: '66',
                                         measurement_unit: measurement_unit,
                                         duty_expression_description: 'abc').should =~ Regexp.new(unit)
        end
      end
    end
  end

  describe '.prettify' do
    context 'has less than 4 decimal places' do
      it 'returns number with insignificant zeros stripped up to 2 decimal points' do
        expect(DutyExpressionFormatter.prettify(1.2)).to eq '1.20'
      end
    end

    context 'has 4 or more decimal places' do
      it 'returns formatted number with 4 decimal places' do
        expect(DutyExpressionFormatter.prettify(1.23456)).to eq '1.2346'
      end
    end
  end
end