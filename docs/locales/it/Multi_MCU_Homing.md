# Homing e Probing con microcontrollore multiplo

Klipper sopporta un meccanismo per homing con un fine corsa collegato a un micro controllore mentre i motori passo-passo sono collegati ad un controllore diverso. Questa modalità è definita Homing multi-mcu. Questa funzione è usata quando una sonda Z è collegata ad un differente controllore rispetto ai motori dell'asse Z.

Questa funzione può essere utile per semplificare il cablaggio, poiché potrebbe essere più conveniente collegare un finecorsa o una sonda a un microcontrollore più vicino. Tuttavia, l'utilizzo di questa funzione può comportare un "overshoot" dei motori passo-passo durante le operazioni di homing o con sonda.

L' 'overshoot' si verifica a causa di possibili ritardi nella trasmissione del messaggio tra il microcontrollore che controlla il finecorsa e i microcontrollori che muovono i motori passo-passo. Il codice Klipper è progettato per limitare questo ritardo a non più di 25 ms. (Quando è attivato l'homing multi-mcu, i microcontrollori inviano messaggi di stato periodici e controllano che i messaggi di stato corrispondenti vengano ricevuti entro 25 ms.)

Quindi, ad esempio, se si esegue l'homing a 10 mm/s, è possibile un superamento fino a 0,250 mm (10 mm/s * .025s == 0,250 mm). È necessario prestare attenzione durante la configurazione dell'homing multi-mcu per tenere conto di questo tipo di overshoot. L'uso di velocità di riferimento o di sonda più lente può ridurre la sovraelongazione (overshot).

La sovraelongazione 'overshot' del motore passo-passo non dovrebbe influire negativamente sulla precisione della procedura di homing e di sonda. Il codice Klipper rileverà il superamento e ne terrà conto nei suoi calcoli. Tuttavia, è importante che il design dell'hardware sia in grado di gestire l'overshoot senza causare danni alla macchina.

Se Klipper dovesse rilevare un problema di comunicazione tra i microcontrollori durante l'homing multi-mcu, genererà un errore "Timeout di comunicazione durante l'homing".

Si noti che un asse con più stepper (ad esempio, `stepper_z` e `stepper_z1`) deve trovarsi sullo stesso microcontrollore per poter utilizzare l'homing multi-mcu. Ad esempio, se un endstop si trova su un microcontrollore separato da `stepper_z` allora `stepper_z1` deve trovarsi sullo stesso microcontrollore di `stepper_z`.
