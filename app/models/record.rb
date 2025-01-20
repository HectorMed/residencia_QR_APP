class Record < ApplicationRecord
    require 'csv'

    validates :matricula, presence: true
    validates :first_name, presence: true
    validates :middle_name, presence: false
    validates :last_name, presence: false
    validates :last_name_prefix, presence: false
    validates :gender, presence: true
    validates :program, presence: true

    def self.to_csv
      CSV.generate(headers: true, encoding: 'UTF-8') do |csv|
        csv << ["Matricula", "Primer Nombre", "Segundo Nombre", "Primer Apellido", "Segundo Apellido", "Genero", "Programa", "Fecha y Hora"]
        all.each do |record|
          csv << [record.matricula, record.first_name, record.middle_name, record.last_name, record.last_name_prefix, record.gender, record.program, record.created_at]
        end
      end
    end

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "first_name", "gender", "id", "last_name", "last_name_prefix", "matricula", "middle_name", "program", "updated_at"]
      end

    def self.ransackable_associations(auth_object = nil)
        []
    end

    def self.ransackable_scopes(auth_object = nil)
        [:full_name_cont]
      end
    
    def self.full_name_cont(query)
    where('first_name ILIKE ? OR middle_name ILIKE ? OR CONCAT(first_name, \' \', middle_name) ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
    end
end
