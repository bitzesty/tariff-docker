attributes :short_code, :code, :declarable, :description, :producline_suffix, :leaf

node(:children) { |heading|
  heading.children.map do |heading|
    partial("api/v1/headings/heading", object: heading)
  end
}