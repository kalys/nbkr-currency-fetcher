module Sinatra
  module Dalli
    module Helpers
      def cache(key, params = {}, &block)
        return block.call unless options.cache_enable

        opts = {
          :expiry => options.cache_default_expiry
        }.merge(params)

        value = cget(key, opts)
        return value unless block_given?

        if value
          value
        else
          cset(key, block.call, opts)
        end
      rescue => e
        raise e if development?
        block.call
      end

      def expire(p)
        return unless options.cache_enable
        expire_key(p)
        true
      rescue => e
        raise e if development?
        false
      end

      private

      def client
        options.cache_client ||= ::Dalli::Client.new
      end

      def log(msg)
        puts "[CACHE] #{msg}" if options.cache_logging
      end

      def cget(key, opts)
        v = client.get(key)
        return v unless v
        log "Get: #{key}"
        Marshal.load(v)
      end

      def cset(key, value, opts)
        v = Marshal.dump(value)
        client.set(key, v, opts[:expiry])
        log "Set: #{key}"
        value
      end

      def expire_key(key)
        log "Expire: #{key}"
        client.delete(key)
      end
    end

    def self.registered(app)
      app.helpers Dalli::Helpers

      app.set :cache_client, nil
      app.set :cache_server, "127.0.0.1"
      app.set :cache_enable, true
      app.set :cache_logging, true
      app.set :cache_default_expiry, 86400
    end
  end
end

