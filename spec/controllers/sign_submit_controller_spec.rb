require "rails_helper"

RSpec.describe SignSubmitController do
  valid_params = { signature: "Best E. Person" }

  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", valid_params
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"

  let(:report) { create :report, :filled, signature: "Best E. Person" }
  before { session[:current_report_id] = report.id }

  describe "edit" do
    it "assigns existing attributes" do
      get :edit

      form = assigns(:form)

      expect(form.signature).to eq("Best E. Person")
    end
  end

  describe "#update" do
    context "on success" do
      context "when RAILS_ENV is demo" do
        before do
          allow(Rails).to receive(:env) { "demo".inquiry }
        end

        after do
          allow(Rails).to receive(:env).and_call_original
        end

        it "does not enqueue a pdf mailer job" do
          allow(EmailChangeReportToOfficeJob).to receive(:perform_later)

          put :update, params: { form: valid_params }

          expect(EmailChangeReportToOfficeJob).to_not have_received(:perform_later)
        end

        it "does not enqueue a confirmation text job" do
          allow(TextConfirmationToClientJob).to receive(:perform_later)

          put :update, params: { form: valid_params }

          expect(TextConfirmationToClientJob).to_not have_received(:perform_later)
        end
      end

      it "enqueues a pdf mailer job" do
        allow(EmailChangeReportToOfficeJob).to receive(:perform_later)

        put :update, params: { form: valid_params }

        expect(EmailChangeReportToOfficeJob).to have_received(:perform_later).with(report: report)
      end

      context "when the client has consented to SMS" do
        it "enqueues a confirmation text job" do
          create :member, report: report, is_submitter: true, phone_number: "1113334444"
          report.metadata.update consent_to_sms: "yes"
          allow(TextConfirmationToClientJob).to receive(:perform_later)

          put :update, params: { form: valid_params }

          expect(TextConfirmationToClientJob).to have_received(:perform_later).
            with(phone_number: "1113334444")
        end
      end

      context "when the client has not consented to SMS" do
        it "does not enqueue a confirmation text job" do
          create :member, report: report, is_submitter: true, phone_number: "1113334444"
          report.metadata.update consent_to_sms: "no"
          allow(TextConfirmationToClientJob).to receive(:perform_later)

          put :update, params: { form: valid_params }

          expect(TextConfirmationToClientJob).to_not have_received(:perform_later)
        end
      end

      context "when the client wants an emailed copy of the report" do
        it "enqueues a email report copy job" do
          report.metadata.update email: "fake@example.com"
          allow(EmailReportCopyToClientJob).to receive(:perform_later)

          put :update, params: { form: valid_params }

          expect(EmailReportCopyToClientJob).to have_received(:perform_later).
            with(report: report)
        end
      end

      context "when the client does not want an emailed copy of the report" do
        it "does not enqueue a email report copy job" do
          report.metadata.update email: nil
          allow(EmailReportCopyToClientJob).to receive(:perform_later)

          put :update, params: { form: valid_params }

          expect(EmailReportCopyToClientJob).to_not have_received(:perform_later)
        end
      end
    end
  end
end
