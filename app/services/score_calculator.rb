# frozen_string_literal: true

class ScoreCalculator
  def initialize(user)
    @user = user
  end

  def calculate
    @life_score = @home_score = @auto_score = @disability_score = base_score

    for_youngsters   if @user.age < 30
    for_middle_agers if @user.age >= 30 && @user.age <= 40
    for_200k_income  if @user.age < 60 && @user.income >= 200_000
    for_dependents   if @user.age < 60 && @user.income.positive? && @user.dependents.positive?
    for_life         if @user.age < 60 && @user.marital_status == 'married'
    for_home         if house_ownership && house_ownership == 'mortgaged'
    for_auto         if vehicle_year

    persist_profiles
    ensurance_profile
  end

  private

  def base_score
    @user.risk_questions.reduce(:+)
  end

  def house_ownership
    return @user.house.ownership_status unless @user.house.nil?

    false
  end

  def vehicle_year
    return @user.vehicle.year unless @user.vehicle.nil?

    false
  end

  def for_life
    @life_score += 1
    @disability_score -= 1
  end

  def for_youngsters
    @life_score -= 2
    @home_score -= 2
    @auto_score -= 2
    @disability_score -= 2
  end

  def for_middle_agers
    @life_score -= 1
    @home_score -= 1
    @auto_score -= 1
    @disability_score -= 1
  end

  def for_200k_income
    @life_score -= 1
    @home_score -= 1
    @auto_score -= 1
    @disability_score -= 1
  end

  def for_dependents
    @life_score += 1
    @disability_score += 1
  end

  def for_home
    @home_score += 1
    @disability_score += 1
  end

  def for_auto
    @auto_score += 1 if vehicle_age <= 4
  end

  def vehicle_age
    Date.today.strftime('%Y').to_i - vehicle_year
  end

  def ensurance_profile
    { life: @user.age < 60 ? ensurance_line(@life_score) : 'ineligible',
      home: house_ownership ? ensurance_line(@home_score) : 'ineligible',
      auto: vehicle_year ? ensurance_line(@auto_score) : 'ineligible',
      disability: @user.age < 60 && @user.income.positive? ? ensurance_line(@disability_score) : 'ineligible' }
  end

  def persist_profiles
    risk_profile = @user.risk_profiles.new(ensurance_profile)
    risk_profile.build_score({
      life: @life_score,
      home: @home_score,
      auto: @auto_score,
      disability: @disability_score
    })

    risk_profile.save
  end

  def ensurance_line(score)
    return 'economic' if score <= 0
    return 'regular' if [1, 2].include?(score)
    return 'responsible' if score >= 3
  end
end
