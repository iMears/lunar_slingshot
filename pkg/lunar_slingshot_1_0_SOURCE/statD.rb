# message layout
# type field 0..7
# time of day 8..25
# for type PING0

class StatD
	attr_accessor :ave, :s_ave, :max, :s_max, :min, :s_min, :sample_count

	def reset(size)
		if (size < 4)
			size = 4
		end
		@coeff_1 = 1.0 / size.to_f	# for s_ave filter
		@coeff_2 = 1.0 - @coeff_1 
		@coeff_m_1 = 1.0/(size.to_f * 10.0);	# for recovery towards s_ave
		@coeff_m_2 = 1.0/(size.to_f * 4.0);	# for excursions beyond min/max
		@coeff_m_3 = 0.7

		@sample_size = size
		@sample_count = 0
		size
	end

	def initialize(size=20)
		@coeff_1 = nil # for s_ave filter
		@coeff_2 = nil
		@coeff_m_1 = nil	# for recovery towards s_ave other plane
		@coeff_m_2 = nil 	# for recovery towards s_ave same plane
		@coeff_m_3 = nil 	# for excursions beyond smin/max
		size = reset(size)

		@sample_total = nil		#typical value is sample_size * ave
		@ave = nil
		@e_ave = nil
		@max = nil
		@s_max = nil
		@min = nil
		@s_min = nil
		size
	end

	def add_sample(sample)
		# handle first sample
		if (@sample_count == 0 )
			@sample_count = 1
			@sample_total = sample
			@min = sample
			@max = sample
			@s_max = sample
			@s_min = sample
			@ave = sample
			@s_ave = sample
			return sample
		end

		if (@sample_count < @sample_size )
			# do simple average
			@sample_count += 1			# is 2 first time here
			@sample_total += sample
			@ave = @sample_total / @sample_count.to_f
			@s_ave = (@s_ave * @coeff_2) + (@ave * @coeff_1)
		else
			# do fancy average
			@sample_total += sample - @ave
			@ave = @sample_total / @sample_count.to_f
			@s_ave = (@s_ave * @coeff_2) + (@ave * @coeff_1)
		end

		# handle s_min and s_max
		if (sample > @s_ave)
			# sample bigger than s_ave
			if (sample > @s_max)
				@s_max += @coeff_m_3 * (sample - @s_max)
			else
				#sample between s_ave and s_max
				@s_max -= @coeff_m_2 * (@s_max - @s_ave)
				if (sample > @s_max)
					@s_max = sample
				end
			end
			@s_min += @coeff_m_1 * (@s_ave - @s_min)	# slow coast to s_ave for s_min when sample > ave
		else
			#sample is less than s_ave
			if (sample < @s_min )
				@s_min += @coeff_m_3 * (sample - @s_min)
			else
				# sample between s_min and s_ave
				@s_min -= @coeff_m_2 * (@s_min - @s_ave)
				if (sample < @s_min)
					@s_min = sample
				end
			end
			@s_max -= @coeff_m_1 * (@s_max - @s_ave)	# slow coast to s_ave for s_max when sample < ave
		end

		# handle min and max
		if (sample > @max)
			@max = sample
		elsif (sample < @min)
			@min = sample
		end
		s_ave
	end
	def print_1
		sprintf("< %.1f:%.1f:%.1f >",@s_min*1000.0,@s_ave*1000.0,@s_max*1000.0)
	end
	def print_2
		sprintf("[%.1f < %.1f:%.1f:%.1f > %.1f]",@min*1000.0,@s_min*1000.0,@s_ave*1000.0,@s_max*1000.0,@max*1000.0)
	end
end
