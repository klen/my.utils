install:
	mkdir -p /etc/supervisor/conf.d
	cp supervisor.conf /etc/supervisisor
	cp conf.d/README /etc/supervisor/conf.d
	cp init.d/supervisor /etc/init.d
	update-rc.d supervisor defaults
	/etc/init.d/supervisor start
