#-*- encoding: utf-8 -*-
module TestProvider
  class AfterCreateStrategy
    def initialize(args = {})
    end
    def process
      "processing from test provider"
    end
  end
end
