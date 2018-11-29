require "rails_helper"

RSpec.describe ApplicationMailer do
  let(:change_report) do
    create(:change_report_with_letter, :job_termination)
  end

  before { change_report.member.update first_name: "Joe", last_name: "MacMillan" }

  describe ".office_change_report_submission" do
    it "sets the correct headers" do
      with_modified_env SENDING_EMAIL_ADDRESS: "hello@example.com" do
        email = ApplicationMailer.office_change_report_submission(change_report)

        from_header = email.header.select do |header|
          header.name == "From"
        end.first.value

        expect(from_header).to eq %("ReportChangesColorado" <hello@example.com>)
        expect(email.from).to eq(["hello@example.com"])
        expect(email.subject).to eq("A new change report from Joe MacMillan was submitted!")
      end
    end

    it "sets recipient email from credentials" do
      email = ApplicationMailer.office_change_report_submission(change_report)

      expect(email.to).to eq(["county@example.com"])
    end

    it "attaches the change report PDF with correct name" do
      time = Time.utc(1999, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        pdf = "pdf contents"
        builder = instance_double(ChangeReportPdfBuilder, run: pdf)
        allow(ChangeReportPdfBuilder).to receive(:new).with(an_instance_of(ChangeReportDecorator)).and_return(builder)
        email = ApplicationMailer.office_change_report_submission(change_report)

        expect(email.attachments.count).to eq(1)
        expect(email.attachments.first.read).to eq(pdf)
        expect(email.attachments.first.filename).to eq("1999-01-01_Joe_MacMillan_Change_Report.pdf")
      end
    end
  end
end
