require 'replay'
require "replay/rails/version"

module Replay
  module Rails
    class ActiveRecordEventStore
      class Event < ActiveRecord::Base
        self.table_name = "domain_events"

        def readonly?
          persisted?
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
          if data.is_a? String
            event_type.constantize.new(JSON.parse(data))
          else
            event_type.constantize.new(data)
          end
        end

        def metadata
          if envelope_data.is_a? String
            JSON.parse(envelope_data)
          else
            envelope_data
          end
        end

        def envelope
          @envelope ||= Replay::EventEnvelope.new(
            stream_id,
            event,
            envelope_data
          )
        end

        def self.events_for(stream_id)
          where(:stream_id => stream_id).order('created_at asc')
        end

        def self.event_stream(stream_id)
          events_for(stream_id).to_a.map(&:envelope)
        end
      end

      def self.archive(stream_id)
        live_events = Arel::Table.new(:domain_events)
      end

      def self.published(envelope)
        Event.create(stream_id: envelope.stream_id, event_type: envelope.type, data: envelope.event.to_json, envelope_data: envelope.metadata.to_json)
      end

      def self.event_stream(stream_id)
        Event.event_stream(stream_id)
      end
    end
  end
end

Replay::Backends.register(:active_record, Replay::Rails::ActiveRecordEventStore)
