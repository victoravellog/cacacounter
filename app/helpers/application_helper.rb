module ApplicationHelper
  VIOLETA_DUE_DATE = Date.new(2027, 1, 5)

  ENCOURAGING_MESSAGES = [
    "¡Un pañal menos, un día más cerca de que lo haga solita! 💪",
    "Cada cambio es un acto de amor 💜",
    "¡Papás campeones! Violeta tiene suerte de tenerlos 🌟",
    "Esto también pasará... y lo van a extrañar 😅",
    "¡Otro pañal conquistado! Van increíble 🎯",
    "Violeta aprecia cada cambio (aunque no lo demuestre) 😴",
    "¿Cansados? Normal. ¿Increíbles? También 💜",
    "Modo padres: activado y funcionando 🚀",
    "¡El equipo anti-pañales más pro del mundo! 🏆",
    "Un pañal a la vez, ¡así se hace! 🌸"
  ].freeze

  def violeta_status
    today = Date.current
    if today < VIOLETA_DUE_DATE
      days_until = (VIOLETA_DUE_DATE - today).to_i
      "Faltan #{days_until} días para conocer a Violeta 🤰"
    else
      days_old = (today - VIOLETA_DUE_DATE).to_i
      if days_old < 7
        "Violeta tiene #{pluralize(days_old, 'día', 'días')} de vida 👶"
      elsif days_old < 30
        weeks = days_old / 7
        "Violeta tiene #{pluralize(weeks, 'semana', 'semanas')} de vida 👶"
      else
        months = days_old / 30
        "Violeta tiene #{pluralize(months, 'mes', 'meses')} de vida 👶"
      end
    end
  end

  def violeta_days_old
    today = Date.current
    return nil if today < VIOLETA_DUE_DATE
    (today - VIOLETA_DUE_DATE).to_i
  end

  def total_diapers_changed
    DiaperChange.count
  end

  def diaper_milestone_message
    count = total_diapers_changed
    case count
    when 0 then nil
    when 1..9 then "¡Ya empezaron! 🎉"
    when 10..49 then "¡Doble dígito! 💪"
    when 50..99 then "¡Medio centenar! 🌟"
    when 100..249 then "¡Triple dígito! 🏆"
    when 250..499 then "¡250 pañales! Veteranos 🎖️"
    when 500..999 then "¡500 pañales! Leyendas 👑"
    else "¡Más de 1000! Dioses del pañal 🔱"
    end
  end

  def random_encouragement
    ENCOURAGING_MESSAGES.sample
  end

end
