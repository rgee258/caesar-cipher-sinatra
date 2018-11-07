require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

post '/results' do
  @results = caesar_cipher(params[:str], params[:shift].to_i, params[:direction])
  erb :index
end

def caesar_cipher(text, shift_count, direction)

  # Check for valid shift count and direction inputs
  unless (direction == "right" || direction == "left")
    return "Invalid direction choice, please try again."
  end
  unless (shift_count > -1)
    return "Invalid shift count, please try again."
  end

  alphabet = ("a".."z").to_a.join("")
  text = text.split("")

  # Use map! to modify the array values of text instead of mapping them to a new one
  text.map! { |x|
    # Check for any non-letter character with match, which does not return nil if it is
    if (!(x.match(/[^A-Za-z]/).nil?))
      # If it's not nil, then return the non-letter character
      x
    else
      # Check for caps
      is_capped = false
      if (x == x.upcase)
        is_capped = true
        x.downcase!
      end
      # Convert x into matching index val
      current_index = alphabet.index(x)
      if (direction == "right")
        current_index = (current_index + shift_count) % 26
      else
        current_index = (current_index - shift_count) % 26
      end
      x = alphabet[current_index]
      # Make cap again
      if (is_capped)
        x.upcase!
      end
      # Return conversion
      x
    end
  }

  text.join("")
end