def character_list
  Character.by_date
end
  
def character_update(user_id, character_type, hat_type, shirt_type, pants_type, shoes_type, accessories_type, facial_expression)
  Character.by_user_id.key(user_id).first.update_attributes(:character_type => character_type, :hat_type => hat_type, :shirt_type => shirt_type, :pants_type => pants_type, :shoes_type => shoes_type, :accessories_type => accessories_type, :facial_expression => facial_expression)
end