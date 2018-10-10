require "rails_helper"

RSpec.describe DoYouHaveALetterController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { has_letter: "yes" }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller shows when job termination"
end
