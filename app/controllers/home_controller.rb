class HomeController < ApplicationController
    require 'rqrcode'
    #Callback de Devise para autenticar si el usuario esta logeado.
    before_action :authenticate_user!

    def index
        @matricula = "E" + current_user.email.gsub(/[^A-Za-z0-9]/, '').slice(2, 8)
    
        if user_signed_in?
            qr = RQRCode::QRCode.new(@matricula)
            
            @qr_code = qr.as_png(
                resize_gte_to: false,
                resize_exactly_to: false,
                fill: 'white',
                color: 'black',
                size: 120
            )
        end
    end
end