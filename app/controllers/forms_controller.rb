class FormsController < ApplicationController
  before_action :ensure_report_present, only: %i[edit update]

  helper_method :current_report, :current_percentage, :self_or_other_member_translation_key

  layout "left_aligned"

  def index
    render layout: "application"
  end

  def edit
    @form = form_class.from_report(current_report)
  end

  def update
    @form = form_class.new(current_report, form_params)
    if @form.valid?
      @form.save
      update_session
      send_mixpanel_event
      redirect_to(next_path)
    else
      send_mixpanel_validation_errors
      render :edit
    end
  end

  def current_path(params = nil)
    screen_path(self.class.to_param, params)
  end

  def next_path(params = {})
    next_step = form_navigation.next
    if next_step
      screen_path(next_step.to_param, params)
    end
  end

  def self.show?(report)
    show_rule_sets(report).all?
  end

  def current_report
    Report.find_by(id: session[:current_report_id])
  end

  def current_percentage
    index_of_screens = form_navigation.form_controllers.index(self.class)
    if index_of_screens
      (100 / form_navigation.form_controllers.length) * index_of_screens
    end
  end

  def self_or_other_member_translation_key(key)
    current_report.navigator.submitting_for_other_member? ? "#{key}.other_member" : "#{key}.self"
  end

  private

  delegate :form_class, to: :class

  # Override in subclasses

  def update_session; end

  def form_params
    params.fetch(:form, {}).permit(*form_class.attribute_names)
  end

  # Don't override in subclasses

  def ensure_report_present
    if current_report.blank?
      redirect_to root_path
    end
  end

  def form_navigation
    @form_navigation ||= FormNavigation.new(self)
  end

  def send_mixpanel_event
    MixpanelService.instance.run(
      unique_id: current_report.id,
      event_name: @form.class.analytics_event_name,
      data: AnalyticsData.new(current_report).to_h,
    )
  end

  def send_mixpanel_validation_errors
    data = {
      screen: @form.class.analytics_event_name,
      errors: @form.errors.messages.keys,
    }

    if current_report.present?
      data.merge!(AnalyticsData.new(current_report).to_h)
    end

    MixpanelService.instance.run(
      unique_id: current_report.try(:id),
      event_name: "validation_error",
      data: data,
    )
  end

  class << self
    def to_param
      controller_name.dasherize
    end

    def form_class
      (controller_name + "_form").classify.constantize
    end

    def show_rule_sets(_)
      [ShowRules.defaults_to_true]
    end
  end
end
