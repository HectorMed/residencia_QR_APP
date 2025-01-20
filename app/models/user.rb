class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[azure_activedirectory_v2]

         validates :username, presence: true



    after_create :assign_default_role

    validate :must_have_a_role, on: :update

    private
  
    def must_have_a_role
      unless roles.any?
        errors.add(:roles, "Debes seleccionar un rol.")
      end
    end
  
    # def assign_default_role
    #   self.add_role(:admin) if self.roles.blank?
    # end
    def assign_default_role
      if User.count == 1
        self.add_role(:admin)
      else
        self.add_role(:institutional)
      end
    end
end
