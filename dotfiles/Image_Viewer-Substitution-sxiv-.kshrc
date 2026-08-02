#### Start Substitute - Image_Viewer
# Open images in sxiv
# The alias is called "rs" as I originally used Xfce with Ristretto
rs () {
	toOpen="$@"
	if [[ "$toOpen" == "" ]]; then
		setsid sxiv .
	else
		setsid sxiv "$@"
	fi
}
#### End Substitute
