require 'rubygems'
require 'addressabler/uri'
require 'addressabler/uri_deprecation'

module Addressabler
  def self.all_tlds
    @all_tlds ||= {}.tap do |tlds|
      with_tld_file do |line|
        add_line_to_tlds(line, tlds)
      end
    end
  end

  def self.custom_tlds
    @custom_tlds ||= {}
  end

  def self.custom_tlds=(new_custom_tlds)
    @custom_tlds = new_custom_tlds
  end

  def self.parse_tld(host)
    host = host.to_s.split('.')
    tlds = []
    tlds = look_for_tld_in(private_tlds, host.dup) if use_private_tlds?
    tlds = look_for_tld_in(public_tlds.merge(custom_tlds), host.dup) if tlds.empty?
    tlds.join('.')
  end

  def self.private_tlds
    @private_tlds ||= {}.tap do |tlds|
      in_private_tlds = false
      with_tld_file do |line|
        if in_private_tlds
          add_line_to_tlds(line, tlds)
        elsif line =~ /BEGIN PRIVATE/
          in_private_tlds = true
        end
      end
    end
  end

  def self.public_tlds
    @public_tlds ||= {}.tap do |tlds|
      with_tld_file do |line|
        break if line =~ /END ICANN/
        add_line_to_tlds(line, tlds)
      end
    end
  end

  def self.use_private_tlds=(new_use_private_tlds)
    @use_private_tlds = new_use_private_tlds
  end

  def self.use_private_tlds?
    return @use_private_tlds if defined? @use_private_tlds
    @use_private_tlds = false
  end

  private # More for my own reference than anything else

  # Thanks Domainatrix for the parsing logic!
  def self.add_line_to_tlds(line, tlds)
    line = line.to_s.strip
    unless line == '' || line =~ /^\//
      parts = line.split(".").reverse
      sub_hash = tlds
      parts.each do |part|
        sub_hash = (sub_hash[part] ||= {})
      end
    end
  end

  def self.const_missing(name)
    if name.to_s == 'TLDS'
      deprecation_warning "Addressabler::TLDS will be replaced by Addressabler::public_tlds and Addressabler::private_tlds in Addressable 1.0"
      public_tlds
    else
      super
    end
  end

  def self.deprecation_warning(message)
    puts "ADDRESSABLER DEPRECATION WARNING: #{message}"
    non_addressable_caller = caller.find do |line|
      line !~ /#{File.expand_path(File.join(File.dirname(__FILE__), '..'))}/
    end
    if non_addressable_caller
      puts "  Called from:\n    #{non_addressable_caller}"
    end
  end

  def self.look_for_tld_in(sub_hash, host_parts)
    tlds = []
    while sub_hash = sub_hash[tld = host_parts.pop]
      tlds.unshift(tld)
      if sub_hash.has_key? '*'
        tlds.unshift(host_parts.pop)
      end
    end
    tlds
  end

  def self.with_tld_file
    File.readlines(File.join(File.dirname(__FILE__), 'tlds')).each do |line|
      yield line
    end
  end
end
