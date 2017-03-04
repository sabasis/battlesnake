class Squirrel
	def initialize tree:
		@tree = tree
		@bfd
	end

	#######################
	# Depth First Search
	#######################
	# 
	# Advantages:
	#  * iz real easy yo
	# 
	def bottoms_up_method
		# 1. take the nodes that went the farthest (i.e.: max tree level)
		max_level = @tree.tree_bottom.collect(&:level).max
		# 2. Of those, use the one with the minimum sum value
		winner = @tree.tree_bottom.select{|t|t.level==max_level}.min_by(&:sum)
		# binding.pry 
		bottoms_up_dir(winner).dir
	end

	#############################
	# "Breadth First Search"-ish
	#############################
	#
	# Advantages: 
	#  * can paths that may end safely, but have "dangerous" portions
	#
	# How:
	#   * Option 1: by setting "thresholds" per tree level. Branches that don't pass the threshold are eliminated
	#   * Option 2: Ranking nodes on a level and eliminating a certain percentage of routes 
	#            --> Elimite nodes first by if they have children
	#            --> Then by sum
	#
	def bfd_method
		current_level = @tree.tree.level
		winners = child_filter(@tree.tree.children, 0)
		winner_sum =  winners.first.sum
		tied_winners = winners.select{|w| w.sum ==winner_sum}.collect{|w| bottoms_up_dir(w)}
		tied_winners.min_by(&:sum).dir
	end

	private 

	# scans the children, ranks them, discards the rest
	def child_filter nodes, level
		
		if (level >= 2)
			nodes_with_children = nodes.select{|p| !p.children.empty?}

			# if nodes.length == 1 # no sense traversing down the rest of the tree if only one path left
			# 	return nodes.first
			# end

			if nodes_with_children.length == 0
				# binding.pry
				return nodes.sort_by(&:sum)
			else
				children = nodes_with_children.collect(&:children).flatten.sort_by(&:sum)
				# 
				# Filter some out
				#
				threshold_index = threshold_calc(level: level+1, length: children.length )
				surviving_children = children[0..threshold_index] 

				child_filter(surviving_children, level+1)
			end

		else
			child_filter(nodes.collect(&:children).flatten, level+1)
		end
	end

	def bottoms_up_dir node
		if node.parent.level == 0
			return node
		end
		bottoms_up_dir(node.parent)
	end

	def threshold_calc level:, length: 
		optimal_num_nodes = 3**level
		if length < (optimal_num_nodes*Config::Tree::MIN_THRESHOLD).floor
			return length
		end
		return (length*Config::Tree::THRESHOLD).floor
	end
end