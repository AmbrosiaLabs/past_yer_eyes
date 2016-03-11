require "thor"

module PastYerEyes
  class CLI < Thor
    desc "parse_logs", "Parse Batch Reports and create a Google sheet"
    long_desc <<-DESC
    DESC

    option :log_name, :type => :string, :default => "./pasteurization.json", :aliases => "-l"
    option :sheet_name, :type => :string, :aliases => "-s"
    option :session, :type => :string, :default => "./session.json", :aliases => "-e"

    def create_spreadsheet
      spreadsheet_name = options.fetch(:log_name, default_spreadsheet_name)
      logfile_name = options[:log_name]
      session_file = options[:session]

      ::PastYerEyes::LogParser.parse(session_file, logfile_name, spreadsheet_name)
    end

    default_task :create_spreadsheet

    no_commands do
      def default_spreadsheet_name
        "Pasteurization Batches #{Time.now}"
      end
    end
  end
end
