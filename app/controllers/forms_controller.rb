class FormsController < ApplicationController
  layout "form"

  before_action :ensure_change_report_present, only: %i[edit update]

  def edit
    attribute_keys = Attributes.new(form_attrs).to_sym
    @form = form_class.new(existing_attributes.slice(*attribute_keys))
  end

  def update
    assign_attributes_to_form
    if @form.valid?
      update_models
      redirect_to(next_path)
    else
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

  def self.show?(change_report)
    show_rule_sets(change_report).all?
  end

  def current_change_report
    ChangeReport.find_by(id: session[:current_change_report_id])
  end

  private

  delegate :form_class, to: :class

  # Override in subclasses

  def existing_attributes
    {}
  end

  def assign_attributes_to_form
    @form = form_class.new(form_params)
  end

  def update_models; end

  # Don't override in subclasses

  def ensure_change_report_present
    if current_change_report.blank?
      redirect_to root_path
    end
  end

  def form_attrs
    form_class.attribute_names
  end

  def form_params
    params.fetch(:form, {}).permit(*form_attrs)
  end

  def form_navigation
    @form_navigation ||= FormNavigation.new(self)
  end

  def params_for(model)
    attrs = form_class.attributes_for(model)
    form_params.slice(*Attributes.new(attrs).to_s)
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