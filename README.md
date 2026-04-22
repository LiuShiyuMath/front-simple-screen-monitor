# 御前决策殿 · Royal Decree

Medieval parchment UI for a screen-monitor AI: backend snaps screen every 5s, analyzes intent, frontend presents each observation as a royal petition.

- **Approve** → red wax seal stamps down
- **Reject** → parchment burns away with rising embers

Single static HTML. No build step. Fonts from Google Fonts CDN with cross-platform Chinese fallback (PingFang / Microsoft YaHei / Hiragino Sans GB / Noto Serif SC).

## Live demo

Open via GitHub Pages (once enabled) or double-click `index.html`.

## Hotkeys

| Key | Action |
|-----|--------|
| `A` | 盖印 Seal (approve) |
| `D` | 焚毁 Burn (reject) |
| `SPACE` | 召请 Summon next request |

## Responsive

- Desktop ≥1100px: 3-column chamber
- Tablet: stacked scroll + horizontal stats strip
- Phone: vertical stack, 88×106 tap targets
