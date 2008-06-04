class Twit < ActiveRecord::Base
belongs_to :user, :foreign_key => "user_id"
has_one :dtype
end
