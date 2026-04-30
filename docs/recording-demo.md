# Recording the demo GIF

The static `assets/demo.svg` is a placeholder showing what `/enhance`
output looks like. For the launch, you'll want a real animated GIF
showing the live UX.

Pick the option that matches your tooling.

## Option A — `asciinema` + `agg` (recommended)

Most authentic-looking. Standard format in the OSS world.

### Install

```bash
brew install asciinema    # macOS
# or
pip install asciinema     # cross-platform

# agg converts asciinema casts to animated GIFs
brew install agg
# or download from https://github.com/asciinema/agg/releases
```

### Record

```bash
# Set up recording
cd /path/to/your/test/project    # has .codemap/, lessons, etc.
asciinema rec demo.cast -i 0.5   # -i caps idle time at 0.5s

# Inside the recording:
# 1. Start Claude Code
claude

# 2. Type the demo prompt slowly enough to read
/enhance fix the bug where field area is computed wrong

# 3. Wait for the structured output to appear

# 4. Type 's' to demonstrate submission, OR 'x' to demonstrate scrap

# 5. Exit Claude Code
# Then press Ctrl+D to stop recording
```

### Convert to GIF

```bash
agg --theme monokai --font-family "Menlo, Monaco, monospace" --font-size 16 \
    --speed 1.5 --rows 30 --cols 100 \
    demo.cast assets/demo.gif
```

Tweak `--speed`, `--rows`, `--cols` for the size/pace you want.

### Embed in README

Replace this line in `README.md`:

```markdown
![demo](assets/demo.svg)
```

with:

```markdown
![demo](assets/demo.gif)
```

(or keep both — SVG above the fold, GIF in the "Demo" section).

## Option B — Screen recording tool + GIF converter

If asciinema feels heavy, use any screen recorder:

- **macOS:** QuickTime → File > New Screen Recording → record window only
- **Linux:** `peek` or `kazam`
- **Windows:** ScreenToGif

Then convert MP4/MOV to optimized GIF:

```bash
# Using ffmpeg + gifsicle for small file size
ffmpeg -i demo.mov -vf "fps=15,scale=900:-1" -c:v gif demo-raw.gif
gifsicle -O3 --colors 128 demo-raw.gif -o assets/demo.gif
```

## Option C — Terminalizer (YAML → GIF)

Terminalizer lets you script the recording in YAML — useful if you want
deterministic output without a live session.

```bash
npm install -g terminalizer
terminalizer record demo
# (records your session)
terminalizer render demo -o assets/demo.gif
```

## File size budget

Aim for **<2 MB** for the demo GIF in the README. Larger files slow
page loads and can be rejected by GitHub markdown rendering.

Optimization tips:

- 15 fps is enough for terminal output (vs 30+ for video)
- 800-1000px wide is plenty
- Limit to ~30 seconds of content
- Use `gifsicle -O3 --colors 128` to compress without visible quality loss

## Best practices for the demo content

- **Start with the prompt visible** — viewer should see the input
- **Type at human pace** — don't paste; let the typing animation play
- **Pause briefly after key moments** — gives the viewer time to read
- **End with the prompt cursor blinking** — signals "ready for action"
- **Keep total length under 30s** — attention drops fast on social media

## What to demonstrate

Pick ONE compelling example. Don't try to show everything in one GIF.

Good demo prompts (interesting input, rich output):

1. **Vague debug:** `/enhance fix the bug where field area is computed wrong`
   (shows ambiguity surfacing)
2. **Vague refactor:** `/enhance refactor the auth middleware to use JWT`
   (shows scope detection + lessons cross-reference)
3. **Vague feature:** `/enhance add caching to the satellite tile endpoint`
   (shows project-context awareness)

Avoid trivial examples (`/enhance fix typo in README`) — they don't
showcase the value.

## After recording

1. Save the GIF to `assets/demo.gif`
2. Update `README.md` to reference it
3. Commit + push
4. Use the GIF in:
   - GitHub README (top of file)
   - Show HN post (link to repo, GIF appears at top)
   - Tweet thread (attach as image to the lead tweet)
   - Dev.to article (embed in the intro)

The GIF is the single highest-impact asset for adoption. Worth spending
30 minutes to record well.
