module Omniauth

  module Mock
    def auth_mock
      OmniAuth.config.mock_auth[:github] = {
        'uid'  => '123545',
        'info' => {
          'name'     => 'mock_name',
          'username' => 'mock_username'
        },
        'credentials' => {
          'token'  => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end
  end

  module SessionHelpers
    def signin
      visit root_path
      expect(page).to have_content("Sign In")
      auth_mock
      click_link "Sign In"
    end
  end

end
