# Neo-Bone für Kanata (deutsches Windows)

[Kanata](https://github.com/jtroo/kanata)-Konfiguration, die auf einer normalen deutschen ISO-Tastatur (Windows-Layout „Deutsch", QWERTZ) das [Neo-Bone-Layout](https://neo-layout.org/Layouts/bone/) mit Home Row Mods bereitstellt. Das Betriebssystem bleibt auf Deutsch.

> Getestet mit Kanata `v1.13.0-prerelease-1` unter Windows 11. Die Ebenen 5/6 und tote Tasten (`^`, `´`, `` ` ``) sind nicht umgesetzt.

## Dateien

| Datei | Zweck |
|---|---|
| `neobone.kbd` | Die Kanata-Config |
| `install-kanata.ps1` / `.bat` | Lädt Kanata, kopiert die Config nach `C:\kanata\kanata-pre\` und startet Kanata |
| `run-kanata.ps1` / `.bat` | Startet nur Kanata aus `C:\kanata\kanata-pre\` mit der dortigen `neobone.kbd` |
| `SKILL.md` | Hinweise und Lernpunkte für das Erweitern der Config (für Menschen und KI-Agenten) |

## Layout

Die Buchstaben stehen auf der physischen Taste der angegebenen Position. Die untere linke Reihe ist eine Taste nach links verschoben, `F` liegt auf der `<`-Taste.

```
j d u a x   p h l m w ß
c t i e o   b n r s g q
f v ü ä ö   y z , . k
```

### Ebenen

| Ebene | Inhalt | Aktivierung (halten) |
|---|---|---|
| 1/2 | Buchstaben (Shift wie üblich) | Standard |
| 3 | Sonderzeichen | CapsLock, `#`, Ä-Taste |
| 4 | Navigation und Zahlenblock, Leertaste = `0` | AltGr, linke Shift-Taste, B-Taste, Ö-Taste |

### Home Row Mods

Antippen gibt den Buchstaben, Halten den Modifier (Haltezeit 200 ms):

| Taste | Halten |
|---|---|
| A | Alt |
| D, K | Shift |
| F, J | Strg |
| Ö | Ebene 4 |
| Ä | Ebene 3 |

Auf Ebene 3 und 4 funktionieren die Mods ebenfalls, z. B. Ö halten + F halten + Pfeiltaste ergibt Strg+Pfeil.

## Installation unter Windows

1. Kanata `v1.13.0-prerelease-1` oder neuer von den [Releases](https://github.com/jtroo/kanata/releases) laden (`windows-binaries-x64.zip`) und entpacken. Die Option `windows-sync-keystates none` gibt es erst ab dieser Version.
2. Ordner dieses Repos nach Windows holen und `install-kanata.bat` per Doppelklick ausführen. Das Skript lädt Kanata, kopiert die Config und startet Kanata.
3. Beenden: `Strg` + `Leertaste` + `Esc`.

Von PowerShell aus (Pfad zum Repo anpassen):

```
powershell -ExecutionPolicy Bypass -File "<Pfad>\install-kanata.ps1"
```

Bei jeder Änderung an `neobone.kbd` Skript erneut ausführen, damit die Config neu kopiert wird.

### Autostart

`Win+R` → `shell:startup` und dort eine Verknüpfung anlegen auf:

```
C:\kanata\kanata-pre\kanata_windows_gui_winIOv2_x64.exe --cfg C:\kanata\kanata-pre\neobone.kbd
```

## Validieren (ohne Windows)

```
kanata --cfg neobone.kbd --check
```

Dafür die Binary derselben Version nutzen wie unter Windows.

## Bekannte Probleme

- **Fehler „Unexpected keycode is pressed in kanata but not in Windows" und Zeichen (ü, ö, ä, ß, y, z) lassen sich nicht hintereinander tippen:** Kanata gleicht Tastenzustände mit US-Tastencodes ab, die auf deutschem Layout abweichen. Abhilfe: `windows-sync-keystates none` und Kanata ab `v1.13.0-prerelease-1`. In `v1.12.0` ist der Wert ein Bool (`no`), das behebt das Problem nicht. Siehe [jtroo/kanata#2115](https://github.com/jtroo/kanata/issues/2115).
- **AltGr bleibt hängen:** `windows-altgr cancel-lctl-press` in `defcfg` (bereits gesetzt).
- Die Ebenen 3/4 sind nach Neo nachgebaut und nicht gegen die offiziellen Grafiken verifiziert.

## Funktionsweise

Kanata arbeitet mit Scancodes (Position). Die Namen in `defsrc` sind US-Positionen, das deutsche OS-Layout macht daraus das Zeichen:

| Kanata-Name | Deutsche Taste |
|---|---|
| `y` | Z |
| `z` | Y |
| `[` | Ü |
| `;` | Ö |
| `'` | Ä |
| `-` | ß |
| `\` | # |
| `102d` | < |

Sonderzeichen auf Ebene 3/4 werden per `(unicode …)` ausgegeben. Ausnahme: `"` und `'` über `S-2` und `S-\`.
