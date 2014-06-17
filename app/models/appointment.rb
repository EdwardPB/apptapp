class Appointment < ActiveRecord::Base
#
# Name and date validations
#
  validates :first_name, :last_name , presence: true
  validates :appt_start, :appt_end , presence: true  
  validate  :appt_date_val 
  
#
# Validate appointment availability (no overlap)
#
  validates :appt_start, :appt_end, :overlap => 
           {:message_title   => "Appt time invalid", 
            :message_content => "overlaps existing appt",
            :exclude_edges   => ["appt_start","appt_end"]}  
  private
# 
# insure start end & start date future and < end date 
#  
    def appt_date_val  # Time.zone.parse (appt_start) #DateTime.strptime(appt_start, "%y/%m/%d %H:%M")
      errors.add(:appt_start, "Must be in the future") unless (appt_start > Time.now)
      errors.add(:appt_end, "Must be after Appt Start") unless (appt_end > appt_start)
    end
end