module PastYerEyes
  class BatchRecord
    attr_accessor :name, :guid, :status, :duration, :base_temperature, :batch_key, :events

    def self.parse(key, data)
      record = ::PastYerEyes::BatchRecord.new
      record.batch_key = key
      record.guid = data.fetch("guid", "")
      record.status = data.fetch("status", "")
      record.duration = data.fetch("duration", "")
      record.base_temperature = data.fetch("base_temperature")
      record.name = data.fetch("name", "")

      record.events = data["events"].map do |key, value|
        ::PastYerEyes::BatchEvent.parse(key, value)
      end

      record
    end
  end

  class BatchEvent < Struct.new(:guid, :data_point, :data_type, :timestamp)
    def self.parse(key, event_hash)
      ::PastYerEyes::BatchEvent.new(key, event_hash["data"], event_hash["name"], event_hash["timestamp"])
    end
  end
end

