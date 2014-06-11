module Api
  module V1 
    class AppointmentsController < ApplicationController
      ##
      # List appointments (optionally with time parameters to filter list returned)
      ##
      def index
        @start = params[:list_from].to_datetime unless params[:list_from].blank?
        @end = params[:list_to].to_datetime unless params[:list_to].blank?

        if (@start.blank? and @end.blank?)
          @appointments = Appointment.order(:appt_start).all
        else
          @appointments = Appointment.order(:appt_start).where(appt_start: @start..@end)
        end
#        
        if !@appointments.blank? 
          render json: @appointments
        else
          render json: @appointments, :status => :not_found
        end
      end
      ##
      # Create new appt 
      ##
      def create
        @appointment = Appointment.new(appt_params)
        if @appointment.save
          render json: @appointment, :status => :created
        else
          render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
        end 
      end
      ##
      # Update an existing appt
      ##
      def update
        @appointment = Appointment.find(params[:id])
        if @appointment.update(appt_params)
          render json: @appointment, :status => :accepted
        else
          render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
        end
      end
      
      def destroy
        begin
          @appointment = Appointment.find(params[:id])
          if @appointment.destroy
            render json: @appointment, :status => :accepted 
          else
            render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound
          render :json => [{:errors => 'record with that id not found'.as_json}], :status => :not_found
#          render :json => {:errors => 'record not found'.as_json}, :status => :unprocessable_entity

    # however you want to respond to it
        end
#        @appointment = Appointment.find(params[:id])
#        if (!appointment.blank? and @appointment.destroy)
#          render json: @appointment, :status => :accepted 
#        else
#          render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
#        end
      end
      private
        def appt_params
          params.require(:appointment).permit(:appt_start, :appt_end, :first_name, :last_name, :comment)
        end  
        def dates_valid_format
          begin
            if !(params[:appt_start].is_a?(Time) or blank?) and !(params[:end_start].is_a?(Time) or blank?)
              return
            end
          rescue ArgumentError
            render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
          end 
        end
    end
  end
end
