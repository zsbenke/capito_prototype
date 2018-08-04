class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  private

  def record_notice(record, action: nil)
    t("#{dom_class(record)}.notices.#{action}")
  end
end
