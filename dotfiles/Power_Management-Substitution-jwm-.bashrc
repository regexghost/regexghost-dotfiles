#### Start Substitute - Power_Management
## Shutdown with confirmation
shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	if [[ "$yesOrNoShutdown" == "y" ]]; then
		tmux send-keys -t buffer_tmux.0 C-s
		tmux send-keys -t buffer_tmux.0 C-q
		tmux kill-session -t buffer_tmux
		/usr/sbin/shutdown -h 0
	fi
}

## Reboot with confirmation
reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	if [[ "$yesOrNoReboot" == "y" ]]; then
		tmux send-keys -t buffer_tmux.0 C-s
		tmux send-keys -t buffer_tmux.0 C-q
		tmux kill-session -t buffer_tmux
		/usr/sbin/reboot
	fi
}

## Hibernate to disk with confirmation
hibernate () {
	read -p "Hibernate? (y/N) " yesOrNoHibernate
	[[ "$yesOrNoHibernate" == "y" ]] && qdbus6 org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Hibernate
}

## Hybrid-Sleep with confirmation, i.e. sleep to RAM and disk in case battery dies
hybrid-sleep () {
	read -p "Hybrid-Sleep? (y/N) " yesOrNoHybridSleep
	[[ "$yesOrNoHybridSleep" == "y" ]] && systemctl hybrid-sleep
}

## Sleep with confirmation (i.e. RAM only)
qsleep () {
	read -p "Sleep? (y/N) " yesOrNoQSleep
	[[ "$yesOrNoQSleep" == "y" ]] && qdbus6 org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Suspend
}

## Log Out with confirmation
log-out () {
	read -p "Log Out? (y/N) " yesOrNoLogOut
	[[ "$yesOrNoLogOut" == "y" ]] && qdbus6 org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout
}

## Lock screen with confirmation
lock () {
	read -p "Lock Screen? (y/N) " yesOrNoLock
	[[ "$yesOrNoLock" == "y" ]] && qdbus6 org.kde.screensaver /ScreenSaver Lock
}
#### End Substitute
