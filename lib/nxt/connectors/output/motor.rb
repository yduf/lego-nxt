module NXT
  module Connector
    module Output
      class Motor
        include NXT::Command::Output

        DURATION_TYPE = [:seconds, :degrees, :rotations].freeze
        DURATION_AFTER = [:coast, :brake].freeze
        DIRECTIONS = [:forwards, :backwards].freeze

        attr_accessor :port, :interface

        attr_combined_accessor :duration, 0
        attr_combined_accessor :duration_type, :seconds
        attr_combined_accessor :duration_after, :stop
        attr_combined_accessor :direction, :forwards

        def initialize(port, interface)
          @port = port
          @interface = interface
        end

        def duration=(duration, options = {})
          raise TypeError.new('Expected duration to be a number') unless duration.is_a?(Integer)
          @duration = duration

          if options.include?(:type)
            type = options[:type]

            unless DURATION_TYPE.include?(type)
              raise TypeError.new("Expected duration type to be one of: :#{DURATION_TYPE.join(', :')}")
            end

            @duration_type = type
          else
            @duration_type = :seconds
          end

          if options.include?(:after)
            if @duration_type == :seconds
              after = options[:after]

              unless DURATION_AFTER.include?(after)
                raise TypeError.new("Expected after option to be one of: :#{DURATION_AFTER.join(', :')}")
              end

              @duration_after = after
            else
              raise TypeError.new('The after option is only available when the unit duration is in seconds.')
            end
          else
            @duration_after = :stop
          end

          case @duration_type
          when :rotations
            self.tacho_limit = @duration * 360
          when :degrees
            self.tacho_limit = @duration
          end

          self
        end

        def direction=(direction)
          unless DIRECTIONS.include?(direction)
            raise TypeError.new("Expected direction to be one of: :#{DIRECTIONS.join(', :')}")
          end

          @direction = direction
          self
        end

        def forwards
          self.direction = :forwards
        end

        def backwards
          self.direction = :backwards
        end

        def stop(type = :coast)
          self.power = 0
          self.mode = :coast

          self.move
        end

        # takes block for response, or can return the response instead.
        def move
          response_required = false

          if self.duration > 0 && self.duration_type != :seconds
            response_required = true
          end

          set_output_state(response_required)

          if self.duration > 0 && self.duration_type == :seconds
            sleep(self.duration)
            self.reset
            self.stop(self.duration_after)
          else
            self.reset
          end
        end

        def reset
          self.duration = 0
          self.direction = :forwards
          self.power = 75
          self.mode = :motor_on
          self.regulation_mode = :idle
          self.run_state = :running
          self.tacho_limit = 0
        end
      end
    end
  end
end
