# -*- coding: UTF-8 -*-

require 'spec_helper'

describe UOrpt::Puller do
  before do
    fetcher = double('RMuh::RPT::Log::Fetch')
    allow(fetcher).to receive(:size).and_return(0)
    allow(fetcher).to receive(:byte_start=) { |v| v }
    allow(RMuh::RPT::Log::Fetch).to receive(:new).and_return(fetcher)
  end

  let(:puller) { UOrpt::Puller.new('http://localhost/', :rpt) }

  describe '::TYPES' do
    subject { UOrpt::Puller::TYPES }

    it { should be_an_instance_of Array }

    it 'should have 2 items' do
      expect(subject.length).to eql 2
    end

    it { should include(:rpt) }

    it { should include(:log) }
  end

  describe '.clear_logs!' do
    before do
      puller.instance_variable_set(:@raw_lines, [:hello])
      puller.instance_variable_set(:@parsed_lines, [:ohai])
    end

    it 'should take no args' do
      expect { puller.send(:clear_logs!, nil) }.to raise_error ArgumentError
    end

    it 'should return nil' do
      expect(puller.send(:clear_logs!)).to be_nil
    end

    it 'should clear @raw_lines and @parsed_lines' do
      expect(puller.raw_lines).to_not be_empty
      expect(puller.parsed_lines).to_not be_empty
      puller.send(:clear_logs!)
      expect(puller.raw_lines).to be_empty
      expect(puller.parsed_lines).to be_empty
    end
  end

  describe '.validate_opts' do
    before(:each) do
      @vo_url = 'http://localhost/'
      @vo_type = :rpt
    end

    context 'should always' do
      it 'accept only two arguments' do
        expect { puller.send(:validate_opts, nil, nil, nil) }.to raise_error ArgumentError
        expect { puller.send(:validate_opts, nil) }.to raise_error ArgumentError
      end
    end

    context 'when passed in valid arguments' do
      subject { puller.send(:validate_opts, @vo_url, @vo_type) }

      it { should be_nil }
    end

    context 'when passed invalid url' do
      before { @vo_url = 'urmom ' }

      it 'should raise ArgumentError' do
        expect do
          puller.send(:validate_opts, @vo_url, @vo_type)
        end.to raise_error ArgumentError
      end
    end

    context 'when passed config with invalid type' do
      before { @vo_type = :urmom }

      it 'should raise ArgumentError' do
        expect do
          puller.send(:validate_opts, @vo_url, @vo_type)
        end.to raise_error ArgumentError
      end
    end
  end

  describe '.set_opts' do
    before { allow(puller).to receive(:validate_opts).and_return(nil) }

    before(:each) do
      @so_url = 'http://localhost'
      @so_type = :rpt
      @so_cfg = { start_byte: 42 }
    end

    context 'should always' do
      it 'accept only two arguments' do
        expect { puller.send(:set_opts, nil, nil) }.to raise_error ArgumentError
        expect { puller.send(:set_opts, nil, nil, nil, nil) }.to raise_error ArgumentError
      end

      subject { puller.send(:set_opts, @so_url, @so_type, @so_cfg) }

      it { should be_nil }

      it 'should call .validate_opts with url and cfg' do
        expect(puller).to receive(:validate_opts).with(@so_url, @so_type).and_return(nil)
        subject
      end

      it 'should set @state to empty hash' do
        subject
        i = puller.instance_variable_get(:@state)
        expect(i).to eql Hash.new
      end

      it 'should set @raw_lines to empty array' do
        subject
        i = puller.instance_variable_get(:@raw_lines)
        expect(i).to eql Array.new
      end

      it 'should set @parsed_lines to empty array' do
        subject
        i = puller.instance_variable_get(:@parsed_lines)
        expect(i).to eql Array.new
      end

      it 'should set @url to the url' do
        subject
        i = puller.instance_variable_get(:@url)
        expect(i).to eql @so_url
      end

      it 'should make sure that @start_byte is an integer' do
        subject
        i = puller.instance_variable_get(:@start_byte)
        expect(i).to be_an_instance_of Fixnum
      end
    end

    context 'when :start_byte not in cfg' do
      before { @so_cfg = {} }

      it 'should set @start_byte to 0' do
        puller.send(:set_opts, @so_url, @so_type, @so_cfg)
        i = puller.instance_variable_get(:@start_byte)
        expect(i).to be_zero
      end
    end
  end

  describe '.results' do
    before { puller.instance_variable_set(:@state, last_byte: 42) }

    it 'accept only one arg' do
      expect { puller.send(:results) }.to raise_error ArgumentError
      expect { puller.send(:results, nil, nil) }.to raise_error ArgumentError
    end

    subject { puller.send(:results, %i(ohai)) }

    it { should be_an_instance_of Hash }

    it 'should set the hash key :log to the argument provided' do
      expect(subject[:log]).to eql %i(ohai)
    end

    it 'should set the hash key :last_byte to the :last_byte from @state' do
      expect(subject[:last_byte]).to eql 42
    end
  end

  describe '.pull_log' do

    context 'always' do
      it 'should accept no args'

      it 'should call @fetcher.size'

      it 'should set @fetcher.byte_end'

      it 'call @fetcher.log'

      it 'should set @state[:last_byte] to the last byte of the log'

      it 'should return an instance of array'

      it 'should return the contents of @fetcher.log'
    end

    context 'when @state has :last_byte key' do
      # i.e., when we've pulled logs before

      it 'should set @fetcher.byte_start to val of @state[:last_byte]'
    end
  end

  describe '.parse_logs' do
    context 'should always' do
      it 'should always accept no args'
    end

    context 'when @type is :rpt' do
      it 'should call parse on the @rp obj'

      it 'should return results of @rp.parse'
    end

    context 'when @type is :log' do
      it 'should call parse on the @lp obj'

      it 'should return results of @lp.parse'
    end
  end

  describe '.populate_logs' do
    context 'always' do
      it 'should take no args'

      it 'should call .pull_log'

      it 'should call parse_logs'
    end

    context 'when @raw_lines contains ::RPT_MARKER' do
      it 'should set @type to :rpt'
    end

    context 'when @raw_lines does not contain ::RPT_MARKER' do
      it 'should set @type to :log'
    end
  end

  describe '.process_logs!' do
    before do
      allow(puller).to receive(:clear_logs!).and_return(nil)
      allow(puller).to receive(:populate_logs).and_return(nil)
    end

    it 'should accept no arguments' do
      expect { puller.send(:process_logs!, nil) }.to raise_error ArgumentError
    end

    it 'should call .clear_logs!' do
      expect(puller).to receive(:clear_logs!).and_return(nil)
      puller.send(:process_logs!)
    end

    it 'should call .populate_logs' do
      expect(puller).to receive(:populate_logs).and_return(nil)
      puller.send(:process_logs!)
    end

    it 'should return nil' do
      expect(puller.send(:process_logs!)).to be_nil
    end
  end

  describe '.logs!' do
    it 'should accept no arguments'

    it 'should call .process_logs!'

    it 'should call .results'

    it 'should return the return of .results'
  end

  describe '.raw_logs!' do
    it 'should accept no arguments'

    it 'should call .process_logs!'

    it 'should call .results'

    it 'should return the return of .results'
  end

  describe '.new' do
    before { allow(UOrpt::Puller).to receive(:set_opts).and_return(nil) }

    it 'should take two arguments' do
      expect { UOrpt::Puller.new(nil) }.to raise_error ArgumentError
      expect { UOrpt::Puller.new(nil, nil, nil) }.to raise_error ArgumentError
    end

    it 'should call RMuh::RPT::Log::Parsers::UnitedOperationsLog.new' do
      expect(RMuh::RPT::Log::Parsers::UnitedOperationsLog).to receive(:new).with(chat: true).and_return(nil)
      _ = UOrpt::Puller.new('http://localhost/', :rpt)
    end

    it 'should set @lp to an instance of RMuh::RPT::Log::Parsers::UnitedOperationsLog' do
      allow(RMuh::RPT::Log::Parsers::UnitedOperationsLog).to receive(:new).with(chat: true).and_return(:ohai)
      p = UOrpt::Puller.new('http://localhost/', :rpt)
      expect(p.instance_variable_get(:@lp)).to eql :ohai
    end

    it 'should call RMuh::RPT::Log::Parsers::UnitedOperationsRPT.new' do
      expect(RMuh::RPT::Log::Parsers::UnitedOperationsRPT).to receive(:new).and_return(nil)
      _ = UOrpt::Puller.new('http://localhost/', :rpt)
    end

    it 'should set @rp to an instance of RMuh::RPT::Log::Parsers::UnitedOperationsRPT' do
      allow(RMuh::RPT::Log::Parsers::UnitedOperationsRPT).to receive(:new).and_return(:hello)
      p = UOrpt::Puller.new('http://localhost', :rpt)
      expect(p.instance_variable_get(:@rp)).to eql :hello
    end

    it 'should call RMuh::RPT::Log::Fetch.new' do
      expect(RMuh::RPT::Log::Fetch).to receive(:new).with('http://localhost/', byte_start: 0)
      _ = UOrpt::Puller.new('http://localhost/', :rpt)
    end

    it 'should set @fetcher to an instance of RMuh::RPT::Log::Fetch' do
      allow(RMuh::RPT::Log::Fetch).to receive(:new).with('http://localhost/', byte_start: 0).and_return(:ohai)
      p = UOrpt::Puller.new('http://localhost/', :rpt)
      expect(p.instance_variable_get(:@fetcher)).to eql :ohai
    end
  end
end
