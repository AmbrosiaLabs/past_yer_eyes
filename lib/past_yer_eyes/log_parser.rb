require "json"
require "awesome_print"

module PastYerEyes
  class LogParser
    def self.parse(options, session_file, logfile_name, spreadsheet_name)
      file = File.read(logfile_name)

      records = JSON.parse(file)

      batches = records["batches"].map do |key, value|
        ::PastYerEyes::BatchRecord.parse(key, value)
      end

      SpreadsheetWriter.write_spreadsheet(options, session_file, spreadsheet_name, batches)
    end
  end
end
