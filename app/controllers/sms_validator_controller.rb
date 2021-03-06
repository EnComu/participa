class SmsValidatorController < ApplicationController
  before_action :authenticate_user!
  before_action :can_change_phone, except: [:step1, :documents]

  def step1
    authorize! :step1, :sms_validator

    if current_user.uploads.any?
      redirect_to sms_validator_step2_path
    end
  end

  def step2
    authorize! :step2, :sms_validator
    @user = current_user
  end

  def step3
    authorize! :step3, :sms_validator
    if current_user.unconfirmed_phone.nil? || current_user.sms_confirmation_token.nil?
      redirect_to sms_validator_step2_path
      return
    end
    @user = current_user
    render action: "step3"
  end

  def phone
    authorize! :phone, :sms_validator

    phone = begin
              current_user.phone_normalize(phone_params[:unconfirmed_phone])
            rescue
              phone_params[:unconfirmed_phone]
            end

    current_user.unconfirmed_phone = phone

    if current_user.save
      current_user.set_sms_token!
      current_user.send_sms_token!
      redirect_to sms_validator_step3_path
    else
      render action: "step2"
    end
  end

  def documents
    authorize! :documents, :sms_validator

    event = OnlineVerifications::Upload.new(upload_params)

    if event.save
      if current_user.confirmed_by_sms?
        redirect_back fallback_location: root_path,
                      notice: t('sms_validator.documents.updated')
      else
        redirect_to sms_validator_step2_path
      end
    else
      flash.now[:error] = t('sms_validator.documents.invalid')
      render action: "step1"
    end
  end

  def valid
    authorize! :valid, :sms_validator
    # if current_user.check_sms_token(params[:sms_token][:sms_user_token])
    if current_user.check_sms_token(sms_token_params[:sms_user_token_given])
      flash[:notice] = t('sms_validator.phone.valid')

      if current_user.apply_previous_user_vote_location
        flash[:alert] = t('registration.message.existing_user_location')
      end
      redirect_to authenticated_root_path
    else
      flash.now[:error] = t('sms_validator.phone.invalid')
      render action: "step3"
    end
  end

  private

  def upload_params
    params
      .require(:online_verifications_upload)
      .permit(documents_attributes: [:scanned_picture])
      .merge(verified_id: current_user.id)
  end

  def phone_params
    params.require(:user).permit(:unconfirmed_phone)
  end

  def sms_token_params
    params.require(:user).permit(:sms_user_token_given)
  end

  def can_change_phone
    unless current_user.unconfirmed_by_sms? || current_user.can_change_phone?
      msg = "Ya has confirmado tu número en los últimos meses."

      raise CanCan::AccessDenied.new(msg, params[:action], :sms_validator)
    end
  end
end
