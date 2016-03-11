require "thor"

module PastYerEyes
  class CLI < Thor
    desc "help", "Show options"
    def help
      help_screen = <<-DESC
      past_yer_eyes OPTIONS:

        -l, --log_file=PASTEURIZATION_LOG_FILE, :default => "pasteurization.json"
        -s, --sheet_name=SPREADSHEET_NAME, :default => "Pasteurization Batches CURRENT_TIME"
        -e, --session=SESSION_FILE, :default => "session.json"

      DESC

      puts help_screen
    end

    desc "parse_logs", "Parse Batch Reports and create a Google sheet"
    option :log_name, :type => :string, :default => "./pasteurization.json", :aliases => "-l"
    option :sheet_name, :type => :string, :aliases => "-s"
    option :session, :type => :string, :default => "./session.json", :aliases => "-e"
    option :exclude, :type => :boolean, :default => false
    def create_spreadsheet
      spreadsheet_name = options.fetch(:log_name, default_spreadsheet_name)
      logfile_name = options[:log_name]
      session_file = options[:session]
      filter_options = {}
      filter_options[:completed] = options[:exclude]

      fail "#{session_file} does not exist" unless File.exist?(session_file)
      fail "#{logfile_name} does not exist" unless File.exist?(logfile_name)

      ::PastYerEyes::LogParser.parse(filter_options, session_file, logfile_name, spreadsheet_name)
    end

    default_task :create_spreadsheet

    no_commands do
      def default_spreadsheet_name
        "Pasteurization Batches #{Time.now}"
      end
    end
  end
end
