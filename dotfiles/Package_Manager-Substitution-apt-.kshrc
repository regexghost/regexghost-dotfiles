#### Start Substitute - Package_Manager
alias install='sudo apt install'
alias remove='sudo apt remove'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias fullup='sudo apt update && sudo apt upgrade'
alias search='apt search'
alias aptlog='cat /var/log/dpkg.log | grep'

pacs () {
	numberOfPackages="$(apt list --installed | wc -l)"
	echo "${numberOfPackages} packages installed"
}
#### End Substitute
