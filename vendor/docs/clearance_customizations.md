## Customizing Clearance

### 1. Adding a password confirmation to signup page
1. alter Users model to validate password_confirmation
```
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
```
2. extend Clearance::UsersController and override strong params
```
class UsersController < Clearance::UsersController
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
```
3. update the routes to use the extended controller
```
resources :users, controller: :users, only: :create
```
