class StudentsController < ApplicationController
    require 'csv'
    before_action :authenticate_user!

    def index
        @q = Student.ransack(params[:q])
        @pagy, @students = pagy(@q.result(distinct: true), items: 10)
    end

    def new
        @student = Student.new
    end

    def create
        @student = Student.new(student_params)

        if @student.save
            redirect_to students_path
        else
            render :new, status: :unprocessable_entity
        end

    end

    def destroy
        if params[:id] == "delete_all"
            Student.destroy_all
            redirect_to students_path, notice: 'La base de datos ha sido eliminada.'
        else
            @student = Student.find(params[:id])
            @student.destroy
            redirect_to students_path, alert: 'La base de datos no se pudo eliminar.'
        end
    end

    def import
        if params[:file].present?
            CSV.foreach(params[:file].path, headers: true, encoding: 'bom|utf-8') do |row|
                Student.create(
                    matricula: row['MATRICULA'],
                    first_name: row['FIRST_NAME'],
                    middle_name: row['MIDDLE_NAME'],
                    last_name: row['LAST_NAME'],
                    last_name_prefix: row['LAST_NAME_PREFIX'],
                    gender: row['GENDER'],
                    program: row['PROGRAM']
                )
            end
            redirect_to students_path, notice: 'El CSV fue importado correctamente.'
        else
            redirect_to students_path, alert: 'Selecciona un archivo CSV valido.'
        end
    end

    def download_csv
        send_file(
            "#{Rails.root}/public/plantilla.csv",
            filename: "plantilla.csv",
            type: "text/csv"
        )
    end

    private
    def student_params
        params.require(:student).permit(:matricula, :first_name, :middle_name, :last_name, :last_name_prefix, :gender, :program)
    end

end