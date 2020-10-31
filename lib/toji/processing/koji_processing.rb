module Toji
  module Processing
    module KojiProcessing
      include RiceProcessing

      # 出麹実績値 (Toji::Processing::Dekoji)
      attr_reader :dekoji
    end
  end
end
