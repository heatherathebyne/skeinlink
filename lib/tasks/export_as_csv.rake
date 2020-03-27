require 'csv'

task export_as_csv: [:environment] do
  db_export = CSV do |csv|
    csv << ['company', 'name', 'skein_gram_weight', 'skein_yards', 'weight', 'description']
    YarnProduct.includes(:yarn_company).all.each do |yp|
      csv << [
        yp.yarn_company.name,
        yp.name,
        yp.skein_gram_weight,
        yp.skein_yards,
        yp.common_weight,
        yp.description
      ]
    end
  end
end
