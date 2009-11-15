require 'rubygems'
require '../lib/hits/hits'
require '../lib/hits/graph'

# create a graph
graph = Hits::Graph.new

# add some edges to the graph with weights
graph.add_edge(:bsbodden, :objo, 1.0)
graph.add_edge(:bsbodden, :nusairat, 2.0)
graph.add_edge(:bsbodden, :looselytyped, 3.0)
graph.add_edge(:bsbodden, :neal4d, 8.5)
graph.add_edge(:objo, :nusairat, 2.5)
graph.add_edge(:objo, :bsbodden, 1.0)
graph.add_edge(:neal4d, :bsbodden, 1.15)
graph.add_edge(:nusairat, :bsbodden, 4.5)

# textual display of the graph
puts "graph ==> #{graph}"
puts "graph max weight ==> #{graph.max_weight}"
puts "graph min weight ==> #{graph.min_weight}"

# create a HITS for the graph
hits = Hits::Hits.new(graph)

# show the vertexes incoming and outgoing links (inlinks and outlinks)
graph.each_vertex do |vertex| 
  puts "=== In links for #{vertex} ==="
  graph.in_links(vertex).each { |in_link| puts in_link }
  puts "=== Out links for #{vertex} ==="
  graph.out_links(vertex).each { |out_link| puts out_link }
end

# compute HITS with the default number of iterations
hits.compute_hits

# print the top HUBS and AUTHORITIES
puts "=== TOP HUBS ==="
hits.top_hub_scores.each do |hub|
  puts "hub #{hub}"
end

puts "=== TOP AUTHORITIES ==="
hits.top_authority_scores.each do |authority|
  puts "authority #{authority}"
end

# print all scores
graph.each_vertex do |vertex|
   puts "vertex: #{vertex}, authority: #{hits.authority_scores[vertex]}, hub: #{hits.hub_scores[vertex]}"
end

