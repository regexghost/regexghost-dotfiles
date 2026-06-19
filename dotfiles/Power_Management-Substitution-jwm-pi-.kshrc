#### Start Substitute - Power_Management
## Shutdown with confirmation
shutdown () {
	read yesOrNoShutdown"?Shutdown? (y/N) "
	if [[ "$yesOrNoShutdown" == "y" ]]; then
		mocp -M "$XDG_CONFIG_HOME/moc" --stop
		rm -rf "$XDG_CACHE_HOME/reddit-rss"
		cp /tmp/reddit-rss "$XDG_CACHE_HOME/reddit-rss"
		/usr/sbin/shutdown -h 0
	fi
}

## Reboot with confirmation
reboot () {
	read yesOrNoReboot"?Reboot? (y/N) "
	if [[ "$yesOrNoReboot" == "y" ]]; then
		mocp -M "$XDG_CONFIG_HOME/moc" --stop
		/usr/sbin/reboot
	fi
}

## Hibernate to disk with confirmation
hibernate () {
	read yesOrNoHibernate"?Hibernate? (y/N) "
	[[ "$yesOrNoHibernate" == "y" ]] && systemctl hibernate
}

## Hybrid-Sleep with confirmation, i.e. sleep to RAM and disk in case battery dies
hybrid-sleep () {
	read yesOrNoHybridSleep"?Hybrid-Sleep? (y/N) "
	[[ "$yesOrNoHybridSleep" == "y" ]] && systemctl hybrid-sleep
}

## Sleep with confirmation (i.e. RAM only)
qsleep () {
	read yesOrNoQSleep"?Sleep? (y/N) "
	[[ "$yesOrNoQSleep" == "y" ]] && systemctl suspend
}

## Log Out with confirmation
log-out () {
	read yesOrNoLogOut"?Log Out? (y/N) "
	[[ "$yesOrNoLogOut" == "y" ]] && jwm -exit
}

## Lock screen with confirmation
lock () {
	read yesOrNoLock"?Lock Screen? (y/N) "
	[[ "$yesOrNoLock" == "y" ]] && slock
}
#### End Substitute
