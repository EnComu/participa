class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  prepend_before_filter :load_user_location

  def load_user_location
    @user_location = User.get_location(current_user, params)
  end

  def regions_provinces
    # Dropdownw for AJAX on registrations edit/new
    #
    render \
      partial: 'subregion_select',
      locals: {
        catalonia_resident: @user_location[:catalonia_resident],
        country: @user_location[:country],
        province: @user_location[:province],
        disabled: false,
        required: true,
        field: :province,
        title: "Provincia",
        options_filter: ((!current_user or current_user.can_change_vote_location?) ? User.blocked_provinces : nil)
      }
  end

  def regions_municipies
    # Dropdownw for AJAX on registrations edit/new
    #
    render \
      partial: 'municipies_select',
      locals: {
        country: @user_location[:country],
        province: @user_location[:province],
        town: @user_location[:town],
        disabled: false,
        required: true,
        field: :town,
        title: "Municipio"
      }
  end

  def vote_municipies
    # Dropdownw for AJAX on registrations edit/new
    #
    render \
      partial: 'municipies_select',
      locals: {
        country: "ES",
        province: @user_location[:vote_province],
        town: @user_location[:vote_town],
        disabled: false,
        required: false,
        field: :vote_town,
        title: "Municipio de participación"
      }
  end

  def new
    if Rails.application.secrets.features["allow_inscription"]
      super
    else
      redirect_to root_path, flash: { notice: 'Registrations are not open.' }
    end
  end

  def create
    build_resource(sign_up_params)
    if resource.is_captcha_valid?
      super do
        result, status = user_already_exists? resource, :document_vatid
        if status and result.errors.empty?
          UsersMailer.remember_email(:document_vatid, result.document_vatid).deliver_now
          redirect_to(root_path, notice: t("devise.registrations.signed_up_but_unconfirmed"))
          return
        end

        result, status = user_already_exists? resource, :email
        if status and result.errors.empty?
          UsersMailer.remember_email(:email, result.email).deliver_now
          redirect_to(root_path, notice: t("devise.registrations.signed_up_but_unconfirmed"))
          return
        end

        # If the user already had a location but deleted itslet, he should have
        # his previous location
        #
        if resource.apply_previous_user_vote_location
          flash[:alert] = t("podemos.registration.message.existing_user_location")
        end
      end
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  def recover_and_logout
    # Allow user to reset their password from his profile
    #
    current_user.send_reset_password_instructions
    sign_out_and_redirect current_user
    flash[:notice] = t("devise.confirmations.send_instructions")
  end

  def set_flash_message(key, kind, options = {})
    options.merge! resource_params.deep_symbolize_keys
    message = find_message(kind, options)
    flash[key] = message if message.present?
  end

  private

  def user_already_exists?(resource, type)
    # FIX for https://github.com/plataformatec/devise/issues/3540
    # Devise paranoid only works for passwords resets.
    # With the uniqueness validation on user.document_vatid and user.email
    # it's possible to do a user listing attack.
    #
    # If the email or document_vatid are already taken we should fail
    # silently (showing the same message as an OK creation or giving an
    # error for invalid validations) and send an email to the original
    # user.
    #
    # See test/features/users_are_paranoid_test.rb
    #
    if resource.errors.added? type, :taken
      resource.errors.messages[type] -= [ t('activerecord.errors.models.user.attributes.' + type.to_s + '.taken') ]
      resource.errors.delete(type) if resource.errors.messages[type].empty?
      return resource, true
    else
      return resource, false
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_permitted_keys)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: account_update_permitted_keys)
  end

  def account_update_permitted_keys
    if current_user.can_change_vote_location?
      common_permitted_keys + %i(current_password vote_province vote_town)
    else
      common_permitted_keys + %i(current_password)
    end
  end

  def sign_up_permitted_keys
    common_permitted_keys +
      %i(
        document_type
        document_vatid
        terms_of_service
        over_18
        inscription
        vote_town
        vote_province
        captcha
        catcha_key
      )
  end

  def common_permitted_keys
    %i(
      first_name
      last_name
      email
      email_confirmation
      password
      password_confirmation
      born_at
      gender_identity
      wants_newsletter
      country
      province
      town
      address
      postal_code
    )
  end
end
