# Roblox Speed & Jump Controller

A modern, responsive GUI script for controlling walkspeed and jump power in Roblox games.

## Features

- **Speed Control**: Adjust walkspeed from 0 to 200 with slider and buttons
- **Jump Power Control**: Modify jump power from 0 to 500 with precision controls
- **Mobile-Friendly**: Responsive design optimized for both desktop and mobile devices
- **Modern UI**: Clean interface with gradients, shadows, and smooth animations
- **Floating Jump Button**: Draggable jump button for quick access
- **Keyboard Shortcuts**: RightShift to toggle UI (desktop only)
- **Persistent Settings**: Maintains settings across character respawns

## How to Use

### Quick Load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ansellino/walkspeed-and-jump-roblox/main/walkspeedandjump.lua"))()
```

### Controls

- **Sliders**: Drag to set precise values
- **+/- Buttons**: Increment/decrement values by 1
- **Apply Button**: Apply current settings to character
- **Reset Button**: Reset to default values (16 speed, 50 jump)
- **Hide Interface**: Toggle main UI visibility
- **Floating Jump**: Draggable button for instant jumping

## Interface

- **Responsive Design**: Larger on mobile devices for better touch interaction
- **Draggable Elements**: Main frame and floating jump button can be moved
- **Visual Feedback**: Hover effects and smooth animations
- **Clean Layout**: Organized sections with proper spacing

## Compatibility

- Works with both old JumpPower and new JumpHeight systems
- Compatible with most Roblox games
- Optimized for mobile and desktop platforms

## Purpose

This project is created for:

- Educational purposes and learning Lua scripting
- Personal development and experimentation
- Understanding Roblox GUI development
- Mobile-friendly interface design practice

## Files

- `walkspeedandjump.lua` - Main script with enhanced UI and controls
- `walkspeed.lua` - Legacy version (deprecated)

## Notes

- For educational and personal use only
- Private learning project
- Modern UI with improved user experience
- Mobile-optimized interface design
