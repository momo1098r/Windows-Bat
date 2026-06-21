# DNS Change

Script batch per Windows che permette di abilitare/disabilitare rapidamente i DNS pubblici (Cloudflare, Google, Quad9) sulle interfacce di rete Wi-Fi e LAN.

Funzionalità


Imposta i DNS su Wi-Fi, LAN o entrambe le interfacce
Ripristina il DNS automatico (DHCP) in qualsiasi momento
Riavvia automaticamente l'interfaccia di rete dopo ogni modifica
Provider supportati:

Cloudflare — 1.1.1.1 / 1.0.0.1
Google — 8.8.8.8 / 8.8.4.4
Quad9 — 9.9.9.9 / 149.112.112.112

Utilizzo:
Scarica ChangeDNS.bat
Fai clic destro → Esegui come amministratore
Dal menu seleziona il provider DNS (opzione 9) e poi l'azione desiderata

---
Se i nomi delle tue interfacce di rete non sono "Wi-Fi" e "Ethernet", modifica le variabili IF_WIFI e IF_LAN all'inizio dello script aprendolo in modalità modifica.
