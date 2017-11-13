def user_info(email, value)
  User.by_email.key(email).first[value]
end

def user_data_email(user_mail)
  User.by_email.key(user_mail).first
end

def user_data(user_id)
  User.by_id.key(user_id).first
end

def user_delete(user_id)
  User.by_id.key(user_id).first.destroy
end

def user_password_reset(email)
  new_pass = (0...8).map { (65 + rand(26)).chr }.join
  User.by_id.key(user_info(email, "_id")).first.update_attributes(:password => md5(new_pass))
  new_pass
end

def user_create(first_name, last_name, email, phone_number, password, character_id, timezone, location, purpose)
  user_id = md5(email)
  user_creation = User.new(:_id => md5(email), :first_name => first_name, :last_name => last_name, :email => email, :phone_number => phone_number, :password => md5(password), :character_id => character_id, :timezone => timezone, :location => location, :purpose => purpose).save
  if(user_creation)
    user_creation = md5(email)
  end
  user_creation
end

def user_login(email, password)
  login_valid = false
  login_pass = user_info(email, 'password') rescue ""
  (md5(password) == login_pass)
end

def user_random_pass
  rand(36**10).to_s(36)
end