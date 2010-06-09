include GodHelper

God.watch do |w|
  w.name  = "redis"
  w.group = 'redis'
  w.autostart = true

  w.start     = "/usr/local/redis/redis-server /z/distro/waitress/vendor/redis.conf"
  w.stop      = "kill `cat /var/run/redis.pid`"
  w.restart   = "kill `cat /var/run/redis.pid`; /usr/local/redis/redis-server server /z/distro/waitress/vendor/redis.conf"
  w.pid_file  = "/var/run/redis.pid"
  w.grace     = 10.seconds
 
  default_configurations(w)
  restart_if_resource_hog(w, :memory_usage => false)
  monitor_lifecycle(w)
end
