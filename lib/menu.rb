module Menu

  def display_menu
    system("clear")
    prompt = TTY::Prompt.new
    return prompt.select("--==+ MENU +==--", (["My List", "Generate Suggestions", "Edit Account Details"]))
  end

  def my_list
    system("clear")
    prompt = TTY::Prompt.new
    selection = prompt.select("--==+ TOP TEN +==--", (["Display", "Add", "Remove"]))
    case selection
      when "Display"
        puts "Your Top Ten:"
        MyList::list
        back = prompt.keypress("Press <space> or <enter> to return to the previous menu")
        top_ten
      when "Add"
        name = prompt.ask("")
      when "Remove"
    end
  end

  def menu_router
    selection = display_menu
    case selection
      when "My List"
        system("clear")
        MyList::list
      when "Generate Suggestions"
        puts "Generate Suggestions Selected"

      when "Edit Account Details"
        puts "Account Details Selected"
    end
  end

end