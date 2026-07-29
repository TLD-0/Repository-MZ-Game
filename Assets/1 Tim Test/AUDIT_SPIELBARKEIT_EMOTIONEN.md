# Audit: Spielbarkeit und Dialogemotionen

## Statisches Gesamturteil

Die Questfolge ist im bereitgestellten Projektordner theoretisch durchgängig:

1, 2, 3, 5 → 6 → 7, 8 → 9 oder Skip → 10 → 11 oder 12 → 13 → 14 → 15 → 16 → NickDialog3.

Es wurde kein garantierter Quest-Deadlock in den enthaltenen Scripts, Dialogassets oder der Scene-Konfiguration gefunden.

Nicht vollständig prüfbar ohne Unity-Play-Mode und externe Projektordner: räumliche Erreichbarkeit, fremde Collider, Nav-/Level-Geometrie, tatsächliche Kamerabildausrichtung und externe Prefabbestandteile.

## Direkt vorgenommene Änderungen

### Spielerportrait

`PlayerEmotionPortrait.ShowPortrait()` setzt bei jedem neuen Dialog zuerst wieder die konfigurierte Startemotion. Dadurch übernimmt ein neuer Dialog nicht mehr versehentlich Mayas letzte Emotion aus dem vorherigen Dialog.

Alle zehn Werte aus `PlayerEmotion` besitzen im Scene-Inspector eine Sprite-Zuweisung:
Neutral, Happy, Lachend, Traurig, Besorgt, Genervt, Muede, Seufzen, Ueberrascht und Unsicher.

### Tischdialog mit Tina

In `MayaDialog5` wurde der erste Tina-Emotionswechsel von `SpecificNPC: Tina` auf `CurrentSpeaker` umgestellt.

Der Tisch `InteractableTischMitTina` übergibt bereits den vorhandenen Controller:

`NPC Tina IC/HeadSprite` → `NPCEmotionController` → `SpriteRenderer`.

Ein neuer Renderer war daher nicht nötig. Der vorhandene HeadSprite-Renderer war korrekt aufgebaut, wurde aber durch die falsche NPC-ID nicht angesprochen.

### NickDialog2

- Tina zeigt `Tina_happy`.
- Nick zeigt `Nick_happy`.

### NickDialog3

- Bei „Tina & Theo“ wird mindestens Tinas aktiver Club-HeadSprite mit `Tina_happy` angezeigt.
- Sophy zeigt `Sophy_nervous`.
- Nick zeigt `Nick_happy`.

Die gesetzten Köpfe bleiben in den folgenden Nodes sichtbar, bis der Dialog endet. Am Dialogende werden sie durch die vorhandenen `NPCEmotionController` wieder ausgeblendet.

## Dialogprüfung

- Alle Dialog-Node-Verweise sind gültig.
- Kein fortschrittskritischer Dialog mit deaktiviertem Escape besitzt einen Node ohne Antwort.
- Alle referenzierten Emotionssprites existieren.
- Alle NPCEmotionController besitzen einen gültigen SpriteRenderer.
- Es gibt keine doppelte aktive NPC-ID in der gespeicherten Scene-Konfiguration.
- Tina vor dem Café, Tina im Café und Tina im Club verwenden getrennte IDs: TinaVC, TinaIC und Tina.

## Dialoggruppen ohne NPC-Kopf

Folgende Dialoge sind absichtlich keine direkten NPC-Gespräche und benötigen keinen NPC-HeadSprite:

- MayaDialog1–4, soweit es sich um Monologe handelt
- TelefonDialog und WrongPhoneNumber als Eingabeoberfläche
- DrinkDialog und KaffeeDialog als Auswahloberfläche
- KatjaDialog3 als Telefonstimme des Unternehmens

Im Oma-Dialog existieren für Oma, Mutter und Vater sichtbare normale Körpersprites. Für diese Figuren liegen im bereitgestellten Ordner keine separaten Emotionskopf-Sprites vor. Die Anforderung „Emotion oder Bild“ wird daher über ihre normalen NPC-Bilder erfüllt.

## Quest- und Interaktionsprüfung

- Quests 1, 2, 3 und 5 besitzen gültige Interaktionsobjekte und Ziele.
- Das Bett schließt Quest 6 ab und respektiert das Quest-Gate.
- Officeobjekte schließen Quest 7 und 8 ab.
- Das Telefon ist an Quest 9 Active gebunden und schließt Quest 9 bei 12345 ab.
- Beide Katja-Zweige führen zu Quest 10.
- Sophys Dialog schließt Quest 10 in beiden Antwortzweigen ab.
- Kaffeeobjekte für Quest 11 und 12 besitzen gültige Ziele.
- Beide Tischdialoge führen zu Quest 13 Completed.
- Die Bar verlangt Quest 14 Active; alle neun Kombinationen sind gültig und schließen Quest 14 ab.
- Das ausgewählte Getränk startet/ermöglicht Quest 15 und die Drink-Interaktion schließt Quest 15 ab.
- NickDialog2 startet Quest 16; die Tanzflächeninteraktion schließt Quest 16 ab.
- NickDialog3 wird erst nach Quest 16 Completed freigeschaltet.

## Verbleibende manuelle Kontrolle

Die beiden Endteleportpunkte sind logisch getrennt, liegen aber weiterhin an derselben gespeicherten Position:

- Punkt A: `PlayerTPAfterGoingHomeClubNegative` / `AfterGoingHomeClub`
- Punkt B: `PlayerTPAfterGoingHomeClubPositive` / `AfterGoingHomeClubPositive`

Beide liegen aktuell lokal bei ungefähr X -18.986, Y 0, Z 40.255. Punkt B muss in Unity an die gewünschte zweite Endposition verschoben werden, damit die beiden Enden räumlich unterschiedlich sind.

Theo wird für den Bankdialog verwendet und bei Quest 14 Active ausgeblendet. In NickDialog3 spricht der Text „Tina & Theo“, aber der separate Theo-Club-NPC ist im bereitgestellten Ordner nicht vorhanden. Tinas Kopf wird in diesem Node sichtbar angezeigt; für einen zusätzlich sichtbaren Theo im Club wäre ein zweites Theo-Objekt oder ein eigener Club-HeadSprite nötig.
