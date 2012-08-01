require 'spec_helper'

describe ChaptersController, "GET to #show", :webmock do
  let!(:section) { attributes_for :section }
  let!(:chapter) { attributes_for :chapter, section: section }
  let!(:actual_date) { Date.today.to_s(:dashed) }

  before(:each) do
    stub_request(:get, "http://www.example.com/api/chapters/#{chapter[:short_code]}?as_of=#{actual_date}").
           to_return(status: 200,
                     body: File.read("spec/fixtures/responses/chapters_show.json"),
                     headers: { content_type: 'application/json' })


    get :show, id: chapter[:short_code]
  end

  it { should respond_with(:success) }
  it { should assign_to(:chapter) }
  it { should assign_to(:headings) }
end