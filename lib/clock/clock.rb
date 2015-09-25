module Clock
  class Error < RuntimeError; end

  def self.included(cls)
    cls.extend Now
    cls.extend Canonize
    cls.extend SystemTime
    cls.extend ISO8601
    cls.extend Parse
    cls.extend ElapsedMilliseconds
    cls.extend Timestamp
    cls.extend Configure
  end

  def now(time=nil)
    time || self.class.now(system_time: system_time)
  end

  def canonize(time)
    self.class.canonize time
  end

  def system_time
    self.class.system_time
  end

  def iso8601(time=nil, precision: nil)
    time ||= now
    self.class.iso8601 time, precision
  end

  def parse(str)
    self.class.parse str
  end

  def timestamp(time=nil)
    self.class.timestamp time
  end

  def self.local(time)
    time.getlocal
  end

  def self.localized(time, identifier)
    clock = Localized.build identifier
    clock.canonize time
  end

  def self.utc(time)
    time.utc
  end

  def elapsed_milliseconds(start_time, end_time)
    self.class.elapsed_milliseconds(start_time, end_time)
  end

  module Now
    def now(time=nil, system_time: nil)
      system_time ||= self.system_time
      time ||= system_time.now
      canonize(time)
    end
  end

  module Canonize
    def canonize(time)
      time
    end
  end

  module SystemTime
    extend self
    def system_time
      Time
    end
  end

  module ISO8601
    extend self
    def iso8601(time=nil, precision=nil)
      precision ||= self.precision
      time = time.nil? ? now : canonize(time)
      time.iso8601(precision)
    end

    def precision
      Defaults.precision
    end

    module Defaults
      def self.precision
        3
      end
    end
  end

  module Parse
    extend self
    def parse(str)
      time = SystemTime.system_time.parse str
      time = canonize(time)
      time
    end
  end

  module ElapsedMilliseconds
    extend self
    def elapsed_milliseconds(start_time, end_time)
      start_time = parse(start_time) if start_time.is_a? String
      end_time = parse(end_time) if end_time.is_a? String

      ((end_time - start_time) * 1000).round
    end
  end

  module Timestamp
    extend self
    def timestamp(time=nil)
      time = time.nil? ? now : canonize(time)
      time.to_f
    end
  end

  module Configure
    def configure(receiver)
      instance = new
      receiver.clock = instance
      instance
    end
  end

  extend Now
  extend Canonize
  extend SystemTime
  extend ISO8601
  extend Parse
  extend ElapsedMilliseconds
  extend Timestamp

  class Substitute
    include Clock

    attr_writer :system_time

    def system_time
      @system_time ||= Time
    end

    def now=(val)
      system_time = OpenStruct.new
      system_time.now = val
      self.system_time = system_time
      system_time
    end
  end
end
