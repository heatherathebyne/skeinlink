require 'csv'

task export_as_csv: [:environment] do
  db_export = CSV do |csv|
    csv << ['company', 'name', 'skein_gram_weight', 'skein_yards', 'weight', 'description', 'referral_link', 'referral_partner']
    YarnProduct.includes(:yarn_company).all.each do |yp|
      csv << [
        yp.yarn_company.name,
        yp.name,
        yp.skein_gram_weight,
        yp.skein_yards,
        yp.common_weight,
        yp.description,
        yp.referral_link,
        yp.referral_partner
      ]
    end
  end
end
