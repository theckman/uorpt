# -*- coding: UTF-8 -*-

require 'uri'
require 'rmuh/rpt/log/fetch'
require 'rmuh/rpt/log/parsers/unitedoperationslog'
require 'rmuh/rpt/log/parsers/unitedoperationsrpt'

module UOrpt
  # TODO: Class documentation
  #
  class Puller
    TYPES ||= %i(rpt log)
    RPT_MARKER ||= ' "############################# '

    attr_reader :raw_lines, :parsed_lines, :state, :url, :type

    def initialize(url, cfg)
      set_opts(url, cfg)
      @lp = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(chat: true)
      @rp = RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new
      @fetcher = RMuh::RPT::Log::Fetch.new(@url, byte_start: @start_byte)
    end

    def logs!
      process_logs!
      results(@parsed_lines)
    end

    def raw_logs!
      process_logs!
      results(@raw_lines)
    end

    private

    def validate_opts(u, c)
      fail(ArgumentError, 'invalid format for URL') unless u =~ URI::ABS_URI
      fail(ArgumentError, 'valid types are :rpt or :log') if !c.key?(:type) || !TYPES.include?(c[:type])
      nil
    end

    def set_opts(url, cfg)
      validate_opts(url, cfg)
      @state = {}
      @raw_lines = []
      @parsed_lines = []
      @url = url
      @type = cfg[:type]
      @start_byte = cfg.fetch(:start_byte, 0).to_i
      nil
    end

    def clear_logs!
      @raw_lines.clear
      @parsed_lines.clear
      nil
    end

    def process_logs!
      clear_logs!
      populate_logs
      nil
    end

    def results(lines)
      { log: lines, last_byte: @state[:last_byte] }
    end

    def pull_log
      log_end = @fetcher.size
      @fetcher.byte_start = @state[:last_byte] if @state.key?(:last_byte)
      @fetcher.byte_end = log_end
      log = @fetcher.log
      @state[:last_byte] = log_end
      log
    end

    def parse_logs
      if @type == :rpt
        @rp.parse(@raw_lines)
      else
        @lp.parse(@raw_lines)
      end
    end

    def populate_logs
      @raw_lines = pull_log
      @parsed_lines = parse_logs
    end
  end
end
