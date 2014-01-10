require 'spec_helper'

describe Commodities::ChangesController, "GET to #index" do
  context "commodity is valid at given date", vcr: { cassette_name: "commodities_changes#index" }  do
    let!(:commodity)   { Commodity.new(attributes_for :commodity, goods_nomenclature_item_id: "0101210000") }

    before(:each) do
      get :index, commodity_id: commodity.short_code, format: :atom
    end

    it { should respond_with(:success) }
    it { should assign_to(:changeable) }
    it { should assign_to(:changes) }
  end

  context 'commodity has no changes at given date', vcr: { cassette_name: "commodities_changes#index_4302130000_1998-01-01" } do
    let!(:commodity)   { Commodity.new(attributes_for :commodity, goods_nomenclature_item_id: "4302130000") }

    before(:each) do
      get :index, commodity_id: commodity.short_code, as_of: Date.new(1998,1,1), format: :atom
    end

    it { should respond_with(:success) }
    it { should assign_to(:changeable) }
    it { should assign_to(:changes) }

    it 'fetches no changes' do
      expect(assigns[:changes]).to be_empty
    end
  end

  context 'commodity is not valid at given date', vcr: { cassette_name: "commodities_changes#index_4302130000_2013-11-11" } do
    let!(:commodity)   { Commodity.new(attributes_for :commodity, goods_nomenclature_item_id: "4302130000") }

    before(:each) do
      get :index, commodity_id: commodity.short_code, as_of: Date.new(2013,11,11), format: :atom
    end

    it { should respond_with(:not_found) }
  end
end