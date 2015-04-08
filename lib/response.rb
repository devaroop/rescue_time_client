
module RescueTime
  module Response
    extend self

    def process(resp)
      JSON.parse(resp.body)
    end
    
  end
end
