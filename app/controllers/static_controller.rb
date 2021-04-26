class StaticController < ApplicationController
  def index
    @domains = Domain.all
    @websites = Website.all

    @domain_coverage = @domains.where.not(checked_at: nil).count.to_f / @domains.count
    @website_coverage = @websites.where.not(checked_at: nil).count.to_f / @websites.count
  end

  def about
  end
end
