# Kontakt

Det här dokumentet innehåller kontaktinformation för Klipper.

## Discourse-forum

Det finns en [Klipper Community Discourse-server](https://community.klipper3d.org) för diskussioner om Klipper i forumformat. Observera att Discourse inte är Discord.

## Discord-chatt

Det finns en Discord-server för Klipper på: <https://discord.klipper3d.org>. Observera att Discord inte är Discourse.

Servern drivs av en grupp Klipper-entusiaster för diskussioner om Klipper. Där kan användare chatta med andra användare i realtid.

## Jag har en fråga om Klipper

Många frågor vi får besvaras redan i [Klipper-dokumentationen](Overview.md). Läs dokumentationen och följ anvisningarna där.

Du kan även söka efter liknande frågor i [Klippers Discourse-forum](#discourse-forum).

Vill du dela dina kunskaper och erfarenheter med andra Klipper-användare kan du gå med i [Klippers Discourse-forum](#discourse-forum) eller [Klippers Discord-chatt](#discord-chat). I båda grupperna kan Klipper-användare diskutera Klipper med varandra.

Har du en allmän fråga eller allmänna utskriftsproblem kan du även överväga ett allmänt forum om 3D-utskrift eller ett forum som är inriktat på skrivarens maskinvara.

## Jag har ett önskemål om en funktion

Alla nya funktioner kräver någon som är intresserad av och kan implementera funktionen. Vill du hjälpa till att implementera eller testa en funktion kan du söka efter pågående utveckling i [Klippers Discourse-forum](#discourse-forum). Det finns även [Klippers Discord-chatt](#discord-chat) för diskussioner mellan medarbetare.

## Hjälp! Det fungerar inte!

Om du har problem rekommenderar vi att du läser [Klipper-dokumentationen](Overview.md) noggrant och kontrollerar att alla steg har följts.

Om du har utskriftsproblem rekommenderar vi att du noggrant granskar skrivarens maskinvara, inklusive alla fogar, kablar och skruvar, och kontrollerar att inget är onormalt. De flesta utskriftsproblem beror inte på Klipper. Om du hittar ett maskinvaruproblem bör du söka i allmänna forum om 3D-utskrift eller forum som är inriktade på skrivarens maskinvara.

Du kan även söka efter liknande problem i [Klippers Discourse-forum](#discourse-forum).

Vill du dela dina kunskaper och erfarenheter med andra Klipper-användare kan du gå med i [Klippers Discourse-forum](#discourse-forum) eller [Klippers Discord-chatt](#discord-chat). I båda grupperna kan Klipper-användare diskutera Klipper med varandra.

## Jag hittade ett fel i Klipper-programvaran

Klipper är ett projekt med öppen källkod och vi uppskattar när medarbetare hjälper till att diagnostisera fel i programvaran.

Problem ska rapporteras i [Klippers Discourse-forum](#discourse-forum).

Det behövs viktig information för att åtgärda ett fel. Följ dessa steg:

1. Kontrollera att du kör oförändrad kod från <https://github.com/Klipper3d/klipper>. Om koden har ändrats eller kommer från en annan källa ska problemet återskapas med den oförändrade koden från <https://github.com/Klipper3d/klipper> innan det rapporteras.
1. Kör om möjligt `M112` direkt efter den oönskade händelsen. Då går Klipper till läget "shutdown state" och ytterligare felsökningsinformation skrivs till loggfilen.
1. Hämta Klippers loggfil från händelsen. Loggfilen är utformad för att besvara vanliga frågor från Klipper-utvecklarna om programvaran och dess miljö, som programvaruversion, maskinvarutyp, konfiguration, händelsetidpunkt och hundratals andra frågor.
   1. Särskilda Klipper-webbgränssnitt kan hämta Klippers loggfil direkt, vilket är enklast. Annars behövs verktyget "scp" eller "sftp" för att kopiera loggfilen till datorns skrivbord. "scp" ingår normalt i Linux- och MacOS-skrivbord. Det finns fria scp-verktyg för andra system, till exempel WinSCP. Loggfilen kan finnas i `~/printer_data/logs/klippy.log`. I ett grafiskt scp-verktyg letar du efter mappen "printer_data", sedan "logs" och därefter `klippy.log`. Den kan alternativt ligga i `/tmp/klippy.log`; om verktyget inte kan kopiera den direkt klickar du upprepade gånger på `..` eller "parent folder" tills du når rotkatalogen, öppnar mappen `tmp` och väljer `klippy.log`.
   1. Kopiera loggfilen till skrivbordet så att den kan bifogas i en felrapport.
   1. Ändra inte loggfilen på något sätt och skicka inte bara ett utdrag. Endast den fullständiga, oförändrade loggfilen innehåller nödvändig information.
   1. Det är en bra idé att komprimera loggfilen med zip eller gzip.
1. Öppna ett nytt ämne i [Klippers Discourse-forum](#discourse-forum) och beskriv problemet tydligt. Andra Klipper-bidragsgivare behöver förstå vilka steg som togs, vilket resultat som förväntades och vad som faktiskt hände. Bifoga den komprimerade Klipper-loggfilen till ämnet.

## Jag gör ändringar som jag vill inkludera i Klipper

Klipper är programvara med öppen källkod och vi uppskattar nya bidrag.

Se [CONTRIBUTING-dokumentet](CONTRIBUTING.md) för information.

Det finns flera [dokument för utvecklare](Overview.md#developer-documentation). Har du frågor om koden kan du även fråga i [Klippers Discourse-forum](#discourse-forum) eller i [Klippers Discord-chatt](#discord-chat).

## Professionella tjänster

![](img/klipper-logo-small.png)

Anpassad programvaruutveckling, programvarusupport och lösningar: <https://ko-fi.com/koconnor>
