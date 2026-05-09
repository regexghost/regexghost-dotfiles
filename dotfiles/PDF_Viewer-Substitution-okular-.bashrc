#### Start Substitute - PDF_Viewer
# Open pdf files in Okular
pdf () {
	for arg; do
		okular "$arg" & disown
	done
}
#### End Substitute
