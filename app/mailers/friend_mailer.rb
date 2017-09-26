class FriendMailer < ApplicationMailer
	def new_friend_msg(friend)
		@friend = friend
		mail(:to => friend.email, :subject => "My New Friend")
	end

	def remove_friend_msg(friend)
		@friend = friend
		mail(:to => friend.email, :subject => "It's not you, it's me")
	end
end
