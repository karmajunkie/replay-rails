require 'replay'
require "replay/rails/version"

module Replay
  module Rails
    class ActiveRecordEventStore 
      class Event < ActiveRecord::Base
        self.table_name = "domain_events"

        def readonly?
          true
        end

        def destroy
          raise ActiveRecord::ReadOnlyRecord.new
        end
        def delete
          raise ActiveRecord::ReadOnlyRecord.new
        end

        def self.delete_all(*args)
          raise ActiveRecord::ReadOnlyRecord.new
        end

        def self.delete(*args)
          raise ActiveRecord::ReadOnlyRecord.new
        end

        def event
          event_type.constantize.new(JSON.parse(event_data))
        end

        def self.events_for(stream_id)
          where(:stream_id => stream_id).order('created_at asc')
        end

        def self.event_stream(stream_id)
          events_for(stream_id).to_a.map(&:event)
        end

      end

      def self.published(stream_id, event)
        Event.create(stream_id: stream_id, event_type: event.class.to_s, event_data: event.to_json)
      end

      def self.event_stream(stream_id)
        Event.event_stream(stream_id)
      end
    end
  end
end

Replay::Backends.register(:active_record, Replay::Rails::ActiveRecordEventStore)
