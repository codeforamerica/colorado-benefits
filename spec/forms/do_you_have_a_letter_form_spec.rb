 require "rails_helper"

 RSpec.describe DoYouHaveALetterForm do
   describe "validations" do
     context "when has_termination_letter is provided" do
       it "is valid" do
         form = DoYouHaveALetterForm.new(nil, has_termination_letter: "yes")

         expect(form).to be_valid
       end
     end

     context "when has_termination_letter is not provided" do
       it "is invalid" do
         form = DoYouHaveALetterForm.new(nil, has_termination_letter: nil)

         expect(form).not_to be_valid
         expect(form.errors[:has_termination_letter]).to be_present
       end
     end
   end

   describe "#save" do
     let(:change_report) { create :change_report, :with_navigator }

     let(:valid_params) do
       {
         has_termination_letter: "yes",
       }
     end

     it "persists the values to the correct models" do
       form = DoYouHaveALetterForm.new(change_report, valid_params)
       form.valid?
       form.save

       change_report.reload

       expect(change_report.navigator.has_termination_letter_yes?).to be_truthy
     end
   end

   describe ".from_change_report" do
     it "assigns values from change report navigator" do
       change_report = create(:change_report, navigator: build(:change_report_navigator, has_termination_letter: "yes"))

       form = DoYouHaveALetterForm.from_change_report(change_report)

       expect(form.has_termination_letter).to eq("yes")
     end
   end
 end
