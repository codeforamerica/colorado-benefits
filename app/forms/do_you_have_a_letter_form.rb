class DoYouHaveALetterForm < Form
  set_attributes_for :navigator, :has_documents

  validates_presence_of :has_documents, message: "Please answer this question."

  def save
    change_report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(change_report)
    HashWithIndifferentAccess.new(change_report.navigator.attributes)
  end
end
