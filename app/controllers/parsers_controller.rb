class ParsersController < ApplicationController
  # To run application:
  # bundle install
  # rails s
  # http://localhost:3000
  def index;end

  def parse
    # Render tables row
    render json: {
      html: render_to_string(
              partial: 'logs.html.erb',
              locals: { logs: parse_logs(params[:logs])}
            )
    }
  end

  private

  def parse_logs(logs)
    parsed_logs = logs.split("\n").map do |log| # Split events by row
      log_hash = {}
      log_hash["event"] = log # Save original event
      next if log.blank?

      log.strip.split(' ').each do |log_field| # split event by fields
        log_field = log_field.split('=')
        if log_field[1] && ['src', 'timestamp', 'dst'].include?(log_field[0])
          # Save only required fields
          if ['src', 'dst'].include?(log_field[0])
            log_hash[log_field[0]] = validate_ip(log_field[1].tr('^0-9.', '') )
          else
            log_hash[log_field[0]] = log_field[1]
          end
        end
      end
      log_hash
    end
    parsed_logs
  end

  def validate_ip(ip)
    # Validation of IP address
    ipaddr = IPAddr.new(ip)
    {
      'value' => ip,
      'valid' => true,
      'private' => ipaddr.private?, # Validate IP is private
    }
  rescue
    # Save as Invalid on error
    {
      'value' => ip,
      'valid' => false
    }
  end
end
