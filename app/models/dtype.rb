class Dtype < ActiveRecord::Base
belongs_to :user, :foreign_key => "user_id"
belongs_to :twit, :foreign_key => "twit_id"
end

