require 'rgl/dot'
require 'rgl/adjacency'
require 'rgl/bidirectional'

module Hits
  
  class Graph
    attr_reader :graph
    
    def initialize
      @graph = RGL::DirectedAdjacencyGraph.new
      @in_links = {}
      @edge_weights = {}
    end
    
    def add_edge(from, to, weight = 1.0)
      @graph.add_edge(from, to)
      @in_links[to] ||= []
      @in_links[to] << from unless @in_links[to].include? from
      @edge_weights[[to, from]] = weight
    end
    
    def in_links(vertex)
      @in_links[vertex]
    end
    
    def out_links(vertex)
      @graph.adjacent_vertices(vertex)
    end
    
    def each_vertex(&b)
      @graph.each_vertex(&b)
    end
    
    def weight(to, from)
      @edge_weights[[to, from]]
    end
    
    def weight=(to, from, weight)
      @edge_weights[[to, from]] = weight if @edge_weights[[to, from]]
    end
    
    def max_weight
      @edge_weights.values.max
    end
    
    def min_weight
      @edge_weights.values.min
    end
    
    def weights
      @edge_weights.values
    end

    def to_s
      @graph.edges.to_a.to_s
    end
      
  end
end