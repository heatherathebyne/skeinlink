module YarnWeight
  include ActiveSupport::Concern

  # Starting at 10 to explicitly separate id from Craft Yarn Council weight
  YARN_WEIGHTS = {
    10 => { name: 'Lace', craft_yarn_council_weight: 0 },
    11 => { name: 'Light Fingering', craft_yarn_council_weight: 0 },
    12 => { name: 'Fingering', craft_yarn_council_weight: 1 },
    13 => { name: 'Sport', craft_yarn_council_weight: 2 },
    14 => { name: 'DK', craft_yarn_council_weight: 3 },
    15 => { name: 'Worsted', craft_yarn_council_weight: 4 },
    16 => { name: 'Aran', craft_yarn_council_weight: 4 },
    17 => { name: 'Bulky', craft_yarn_council_weight: 5 },
    18 => { name: 'Super Bulky', craft_yarn_council_weight: 6 },
    19 => { name: 'Jumbo', craft_yarn_council_weight: 7 },
    20 => { name: 'Thread', craft_yarn_council_weight: 0 }
  }.freeze

  def common_weight
    YARN_WEIGHTS[weight_id][:name] if weight_id
  end

  def common_weight_select_options
    weights = YARN_WEIGHTS.map do |id, hsh|
      [hsh[:name], id]
    end
  end
end
