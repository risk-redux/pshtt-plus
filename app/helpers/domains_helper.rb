module DomainsHelper
  def notes_list(notes, limit = nil)
    render("domains/shared/notes_list", notes: notes, limit: limit)
  end

  def dns_section(domain)
    render("domains/shared/dns_section", domain: domain)
  end

  def websites_section(domain)
    websites = domain.websites
    live_websites = websites.where(is_live: true)

    render("domains/shared/websites_section", domain:domain, live_websites: live_websites)
  end

  def meta_data_form(domain)
    render("domains/shared/meta_data_form", domain: domain)
  end

  def dns_report_card(domain)
    render("domains/shared/dns_report_card", domain: domain, report_card: domain.report_card)
  end

  def website_report_card(website)
    if website.is_https
      render("domains/shared/https_website_report_card", website: website, report_card: website.report_card)
    else
      render("domains/shared/http_website_report_card", website: website, report_card: website.report_card)
    end
  end

  def tool_kit_form(domain)
    render("domains/shared/tool_kit_form", domain: domain)
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
