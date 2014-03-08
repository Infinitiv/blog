module ApplicationHelper
  def current_user
    User.find_by_id(session[:user_id])
  end
  
  def sanitize_full(text)
    options = Sanitize::Config::RELAXED
    options[:attributes]['a'].push('target')
    if text =~ /(youtu.be|youtube.com)/ 
      if action_name == 'show'
	options[:elements].push('iframe')
	options[:attributes]['iframe'] = ['width', 'height', 'src', 'frameborder', 'allowfullscreen', 'style']
	insert_youtube(text)
	else
	  remove_youtube(text)
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
    
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 300, :omission => '... ', :separator => ' ')
  end
end
