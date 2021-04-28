module DomainsHelper
  def notes_list(notes, limit = nil)
    render("domains/shared/notes_list", notes: notes, limit: limit)
  end

  def websites_section(domain)
    websites = domain.websites

    render("domains/shared/websites_section", domain:domain, websites: websites)
  end

  def meta_data_form(domain)
    render("domains/shared/meta_data_form", domain: domain)
  end

  def dns_form(domain)
    render("domains/shared/dns_form", domain: domain)
  end

  def website_report_card(website)
    if website.is_https
      render("domains/shared/https_website_report_card", website: website, report_card: website.is_behaving?)
    else
      render("domains/shared/http_website_report_card", website: website, report_card: website.is_behaving?)
    end
  end

  def report_card_icon(behaving)
    case behaving
    when "success"
      return "fa-check-circle"
    when "warning"
      return "fa-times-circle"
    when "danger"
      return "fa-exclamation-circle"
    when "info"
      return "fa-info-circle"
    else
      return "fa-coffee"
    end
  end
end
