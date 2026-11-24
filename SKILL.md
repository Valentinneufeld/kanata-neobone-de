---
name: neobone-kanata
description: Neo-Bone-Layout mit Home Row Mods auf deutschem Windows 11 per Kanata. Verwenden, wenn neobone.kbd erweitert, geändert, geprüft oder auf Windows installiert werden soll.
---

# neobone.kbd erweitern

Config: `neobone.kbd` im Projektordner. Ziel: Windows 11, OS-Layout **Deutsch (QWERTZ)**, Kanata v1.13.0-prerelease-1.

## Grundregeln

- Kanata arbeitet per **Scancode/Position**. Namen in `defsrc` und bei Ausgabe sind **US-Positionen**.
- OS bleibt auf Deutsch. Umrechnung Position -> deutsches Zeichen:
  - `y` = Taste mit "Z", `z` = Taste mit "Y"
  - `[` = ü, `;` = ö, `'` = ä, `-` = ß, `/` = "-"
  - `\` = `#`, `102d` = `<`
- **Y/Z-Falle:** Für das Zeichen z muss die Taste `y` ausgegeben werden, für y die Taste `z`.
- `defsrc` und jede `deflayer` müssen exakt gleich viele Einträge haben. Zeilenumbrüche sind egal.
- Ausgabe von Sonderzeichen (Ebene 3/4) per `(unicode X)`. Ausnahmen:
  - `"` -> `S-2`, `'` -> `S-\` (deutsches Layout)
  - `(unicode "\"")` bricht den Parser ("Unterminated string").
  - `\`, `(`, `)`, `{`, `}`, `[`, `]`, `,` stehen in Anführungszeichen: `(unicode "(")`.

## Layer-Aufbau

| Layer | Zweck | Aktivierung |
|---|---|---|
| `bone` | Ebene 1/2, Shift kommt vom OS | Standard |
| `sym` | Ebene 3, Sonderzeichen (Neo) | Caps, `#`, Ä halten |
| `nav` | Ebene 4, Navigation + Ziffernblock, Leertaste = `0` | B, AltGr, linke Shift-Taste, Ö halten |

Bone-Buchstaben (Reihe 1/2/3):
```
j d u a x  p h l m w ß
c t i e o  b n r s g q
f v ü ä ö  y z , . k
```
Physisch ist die untere Reihe eine Taste nach links verschoben: `f` auf `<` (102d), `v` auf der Taste "Y", ü ä ö darauf folgend, die Taste B ist Layer-nav-Taste (`@l4`). Dasselbe gilt für die linken 5 Zeichen der unteren Reihe in `sym` (# $ | ~ `) und `nav` (Esc Tab Ins Enter Strg+Z): `102d` trägt das erste Zeichen, B ist `@l4`.

## Home Row Mods

- Physische Position (QWERTZ-Beschriftung), Tap = Bone-Buchstabe:
  A = Alt, S/L = Win, D/K = Shift, F/J = Strg, Ö = Layer nav, Ä = Layer sym.
- Alias-Typ: `tap-hold-release 200 200 <tap> <hold>`.
- **Mods müssen auch auf sym/nav funktionieren**, damit z.B. Ö halten + F halten + Pfeil Strg+Pfeil ergibt.
  Dafür haben die Positionen A/S/D/F/J/K/L in `sym` (Aliase `s-*`) und `nav` (Aliase `n-*`) eigene Hold-Taps mit dem Tap-Zeichen der jeweiligen Ebene.
- Neue Mod-Taste hinzufügen: Alias in allen drei Layern setzen (bone, sym, nav).

## Bekannte Probleme

- **AltGr hängt / Layer bleibt hängen:** `windows-altgr cancel-lctl-press` in `defcfg` (Windows erzeugt bei AltGr ein Fake-Strg).
- **"Unexpected keycode is pressed in kanata but not in Windows" + Zeichen kommen nicht mehrfach hintereinander** (betrifft y, z, ü, ö, ä, ß): Kanata prüft per `GetAsyncKeyState` mit US-Tastencodes, die auf deutschem Layout anders heißen, und löscht dann den Tastenzustand. In **v1.12.0 nicht per Config lösbar** (`windows-sync-keystates no` schaltet nur einen zweiten Check ab, nicht diesen). Lösung: **v1.13.0-prerelease-1** oder neuer verwenden (https://github.com/jtroo/kanata/releases/tag/v1.13.0-prerelease-1) und `windows-sync-keystates none` in `defcfg` setzen. In v1.12.0 ist der Wert ein Bool und `none` ein Parse-Fehler; in v1.13 ist `no` ungültig. Immer mit der Binary-Version validieren, die auf dem Rechner läuft. Siehe Issue jtroo/kanata#2115.
- Layer-Tasten (`caps \ 102d ralt`) in jeder `deflayer` explizit als `@l3`/`@l4` eintragen, nicht als `_`.
- Notausgang beim Testen: `Ctrl+Space+Esc` beendet Kanata.
- Ebenen 3/4 sind aus dem Gedächtnis nach Neo gebaut. Die Webseite https://neo-layout.org/Layouts/bone/ zeigt sie nur als Bilder, ggf. gegen die Bilder prüfen.
- Nicht umgesetzt: Ebenen 5/6, tote Tasten (`^`, `´`, `` ` ``), ß -> ẞ mit Shift ungeprüft.

## Validieren (in WSL/Linux, ohne Windows)

```
curl -sL -o /tmp/k.zip https://github.com/jtroo/kanata/releases/download/v1.13.0-prerelease-1/linux-binaries-x64.zip
unzip -o -q /tmp/k.zip -d /tmp/k && chmod +x /tmp/k/kanata_linux_x64
/tmp/k/kanata_linux_x64 --cfg neobone.kbd --check
rm -rf /tmp/k /tmp/k.zip
```
Erwartet: `config file is valid`. `gh release download` geht ohne Login nicht, daher `curl`.

## Installation / Update unter Windows

- Zielordner (Skripte und Config): `C:\kanata\kanata-pre\`. Das ZIP entpackt flach dorthin.
- Dateien: `kanata_windows_tty_winIOv2_x64.exe` (Konsole), `kanata_windows_gui_winIOv2_x64.exe` (Tray).
- `install-kanata.ps1` / `.bat`: beendet laufendes Kanata, lädt bei Bedarf die Version aus `$ver`, kopiert `neobone.kbd` aus dem Skriptordner nach `C:\kanata\kanata-pre\` und startet Kanata. Bei Versionswechsel `$ver` im Skript anpassen.
- `run-kanata.ps1` / `.bat`: startet nur Kanata aus `C:\kanata\kanata-pre\`.
- Doppelklick auf `.ps1` öffnet den Editor, daher die `.bat`-Starter.
- Config **bei jeder Änderung erneut kopieren** (Repo-Datei ist nur Kopie), also `install-kanata.bat` erneut ausführen.
- Autostart: `shell:startup` + Verknüpfung auf die GUI-EXE mit `--cfg C:\kanata\kanata-pre\neobone.kbd`. Lokale Kopie nutzen, WSL läuft beim Boot evtl. noch nicht.
- Kanata läuft nur unter Windows, nicht in WSL.

## Workflow für Änderungen

1. `neobone.kbd` mit dem edit-Tool ändern.
2. Mit `--check` validieren (siehe oben).
3. Nutzer bitten, die Config erneut zu kopieren und Kanata neu zu starten.
4. Bei Fehlern: betroffene Ebene, Aktivierungstaste und Zeitpunkt des Hängens erfragen.
