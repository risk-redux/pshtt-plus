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
      self.websites.create(protocol: "http", is_www: false)
      self.websites.create(protocol: "http", is_www: true)
      self.websites.create(protocol: "https", is_www: false)
      self.websites.create(protocol: "https", is_www: true)
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
        @a_record = query.getresources(self.domain_name, Resolv::DNS::Resource::IN::A).map { |r| r.address.to_s }
        @aaaa_record = query.getresources(self.domain_name, Resolv::DNS::Resource::IN::AAAA).map { |r| r.address.to_s }
        @cname_record = query.getresources(self.domain_name, Resolv::DNS::Resource::IN::CNAME).map { |r| r.name.to_s }
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

      unless @a_record.nil? && @aaaa_record.nil? && @cname_record.nil?
        self.last_live_at = current_time_from_proper_timezone
      else
        self.notes.push("[#{current_time_from_proper_timezone}] Domain died!")
      end

      self.save
    rescue => exception
      puts "[#{current_time_from_proper_timezone}, #{self.domain_name}] exception: #{exception}"
    end
  end
end
