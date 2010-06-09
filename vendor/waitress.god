include GodHelper

God.watch do |w|
  w.name  = "waitress"
  w.group = 'waitress-group'
  w.autostart = true

  w.start     = "/usr/bin/thin -C /z/distro/waitress/config.yml -R /z/distro/waitress/config.ru start"
  w.stop      = "/usr/bin/thin -C /z/distro/waitress/config.yml -R /z/distro/waitress/config.ru stop"
  w.restart   = "/usr/bin/thin -C /z/distro/waitress/config.yml -R /z/distro/waitress/config.ru restart"
  w.pid_file  = "/var/run/waitress.pid"
  w.grace     = 10.seconds
 
  default_configurations(w)
  restart_if_resource_hog(w, :memory_usage => false)
  monitor_lifecycle(w)
end
