package main

import (
	"fmt"
	"encoding/csv"
	"github.com/gdamore/tcell/v2"
	"os"
	"os/exec"
)

var styles = map[string]tcell.Style{}
var termHeight int
var termWidth int

var homeDir string

type sound struct {
	name string
	path string
	key rune
}

var sounds []sound

var cmds []*exec.Cmd

/*
soundboard.csv:
`v,Vine boom,wav/vineboom.wav`
`<key>,<name>,<filename>`
*/

const CONFIG_FILE=".config/regexghost/soundboard.csv"
const SOUND_LOC=".local/share/regexghost/sounds"

// Function to allow adding strings to screen instead of just individual runes (chars)
func drawText(s tcell.Screen, x1, y1, x2, y2 int, style tcell.Style, text string) {
	row := y1
	col := x1
	for _, r := range []rune(text) {
		s.SetContent(col, row, r, nil, style)
		col++
		if col >= x2 {
			row++
			col = x1
		}
		if row > y2 {
			break
		}
	}
}

func errorOut(e string) {
	fmt.Println(e)
	os.Exit(1)
}

func loadSounds() {
	file, err := os.Open(homeDir + "/" + CONFIG_FILE)

	if err != nil {
		errorOut("Error, config file not present")
	}

	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()

	if err != nil {
		errorOut("Error parsing csv file")
	}

	for _, record := range records {
		key := rune(record[0][0])
		newSound := sound {
			name: record[1],
			path: record[2],
			key: key,
		}
		sounds = append(sounds, newSound)
		fmt.Println(newSound)
	}
}

func drawSoundboard(s tcell.Screen) {
	s.Clear()
	drawText(s, 0, 0, 50, 10, styles["pink"], "Soundboard")
	for i, soundEntry := range sounds {
		line := string(soundEntry.key) + ": " + soundEntry.name
		drawText(s, 0, i+2, 50, 100, styles["blue"], line)
	}
}

func playSound(path string) {
//	cmd := exec.Command("mpv", "--no-config", "--no-resume-playback", "--force-window=no", homeDir + "/" + SOUND_LOC + "/" + path)
	cmd := exec.Command("aplay", homeDir + "/" + SOUND_LOC + "/" + path)
	cmds = append(cmds, cmd)
	cmd.Start()
}

func killSounds() {
	for _, cmd := range cmds {
		cmd.Process.Kill()
	}
}

func findAndPlaySound(key rune) {
	for _, soundEntry := range sounds {
		if soundEntry.key == key {
			playSound(soundEntry.path)
		}
	}
}

func main() {
	homeDir, _ = os.UserHomeDir()

	loadSounds()

	s, err := tcell.NewScreen()
	if err != nil {
		panic(err)
	}
	err = s.Init()
	if err != nil {
		panic(err)
	}

	// Create colours
	blueColour := tcell.NewHexColor(0x38ffea)
	pinkColour := tcell.NewHexColor(0xff76c1)

	// Use the colours to make styles and add to "styles" map
	styles["white"] = tcell.StyleDefault.Background(tcell.ColorReset).Foreground(tcell.ColorReset)
	styles["blue"] = tcell.StyleDefault.Background(tcell.ColorReset).Foreground(blueColour)
	styles["pink"] = tcell.StyleDefault.Background(tcell.ColorReset).Foreground(pinkColour)

	s.SetStyle(styles["white"])
	s.Clear()

	quit := func() {
		s.Fini()
		os.Exit(0)
	}

	for {
		s.Show()

		drawSoundboard(s)
		ev := s.PollEvent()

		switch ev := ev.(type) {
			case *tcell.EventResize:
				s.Sync()
			case *tcell.EventKey:
				if ev.Key() == tcell.KeyRune {
					if ev.Rune() == 'q' {
						killSounds()
						quit()
					} else if ev.Rune() == ' ' {
						killSounds()
				} else {
					findAndPlaySound(ev.Rune())
				}
			}
		}
	}
}
