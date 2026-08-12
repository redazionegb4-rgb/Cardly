CARDLY — BUILD 1
Versione 1.0 (Build 2)
Target: iPhone / iOS 17+

Come aprire:
1. Apri Cardly.xcodeproj con Xcode.
2. Seleziona il target Cardly > Signing & Capabilities.
3. Scegli il tuo Team Apple Developer.
4. Se il Bundle Identifier com.cardly.app è già occupato, cambialo con uno tuo univoco.
5. Collega iPhone oppure usa Simulator e premi Run.

Funzioni incluse:
- Home Cardly
- Aggiunta tessera
- Scanner barcode/QR con fotocamera
- Inserimento manuale
- QR Code e Code 128
- Categorie
- Ricerca
- Preferiti
- Dettaglio tessera
- Luminosità massima automatica sul codice
- Tema chiaro/scuro/automatico
- Salvataggio locale
- Icona Cardly
- Lingua italiana

Da completare nelle build successive:
- iCloud reale
- Blocco Face ID all'avvio
- riconoscimento automatico logo/negozio
- editing tessera
- importazione foto tessera


Correzioni Build 2:
- Bundle Identifier: com.cardlynew.app
- CFBundleIdentifier aggiunto a Info.plist
- CFBundleShortVersionString e CFBundleVersion aggiunti
- Build number aggiornato a 2


CARDLY BUILD 3 - APP STORE FIX
- Bundle ID: com.cardlynew.app
- Versione: 1.0
- Build: 3
- Info.plist generato automaticamente da Xcode
- Chiave fotocamera configurata nelle Build Settings
- Configurazione Archive/App Store resa più standard

Prima dell'Archive: TARGET Cardly > Signing & Capabilities > scegli il tuo Team.
Poi Product > Clean Build Folder e Product > Archive.
