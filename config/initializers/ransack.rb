Ransack.configure do |config|
    config.add_predicate 'updated_before',
                         arel_predicate: 'lt',
                         formatter: proc { |v| v.to_date },
                         validator: proc { |v| v.present? },
                         type: :date
  end
  