class Appointment < ActiveRecord::Base
#
  validates :first_name, :last_name , presence: true
  validate  :val_date 
# Validate appointment availability (no overlap)
  validates :appt_start, :appt_end, :overlap => 
           {:message_title   => "Appt time invalid", 
            :message_content => "overlaps existing appt",
            :exclude_edges   => ["appt_start","appt_end"]}  
#
# Check for no parms on post
#
  private
    #
 #   def val_name
 #     puts "in val_name"
 #     errors.add(:first_name) unless !first_name.blank? 
 #     errors.add(:last_name) unless !last_name.blank? 
 #   end
  # test format of start end & start date future and < end date 
    def val_date
#      errors.add(:appt_start, "invalid value") unless (appt_start.is_a?(Time)) #rescue ArgumentError) == ArgumentError)
#      errors.add(:appt_end, "invalid value") unless (appt_end.is_a?(Time)) #rescue ArgumentError) == ArgumentError)
      errors.add(:appt_start, "Must be in the future") unless (appt_start > Time.now)
      errors.add(:appt_end, "Must be after Appt Start") unless (appt_end > appt_start)
      
    end
end