module Clock
  module Controls
    module Time
      module Elapsed
        def self.example(units, reference: nil, precision: nil)
          time = Raw.example units, reference: reference, precision: precision

          ISO8601.example time, precision: precision
        end

        module Raw
          def self.example(units, reference: nil, precision: nil)
            reference ||= Time::Raw.example

            unit_duration = Unit::Duration::Seconds.example precision: precision

            elapsed_seconds = units * unit_duration

            reference + elapsed_seconds
          end
        end

        module Unit
          module Frequency
            def self.example(precision: nil)
              precision ||= Clock::ISO8601::Defaults.precision

              10 ** precision
            end
          end

          module Duration
            module Seconds
              def self.example(precision: nil)
                frequency = Frequency.example precision: precision

                Rational(1, frequency)
              end
            end
          end
        end
      end
    end
  end
end
