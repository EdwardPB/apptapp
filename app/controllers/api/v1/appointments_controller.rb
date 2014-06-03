module Api
  module V1 
    class AppointmentsController < ApplicationController
      def index
        @appointments = Appointment.order(:appt_start).all
        if @appointments
          render json: @appointments
        else
          render json: @appointments, :status => :not_found
      end
      def new
        @appointment = Appointment.new
      end
      def create
        @appointment = Appointment.new(appt_params)
        if @appointment.save
          render json: @appointment, :status => :ok
        else
          render :status => :unprocessable_entity
        end 
      end
      def update
        @appointment = Appointment.find(params[:id])
        if @appointment.update(appt_params)
          render json: @appointment, :status => :ok
        else
          render json: @appointment, :status => :unprocessable_entity
        end
#        .assign_attributes(appt_params).save!
#        if @appointment.save
#          render json: @appointment
#        else
#        end        
      end
      def delete
      end
      private
        def appt_params
          params.require(:appointment).permit(:appt_start, :appt_end, :first_name, :last_name, :comment)
        end  
    end
  end
end
