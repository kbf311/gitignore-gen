@echo off
chcp 65001 > nul
setlocal
cd /d "%~dp0"

:: 出力先ディレクトリ・ファイル名
set OUTPUT_DIR=output
set OUTPUT_FILE=%OUTPUT_DIR%\.gitignore

:: 出力先フォルダの作成
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

:: 追記用の独自設定ファイル名
set CUSTOM_RULES_FILE=my-gitignore.txt

:: 引数の取得（前後のダブルクォートを除去）
set "TARGETS=%*"
if defined TARGETS (
    set "TARGETS=%TARGETS:"=%"
)

if "%TARGETS%"=="" (
    echo [エラー] 生成対象が指定されていません。
    echo 使用例: %~nx0 windows,python
    pause
    exit /b 1
)

echo [1/2] gitignore.io から %TARGETS% の設定を取得中...
curl -sL "https://www.toptal.com/developers/gitignore/api/%TARGETS%" > "%OUTPUT_FILE%"
if errorlevel 1 (
    echo [エラー] 設定の取得に失敗しました。インターネット接続を確認してください。
    pause
    exit /b 1
)

echo [2/2] 独自ルールの追記中...
if exist "%CUSTOM_RULES_FILE%" (
    (
        echo.
        type "%CUSTOM_RULES_FILE%"
    ) >> "%OUTPUT_FILE%"
    echo 独自ルール ^(%CUSTOM_RULES_FILE%^) を正常に追記しました。
) else (
    echo [警告] 追記用ファイル "%CUSTOM_RULES_FILE%" が見つかりませんでした。
)

echo 完了しました: %OUTPUT_FILE% を作成・更新しました。
pause