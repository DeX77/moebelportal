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

    when /the page of (.+) named "(.+)"/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/"+$1

      instances = tm.get(topicType).instances
      single_instance = instances.select{  |x| x.occurrences.try(:first).try(:value) == $2 }.first unless instances.blank?
      url_for :controller => $1.pluralize, :only_path => true, :action => 'show', :id => single_instance.id unless single_instance.blank?

    when /a non existing (.+) page/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/"+$1

      all_instances = tm.instances
      topic_instances = tm.get(topicType).instances
      not_topic_instances = all_instances - topic_instances

      random_id = not_topic_instances.map { |x| x.id }.sample

      "/#{$1.pluralize}/#{random_id}"

    when /the edit page of (.*) "(.*)"/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/"+$1

      instances = tm.get(topicType).instances
      single_instance = instances.select{  |x| x.occurrences.try(:first).try(:value) == $2 }.first unless instances.blank?
      url_for :controller => $1.pluralize, :only_path => true, :action => 'edit', :id => single_instance.id unless single_instance.blank?

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
