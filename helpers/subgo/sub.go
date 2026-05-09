package main

import  (
	"fmt"
	"os"
	"regexp"
	"bufio"
	"strings"
	"io"
	"path/filepath"
	"crypto/sha256"
	"encoding/hex"
	"path"
)

type Paths struct {
	InputFilepath string
	TrueName string
	SubsDir string
}

type SubZone struct {
	StartLine int
	EndLine int
	ZoneName string
	Hash string
	CurrentInstance SubInstance
}

type SubInstance struct {
	Filename string
	Hash string
	SubName string
	Content []string
}

// Helpers

func panicIfErr(err error) {
	if err != nil {
		panic(err)
	}
}

func hashLines(lines []string) string {
	hash := sha256.New()
	asString := joinLines(lines)
	hash.Write([]byte(asString))
	return hex.EncodeToString(hash.Sum(nil))
}

func hashFile(filepath string) string {
	hash := sha256.New()
			
	file, err := os.Open(filepath)
	panicIfErr(err)
			
	_, err = io.Copy(hash, file)
	panicIfErr(err)
			
	return hex.EncodeToString(hash.Sum(nil))
}

// Get Zone and Sub names
// Zone = general name of area, Sub = specific instance of that area

func extractZoneName(line string) string {
	r, _ := regexp.Compile("Start Substitute - ([^ ]*)")
	return r.FindStringSubmatch(line)[1]
}

func extractZoneAndSubName(filename string) (string, string) {
	r, _ := regexp.Compile("([^-]*)-Substitution-([^-]*)")
	x := r.FindStringSubmatch(filename)
	return x[1], x[2]
}

// File handling

func readFileIntoLines(filename string) (lines []string) {
	file, err := os.Open(filename)
	panicIfErr(err)
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}

func fileParse(inputFile string) []string {
	lines := readFileIntoLines(inputFile)
	return lines
}

func joinLines(lines []string) string {
	return strings.Join(lines, "\n") + "\n"
}

func writeLinesToFile(lines []string, outputFile string) {
	file, err := os.Create(outputFile)
	panicIfErr(err)
	defer file.Close()
	_, err = file.Write([]byte(joinLines(lines)))
	panicIfErr(err)
}

// Input new name

func userInputName(prompt string) (name string) {
	fmt.Print("Enter name for sub (" + prompt + "): ")
	fmt.Scanln(&name)
	return name
}

func nameAlreadyTaken(name string, otherInstances []SubInstance) bool {
	for _, inst := range otherInstances {
		if name == inst.SubName {
			return true
		}
	}
	return false
}

// Get relevant subs for a specific file, and zone
func getRelevantInstances(paths Paths, zoneName string) (relevantInstances []SubInstance) {
	entries, err := os.ReadDir(paths.SubsDir)
	panicIfErr(err)
	for _, e := range entries {
		if strings.HasPrefix(e.Name(), zoneName + "-Substitution-") && strings.HasSuffix(e.Name(), paths.TrueName) {
			_, name := extractZoneAndSubName(e.Name())
			newInstance := SubInstance {
				Filename: e.Name(),
				Content: fileParse(filepath.Join(paths.SubsDir, e.Name())),
				SubName: name,
			}
			newInstance.Hash = hashLines(newInstance.Content)

			relevantInstances = append(relevantInstances, newInstance)
		}
	}

	return relevantInstances
}

// Extract zones from file
func extractZones(lines []string) ([]SubZone) {
	var curZone SubZone
	var zones []SubZone
	for i, line := range lines {
		if strings.Contains(line, "Start Substitute") {
			curZone = SubZone{}
			curZone.StartLine = i
			curZone.ZoneName = extractZoneName(line)
		}
		if strings.Contains(line, "End Substitute") {
			curZone.EndLine = i
			instance := SubInstance {
				Content: lines[curZone.StartLine:i+1],
			}
			instance.Hash = hashLines(instance.Content)
			curZone.CurrentInstance = instance
			zones = append(zones, curZone)
		}
	}

	return zones
}

// Check for any new subsitutions and handle them
func newSubs(paths Paths) {
	lines := fileParse(paths.InputFilepath)
	zones := extractZones(lines)
	
	for _, zone := range zones {
		match := false
		hash := zone.CurrentInstance.Hash
		relevantInstances := getRelevantInstances(paths, zone.ZoneName)
		// If there are existing instances for this zone, check for a match
		for _, inst := range relevantInstances {
			if inst.Hash == hash {
				match = true
				break
			}
		}
		
		// If we get a match don't save again
		if !match {
			newSub(paths, zone, relevantInstances)
		}
	}
}

// Get name for new substitution and save
func newSub(paths Paths, zone SubZone, otherInstances []SubInstance) {
	name := userInputName(zone.ZoneName)
	for nameAlreadyTaken(name, otherInstances) {
		name = userInputName(zone.ZoneName)
	}
	saveNewSub(paths, zone, name)
}

// Write a new sub to file
func saveNewSub(paths Paths, zone SubZone, name string) {
	filename := paths.SubsDir + "/" + zone.ZoneName + "-Substitution-" + name + "-" + paths.TrueName
	writeLinesToFile(zone.CurrentInstance.Content, filename)
}

// Prompt the user to pick between substitutions
func userPickSub(paths Paths, line string) []string {
	zoneName := extractZoneName(line)
	relevantInstances := getRelevantInstances(paths, zoneName)
	for i, inst := range relevantInstances {
		fmt.Printf("%d: %s\n", i+1, inst.SubName)
	}
	var choice int
	fmt.Print("Pick sub to use: ")
	fmt.Scanln(&choice)
	chosenInst := relevantInstances[choice-1]
	return readFileIntoLines(path.Join(paths.SubsDir, chosenInst.Filename))
}

// Assemble a final config file from base file and user chosen substitutions
func makeFinalFile(paths Paths, outputFile string) {
	lines := fileParse(paths.InputFilepath)
	var finalLines []string
	for i, line := range lines {
		_ = i
		if strings.Contains(line, "Start Substitute") {
			newLines := userPickSub(paths, line)
			finalLines = append(finalLines, newLines...)
		} else {
			finalLines = append(finalLines, line)
		}
	}

	writeLinesToFile(finalLines, outputFile)
}

// Remove all substitutions from a file, leaving only the header
func cleanFile(paths Paths, outputFile string) {
	lines := fileParse(paths.InputFilepath)
	zones := extractZones(lines)

	var finalLines []string
	previous := -1
	for _, zone := range zones {
		finalLines = append(finalLines, lines[previous+1:zone.StartLine+1]...)
		previous = zone.EndLine
	}
	finalLines = append(finalLines, lines[previous+1:]...)

	writeLinesToFile(finalLines, outputFile)
}

func printHelp() {
	fmt.Println("Usage:")
	fmt.Println("  sub save proper_filename /path/to/subs/ path/to/input_file")
	fmt.Println("  sub make proper_filename /path/to/subs/ path/to/clean_file path/to/output_file")
	fmt.Println("    e.g. sub make tmux.conf /path/to/subs/ path/to/tmux.conf final/tmux.conf")
	fmt.Println("  sub clean proper_filename /path/to/subs path/to/input_file path/to/output_file")
}

func main() {
	if len(os.Args) < 5 {
		printHelp()
		os.Exit(1)
	}
	command := os.Args[1]
	paths := Paths{
		InputFilepath: os.Args[4],
		SubsDir: os.Args[3],
		TrueName: os.Args[2],
	}
	
	if command == "save" {
		newSubs(paths)
	} else if command == "clean" {
		if len(os.Args) != 6 {
			printHelp()
			os.Exit(1)
		}
		outputFile := os.Args[5]
		cleanFile(paths, outputFile)
	} else if command == "make" {
		if len(os.Args) != 6 {
			printHelp()
			os.Exit(1)
		}
		outputFile := os.Args[5]
		makeFinalFile(paths, outputFile)
	}
}
