require 'fb_graph'

module FacebookIntegrationHelpers
  shared_context "with unconnected facebook user" do
    let(:fb_user) { create_test_user(installed: false) }
    after { fb_user.destroy }
  end

  def app_client
    FbGraph::Application.new(ENV['facebook_id'], :secret => ENV['facebook_secret'])
  end

  def create_test_user(options)
    query = {
      :installed => true,
      :permissions => 'email,offline_access'
    }.merge(options)

    app_client.test_user!(query)
  end

  def complete_facebook_connect_and_wait_for(content)
    within_window "Log In | Facebook" do
      fill_in 'Email:', with: fb_user.email
      fill_in 'Password:', with: fb_user.password
      click_button "Log In"
      # synchronization makes this never return, maybe because
      # it's running in a different window?
      without_resynchronize { click_button "Allow" }
    end
    wait_a_while_for { page.should have_content(content) }
  end

  # this is a bit of a hack - inquiring on the capybara mailing list
  # for better solutions
  def without_resyncronize
    page.driver.options[:resynchronize] = false
    yield
    page.driver.options[:resynchronize] = true
  end

  def wait_a_while_for
    default_wait = Capybara.default_wait_time
    Capybara.default_wait_time = 30
    yield
    Capybara.default_wait_time = default_wait
  end
end
