def add_colors(number_of_colors)
  # http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/
  h = 0.5
  golden_ratio_conjugate = 0.618033988749895
  colors = (1..number_of_colors).to_a.map do
    h += golden_ratio_conjugate
    h %= 1
    hsv_to_rgb(h, 0.9, 0.95)
  end
  hash = colors.map do |r, g, b|
    {
      full: "rgba(#{r},#{g},#{b},1)",
      transparent: "rgba(#{r},#{g},#{b},0.2)"
    }
  end
  hash.map { |c| OpenStruct.new c }
end

# HSV values in [0..1]
# returns [r, g, b] values from 0 to 255
# rubocop:disable Metrics/AbcSize, Style/ParallelAssignment, Naming/MethodParameterName, Style/NumericPredicate
def hsv_to_rgb(h, s, v)
  h_i = (h * 6).to_i
  f = h * 6 - h_i
  p = v * (1 - s)
  q = v * (1 - f * s)
  t = v * (1 - (1 - f) * s)
  r, g, b = v, t, p if h_i == 0
  r, g, b = q, v, p if h_i == 1
  r, g, b = p, v, t if h_i == 2
  r, g, b = p, q, v if h_i == 3
  r, g, b = t, p, v if h_i == 4
  r, g, b = v, p, q if h_i == 5
  [(r * 256).to_i, (g * 256).to_i, (b * 256).to_i]
end
# rubocop:enable Metrics/AbcSize, Style/ParallelAssignment, Naming/MethodParameterName, Style/NumericPredicate

DISCIPLINE_COLORS = add_colors(Discipline.all.size).map(&:full)
COLOR_FOR_DISCIPLINE_ID = Discipline.all.each_with_index.each_with_object({}) { |(discipline, i), o| o[discipline.id] = DISCIPLINE_COLORS[i] } # rubocop:todo Metrics/LineLength
