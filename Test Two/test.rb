require 'css_compressor'

compressor = CSSCompressor.new("input.css")
compressor.compress_to("output.css")