# Bidra till Klipper

Tack för att du bidrar till Klipper! Detta dokument beskriver processen för att bidra med ändringar till Klipper.

Se [kontaktsidan](Contact.md) för information om felrapportering eller uppgifter om hur du kontaktar utvecklarna.

## Översikt över bidragsprocessen

Bidrag till Klipper följer i allmänhet denna övergripande process:

1. En bidragsgivare börjar med att skapa en [GitHub-pull request](https://github.com/Klipper3d/klipper/pulls) när bidraget är redo för bred användning.
1. När en [granskare](#reviewers) kan [granska](#what-to-expect-in-a-review) bidraget tilldelar hen sig själv pull requesten på GitHub. Målet med granskningen är att hitta fel och kontrollera att bidraget följer dokumenterade riktlinjer.
1. Efter en lyckad granskning "godkänner" granskaren den på GitHub och en [underhållare](#reviewers) checkar in ändringen i Klippers master-gren.

När du arbetar med förbättringar kan du överväga att starta, eller bidra till, ett ämne på [Klipper Discourse](Contact.md). En pågående diskussion på forumet kan öka synligheten för utvecklingsarbetet och locka andra som är intresserade av att testa nytt arbete.

## Vad du kan förvänta dig vid en granskning

Bidrag till Klipper granskas före sammanfogning. Granskningsprocessens huvudsakliga mål är att kontrollera fel och att bidraget följer riktlinjerna i Klipper-dokumentationen.

Det finns många sätt att utföra en uppgift, och granskningens avsikt är inte att diskutera den "bästa" implementeringen. När det är möjligt är granskningsdiskussioner som bygger på fakta och mätningar att föredra.

De flesta bidrag leder till återkoppling från en granskning. Var beredd på att ta emot återkoppling, lämna ytterligare uppgifter och uppdatera bidraget vid behov.

Vanliga saker som en granskare tittar efter:

1. Är bidraget fritt från fel och redo för bred användning?

   Bidragsgivare förväntas testa sina ändringar före insändning. Granskarna letar efter fel men testar i allmänhet inte bidrag. Ett godtaget bidrag distribueras ofta till tusentals skrivare inom några veckor efter godkännande. Bidragens kvalitet är därför en prioritet.

   Huvudförrådet [Klipper3d/klipper](https://github.com/Klipper3d/klipper) på GitHub tar inte emot experimentellt arbete. Bidragsgivare bör utföra experiment, felsökning och tester i egna förråd. [Klipper Discourse](Contact.md) är en bra plats för att uppmärksamma nytt arbete och hitta användare som vill ge återkoppling från verklig användning.

   Bidrag måste klara alla [regressionstestfall](Debugging.md).

   När ett fel i koden rättas bör bidragsgivaren ha en allmän förståelse av felets grundorsak, och rättningen bör riktas mot den grundorsaken.

   Kodbidrag bör inte innehålla överdriven felsökningskod, felsökningsalternativ eller felsökningsloggning vid körning.

   Kommentarer i kodbidrag bör fokusera på att underlätta kodunderhåll. Bidrag bör inte innehålla utkommenterad kod eller överdrivna kommentarer som beskriver tidigare implementationer. Det bör inte heller finnas överdrivet många "todo"-kommentarer.

   Dokumentationsuppdateringar bör inte ange att de är "pågående arbete".
1. Ger bidraget en "stor påverkan" för verkliga användare som utför verkliga uppgifter?

   Granskare behöver åtminstone för egen del identifiera ungefär "vem målgruppen är", "hur stor målgruppen är", vilken "nytta" den får, hur nyttan mäts och "resultaten av dessa mätningar". I de flesta fall är detta uppenbart för både bidragsgivaren och granskaren och uttalas inte uttryckligen under en granskning.

   Bidrag till Klippers master-gren förväntas ha en betydande målgrupp. Som en allmän tumregel bör bidrag rikta sig till minst 100 verkliga användare.

   Om en granskare frågar om detaljer kring bidragets "nytta", se det inte som kritik. Att kunna förstå en ändrings nytta i verklig användning är en naturlig del av granskningen.

   När nytta diskuteras är det bättre att tala om "fakta och mätningar". Granskare söker i allmänhet inte svar som "någon kan ha nytta av alternativ X" eller "bidraget lägger till en funktion som firmware X implementerar". I stället är det bättre att beskriva hur kvalitetsförbättringen mättes och vilka resultaten blev. Till exempel: "tester på Acme X1000-skrivare visar förbättrade hörn enligt bild …", eller "utskriftstiden för verkligt objekt X på en Foomatic X900-skrivare minskade från 4 till 3,5 timmar". Tester av denna typ kan kräva avsevärd tid och ansträngning. Några av Klippers mest anmärkningsvärda funktioner krävde månader av diskussion, omarbetning, testning och dokumentation innan de sammanfogades med master-grenen.

   Alla nya moduler, konfigurationsalternativ, kommandon, kommandoparametrar och dokument bör ha "stor påverkan". Vi vill inte belasta användarna med alternativ som de rimligen inte kan konfigurera eller som inte ger någon betydande nytta.

   En granskare kan be om ett förtydligande kring hur en användare ska konfigurera ett alternativ. Ett idealiskt svar innehåller uppgifter om processen, till exempel: "användare av MegaX500 förväntas sätta alternativ X till 99,3 medan användare av Elite100Y förväntas kalibrera alternativ X med proceduren …".

   Om syftet med ett alternativ är att göra koden mer modulär bör kodkonstanter användas i stället för användarvända konfigurationsalternativ.

   Nya moduler, alternativ och parametrar bör inte ha funktionalitet som liknar befintliga modulers. Om skillnaderna är godtyckliga är det bättre att använda det befintliga systemet eller refaktorera den befintliga koden.
1. Är bidragets upphovsrätt tydlig, relevant och kompatibel?

   Nya C- och Python-filer bör ha en otvetydig upphovsrättsnotis. Se befintliga filer för önskat format. Det avråds från att ange upphovsrätt i en befintlig fil vid små ändringar av den filen.

   Kod från tredjepartskällor måste vara kompatibel med Klipper-licensen GNU GPLv3. Stora tillägg av tredjepartskod bör läggas i katalogen `lib/` och följa formatet i [lib/README](../lib/README).

   Bidragsgivare måste ange en [Signed-off-by-rad](#format-of-commit-messages) med sitt fullständiga verkliga namn. Den visar att bidragsgivaren godkänner [utvecklarens ursprungscertifikat](developer-certificate-of-origin).
1. Följer bidraget riktlinjerna i Klipper-dokumentationen?

   I synnerhet bör koden följa riktlinjerna i <Code_Overview.md> och konfigurationsfiler riktlinjerna i <Example_Configs.md>.
1. Är Klipper-dokumentationen uppdaterad för att spegla nya ändringar?

   Som ett minimum måste referensdokumentationen uppdateras med motsvarande kodändringar:

   * Alla kommandon och kommandoparametrar måste dokumenteras i <G-Codes.md>.
   * Alla användarvända moduler och deras konfigurationsparametrar måste dokumenteras i <Config_Reference.md>.
   * Alla exporterade "statusvariabler" måste dokumenteras i <Status_Reference.md>.
   * Alla nya "webhooks" och deras parametrar måste dokumenteras i <API_Server.md>.
   * Varje ändring som inte är bakåtkompatibel för ett kommando eller en konfigurationsinställning måste dokumenteras i <Config_Changes.md>.

Nya dokument bör läggas till i <Overview.md> och i webbplatsindexet [docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml).

1. Är commitarna välformade, behandlar ett ämne var och är oberoende?

   Commitmeddelanden bör följa det [föredragna formatet](#format-of-commit-messages).

   Commitar får inte ha någon sammanslagningskonflikt. Nya tillägg till Klippers master-gren görs alltid via "rebase" eller "squash and rebase". Det är vanligen inte nödvändigt att sammanfoga om bidraget vid varje uppdatering av Klippers master-förråd. Vid en sammanslagningskonflikt rekommenderas dock att bidragsgivaren använder `git rebase` för att lösa den.

   Varje commit bör behandla en enda ändring på hög nivå. Stora ändringar bör delas upp i flera oberoende commitar. Varje commit bör "stå för sig själv" så att verktyg som `git bisect` och `git revert` fungerar tillförlitligt.

   Ändringar av blanktecken bör inte blandas med funktionella ändringar. I allmänhet godtas inte onödiga blankteckenändringar, om de inte kommer från den etablerade "ägaren" till koden som ändras.

Klipper har ingen strikt "guide för kodstil", men ändringar av befintlig kod bör följa den övergripande kodstrukturen, indenteringsstilen och formatet för den befintliga koden. Bidrag med nya moduler och system har större frihet i kodstil, men den nya koden bör ha en internt konsekvent stil och i allmänhet följa branschens kodnormer.

Det är inte en gransknings mål att diskutera "bättre implementationer". Om en granskare har svårt att förstå implementeringen av ett bidrag kan hen dock begära ändringar för att göra den tydligare. I synnerhet kan ändringar krävas om granskarna inte kan övertyga sig om att bidraget är fritt från fel.

Som en del av en granskning kan en granskare skapa en alternativ pull request för ett ämne. Det kan göras för att undvika alltför mycket fram och tillbaka om mindre processfrågor och därmed effektivisera bidragsprocessen. Det kan också göras eftersom diskussionen inspirerar granskaren att bygga en alternativ implementation. Båda situationerna är normala resultat av en granskning och bör inte ses som kritik av det ursprungliga bidraget.

### Hjälpa till med granskningar

Vi uppskattar hjälp med granskningar! Du behöver inte vara en [uppräknad granskare](#reviewers) för att granska. Bidragsgivare med GitHub-pull requests uppmuntras också att granska sina egna bidrag.

För att hjälpa till med en granskning följer du stegen i [vad du kan förvänta dig vid en granskning](#what-to-expect-in-a-review) för att kontrollera bidraget. När granskningen är klar lägger du till en kommentar med dina resultat i GitHub-pull requesten. Om bidraget klarar granskningen ska det anges uttryckligen i kommentaren, exempelvis: "Jag granskade ändringen enligt stegen i CONTRIBUTING-dokumentet och allt ser bra ut för mig". Om vissa steg inte kunde utföras ska det uttryckligen anges vilka steg som granskades och vilka som inte granskades, exempelvis: "Jag kontrollerade inte koden för fel, men granskade allt annat i CONTRIBUTING-dokumentet och det ser bra ut".

Vi uppskattar också testning av bidrag. Om koden har testats, lägg till en kommentar i GitHub-pull requesten med testresultatet, oavsett om det lyckades eller misslyckades. Ange uttryckligen att koden testades och resultatet, till exempel: "Jag testade denna kod på min Acme900Z-skrivare med en vasutskrift och resultatet var bra".

### Granskare

Klippers "granskare" är:

| Namn | GitHub-id | Intresseområden |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input Shaping, resonanstestning, kinematik |
| Eric Callahan | @Arksine | Bäddnivellering, flashning av MCU |
| James Hartley | @JamesH1978 | Konfigurationsfiler |
| Kevin O'Connor | @KevinOConnor | Kärnrörelsesystem, mikrokontrollerkod |

"Pinga" inte någon av granskarna och rikta inte bidrag till dem. Alla granskare följer forumen och pull requestarna och tar sig an granskningar när de har tid.

Klippers "underhållare" är:

| Namn | GitHub-namn |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format för commitmeddelanden

Varje commit bör ha ett commitmeddelande med ungefär följande format:

```
module: Capitalized, short (50 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 75
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Further paragraphs come after blank lines..

Signed-off-by: My Name <myemail@example.org>
```

I exemplet ovan bör `module` vara namnet på en fil eller katalog i förrådet, utan filändelse. Till exempel `clocksync: Fix typo in pause() call at connect time`. Syftet med att ange ett modulnamn i commitmeddelandet är att ge sammanhang åt commitkommentarerna.

Det är viktigt att varje commit har en rad "Signed-off-by". Den intygar att du godkänner [utvecklarens ursprungscertifikat](developer-certificate-of-origin). Raden måste innehålla ditt verkliga namn, alltså inga pseudonymer eller anonyma bidrag, och en aktuell e-postadress.

## Bidra till Klipper-översättningar

[Projektet Klipper-translations](https://github.com/Klipper3d/klipper-translations) är avsett för att översätta Klipper till olika språk. [Weblate](https://hosted.weblate.org/projects/klipper/) är värd för alla Gettext-strängar för översättning och granskning. Språkversioner kan visas på [klipper3d.org](https://www.klipper3d.org) när de uppfyller följande krav:

- [ ] 75 % total täckning
- [ ] Alla rubriker (H1) är översatta
- [ ] En uppdaterad PR för navigeringshierarkin i klipper-translations.

För att minska frustrationen med domänspecifika termer och få kännedom om pågående översättningar kan du skicka en PR som ändrar `readme.md` i [projektet Klipper-translations](https://github.com/Klipper3d/klipper-translations). När en översättning är klar kan motsvarande ändring göras i Klipper-projektet.

Om en översättning redan finns i Klipper-förrådet och inte längre uppfyller kontrollistan ovan markeras den som inaktuell efter en månad utan uppdatering.

När kraven är uppfyllda behöver du:

1. uppdatera [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations) i förrådet klipper-translations
1. Valfritt: lägg till filen manual-index.md i mappen `docs\locals\<lang>` i klipper-translations-förrådet för att ersätta den språkspecifika index.md. Den genererade index.md renderas inte korrekt.

Kända problem:

1. Det finns för närvarande inget sätt att översätta bilder i dokumentationen korrekt
1. Det går inte att översätta rubriker i mkdocs.yml.
