module Hiteable
  include Bots

  def hiteable_by?(ua)
    if ua
      return false if WILD_CARDS.detect { |wc| ua.downcase.include? wc } or LIST.include? ua
    end

    true
  end

  def hit_view(ua, ip)
    if hiteable_by?(ua)
      key = "#{self.class.to_s}:#{self.id}:#{ip}"
      if $redis.get(key).nil?
        $redis.set(key, Time.now.to_i)
        self.class.increment_counter(:views, self.id)
        $redis.expire(key, Settings.redis.expire_view)
      end
    end
  end
end
