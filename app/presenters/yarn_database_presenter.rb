class YarnDatabasePresenter
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def self.page_title
    'Yarn Database'
  end

  def self.sidebar
    new.sidebar
  end

  def self.card_title(yarn_product)
    new.card_title(yarn_product)
  end

  def self.card_description(_)
    nil
  end

  def self.sorting_options_partial
    'yarn_database/sorting_options'
  end

  def sidebar
    link_to 'Add Yarn to Database', new_yarn_product_path, class: 'list-group-item'
  end

  def card_title(yarn_product)
    link_to yarn_product.name, yarn_product, class: 'stretched-link'
  end
end
