class Integer
  def prime?
    (self < 2) ? false : 2.upto(self - 1).all? { |i| remainder(i).nonzero? }
  end

  def prime_factors
    2.upto(abs).each do |number|
      if abs.remainder(number).zero? and number.prime?
        return [number] + (abs / number).prime_factors
      end
    end
    []
  end

  def harmonic
    (1..self).map { |a| 1 / a.to_r } .reduce(:+) if (self > 0)
  end

  def digits
    abs.to_s.chars.map(&:to_i)
  end
end

class Array
  def frequencies
    hash = Hash.new(0)
    self.each { |i| hash[i] += 1 }
    return hash
  end

  def average
    reduce(:+) / length.to_f unless empty?
  end

  def drop_every(step)
    new_array = self.dup
    (self.size / step).downto(1).each { |i| new_array.delete_at(i * step - 1) }
    return new_array
  end

  def combine_with(other = [])
    longer, shorter = self.length > other.length ? [self, other] : [other, self]

    combined = take(shorter.length).zip(other.take(shorter.length)).flatten(1)
    rest     = longer.drop(shorter.length)

    combined + rest
  end
end

puts 360.prime_factors
