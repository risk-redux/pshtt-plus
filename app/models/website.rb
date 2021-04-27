class Website < ApplicationRecord
  belongs_to :domain
  after_create :bootstrap

  serialize :redirect_url
  serialize :notes

  def bootstrap
    begin
      self.notes = ["[#{current_time_from_proper_timezone}] Website created!"]
      self.save
    rescue => exception
      puts "[#{current_time_from_proper_timezone}] Exception: #{exception}"
    end
  end

  def check_website
    puts "Checking website status for #{self.to_url}"

    @http_status_code
    @http_status
    @redirect_url
    @digest
    @notes

    begin
      uri = URI(self.to_url)

      Net::HTTP.start(uri.host, uri.port, { read_timeout: 5, open_timeout: 5, use_ssl: self.is_https }) do |http|
        response = http.get(uri)

        @http_status_code = response.code
        @http_status = "#{response.class}: #{response.message}"
        @redirect_url = response.to_hash['location']
        @hsts = response.to_hash['strict-transport-security']
        @digest = Digest::SHA256.hexdigest response.body
      end
    rescue => exception
      @notes = "[#{current_time_from_proper_timezone}, #{self.to_url}] Exception: #{exception.message}"
      puts @notes
    end

    begin
      self.http_status_code = @http_status_code
      self.http_status = @http_status
      self.redirect_url = @redirect_url
      self.is_hsts = ! @hsts.nil?
      self.hsts_max_age = parse_hsts(@hsts)
      self.checked_at = current_time_from_proper_timezone

      unless @http_status_code.nil?
        self.last_live_at = current_time_from_proper_timezone
        self.is_live = true
      else
        if self.is_live == true
          self.notes.push("[#{current_time_from_proper_timezone}] Website died!")
          self.is_live = false
        end
      end

      unless self.digest == @digest
        self.digest = @digest
        self.notes.push("[#{current_time_from_proper_timezone}] Digest change: #{@digest}")
      end

      unless @notes.nil?
        self.notes.push(@notes)
      end

      self.save
    rescue => exception
      puts "[#{current_time_from_proper_timezone}, #{self.to_url}] Exception: #{exception}"
    end
  end

  def to_url
    url = ""

    url += self.is_https ? "https://" : "http://"
    url += self.is_www ? "www." : ""
    
    url += self.domain.domain_name

    return url
  end

  def parse_hsts(hsts)
    unless hsts.nil?
      parse = hsts[0].match(/max-age=([0-9]*)/)
      unless parse.nil?
        return parse[1].to_i
      else
        return nil
      end
    else
      return nil
    end
  end
end
