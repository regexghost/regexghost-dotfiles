#### Start Substitute - Image_Viewer
# Open images in gwenview
# The alias is called "rs" as I originally used Xfce with Ristretto
rs () {
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		gwenview . & disown
	else
		gwenview "$@" & disown
	fi
}
#### End Substitute
