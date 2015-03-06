class Node
	attr_accessor :node, :next

	def initialize(node)
		@node = node
	end

	# Time O(n), space O(1)
	def self.reverse(first)
		return unless first
		
		rest = first.next
		return unless rest

		Node.reverse(rest)
		first.next.next = first

		first.next = nil
	end

	# visualize the list
	def self.node_list(node, msg = "")
		return msg if node.nil?
		node_list(node.next, msg << "#{node.node} -> ")
	end
end

node1 = Node.new("First")
node2 = Node.new("Second")
node1.next = node2
p Node.node_list(node1)
Node.reverse(node1)
p Node.node_list(node2)