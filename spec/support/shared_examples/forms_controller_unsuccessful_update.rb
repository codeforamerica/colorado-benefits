require "rails_helper"

RSpec.shared_examples_for "form controller unsuccessful update" do |invalid_params|
  describe "#update" do
    context "on unsucessful update" do
      let(:mock_mixpanel_service) { spy(MixpanelService) }
      let(:fake_analytics_data) { { foo: "bar" } }
      let(:current_report) { create :report, :filled }

      before do
        session[:current_report_id] = current_report.id
        allow(MixpanelService).to receive(:instance).and_return(mock_mixpanel_service)
        allow(AnalyticsData).to receive(:new).with(current_report) { fake_analytics_data }

        put :update, params: { form: invalid_params || {} }
      end

      it "sends a mixpanel event with the validation error" do
        data = {
          screen: controller.form_class.analytics_event_name,
          errors: assigns(:form).errors.messages.keys,
        }.merge(fake_analytics_data)

        expect(mock_mixpanel_service).to have_received(:run).with(
          unique_id: current_report.id,
          event_name: "validation_error",
          data: data,
        )
      end

      it "rerenders edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
