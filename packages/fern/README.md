# Fern

A floating olive-black strip, 40 points tall and 6 points from the screen's edges, with widgets
in pill groups, a pale-lime accent and Material-style tonal states. In the light appearance, the
strip turns pale with an olive-green accent.

## Font

Fern is set in [Rubik](https://fonts.google.com/specimen/Rubik). Install it with
`brew install --cask font-rubik` or from Google Fonts. Until it's installed, StableBar uses the
system font.

## Pills

A theme can't place widgets, so the pills come from groups in your configuration. Fern styles
these groups as pills on the raised surface: `workspaces`, `media`, `system`, `disk` and
`status`. The `clock` group is a lime pill. Put a widget in one with `group`:

```json
{ "id": "battery", "type": "battery", "position": "right", "group": "status" }
```

Other themes don't define these groups, and a widget in an unknown group stops the configuration
from loading. To keep switching themes, declare each group you use in your configuration with an
empty style, such as `"groups": { "status": { "style": {} } }`; Fern's style still applies.

The `time` role draws a widget as a lime chip that turns solid while its popup is open. Fern also
styles the `heading`, `key`, `value`, `button` and `meter` roles for popups.

## AeroSpace modes

While AeroSpace is in any mode other than `main`, the strip's border turns amber.
