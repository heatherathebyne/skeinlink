class StashYarnPresenter
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def self.page_title
    'My Stash'
  end

  def self.sidebar
    new.sidebar
  end

  def self.card_title(stash_yarn)
    new.card_title(stash_yarn)
  end

  def self.card_description(stash_yarn)
    new.card_description(stash_yarn)
  end

  def self.sorting_options_partial
    'stash_yarns/sorting_options'
  end

  def sidebar
    link_to 'Add to My Stash', new_stash_yarn_path, class: 'list-group-item'
  end

  def card_title(stash_yarn)
    link_to stash_yarn.name, stash_yarn, class: 'stretched-link'
  end

  def card_description(stash_yarn)
    desc = ''
    desc << "#{stash_yarn.colorway_name}, " if stash_yarn.colorway_name
    desc << "#{pluralize stash_yarn.skein_quantity, 'skein'}"
    desc << " / #{stash_yarn.total_yardage} total yards" if stash_yarn.total_yardage
    desc
  end
end
