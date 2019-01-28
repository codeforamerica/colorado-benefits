class AddChangeInHoursDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_change_in_hours_documents_yes? && report.change_in_hours_change.documents.empty?)
  end
end
