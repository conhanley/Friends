class Friend < ApplicationRecord
	# Misc. Constants
	FRIENDSHIP_LEVELS = [ ["Casual", 1], ["Good", 2], ["Close", 3], ["Best", 4] ]

	# Validations
	validates_presence_of :full_name, :email, :level
  validates_format_of :phone, :with => /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"
  validates_inclusion_of :level, in: [1,2,3,4], message: "level not recognized by the system"
  
  # Uploaders
  mount_uploader :photo, PhotoUploader
	
end
