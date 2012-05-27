module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the new user page/
      new_user_path

    when /the new usergroup page/
      new_usergroup_path

    when /the new tool page/
      new_tool_path

    when /the new step page/
      new_step_path

    when /the new product page/
      new_product_path

    when /the new material page/
      new_material_path

    when /the new manual page/
      new_manual_path

    when /the new language page/
      new_language_path

    when /the page of usergroup named "(.+)"/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/usergroup"
      usergroups = tm.get(topicType).instances
      group = usergroups.select{  |x| x.occurrences.try(:first).try(:value) == $1 }.first unless usergroups.blank?
      usergroup_path(group.id) unless group.blank?

    when /the page of manual named "(.+)"/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/manual"

      manuals = tm.get(topicType).instances
      manual = manuals.select{  |x| x.occurrences.try(:first).try(:value) == $1 }.first unless manuals.blank?
      manual_path(manual.id) unless manual.blank?

    when /the page of product named "(.+)"/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/product"

      products = tm.get(topicType).instances
      product = products.select{  |x| x.occurrences.try(:first).try(:value) == $1 }.first unless products.blank?
      product_path(product.id) unless product.blank?

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
