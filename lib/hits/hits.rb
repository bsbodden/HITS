module Hits

  class Hits
    
    def initialize(graph)
      @graph = graph
      @hub_scores = {}
      @authority_scores = {}
      @graph.each_vertex do |vertex|
        @hub_scores[vertex] = 1.0
        @authority_scores[vertex] = 1.0
      end
    end
    
    def compute_hits(iterations = 25)
      (1..iterations).each do
        @graph.each_vertex do |vertex|
          authority_score = @graph.in_links(vertex).inject(0.0) { |sum, vertex| sum + @hub_scores[vertex] }
          hub_score = @graph.out_links(vertex).inject(0.0) { |sum, vertex| sum + @authority_scores[vertex] }
          @authority_scores[vertex] = authority_score
          @hub_scores[vertex] = hub_score    
        end
      end
    end
    
    def top_hub_scores(how_many=5)
      @hub_scores.sort_by { |k,v| v }.collect { |v| v[0] }.reverse.first(how_many)
    end
    
    def top_authority_scores(how_many=5)
      @authority_scores.sort_by { |k,v| v }.collect { |v| v[0] }.reverse.first(how_many)
    end

  end
     
end