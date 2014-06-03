class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime     :appt_start
      t.datetime     :appt_end
      t.string   :first_name
      t.string   :last_name
      t.text     :comment
      t.timestamps
    end
    add_index :appointments, :appt_start
    add_index :appointments, :appt_end
  end
 end
