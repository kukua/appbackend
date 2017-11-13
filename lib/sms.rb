def sms_create(user_id, phone_number, message_content)
  sms_state = SMS.new(:user_id => user_id, :phone_number => phone_number, :message_content => message_content).save
  if(sms_state)
    sms_state = sms_state._id
  end
  sms_state
end

def sms_send(recipient, sms_text)
  account_sid = "AC1e65fc1095fdd04cf64c58a6558049dc"
  auth_token = "6e32aa8c9735784e600e73d1bd78ceb7"
  
  @client = Twilio::REST::Client.new account_sid, auth_token
  message = @client.messages.create(
      body: sms_text,
      to: recipient,
      from: "+447481343620")
  
  message.sid rescue false
end