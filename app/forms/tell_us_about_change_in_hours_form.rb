class TellUsAboutChangeInHoursForm < Form
  set_attributes_for :change,
                     :hourly_wage, :lower_hours_a_week_amount, :upper_hours_a_week_amount, :paid_how_often,
                     :change_date_day, :change_date_month, :change_date_year, :change_in_hours_notes

  validates_presence_of :hourly_wage, message: "Please add a number."
  validates_presence_of :paid_how_often, message: "Please add an answer"
  validates_presence_of :lower_hours_a_week_amount, message: "Please add an amount."
  validates :change_date, date: true

  attr_internal_reader :change_date

  def save
    attributes = attributes_for(:change)
    attributes[:change_date] = to_datetime(change_date_year, change_date_month, change_date_day)

    report.current_change.update(attributes.except(:change_date_day, :change_date_month, :change_date_year))
  end

  def self.existing_attributes(report)
    attributes = report.current_change.attributes
    %i[year month day].each do |sym|
      attributes["change_date_#{sym}"] = report.current_change.change_date.try(sym)
    end
    HashWithIndifferentAccess.new(attributes)
  end
end
