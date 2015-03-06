class BinaryTree
	
	def self.from_array(arr)
		root = Node.new(arr.first)
		tree = BinaryTree.new(root)
		arr[1..-1].each do |n|
			tree.insert(n)
		end
		tree
	end

	def initialize(root = nil)
		@root = root
	end

	def inspect
		@root.inspect
	end

	def insert(val)
		@root.insert(val)
	end

	def include?(val)
		@root.include?(val)
	end

	def each(&block)
		@root.each(&block)
	end

	def find_greater_than(n)
		result = nil
		@root.each do |node|
			break if result
			result = node.data if node > n
		end
		result
	end

end

class Node
	include Comparable

	attr_accessor :data, :left, :right
	
	def initialize(data)
		@data = data
		@left = nil
		@right = nil
	end
	
	def inspect
		"#{@data} => [left: #{@left.inspect} | right: #{right.inspect}]"
	end

	def insert(val)
		case val <=> @data
		when -1
			insert_left(val)
		when 1
			insert_right(val)
		when 0
			false
		end
	end

	def insert_left(val)
		if @left
			@left.insert(val)
		else
			@left = Node.new(val)
		end
	end

	def insert_right(val)
		if @right
			@right.insert(val)
		else
			@right = Node.new(val)
		end
	end

	def include?(val)
		case val <=> @data
		when -1
			if @left 
				@left.include?(val) 
			else
				false
			end
		when 1
			if @right
				@right.include?(val)
			else
				false
			end
		when 0
			then true
		end
	end

	def each(&block)
		left.each(&block) if left
		block.call(self)
		right.each(&block) if right
	end

	def <=>(other)
		if other.class == Node
			data <=> other.data
		elsif other.class == Fixnum
			data <=> other
		end
	end

end


arr = (1..200).to_a.shuffle
arr = arr.take(50)
tree = BinaryTree.from_array(arr)

p tree.find_greater_than(25)