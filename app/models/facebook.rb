module Facebook
  class AfterCreateStrategy
    def initialize(args)
      @user = args[:user]
    end

    def process(args = {})
      create_pages
    end

    def create_pages
      user = FbGraph::User.me(@user.access_token)
      user.accounts.each do |account|
        next unless account.perms.include?("CREATE_CONTENT")
        SocialUser.create(
          provider: "facebook_#{account.category.downcase}",
          uid:      account.identifier,
          email:    "#{account.identifier}@facebook.com",
          nickname: account.name,
          access_token: account.access_token,
          expires: nil,
          parent_id: @user.id
        ))
      end
    end
  end
end
