module Api
  module V1 
    class AppointmentsController < ApplicationController
#
#     List appointments (optionally accepts time parameters to filter list returned)
#
      def index
 
        filter_start = Time.zone.parse (params[:list_from]) unless params[:list_from].blank?
        filter_end   = Time.zone.parse (params[:list_to])   unless params[:list_to].blank? 
        
        @appointments = Appointment.order(:appt_start)
        
        if (!filter_start.blank? and !filter_end.blank?)                       #both dates 
          @appointments = @appointments.where(appt_start: filter_start..filter_end)
        elsif (!filter_start.blank? and filter_end.blank?)                     #start_only
           @appointments = @appointments.where('appt_start >= ?', filter_start) 
        elsif (filter_start.blank? and !filter_end.blank?)                     # end date only
            @appointments = @appointments.where('appt_start <= ?', filter_end)
        else (filter_start.blank? and filter_end.blank?)                       #no dates 
            @appointments = @appointments.all
        end 
        
        if !@appointments.blank? 
          render json: @appointments, :status => :ok 
        else
          render :json => {:errors => 'No records found for given criteria'.as_json}, :status => :not_found
        end
      end
#
#     Create new appt 
#
      def create
        
        @appointment = Appointment.new(appt_params)
        
        @appointment.appt_start = Time.zone.parse(appt_params[:appt_start])
        @appointment.appt_end   = Time.zone.parse(appt_params[:appt_end])
        
        if @appointment.save
          render json: @appointment, :status => :created
        else
          render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
        end 
      end
 #
 #    Update a appt
 #
      def update
        begin
          @appointment = Appointment.find(params[:id])

          @appointment.appt_start = Time.zone.parse(appt_params[:appt_start])  unless appt_params[:appt_start].blank? 
          @appointment.appt_end = Time.zone.parse(appt_params[:appt_end]) unless appt_params[:appt_end].blank?
          
          if @appointment.update(appt_params)
            render json: @appointment, :status => :accepted
          else
            render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound
          return_not_found
        end
      end
 #
 #    adios row 
 #
      def destroy
        begin
          @appointment = Appointment.find(params[:id])
          if @appointment.destroy
            render json: @appointment, :status => :accepted 
          else
            render :json => {:errors => @appointment.errors.as_json}, :status => :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound
          return_not_found
        end
      end
#
#     private methods 
#
      private
#
#       Strong Params  
#
        def appt_params
          params.require(:appointment).permit(:appt_start, :appt_end, :first_name, :last_name, :comment)
        end 
#
#       Common message on find [:id] not founf rescue
#
        def return_not_found
          render :json => {:errors => 'record with that id not found'.as_json}, :status => :not_found
        end 
    end
  end
end
