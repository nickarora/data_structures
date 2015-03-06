class HashSet
	def initialize
		@buckets = Array.new(8) { [] }
		@count = 0
	end

	#O(1) - ammortized
	def include?(value)
		bucket_for(value).include?(value)
	end

	def insert(value)
		return false if include?(value)

		self.resize! if (count + 1).fdiv(buckets.length) > 1.00

		bucket_for(value) << value
		self.count += 1

		true
	end

	def remove(value)
		return unless include?(value)

		bucket_for(value).delete(value)
		self.count -= 1
	end

	def bucket_for(value, buckets = self.buckets)
		buckets[value_hash(value) % buckets.length]
	end

	def value_hash(value)
		value
	end

	def resize!
		new_buckets = Array.new(buckets.length * 2) { [] }

		buckets.each do |bucket|
			bucket.each do |item| # Expect only one value, but just in case of collision
				bucket_for(item, new_buckets) << item
			end
		end

		@buckets = new_buckets
	end
end