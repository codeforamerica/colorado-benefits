class TellUsAboutChangeInHoursJobForm < Form
  set_attributes_for :report,
                     :company_name, :manager_name, :manager_phone_number

  before_validation -> { strip_dashes(:manager_phone_number) }

  validates_presence_of :company_name, message: "Please add a name."
  validates :manager_phone_number, ten_digit_phone_number: true, allow_blank: true

  def save
    report.update(attributes_for(:report))
  end
end
