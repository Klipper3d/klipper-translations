# 概要

Klipperドキュメントへようこそ。Klipperが初めての方は [機能一覧](Features.md)と [インストール](Installation.md)からご覧ください。

## 概要情報

- [機能一覧](Features.md): Klipperの各機能に関する詳細なリストです。
- [FAQ](FAQ.md): よくある質問と回答です。
- [リリース](Releases.md): Klipperのリリース履歴です。
- [Config更新情報](Config_Changes.md):Configの変更が必要な可能性のある直近のソフトウェアの仕様変更情報です。
- [問い合わせ先](Contact.md): Klipper開発者へのバグ報告と一般的な連絡先について。

## インストールと設定

- [インストール](Installation.md): Klipperのインストールガイドです。
- [Config参照情報](Config_Reference.md): Configの各種パラメータの説明です。
   - [Rotation Distance](Rotation_Distance.md): ステッパーモーターの設定で必要な rotation_distanceの計算について。
- [設定確認](Config_checks.md): Configファイルのピン設定の基本的な確認方法について。
- [ベッドレベリング](Bed_Level.md): Klipperの"bed leveling"の設定について。
   - [デルタキャリブレーション](Delta_Calibrate.md): デルタ型プリンタのキャリブレーションについて。
   - [プローブキャリブレーション](Probe_Calibrate.md): オートレベリング用のZ軸プローブのキャリブレーションについて。
   - [BL-Touch](BLTouch.md): "BL-Touch"型の Z軸プローブの設定について。
   - [マニュアルレベリング](Manual_Level.md): Z軸エンドストップとマニュアルベッドレベリングについて。
   - [ベッドメッシュ](Bed_Mesh.md): ベッド表面の凹凸の補正について。
   - [Endstop phase](Endstop_Phase.md): ステッピングモーターの励磁ステップ状態を活用したZ軸ホーミング制度の向上について。
- [共振補償](Resonance_Compensation.md): 共振による印刷品質低下を抑制する機能について。
   - [共振周波数測定](Measuring_Resonances.md): adxl345加速度センサーを使用した固有共振周波数の測定方法です。
- [Pressure advance](Pressure_Advance.md):エクストルーダーのプレッシャーアドバンスの設定です。
- [Gコード](G-Codes.md): KlipperでサポートされているGコードについて。
- [コマンドテンプレート](Command_Templates.md): Gコードマクロと条件演算子について。
   - [情報の参照](Status_Reference.md): Gコードマクロ等で参照可能なプリンターに関する情報について。
- [TMCドライバー](TMC_Drivers.md): KlipperでのTrinamic社製ステッピングモータードライバーICの使用について。
- [マルチMCUホーミング](Multi_MCU_Homing.md): 複数のマイクロコントローラーを使用したホーミングとプロービングについて。
- [スラサー設定](Slicers.md): 各スライサーにおけるKlipper向けの設定について。
- [斜め補正](Skew_Correction.md): XY軸が斜めに印刷される際の調整について。
- [PWMツール](Using_PWM_Tools.md): PWM制御ツールの使用について(レーザーやスピンドル等の)。
- [Exclude Object](Exclude_Object.md): Exclude Objects の実装ガイド。

## 開発者向けドキュメント

- [コード全体の流れについて](Code_Overview.md): 開発を希望される方はこちらを最初にお読みください。
- [運動力学](Kinematics.md): Klipperでの制御実装の技術的な詳細について。
- [プロトコル](Protocol.md): ホストコンピューターとマイクロコントローラー間の低レベルなメッセージングプロトコルの情報。
- [APIサーバー](API_Server.md): KlipperのAPIと制御コマンドに関する情報。
- [MCUコマンド](MCU_Commands.md): マイクロコントローラーの低レベルな制御コマンドの実装について。
- [CAN busプロトコル](CANBUS_protocol.md): KlipperのCAN busメッセージのフォーマットについて。
- [デバッグ](Debugging.md): Klipperのテストとデバッグ方法について。
- [ベンチマーク](Benchmarks.md): Klipperベンチマークの実施方法について。
- [貢献方法](CONTRIBUTING.md): Klipperの改善への貢献方法について。
- [パッケージング](Packaging.md): OSパッケージの作成方法について。

## 特定の機器に関するドキュメント

- [Config例](Example_Configs.md): KlipperにConfigファイルを追加する際の例です。
- [SDカードによる更新](SDCard_Updates.md): SDカードにコピーしたファームウェアファイルによるマイクロコントローラーのフラッシュ方法について。
- [Raspberry PiのMCUとしての使用](RPi_microcontroller.md): Raspberry PiのGPIOピンを利用した周辺機器の制御に関する詳細情報です。
- [Beaglebone](Beaglebone.md): Beaglebone PRUでKlipperを実行する際の詳細について。
- [ブートローダー](Bootloaders.md): マイクロコントローラーのフラッシュに関する開発情報。
- [CAN bus](CANBUS.md): KlipperでのCAN bus使用に関する情報。
   - [CAN bus troubleshooting](CANBUS_Troubleshooting.md): Tips for troubleshooting CAN bus.
- [TSL1401CLフィラメント径センサー](TSL1401CL_Filament_Width_Sensor.md)
- [ホール素子フィラメント径センサー](Hall_Filament_Width_Sensor.md)
