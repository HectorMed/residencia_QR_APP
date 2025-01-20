class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :matricula
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :last_name_prefix
      t.string :gender
      t.string :program

      t.timestamps
    end
  end
end
