# set the Windows proxy settings if the http_proxy environment variable is set.
if (Test-Path Env:\http_proxy) {
    $proxy_host = $env:http_proxy -replace '^https?://','' -replace '/',''
}
if (Test-Path Env:\https_proxy) {
    $proxy_host = $env:https_proxy -replace '^https?://','' -replace '/',''
}
if (Test-Path Variable:\proxy_host) {
    $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $regKey ProxyEnable -Value 1
    Set-ItemProperty -Path $regKey ProxyOverride -Value '<local>'
    Set-ItemProperty -Path $regKey ProxyServer -Value $proxy_host
}
