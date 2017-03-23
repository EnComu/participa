Rails.application.routes.draw do

  get '', to: redirect("/#{I18n.locale}")

  # redsys MerchantURL 
  post '/orders/callback/redsys', to: 'orders#callback_redsys', as: 'orders_callback_redsys'

  namespace :api do
    scope :v1 do 
      scope :gcm do 
        post 'registrars', to: 'v1#gcm_registrate'
        delete 'registrars/:registrar_id', to: 'v1#gcm_unregister'
      end
    end
  end

  scope "/(:locale)", locale: /es|ca|eu/ do 

    get '/openid/discover', to: 'open_id#discover', as: "open_id_discover"
    get '/openid', to: 'open_id#index', as: "open_id_index"
    post '/openid', to: 'open_id#create', as: "open_id_create"
    get '/user/:id', to: 'open_id#user', as: "open_id_user"
    get '/user/xrds', to: 'open_id#xrds', as: "open_id_xrds"

    get '/countvotes/:election_id', to: 'page#count_votes', as: 'page_count_votes'

    get '/privacy-policy', to: 'page#privacy_policy', as: 'page_privacy_policy'
    get '/inscription-policy', to: 'page#inscription_policy', as: 'page_inscription_policy'
    get '/legal', to: 'page#legal', as: 'page_legal'
    get '/cookie-policy', to: 'page#cookie_policy', as: 'page_cookie_policy'
    get '/preguntas-frecuentes', to: 'page#faq', as: 'faq'

    get '/equipos-de-accion-participativa', to: 'participation_teams#index', as: 'participation_teams'
    put '/equipos-de-accion-participativa/entrar(/:team_id)', to: 'participation_teams#join', as: 'participation_teams_join'
    put '/equipos-de-accion-participativa/dejar(/:team_id)', to: 'participation_teams#leave', as: 'participation_teams_leave'
    patch '/equipos-de-accion-participativa/actualizar', to: 'participation_teams#update_user', as: 'participation_teams_update_user'

    get '/propuestas', to: 'proposals#index', as: 'proposals'
    get '/propuestas/info', to: 'proposals#info', as: 'proposals_info'
    get '/propuestas/:id', to: 'proposals#show', as: 'proposal'
    post '/apoyar/:proposal_id', to: 'supports#create', as: 'proposal_supports'

    get :notices, to: 'notice#index', as: 'notices'
    get '/vote/create/:election_id', to: 'vote#create', as: :create_vote
    get '/vote/create_token/:election_id', to: 'vote#create_token', as: :create_token_vote
    get '/vote/check/:election_id', to: 'vote#check', as: :check_vote
    
    get '/vote/sms_check/:election_id', to: 'vote#sms_check', as: :sms_check_vote
    get '/vote/send_sms_check/:election_id', to: 'vote#send_sms_check', as: :send_sms_check_vote
    
    devise_for :users, controllers: { registrations: 'registrations' }

    get '/microcreditos', to: 'microcredit#index', as: 'microcredit'
    get '/microcréditos', to: redirect('/microcreditos')
    get '/microcreditos/provincias', to: 'microcredit#provinces'
    get '/microcreditos/municipios', to: 'microcredit#towns'
    get '/microcreditos/informacion', to: 'microcredit#info', as: 'microcredits_info'
    get '/microcreditos/:id', to: 'microcredit#new_loan', as: :new_microcredit_loan
    get '/microcreditos/:id/login', to: 'microcredit#login', as: :microcredit_login
    post '/microcreditos/:id', to: 'microcredit#create_loan', as: :create_microcredit_loan
    get '/microcreditos/:id/renovar(/:loan_id/:hash)', to: 'microcredit#loans_renewal', as: :loans_renewal_microcredit_loan
    post '/microcreditos/:id/renovar/:loan_id/:hash', to: 'microcredit#loans_renew', as: :loans_renew_microcredit_loan

    authenticate :user do
      scope :validator do
        scope :sms do 
          get :step1, to: 'sms_validator#step1', as: 'sms_validator_step1'
          get :step2, to: 'sms_validator#step2', as: 'sms_validator_step2'
          get :step3, to: 'sms_validator#step3', as: 'sms_validator_step3'
          post :phone, to: 'sms_validator#phone', as: 'sms_validator_phone'
          post :captcha, to: 'sms_validator#captcha', as: 'sms_validator_captcha'
          post :valid, to: 'sms_validator#valid', as: 'sms_validator_valid'
        end
      end
      
      scope :colabora do
        delete 'baja', to: 'collaborations#destroy', as: 'destroy_collaboration'
        get 'ver', to: 'collaborations#edit', as: 'edit_collaboration'
        get '', to: 'collaborations#new', as: 'new_collaboration'
        get 'confirmar', to: 'collaborations#confirm', as: 'confirm_collaboration'
        post 'crear', to: 'collaborations#create', as: 'create_collaboration'
        post 'modificar', to: 'collaborations#modify', as: 'modify_collaboration'
        get 'OK', to: 'collaborations#OK', as: 'ok_collaboration'
        get 'KO', to: 'collaborations#KO', as: 'ko_collaboration'
      end
    end
    
    scope :impulsa do
      get '', to: 'impulsa#index', as: 'index_impulsa'
      get 'nuevo', to: 'impulsa#new', as: 'new_impulsa'
      get 'ver', to: 'impulsa#edit', as: 'edit_impulsa'
      post 'crear', to: 'impulsa#create', as: 'create_impulsa'
      post 'modificar', to: 'impulsa#modify', as: 'modify_impulsa'
      get ':id/attachment/:field/:style/:filename', to: 'impulsa#attachment', as: 'attachments_impulsa', constraints: { filename: /[^\/]*/ }
      get 'categorias', to: 'impulsa#categories', as: 'impulsa_categories'
      get 'categoria/:id', to: 'impulsa#category', as: 'impulsa_category'
      get 'proyecto/:id', to: 'impulsa#project', as: 'impulsa_project'
    end

    scope :brujula do
      get '', to: 'blog#index', as: 'blog'
      get ':id', to: 'blog#post', as: 'post'
      get 'categoria/:id', to: 'blog#category', as: 'category'
    end
    
    # http://stackoverflow.com/a/8884605/319241 
    devise_scope :user do
      get '/registrations/regions/provinces', to: 'registrations#regions_provinces'
      get '/registrations/regions/municipies', to: 'registrations#regions_municipies'
      get '/registrations/vote/municipies', to: 'registrations#vote_municipies'

      authenticated :user do
        root 'tools#index', as: :authenticated_root
      end
      unauthenticated do
        root 'devise/sessions#new', as: :root
      end
    end
    
    if Rails.application.secrets.features["verification_presencial"]
      scope '/verificadores' do 
        get '/', to: 'verification#step1', as: :verification_step1
        get '/nueva', to: 'verification#step2', as: :verification_step2
        get '/confirmar', to: 'verification#step3', as: :verification_step3
        post '/search', to: 'verification#search', as: :verification_search
        post '/confirm', to: 'verification#confirm', as: :verification_confirm
        get '/ok', to: 'verification#result_ok', as: :verification_result_ok
        get '/ko', to: 'verification#result_ko', as: :verification_result_ko
      end
    end    

    scope '/verificaciones' do 
      get '/', to: 'verification#show', as: :verification_show
    end

    %w(404 422 500).each do |code|
      get code, to: 'errors#show', code: code
    end
  end
  # /admin
  ActiveAdmin.routes(self)

  constraints CanAccessResque.new do
    mount Resque::Server.new, at: '/admin/resque', as: :resque
  end

end
