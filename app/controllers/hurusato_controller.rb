class HurusatoController < ApplicationController
  def index; end

  def maximum
    begin
      @maximum = Hurusato.hurusato_maximum(
        params[:hurusato]&.slice(:municipal_tax, :social_security_expenses, :annual_income, :taxable_income)
      )
    rescue ArgumentError => e
      @error = e.message
    end
    render :maximum
  end
end
