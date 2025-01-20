class RecordsController < ApplicationController
    require 'csv'
    before_action :authenticate_user!
    
    def index
        @q = Record.ransack(params[:q])
        @pagy, @records = pagy(@q.result(distinct: true).order(created_at: :desc), items: 10)


        respond_to do |format|
            format.html
            format.csv { send_data @records.to_csv,
                        type: 'text/csv; charset=UTF-8',
                        encoding: 'UTF-8',
                        filename: "Registros-#{Date.current}.csv" }
        end
        
    end
      
    def new
        @record = Record.new
    end

    def create
        student = Student.find_by(matricula: params[:record][:matricula])

        @record = Record.new(record_params)

        if student
            @record.first_name = student.first_name
            @record.middle_name = student.middle_name
            @record.last_name = student.last_name
            @record.last_name_prefix = student.last_name_prefix
            @record.gender = student.gender
            @record.program = student.program 
        end

        if @record.save
            flash[:notice] = 'Captura Exitosa'
            render turbo_stream: [
                turbo_stream.replace("notice", partial: "shared/flash"),
                turbo_stream.replace("records",
                partial: "new_record",
                locals: { record: Record.new })]
        else
            flash.now[:alert] = 'La matricula es incorrecta.'
            render :new, status: :unprocessable_entity
        end
    end
    
    def import
        if params[:file].present?
            CSV.foreach(params[:file].path, headers: true, encoding: 'bom|utf-8') do |row|
                Record.create!(
                matricula: row['MATRICULA'],
                first_name: row['FIRST_NAME'],
                middle_name: row['MIDDLE_NAME'],
                last_name: row['LAST_NAME'],
                last_name_prefix: row['LAST_NAME_PREFIX'],
                gender: row['GENDER'],
                program: row['PROGRAM'],
                created_at: row['CREATED_AT']
                )
          end
          redirect_to records_path, notice: 'El CSV fue importado correctamente.'
        else
          redirect_to records_path, alert: 'Selecciona un archivo CSV.'
        end
    end

    private
    def record_params
        params.require(:record).permit(:matricula)
    end
end