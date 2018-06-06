module FoodMenus
  class Unit < ::ApplicationBase
    KINDS = ['Quantity', 'Measurement', 'Volume', 'Weight']

    validates_presence_of :name, :abbreviation, :kind, :conversion_rate
    validates :conversion_rate, numericality: { greater_than: 0 }
    validates_uniqueness_of :name, :abbreviation

    default_scope { order(:kind, :conversion_rate) }

    def to_s
      "#{self.name} (#{self.abbreviation})"
    end

    def other_available_units
      Unit.where(kind: self.kind).where('id <> ?', self.id).order(:conversion_rate)
    end
  end
end