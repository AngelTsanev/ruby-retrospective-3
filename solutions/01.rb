class Integer
  def prime?
    (self < 2) ? false : 2.upto(self - 1).all? { |i| remainder(i).nonzero? }
  end

  def prime_factors
    return [] if self == 1
    2.upto(abs) do |number|
      if number.prime? and (abs).remainder(number).zero?
        [number] + (abs / number).prime_factors
      end
    end
  end

  def harmonic
      (1..self).map { |a| 1 / a.to_r } .reduce(:+) if (self > 0)
  end

  def digits
    abs.to_s.chars.map(&:to_i)
  end

    return digits_array
  end
end

class Array

  def frequencies
  hash = Hash.new(0)

  self.each { |i| hash[i] += 1 }
  #hash.each {|key, value| } puts "#{key} appears #{value} times"}

  return hash
  end

  def average
    if self == []
      return 0.0
    else
            ((self.inject { |sum, current| sum += current } ).to_f / self.size)
          end
  end

  def drop_every(step)
          new_array = self.dup

          (self.size / step).downto(1).each { |i| new_array.delete_at(i * step - 1) }

          return new_array
  end

  def combine_with(second_array = [])
          array_to_be_returned = []
    upper_limit = ([self.size, second_array.size].max - 1)
          0.upto(upper_limit).each do |i|
                    array_to_be_returned << self[i] if self[i]
                array_to_be_returned << second_array[i] if second_array[i]
            end
            return array_to_be_returned
  end

end


