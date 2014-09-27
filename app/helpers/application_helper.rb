module ApplicationHelper
  def current_user
    User.find_by_id(session[:user_id])
  end
  
  def sanitize_full(text)
    options = Sanitize::Config.merge(Sanitize::Config::RELAXED, 
                                     attributes: {'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ["target"]})
    case 
      when text =~ /(youtu.be|youtube.com)/ 
	if action_name == 'show'
	  options = Sanitize::Config.merge(Sanitize::Config::RELAXED,
				      attributes: {'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ["target"], 'iframe' => ['width', 'height', 'src', 'frameborder', 'allowfullscreen', 'style']},
				      elements: Sanitize::Config::RELAXED[:elements] + ['iframe'])
	  insert_youtube(text)
	  else
	    remove_youtube(text)
	end
      when text =~ /(connect.garmin.com)/
	if action_name == 'show'
	  options = Sanitize::Config.merge(Sanitize::Config::RELAXED,
				      attributes: {'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ["target"], 'iframe' => ['width', 'height', 'src', 'frameborder', 'style']},
				      elements: Sanitize::Config::RELAXED[:elements] + ['iframe'])
	  insert_garmin(text)
	  else
	    remove_garmin(text)
	end
    end
    Sanitize.clean(text, options).html_safe
  end
  
  def insert_youtube(text)
    matches = text.scan(/(\S*)(youtu.be|youtube.com)(\S*)/)
    matches.each do |m|
      id = /^.*(youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^<#\&\?]*).*/.match(m.join(''))[2]
      iframe = "<iframe width='30%' style='float:right; padding-left: 10px;' src='//www.youtube.com/embed/#{id}?rel=0' frameborder='0' allowfullscreen></iframe>"
      text.gsub!(m.join(''), iframe)
    end
    text
  end
  
  def remove_youtube(text)
    matches = text.scan(/(\S*)(youtu.be|youtube.com)(\S*)/)
    matches.each do |m|
      text.gsub!(m.join(''), '')
    end
    text
  end
  
  def insert_garmin(text)
    matches = text.scan(/(\S*)(connect.garmin.com)(\S*)/)
    matches.each do |m|
      id = /\d+/.match(m.join(''))[0]
      iframe = "<iframe width='475' height='548' style='float:left; padding-right: 10px;' src='http://connect.garmin.com:80/activity/embed/#{id}' frameborder='0'></iframe>"
      text.gsub!(m.join(''), iframe)
    end
    text
  end
  
  def remove_garmin(text)
    matches = text.scan(/(\S*)(connect.garmin.com)(\S*)/)
    matches.each do |m|
      text.gsub!(m.join(''), '')
    end
    text
  end
    
  def sanitize_truncate(text)
    remove_youtube(text)
    remove_garmin(text)
    truncate(Sanitize.clean(text), :length => 500, :omission => '... ', :separator => ' ')
  end
end
