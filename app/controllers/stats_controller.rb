class StatsController < ApplicationController
    before_action :authenticate_user!
  
    def index
        start_date = Date.parse(params[:start_date]).to_datetime if params[:start_date].present?
        end_date = Date.parse(params[:end_date]).to_datetime if params[:end_date].present?
        filtrado = Record.where("program LIKE ?", "%#{params[:filtrar]}%")
  
        if start_date.present? && end_date.present?
            filtrado = filtrado.where("records.created_at >= ? AND records.created_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
        end
        
        @filtered_records = filtrado
        @pie_chart_data_f = filtrado.where(gender: "F").group(:program).count
        @pie_chart_data_m = filtrado.where(gender: "M").group(:program).count
        @pie_chart_data_all = filtrado.group(:program).count

        respond_to do |format|
          format.html
          format.pdf do
            render pdf: "Reporte-#{Date.current}", # Establece el nombre personalizado aquí
            layout: "pdf",
            encoding: "UTF-8",
            template: "stats/pdf",
            disposition: :inline
          end
        end
    end    
end