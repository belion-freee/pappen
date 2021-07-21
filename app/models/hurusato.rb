class Hurusato
  def self.hurusato_maximum(opts = {})
    taxable_income = opts[:taxable_income].presence&.to_i
    annual_income = opts[:annual_income].presence&.to_i

    raise ArgumentError, "課税所得額か給与所得は必須です" if taxable_income.blank? && annual_income.blank?

    if annual_income.present?
      # 給与所得控除
      income_deduction =
        case annual_income
        when (0..1625000)       then 550000
        when (1625001..1800000) then (annual_income * 0.4) - 100000
        when (1800001..3600000) then (annual_income * 0.3) + 80000
        when (3600001..6600000) then (annual_income * 0.2) + 440000
        when (6600001..8500000) then (annual_income * 0.1) + 1100000
        else 1950000
        end

      # 社会保障費
      social_security_expenses = opts[:social_security_expenses].presence&.to_i || (annual_income * 0.15).round

      # 住民税の基礎控除
      basic_deduction =
        case annual_income
        when (0..24000000)        then 430000
        when (24000001..24500000) then 290000
        when (24500001..2500000)  then 150000
        else 0
        end

      income = annual_income - (income_deduction + social_security_expenses + basic_deduction)
    else
      income = taxable_income
    end

    raise ArgumentError, "課税対象額が0未満です" if income < 0

    # 所得税の税率
    income_tax =
      case income.round(-3)
      when (1000..1949000)      then 5
      when (1950000..3299000)   then 10
      when (3300000..6949000)   then 20
      when (6950000..8999000)   then 23
      when (9000000..17999000)  then 33
      when (18000000..39999000) then 40
      else 45
      end

    # 住民税の税率(市民税と県民税の合計)
    municipal_tax = opts[:municipal_tax].presence&.to_f || 10.00

    # 寄附金控除の限度割合(住民税所得割額の20%)
    limit_rate = 0.2

    # 所得割額
    income_rate = income * (municipal_tax / 100.0)

    # 住民税からの控除割合(特例分)
    deduction_rate = ((90 - income_tax) / 100.0)

    # ふるさと納税の寄附金控除限度額
    # @see https://www.soumu.go.jp/main_sosiki/jichi_zeisei/czaisei/czaisei_seido/furusato/mechanism/deduction.html
    (((income_rate * limit_rate) / deduction_rate) + 2000).round
  end
end
