require_relative "../summarizer/application_summary"

namespace :summarizer do
  desc "Posts an update about the last day's app activity"
  task :post_update, [:channel] => [:environment] do |_, args|
    text = Summarizer::ApplicationSummary.new(
      DateTime.now - 1.day,
        "America/Denver", # Timezone for Denver
    ).daily_summary
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: args[:channel], text: text, as_user: true)
  end
end
