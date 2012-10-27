class CSSCompressor
  def initialize(filename)
    @contents = File.read(filename)
    #puts @contents
  end

  def compress_to(destination_filename)

    # ^\s*\/\*[^\n]*\*\/\s*\n matches comments that start/end on the same line
    # ^\s*\n takes care of blank lines including lines with only white space

    compressed_string = @contents.gsub /^\/\*[^\n]*\*\/\s*\n|^\s*\n/, ''
    #puts compressed_string
    File.open(destination_filename, 'w') { |file| file.write(compressed_string) }
  end

  def better_compress_to(destination_filename)

    # this is a better compress_to that still keeps the syntax of the css
    # obviously getting rid of comments and whitespace is the best text compression,
    # but it makes things unreadable

    # ^\s*\/\*[^\n]*\*\/\s*\n matches comments that start/end on the same line
    # \/\*.*\*\/ takes care of any comments, including multi-line
    # ^\s*\n takes care of blank lines including lines with only white space

    compressed_string = @contents.gsub /^\s*\/\*[^\n]*\*\/\s*\n|^\s*\n|\/\*.*\*\//m, ''
    #puts compressed_string
    File.open(destination_filename, 'w') { |file| file.write(compressed_string) }

    end
end



