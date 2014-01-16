class Integer

  def prime?
    (self < 2) ? false : 2.upto(self - 1).all? { |i| remainder(i).nonzero? }
  end

  def prime_factors
    prime_factors_array = []
    current_number = self.abs

    while (current_number > 1)
      prime_factors_array << current_number.lowest_prime_devisor
      current_number /= current_number.lowest_prime_devisor
    end

    return prime_factors_array
  end

  def lowest_prime_devisor
          given_number = self

          2.upto(given_number).each do |likely_divisor|
            if likely_divisor.prime? and given_number.remainder(likely_divisor).zero?
                    return likely_divisor
            end
          end
  end

  def harmonic
          if self == 1
            Rational(1,1)
          else
            1.upto(self).inject { |sum, current| sum += Rational(1,current) }
    end
  end

  def digits
          given_digit = self.abs
    digits_array = []

    while(given_digit > 0)
      digits_array.insert(0, given_digit.remainder(10))
      given_digit /= 10
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


