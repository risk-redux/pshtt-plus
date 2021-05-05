class StaticController < ApplicationController
  def index

    @data = {}

    @data[:domain_data] = [
      { label: "Live", value: Domain.where(is_live: true).count },
      { label: "Dead", value: Domain.where(is_live: false).count }
    ]

    @data[:website_data] = [
      { label: "Live", value: Website.where(is_live: true).count },
      { label: "Dead", value: Website.where(is_live: false).count }
    ]

    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@data.as_json) }
    end
  end

  def about
  end

  def sunburst
    domain_names = Domain.select(:domain_name).map{ |domain| domain.domain_name }
    split_and_reversed_domain_names = domain_names.map{ |domain_name| domain_name.split('.').reverse }

    @data = arrayify(hash_domain_names(split_and_reversed_domain_names))
    
    respond_to do |format|
      format.json { render json: JSON.pretty_generate(@data) }
    end
  end

  private

  def hash_domain_names(domain_names)
    domain_names.each.with_object({}) do |keys, hashes|
      target = hashes
      keys.map { |key| target = target[key] ||= {} }
    end
  end

  def arrayify(hashed_domain_names)
    list = []

    hashed_domain_names.keys.each do |key|
      unless hashed_domain_names[key].empty?
        list.push( { label: key, children: arrayify(hashed_domain_names[key]) } )
      else
        list.push( { label: key, value: 1 } )
      end
    end

    return list
  end
end
