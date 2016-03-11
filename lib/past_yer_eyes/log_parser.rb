require "json"
require "google/api_client"
require "google_drive"

TIMESTAMP_COL = 1
READING_COL = 2
DATA_COL = 3

module PastYerEyes
  class LogParser
    def self.parse(session_file, logfile_name, spreadsheet_name)
      session = GoogleDrive.saved_session(session_file)

      sheet = session.create_spreadsheet(spreadsheet_name)

      file = File.read(logfile_name)

      records = JSON.parse(file)

      records.each do |record|
        print_record(sheet, record)
      end
    end

    def self.print_footer(ws, row, batch_name, batch_record)
      ws[row, 1] = "Batch Name"
      ws[row, 2] = batch_name
      row += 1
      ws[row, 1] = "Duration"
      ws[row, 2] = batch_record['duration']
      row += 1
      ws[row, 1] = "Base Temperature"
      ws[row, 2] = batch_record['base_temperature']
      row += 1
      ws[row, 1] = "Status"
      ws[row, 2] = batch_record['status']
      ws.save
    end

    def self.print_record(sheet, record)
      batch_name = record.first
      batch_record = record[1]

      ws = sheet.add_worksheet("#{batch_record['name']}: #{batch_record['status']}")

      ws[1,TIMESTAMP_COL] = "Timestamp"
      ws[1,READING_COL] = "Reading"
      ws[1,DATA_COL] = "Value"

      row = 2
      batch_record['events'].each do |key, value|
        ws[row, TIMESTAMP_COL] = value["timestamp"]
        ws[row, READING_COL] = value["name"]
        ws[row, DATA_COL] = value["data"]
        row += 1
      end

      print_footer(ws, row + 1, batch_name, batch_record)
    end
  end
end
