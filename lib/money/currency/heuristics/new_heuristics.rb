class Money
  class Currency
    module NewHeuristics
      include Money::Currency::Heuristics

      def currencies_by_iso_code
        Tree.new(table).as_hash
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

      class Tree
        def initialize(currencies)
          @currencies = currencies
          @nodes = {}
        end

        def as_hash
          build

          @nodes
        end

        private

        def build
          @currencies.each do |_, currency|
            path = currency[:iso_code].downcase
            add(path, currency)
          end
        end

        def add(path, node)
          (@nodes[path] ||= []) << node
        end
      end
    end
  end
end