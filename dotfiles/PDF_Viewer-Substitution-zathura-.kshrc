#### Start Substitute - PDF_Viewer
# Open pdf files in Zathura
pdf () {
	for arg; do
		setsid zathura "$arg"
	done
}
#### End Substitute
