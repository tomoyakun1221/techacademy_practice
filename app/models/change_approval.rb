class ChangeApproval < ApplicationRecord
  belongs_to :user
  belongs_to :attendance
  
  enum application_situation: { application: 0, approval: 1, rejection: 2 }
end
