module Sidekiq
  module Middleware
    module Server
      class ActiveRecord
        def call(*args)
          yield
        ensure
          conn = ::ActiveRecord::Base.connection
          conn.disconnect!

          ::ActiveRecord::Base.connection_pool.checkin conn
          ::ActiveRecord::Base.connection_pool.connections.delete(conn)

          ::ActiveRecord::Base.clear_active_connections!
        end
      end
    end
  end
end
