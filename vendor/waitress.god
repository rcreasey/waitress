include GodHelper

God.watch do |w|
  w.name  = "waitress"
  w.group = 'waitress'
  w.autostart = true

  w.start     = "/usr/bin/rackup --pid /var/run/waitress.pid -p 8000 --env production -D /z/distro/waitress/config.ru"
  w.stop      = "kill `cat /var/run/waitress.pid`"
  w.restart   = "kill `cat /var/run/waitress.pid`; /usr/bin/rackup --pid /var/run/waitress.pid -p 8000 --env production -D /z/distro/waitress/config.ru"
  w.pid_file  = "/var/run/waitress.pid"
  w.grace     = 10.seconds
 
  default_configurations(w)
  restart_if_resource_hog(w, :memory_usage => false)
  monitor_lifecycle(w)
end
