module SoundCloud
  class Client

    private

    # MonkeyPatch this method. This can be removed once the issue specified
    # https://github.com/soundcloud/soundcloud-ruby/issues/53 got fixed and released
    def handle_response(refreshing_enabled=true, &block)
      response = block.call
      if response && !response.success?
        if response.code == 401 && refreshing_enabled && options_for_refresh_flow_present?
          exchange_token
          # TODO it should return the original
          handle_response(false, &block)
        else
          raise ResponseError.new(response)
        end
      elsif response.parsed_response.is_a?(Hash)
        HashResponseWrapper.new(response)
      elsif response.parsed_response.is_a?(Array)
        ArrayResponseWrapper.new(response)
      elsif response && response.success?
        response
      end
    end

  end
end
