class PairStat
  attr_reader :avg_time, :n, :s1, :s2, :s_d

  def self.from_json(data)
    PairStat.new(data['s1'], data['s2'], data['avg_time'], data['n'], data['s_d'])
  end

  def initialize(s1, s2, avg_time = 0.0, n = 0, s_d = 0.0)
    # Среднее время
    @avg_time = avg_time
    # Количество записей
    @n = n
    # Среднеквадратичное отклонение ^ 2
    @s_d = s_d

    @s1 = s1
    @s2 = s2
  end

  def update(new_time)
    n_updated = @n + 1  # Обновленное количество записей
    
    @avg_time = (@avg_time * @n + new_time) / n_updated
    @s_d = Math.sqrt(((@s_d ** 2) * @n + (new_time - @avg_time) ** 2) / n_updated)
    @n = n_updated
  end

  def to_h
    {
      s1: @s1,
      s2: @s2,
      n: @n,
      avg_time: @avg_time,
      s_d: @s_d
    }
  end

  def to_json(_)
    to_h.to_json
  end

  def to_s
    "'#{@s1}' to '#{@s2}' with Number = #{@n} | Average = #{@avg_time} | Standard Deviation = #{@s_d}"
  end

  def inspect
    "#<#{self.class.name} @s1=#{@s1} @s2=#{@s2} @n=#{@n} @avg_time=#{@avg_time} @s_d=#{@s_d}>"
  end
end