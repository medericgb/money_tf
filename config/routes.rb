require 'sidekiq/web'

Rails.application.routes.draw do
    if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  else
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
