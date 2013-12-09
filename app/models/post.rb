class Post < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  attr_accessible :description, :name, :avatar

end
