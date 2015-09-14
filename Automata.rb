class Avalanche
  
  def initialize (size, threshold, conservative = true)
    @threshold = threshold
    @size = size
    @conservative = conservative
    @flag = false

    @height = Array.new @size
    @height.map! do |ar| 
      ar = Array.new @size
      ar.map! {0}
		end

    @slope = Array.new(@size)
    @slope.map! do |ar|
			ar = Array.new(@size)
			ar.map! {0}
    end
  end

	def height
		@height
	end

  def size
    @size
  end

  def snowing!
    @point = 2.times.map{ rand(@size) }
    if @conservative then
      @height[@point[0]][@point[1]] += 1
    else
			row = rand(2) == 1
      (0..@point[0]).each do |t|
        if row then
          @height[t][@point[1]] += 1
        else
          @height[@point[1]][t] += 1
        end
      end
    end
  end

  def compute_slope
    (@size).times do |i|
      (@size).times do |j|
      	if j.even? then
					if i == 0 then
						@slope[0][j] = 2*@height[0][j] - @height[0][j+1] - @height[0][j+2] unless j == @size - 2
						@slope[0][j] = 2*@height[i][j] - @height[i][j+1] if j == @size - 2
					else
						@slope[i][j] = @height[i][j]+ @height[i-1][j+1]- @height[i][j+1]- @height[i][j+2] unless j == @size - 2
						@slope[i][j] = @height[i][j] + @height[i-1][j+1] - @height[i][j+1] if j == @size -2
					end
		    else
					if i == @size - 1 then
						@slope[i][j] = @height[i][j] + @height[i][j+1] - @height[i][j+2] unless j == @size - 1
						@slope[i][j] = @height[i][j] if j == @size - 1
					else
						@slope[i][j] = @height[i][j]+ @height[i][j+1] - @height[i+1][j+1]- @height[i][j+2] unless j == @size - 1
						@slope[i][j] = @height[i][j] if j == @size - 1
					end
				end
			end
		end
	end



	def fall
		@slope.each.with_index do |ar, i|
			ar.each.with_index do |slope, j|
				if slope > @threshold then
					if j.even? then
						if i == 0 then
							if j == @size - 2 then
								@height[i][j] -= 1
								@height[i][j+1] += 1
							else
								@height[i][j] -= 1
								@height[i][j+1] += 1
								@height[i][j+2] += 1
							end
						else
							if j == @size - 2 then
								@height[i][j] -= 1
								@height[i-1][j+1] -= 1
								@height[i][j+1] += 1
							else
								@height[i][j] -= 1
								@height[i-1][j+1] -= 1
								@height[i][j+1] += 1
								@height[i][j+2] += 1
							end
						end
					else
						if i == @size - 1 then
							if j == @size - 1 then
								@height[i][j] -= 1
							else
								@height[i][j] -= 1
								@height[i][j+1] -= 1
								@height[i][j+2] += 1
							end
						else
							if j == @size - 1 then
								@height[i][j] -= 1
							else
								@height[i][j] -= 1
								@height[i][j+1] -= 1
								@height[i+1][j+1] += 1
								@height[i][j+2] += 1
							end
						end
					end										
				end
			end
		end
	end

	def show
		@height.transpose.map{|ar| ar * ' '}*"\n" + "\n\n" + @slope.transpose.map{|ar| ar * ' '}*"\n" + "\n\n"
	end

  def start 
    loop do 
      snowing!
      compute_slope
      loop do
        compute_slope
        fall
        break if @slope.all? {|ar| ar.all? {|slope| slope <= @threshold}}
      end
      to_file
      break if average_slope > 6.5
    end
  end

  def average_slope
    @slope.map{|ar| ar.reduce(:+)}.reduce(:+) / 40.0**2 
  end

	def to_file
		File.open("average_slope.txt", "a") {|f| f.puts average_slope}
	end
end


projekt = Avalanche.new(40, 7, false)

projekt.start
