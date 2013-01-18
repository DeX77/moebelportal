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
      
    when /the login page/
      '/login'
      
    when /the logout page/
      '/logout'
      
    when /the new user page/
      '/user/create'

    when /the new usergroup page/
      '/usergroup/create'

    when /the new tool page/
      '/tool/create'

    when /the new step page/
      '/step/create'

    when /the new product page/
      '/product/create'

    when /the new material page/
      '/material/create'

    when /the new manual page/
      '/manual/create'

    when /the new language page/
      "/language/create"
      
    when /the languages page/
      "/language/list"
      
    when /the users page/
      "/user/list"
      
    when /the tools page/
      '/tool/list'
      
    when /the materials page/
      '/material/list'
      
    when /the usergroups page/
      '/usergroup/list'
      
    when /the manuals page/
      '/manual/list'
      
    when /the products page/
      '/'
      
    when /the steps page/
      '/step/list'

    when /the page of (.+) named "(.+)"/
      base_locator = "http://moebelportal.topicmapslab.de"
      tm = RTM[base_locator]
      topicType = base_locator + "/types/"+$1

      instances = tm.get(topicType).instances
      single_instance = instances.select{  |x| x.occurrences.try(:first).try(:value) == $2 }.first unless instances.blank?
      url_for :controller => $1.pluralize, :only_path => true, :action => 'show', :id => single_instance.id unless single_instance.blank?

    when /a non existing (.+) page/      
      "/#{$1}/show/pretty_sure_this_is_wrong"

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
