require "rails_helper"

RSpec.shared_examples_for "add documents form" do |change_type|
  describe "#save" do
    let(:report) { create :report, :with_change, change_type: change_type }
    let(:active_storage_blob) do
      ActiveStorage::Blob.create_after_upload!(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
    end

    let(:valid_params) do
      {
        letters: ["", active_storage_blob.signed_id],
      }
    end

    it "persists the values to the correct models excluding any empty values" do
      form = described_class.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.reported_changes.last.documents.count).to eq 1
    end

    it "ignores values that are already present" do
      report.reported_changes.last.documents.attach(active_storage_blob)
      valid_params[:letters] = [report.reported_changes.last.documents.first.signed_id]

      form = described_class.new(report, valid_params)
      form.valid?

      expect do
        form.save
      end.to_not(change { report.reported_changes.last.documents.count })
    end

    it "removes values that are not included anymore" do
      report.reported_changes.last.documents.attach(active_storage_blob)
      valid_params[:letters] = []

      form = described_class.new(report, valid_params)
      form.valid?

      expect do
        form.save
      end.to(change { report.reported_changes.last.documents.count }.from(1).to(0))
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create(:report, :with_navigator, :with_change, change_type: change_type)
      report.reported_changes.last.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )

      form = described_class.from_report(report)

      expect(form.letters.count).to eq 1
      expect(form.letters.first.filename).to eq "image.jpg"
    end
  end
end
