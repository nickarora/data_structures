class Object
	# call the method if the object exists!
	def try(method, *args)
		self && self.send(method, *args)
	end
end

class AVLTreeNode
	attr_accessor :value, :parent, :left, :right, :depth

	def initialize(value)
		@value = value
		@depth = 1
	end

	# returns the current balance
	# based on a comparison of the right child
	# and left child's depth
	def balance
		(right.try(:depth) || 0) - (left.try(:depth) || 0)
	end

	# a balanced tree has a depth-differential of
	# no more than 1
	def balanced?
		balance.abs < 2
	end

	# determine if this is a left branch
	# or right branch
	def parent_side
		return nil if parent.nil?
		parent.left == self ? :left : :right
	end

	def recalculate_depth!
		@depth = [
			left.try(:depth) || 0,
			right.try(:depth) || 0
		].max + 1
	end
end

class AVLTree

	def initialize
		@root = nil
	end

	def empty?
		@root.nil?
	end

	def include?(value)
		vertex, parent = find(value)
		!!vertex
	end

	def insert(value)
		# make it the root in an empty tree
		if empty?
			@root = AVLTreeNode.new(value)
			return true
		end

		# don't insert it if we already have
		# a value
		vertex, parent = find(value)
		return false if vertex

		# if we made it this far
		# vertex = nil
		# parent = final node in tree
		# now we can insert it
		vertex = AVLTreeNode.new(value)
		if value < parent.value
			parent.left = vertex
		else
			parent.right = vertex
		end

		vertex.parent = parent

		# rebalance as necessary
		update(parent)

		true
	end

  def traverse(vertex = @root, &prc)
    return if vertex.nil?
    traverse(vertex.left, &prc)
    prc.call(vertex.value, vertex)
    traverse(vertex.right, &prc)
  end

	protected

	def find(value)
		vertex = @root
		parent = nil

		until vertex.nil?
			# found?
			break if vertex.value == value

			# down a level
			parent = vertex
			if value < vertex.value
				vertex = vertex.left
			else
				vertex = vertex.right
			end
		end

		[vertex, parent]
	end

	def update(vertex)

		return if vertex.nil?

		# more left children
		if vertex.balance == -2

			# first balance left child
			if vertex.left.balance == 1
				left_rotate!(vertex.left)
			end

			# then go to town right rotating
			right_rotate!(vertex)
		elsif vertex.balance == 2

			# first balance right child
			if vertex.right.balance == -1
				right_rotate!(vertex.right)
			end

			# then go to town left rotating
			left_rotate!(vertex)
		elsif vertex.balance.abs < 2
		else
			# should not be here!
			raise "Tree Should Overly Imbalanced!"
		end
	end

	def left_rotate!(parent)
		parent_parent = parent.parent
		parent_side = parent.parent_side

		r_child = parent.right
		rl_child = r_child.try(:left) # possibly nil

		# not root and a left branch
		if parent_parent && parent_side == :left

			# left child has become the old right child
			parent_parent.left = r_child

		# not root and a right branch
		elsif parent_parent && parent_side == :right
			parent_parent.right = r_child
		else
			@root = r_child
		end
		r_child.parent = parent_parent

		r_child.left = parent
		parent.parent = r_child

		parent.right = rl_child
		rl_child.parent = parent if rl_child

		parent.recalculate_depth
	end

  def right_rotate!(parent)
    parent_parent, parent_side = parent.parent, parent.parent_side
    l_child = parent.left
    lr_child = l_child.try(:right)

    if parent_parent && parent_side == :left
      parent_parent.left = l_child
    elsif parent_parent && parent_side == :right
      parent_parent.right = l_child
    else
      @root = l_child
    end
    l_child.parent = parent_parent

    l_child.right = parent
    parent.parent = l_child

    parent.left = lr_child
    lr_child.parent = parent if lr_child

    parent.recalculate_depth!
  end

end

tree = AVLTree.new
nums = (1...100).to_a.sample(50).shuffle!
nums.each { |num| tree.insert(num) }
nums.each do |num|
  fail unless tree.include?(num)
end

tree.traverse { |_, vertex| fail unless vertex.balanced? }
