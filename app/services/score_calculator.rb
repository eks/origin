# frozen_string_literal: true

class ScoreCalculator
  def initialize(params)
    base_score = calculate_base_score(params[:risk_questions])
    @life_score = @home_score = @auto_score = @disability_score = base_score

    @income = params[:income].to_i
    @house = params[:house]
    @vehicle = params[:vehicle]
    @age = params[:age].to_i
    @dependents = params[:dependents].to_i
    @marital_status = params[:marital_status]
  end

  def calculate
    life_young
    life_middle_age
    desability_high_income
    home
    desability
    life
    auto

    { life: elegible_for_life_insurance? ? ensurance_line(@life_score) : 'ineligible',
      home: elegible_for_home_insurance? ? ensurance_line(@home_score) : 'ineligible',
      auto: elegible_for_auto_insurance? ? ensurance_line(@auto_score) : 'ineligible',
      disability: elegible_for_disability_insurance? ? ensurance_line(@disability_score) : 'ineligible' }
  end

  private

  def life
    if elegible_for_life_insurance? && @marital_status == 'married'
      @life_score += 1
      @disability_score -= 1
    end
  end

  def life_young
    if elegible_for_life_insurance? && @age < 30
      @life_score -= 2
      @home_score -= 2
      @auto_score -= 2
      @disability_score -= 2
    end
  end

  def life_middle_age
    if elegible_for_life_insurance? && @age >= 30 && @age <= 40
      @life_score -= 1
      @home_score -= 1
      @auto_score -= 1
      @disability_score -= 1
    end
  end

  def desability_high_income
    if elegible_for_disability_insurance? && @income >= 200_000
      @life_score -= 1
      @home_score -= 1
      @auto_score -= 1
      @disability_score -= 1
    end
  end

  def desability
    if elegible_for_disability_insurance? && @dependents.positive?
      @life_score += 1
      @disability_score += 1
    end
  end

  def home
    if elegible_for_home_insurance? && @house[:ownership_status] == 'mortgaged'
      @home_score += 1
      @disability_score += 1
    end
  end

  def auto
    @auto_score += 1 if elegible_for_auto_insurance? && vehicle_age(@vehicle) <= 5
  end

  def calculate_base_score(risk_questions)
    risk_questions.map(&:to_i).reduce(:+)
  end

  def vehicle_age(vehicle)
    Date.today.strftime('%Y').to_i - vehicle[:year].to_i
  end

  def not_present?(field)
    field.blank? || field == 0
  end

  def elegible_for_home_insurance?
    return false if not_present?(@house)

    true
  end

  def elegible_for_auto_insurance?
    return false if not_present?(@vehicle)

    true
  end

  def elegible_for_life_insurance?
    return false if @age > 60

    true
  end

  def elegible_for_disability_insurance?
    return false if @income.zero? || @age > 60

    true
  end

  def ensurance_line(score)
    return 'economic' if score <= 0
    return 'regular' if [1, 2].include?(score)
    return 'responsible' if score >= 3
  end
end
