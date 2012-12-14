require "spec_helper"

describe "description" do
  include_context 'with unconnected facebook user'

  it "should description" do
    FacebookIntegrationHelpers.complete_facebook_connect_and_wait_for("content")
  end
end
