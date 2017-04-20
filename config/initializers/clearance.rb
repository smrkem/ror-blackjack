class EmailConfirmationGuard < Clearance::SignInGuard
  def call
    if unconfirmed?
      failure("You must confirm your email address.")
    else
      next_guard
    end
  end

  def unconfirmed?
    signed_in? && !current_user.email_confirmed_at
  end
end

Clearance.configure do |config|
  config.mailer_sender = "no-reply@example.com"
  config.rotate_csrf_on_sign_in = true

  config.sign_in_guards = [EmailConfirmationGuard]
end
