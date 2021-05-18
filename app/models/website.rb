class Website < ApplicationRecord
  belongs_to :domain
  after_create :bootstrap

  serialize :notes
  serialize :report_card

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
    @certificate

    begin
      uri = URI(self.to_url)

      Net::HTTP.start(uri.host, uri.port, { read_timeout: 5, open_timeout: 5, use_ssl: self.is_https }) do |http|
        response = http.get(uri)

        @http_status_code = response.code
        @http_status = "#{response.class}: #{response.message}"
        @redirect_url = response.to_hash['location']
        @hsts = response.to_hash['strict-transport-security']
        @digest = Digest::SHA256.hexdigest response.body

        if self.is_https
          @certificate = OpenSSL::X509::Certificate.new(http.peer_cert.to_s)
        end
      end
    rescue => exception
      @notes = "[#{current_time_from_proper_timezone}, #{self.to_url}] Exception: #{exception.message}"
      puts @notes
    end

    begin
      self.http_status_code = @http_status_code
      self.http_status = @http_status
      self.redirect_url = parse_redirect_url(@redirect_url)
      self.is_hsts = ! @hsts.nil?
      self.hsts_max_age = parse_hsts(@hsts)
      self.checked_at = current_time_from_proper_timezone
      
      self.certificate = @certificate.to_s

      self.not_before = @certificate.not_before
      self.not_after = @certificate.not_after
      self.issuer = @certificate.issuer.to_s
      self.subject = @certificate.subject.to_s

      unless @http_status_code.nil?
        self.last_live_at = current_time_from_proper_timezone
        self.report_card = grade_website
        self.is_live = true
      else
        if self.is_live || self.is_live.nil?
          self.notes.push("[#{current_time_from_proper_timezone}] Website died!")
          self.report_card = nil
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

  def is_behaving?
    unless self.report_card.nil?
      grades = self.report_card.map { |grade| grade[:behaving] }
      
      return !(grades.include? "warning")
    else
      return true
    end
  end

  def grade_website
    if self.is_https
      return self.grade_https
    else
      return self.grade_http
    end
  end

  private
  
  def grade_https
    report_card = Set.new
    
    report_card << grade_hsts
    report_card << grade_downgrade_redirections
    
    return report_card
  end

  def grade_http
    report_card = Set.new

    if self.http_status_code < 400 && self.http_status_code >= 300
      if self.is_www
        if self.redirect_url.match("https://www." + self.domain.domain_name).nil?
          report_card << { behaving: "warning", message: "HTTP websites should only ever redirect to their HTTPS counterparts." }
        else
          report_card << { behaving: "success", message: "HTTP website appropriately redirects to an HTTPS location within the same domain!" }
        end
      else
        if self.redirect_url.match("https://" + self.domain.domain_name).nil?
          report_card << { behaving: "warning", message: "HTTP websites should only ever redirect to their HTTPS counterparts." }
        else
          report_card << { behaving: "success", message: "HTTP website appropriately redirects to an HTTPS location within the same domain!" }
        end
      end
    else
      report_card << { behaving: "warning", message: "HTTP websites should only ever redirect to their HTTPS counterparts." }
    end

    return report_card
  end

  def grade_downgrade_redirections
    unless self.redirect_url.nil?
      unless self.redirect_url.match("https://").nil?
        return { behaving: "success", message: "HTTPS website redirects appropriately to other HTTPS locations!"}
      else
        return { behaving: "warning", message: "HTTPS websites must not downgrade with redirection to HTTP locations."}
      end
    else
      return { behaving: "info", message: "HTTPS website is a terminal (i.e., does not redirect)."}
    end
  end

  def grade_hsts
    if self.is_hsts && (self.hsts_max_age >= 31536000)
      return { behaving: "success", message: "Strict-Transport-Security is appropriately configured with a max-age of at least 31536000 seconds!"}
    else
      return { behaving: "warning", message: "Strict-Transport-Security is not configured with a max-age of at least 31536000 seconds."}
    end
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

  def parse_redirect_url(redirect_url)
    unless redirect_url.nil? || redirect_url.empty?
      return redirect_url[0]
    else
      return nil
    end
  end
end
