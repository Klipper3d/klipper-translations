# 特徴

Klipper にはいくつかの魅力的な機能があります:

* 高精度のステッパー動作。 Klipperは、プリンターの動きを計算する際に、アプリケーションプロセッサ（低価格のRaspberry Piなど）を利用します。アプリケーションプロセッサは、各ステッピングモータをいつステップさせるかを決定し、それらのイベントを圧縮してマイクロコントローラに送信し、マイクロコントローラが要求された時間に各イベントを実行します。各ステッパーイベントは、25マイクロ秒以上の精度でスケジュールされます。このソフトウェアは（ブレゼンハムのアルゴリズムのような）運動学的推定を使用せず、加速の物理学と機械の運動学の物理学に基づいて正確なステップ時間を計算します。より正確なステッパー動作は、より静かで安定したプリンター動作を提供します。
* クラス最高のパフォーマンス。 Klipper は、新旧どちらのマイコンでも高いステップレートを実現できます。古い8ビットマイコンでも、毎秒175Kステップを超える速度を得ることができます。最近のマイコンでは、毎秒数百万ステップも可能です。ステッパー・レートが高いほど、印刷速度が速くなります。ステッパーイベントのタイミングは、高速でも正確なままであるため、全体的な安定性が向上します。
* Klipper は複数のマイクロコントローラーを搭載したプリンターをサポートしています。例えば、1つのマイコンをエクストルーダーの制御に使い、別のマイコンはプリンターのヒーターを制御し、3つ目のマイコンはプリンターの残りの部分を制御することができます。クリッパーホストソフトウェアは、マイクロコントローラー間のクロックドリフトを考慮したクロック同期を実装しています。複数のマイコンを有効にするための特別なコードは必要なく、設定ファイルに数行追加するだけです。
* シンプルなConfigファイルによる設定。 設定を変更するためにマイクロコントローラーをリフラッシュする必要はありません。Klipper の全ての設定は、簡単に編集できる標準の設定ファイルに保存されています。これにより、ハードウェアのセットアップとメンテナンスが容易になります。
* Klipper は "Smooth Pressure Advance" をサポートしています。 これにより、エクストルーダーの"にじみ"が減り、コーナーのプリント品質が向上します。クリッパーの実装は、瞬間的なエクストルーダのスピード変更を行わないため、全体的な安定性と堅牢性が向上します。
* Klipper は、印刷品質への振動の影響を軽減する "Input Shaping" をサポートしています。これにより、印刷の "リンギング"（"ゴースト"、"エコー"、"リップリング"とも呼ばれる）を低減または除去することができます。また、高い印刷品質を維持しながら、より速い印刷速度を得ることができます。
* Klipper ーは "反復ソルバー" を使って、シンプルな運動方程式から正確なステップタイムを計算します。これにより、新しいタイプのロボットへのクリッパーの移植が容易になり、複雑な運動学でも正確なタイミングを保つことができます（"ラインセグメンテーション" は必要ありません）。
* Klipper はハードウェアにとらわれません。ローレベルのエレクトロニクス・ハードウェアとは無関係に、同じ正確なタイミングを得ることができるはずです。Klipper マイクロコントローラーのコードは、Klipper ホスト・ソフトウェアが提供するスケジュールに忠実に従うように設計されています。これにより、利用可能なハードウェアの使用や、新しいハードウェアへのアップグレードが容易になり、ハードウェアへの信頼が高まります。
* ポータブルコード。 Klipper はARM、AVR、PRUベースのマイクロコントローラーで動作します。既存の "reprap" スタイルのプリンターは、ハードウェアを変更することなく、Raspberry Piを追加するだけでKlipperを動かすことができます。Klipperの内部コードレイアウトは、他のマイクロコントローラ・アーキテクチャのサポートも容易にしています。
* よりシンプルなコード。Klipper は、ほとんどのコードに非常に高度な言語（Python）を使用しています。運動学アルゴリズム、Gコード解析、加熱とサーミスタのアルゴリズムなど、すべてがPythonで書かれています。これにより、新機能の開発が容易になります。
* カスタムのプログラマブルなマクロ。 新しいGコードコマンドをプリンタの設定ファイルで定義できます（コードの変更は不要です）。 これらのコマンドはプログラマブルで、プリンタの状態に応じて異なるアクションを生成できます。
* ビルトイン API サーバー。標準的なGコードインターフェースに加え、Klipper はリッチなJSONベースのアプリケーションインターフェースをサポートしています。 これにより、プログラマーはプリンターを詳細に制御できる外部アプリケーションを構築できます。

## その他の特徴

Klipperは多くの標準的な3dプリンター機能をサポートしています：

* いくつかのウェブインターフェースを利用可能。 Mainsail、Fluidd、OctoPrint などで動作します。これにより、通常のウェブブラウザを使ってプリンターを制御することができます。Klipperを動かすのと同じRaspberry Piでもウェブインターフェースを動かすことができます。
* 標準的なGコードのサポート。 典型的な"スライサー"（SuperSlicer、Cura、PrusaSlicerなど）で生成される一般的なGコードコマンドがサポートされています。
* 複数のエクストルーダをサポート。 ヒーターを共有する押出機や独立キャリッジ（IDEX）上のエクストルーダもサポートしています。
* Cartesian(デカルト式), Delta, CoreXY, CoreXZ, Hybrid-CoreXY, Hybrid-CoreXZ, Deltesian, Rotary Delta, Polar, Cable Winch Style のプリンタに対応しています。
* Automatic bed leveling support. Klipper can be configured for basic bed tilt detection or full mesh bed leveling. The bed mesh can be customized to the print size (adaptive bed mesh). If the bed uses multiple Z steppers then Klipper can also level by independently manipulating the Z steppers. Most Z height probes are supported, including BL-Touch probes and servo activated probes. Probes may be calibrated for axis twist compensation. If using an "eddy current probe" then one can utilize fast bed mesh scanning,
* 自動デルタキャリブレーションをサポート。キャリブレーションツールは、基本的な高さのキャリブレーションだけでなく、XおよびY寸法の拡張キャリブレーションも実行できます。キャリブレーションは、Z高さプローブまたは手動プローブを使用して行うことができます。
* 印刷中の "exclude object" サポート。 このモジュールが設定されている場合、マルチパート印刷の1つのオブジェクトだけをキャンセルすることができます。
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, AHT10, SHT3x, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* 基本的なサーマルヒーター保護はデフォルトで有効。
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer. One can assign a "math formula" to a fan for automatic fan speed updating.
* TMC2130、TMC2208/TMC2224、TMC2209、TMC2660、およびTMC5160ステッパ・モータ・ドライバのランタイム・コンフィギュレーションをサポートします。また、AD5206、DAC084S085、MCP4451、MCP4728、MCP4018、PWMピンを介した従来のステッパ・ドライバの電流制御もサポートしています。
* プリンタに直接取り付けられた一般的なLCDディスプレイをサポート。デフォルトメニューも用意されています。ディスプレイとメニューの内容は、Configファイルで完全にカスタマイズできます。
* 定加速と "look-ahead" (先読み) サポート。すべてのプリンター動作は、停止状態から巡航速度まで徐々に加速し、その後減速して停止状態に戻ります。入力されるGコード移動コマンドのストリームはキューに入れられ、分析されます。同じ方向の移動間の加速は、印刷ストールを減らし、全体的な印刷時間を改善するために最適化されます。
* Klipper は、一般的なエンドストップスイッチの精度を向上させる "stepper phase endstop" アルゴリズムを実装しています。適切に調整された場合、印刷の1層目のベッド密着性を向上させることができます。
* フィラメント有無センサー、フィラメントモーションセンサー、フィラメント幅センサーをサポート。
* Support for measuring and recording acceleration using adxl345, mpu9250, mpu6050, lis2dw12, lis3dh, and icm20948 accelerometers.
* プリンタの振動とノイズを低減するために、短いジグザグ移動の最高速度を制限する機能をサポートしました。詳しくは [kinematics](Kinematics.md) ドキュメントを参照してください。
* 多くの一般的なプリンターについて、サンプル設定ファイルが用意されています。[config ディレクトリ](../config/)に一覧があります。

Klipperを使い始めるには、[installation](Installation.md) ガイドをお読みください。

## ステップ・ベンチマーク

以下はステッパー性能テストの結果です。表示されている数字は、マイクロコントローラーの1秒あたりの総ステップ数を表しています。

| マイクロコントローラ | 1 stepper active | 3 steppers active |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| AR100 | 3529K | 2507K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| RP2040 | 4000K | 2571K |
| RP2350 | 4167K | 2663K |
| SAME70 | 6667K | 4737K |
| STM32H723 | 7429K | 8619K |

特定のボードのマイクロコントローラーがわからない場合は、適切な [configファイル](../config/) を見つけて、そのファイルの先頭にあるコメントからマイクロコントローラーの名前を探してください。

ベンチマークの詳細については、[ベンチマーク・ドキュメント](Benchmarks.md)を参照してください。
