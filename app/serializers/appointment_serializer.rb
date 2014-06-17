class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :appt_start, :appt_end, :comment, :created_at, :updated_at
end
