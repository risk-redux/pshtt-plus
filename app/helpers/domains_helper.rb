module DomainsHelper
  def notes_list(domain)
    render("domains/shared/notes_list", domain: domain)
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
end
