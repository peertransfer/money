class Money
  class Currency
    module NewHeuristics
      include Money::Currency::Heuristics

      def currencies_by_iso_code
        TreeBuilder.build(table).as_hash
      end

      def currencies_by_symbol
        {}.tap do |r|
          table.each do |_, c|
            symbol = (c[:symbol]||"").downcase
            symbol.chomp!('.')
            (r[symbol] ||= []) << c

            (c[:alternate_symbols]||[]).each do |ac|
              ac = ac.downcase
              ac.chomp!('.')
              (r[ac] ||= []) << c
            end
          end
        end
      end

      class TreeBuilder
        def self.build(currencies)
          new(currencies).build
        end

        def initialize(currencies)
          @currencies = Currencies.new(currencies)
          @tree = Tree.new
        end

        def build
          create_branches_from(@currencies.by_iso_code)
          @tree
        end

        private

        def create_branches_from(currencies)
          currencies.each do |iso_code, currency|
            @tree.add_node_to_branch(currency, iso_code)
          end
        end
      end

      class Currencies
        def initialize(currencies)
          @currencies = currencies
        end

        def by_iso_code
          @currencies.each_with_object({}) do |(_, value), currencies_by_iso_code|
            currencies_by_iso_code[value[:iso_code].downcase] = value
          end
        end
      end

      class Tree
        def initialize
          @branches = {}
        end

        def add_node_to_branch(node, branch)
          @branches[branch] = [node]
        end

        def as_hash
          @branches
        end
      end
    end
  end
end