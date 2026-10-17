module BuilderFixtures
  def view_counts
    { five: 5, ten: 10, fifteen: 15 }.transform_values { |views| Article.create!(views: views) }
  end

  def publication_dates
    {
      late_night: Article.create!(published_at: Time.utc(2026, 10, 16, 23, 59, 59)),
      midday: Article.create!(published_at: Time.utc(2026, 10, 17, 12, 0, 0)),
      next_day: Article.create!(published_at: Time.utc(2026, 10, 18, 0, 0, 1)),
      fifteenth: Article.create!(released_on: Date.new(2026, 10, 15)),
      seventeenth: Article.create!(released_on: Date.new(2026, 10, 17))
    }
  end
end
