class Grade
  include Comparable
  attr_reader :enumeration_value, :string_rep

  def initialize(grade)
    @string_rep = grade
    letter = grade[0,1]
    mark = grade[1,2]

    #######################################################################################
    # I created a hash (lookup table) of what each character in your grade is worth
    # Grades with no mark will get an additional point added to their letter value
    # Using my scheme, ultimately, grade enumeration will come out as:
    #
    #  A+ = 14
    #  A  = 13
    #  A- = 12
    #  B+ = 11
    #  B  = 10
    #  B- = 9
    #  C+ = 8
    #  C  = 7
    #  C- = 6
    #  D+ = 5
    #  D  = 4
    #  D- = 3
    #  F+ = 2
    #  F  = 1
    #  F- = 0
    #  Any other grade representation gets -1
    #
    ######################################################################################

    lookup_table = Hash["A" => 12, "B" => 9, "C" => 6, "D" => 3, "F" => 0, "+" => 2, "-" => 0]

    letter_value = lookup_table[letter]
    if letter_value != nil
      if grade.size == 1
        @enumeration_value = letter_value + 1
      elsif grade.size == 2 && mark_value = lookup_table[mark] != nil
        @enumeration_value = letter_value + mark_value
      else
        @enumeration_value = -1
        puts "The input is not properly formatted:
    ( '" + mark + "' is not a valid mark)
    ( '+' and '-' are the only valid marks you can add to a letter grade)"
      end
    else
      @enumeration_value = -1
      puts "The input is not properly formatted:
    ( '" + letter + "' is not a valid letter)
    ( 'A', 'B', 'C', 'D', and 'F' are the only valid letter grades)"
    end
  end

  def <=>(another)
    @enumeration_value <=> another.enumeration_value
  end
end

a_plus = Grade.new("R+")
a = Grade.new("A*")
list = [a_plus, a]
list.sort!
puts list[0].string_rep + " " + list[0].enumeration_value.to_s,list[1].string_rep + " " + list[1].enumeration_value.to_s