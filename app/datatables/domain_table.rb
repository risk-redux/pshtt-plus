class DomainTable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    { 
      draw: params[:draw].to_i,
      recordsTotal: Domain.count,
      recordsFiltered: domains.total_entries,
      tableData: data
    }
  end  

  private

  def data
    domains.map do |domain|
      {
        domain_name: link_to(domain.domain_name, domain),
        published: domain.is_live,
        live_websites: domain.websites.where(is_live: true).count,
        is_behaving: domain.is_behaving?,
        checked_at: domain.checked_at,
        DT_RowAttr: { "data-link": "/domains/#{domain.id}" }
      }
    end
  end

  def domains
    @domains ||= fetch_domains
  end

  def fetch_domains
    fetched_domains = Domain.all

    if params[:search].present?
      if params[:search][:value].present?
        fetched_domains = fetched_domains.where("domain_name like :search", search: "%#{params[:search][:value]}%")
      end
    end

    fetched_domains = fetched_domains.page(page).per_page(per_page)

    return fetched_domains
  end

  def page
    return params[:start].to_i / per_page + 1
  end

  def per_page
    return params[:length].to_i > 0 ? params[:length].to_i : 10
  end
end