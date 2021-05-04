class Domain < ApplicationRecord
  validates :domain_name, presence: true
  has_many :websites
  after_create :bootstrap

  serialize :a_record
  serialize :aaaa_record
  serialize :cname_record
  serialize :notes

  def bootstrap
    begin
      self.notes = ["[#{current_time_from_proper_timezone}] Domain created!"]
      self.save

      # The 4 "Endpoints"
      self.websites.create(is_https: false, is_www: false)
      self.websites.create(is_https: false, is_www: true)
      self.websites.create(is_https: true, is_www: false)
      self.websites.create(is_https: true, is_www: true)
    rescue => exception
      puts "[#{current_time_from_proper_timezone}] Exception: #{exception}"
    end
  end

  def check_websites
    begin
      self.websites.each do |website|
        website.check_website
      end
    rescue => exception
      puts "[#{current_time_from_proper_timezone}, #{self.domain_name}] Exception: #{exception}"
    end
  end

  def check_dns
    puts "Checking DNS for #{self.domain_name}"

    @a_record
    @aaaa_record
    @cname_record
    @notes

    begin
      Resolv::DNS.open() do |query|
        query.timeouts = 1 # Quick resolution or bust!
        
        @a_record = parse_a_record(query)
        @aaaa_record = parse_aaaa_record(query)
        @cname_record = parse_cname_record(query)
      end
    rescue => exception
      @notes = "[#{current_time_from_proper_timezone}, #{self.domain_name}] exception: #{exception}"
      puts @notes
    end

    begin
      self.a_record = @a_record
      self.aaaa_record = @aaaa_record
      self.cname_record = @cname_record
      self.checked_at = current_time_from_proper_timezone
      
      unless @notes.nil?
        self.notes.push(@notes)
      end

      unless @a_record.empty? && @aaaa_record.empty? && @cname_record.empty?
        self.last_live_at = current_time_from_proper_timezone
        self.is_live = true
      else
        self.notes.push("[#{current_time_from_proper_timezone}] Domain died!")
        self.is_live = false
      end

      self.save
    rescue => exception
      puts "[#{current_time_from_proper_timezone}, #{self.domain_name}] exception: #{exception}"
    end
  end

  def base_domain
    domain_pattern = /(.*\.)*(.*\.gov)/
    
    return self.domain_name.match(domain_pattern)[2]
  end

  def decommission_score
    return rand(11)
  end

  def pshtt_status
  end

  def trusty_mail_status
  end

  def is_behaving?
    grades = []
    live_websites = self.websites.where(is_live: true)

    unless live_websites.empty?
      live_websites.each do |website|
        grades.push website.is_behaving?
      end

      # If any websites are misbehaving, fail the domain.
      return !(grades.include? false)
    else
      return false
    end
  end

  private

  def parse_a_record(query)
    records = Set.new

    tld = query.getresources(self.domain_name, Resolv::DNS::Resource::IN::A).map { |r| r.address.to_s }
    www = query.getresources("www." + self.domain_name, Resolv::DNS::Resource::IN::A).map { |r| r.address.to_s }

    tld.each do |record|
      records << record
    end

    www.each do |record|
      records << record + " [www]"
    end

    return records
  end

  def parse_aaaa_record(query)
    records = Set.new

    begin
      tld = query.getresources(self.domain_name, Resolv::DNS::Resource::IN::AAAA).map { |r| r.address.to_s }
      www = query.getresources("www." + self.domain_name, Resolv::DNS::Resource::IN::AAAA).map { |r| r.address.to_s }
    rescue => exception
      @notes = "[#{current_time_from_proper_timezone}, #{self.domain_name}] exception: #{exception}"
      puts @notes
    end

    tld.each do |record|
      records << record
    end

    www.each do |record|
      records << record + " [www]"
    end

    return records
  end

  def parse_cname_record(query)
    records = Set.new

    tld = query.getresources(self.domain_name, Resolv::DNS::Resource::IN::CNAME).map { |r| r.name.to_s }
    www = query.getresources("www." + self.domain_name, Resolv::DNS::Resource::IN::CNAME).map { |r| r.name.to_s }

    tld.each do |record|
      records << record
    end

    www.each do |record|
      records << record + "[www]"
    end

    return records
  end
end
